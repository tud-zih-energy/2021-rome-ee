#include <array>
#include <chrono>
#include <fstream>
#include <iostream>
#include <vector>

#include <omp.h>

#include <x86_energy.hpp>

#include "pcg_random.hpp"

extern "C"
{
#include "kernel.h"
}

using my_clock = std::chrono::system_clock;

template <typename T>
double chrono_seconds(T duration)
{
    return std::chrono::duration_cast<std::chrono::duration<double>>(duration).count();
}

#define KERNEL xor_kernel

uint64_t calibrate(my_clock::duration kernel_duration)
{
    std::vector<uint64_t> calibration_data(16, 0x0000FFFFull);
    uint64_t instructions = 1e9;
    std::cout << "Starting calibration" << std::endl;
    auto min_duration = my_clock::duration::max();
    // repeat to avoid outliers
#pragma omp parallel
    {
        for (int i = 0; i < 6; i++)
        {
            {
#pragma omp barrier
                auto begin = my_clock::now();
                KERNEL(calibration_data.data(), instructions);
#pragma omp barrier
                auto duration = my_clock::now() - begin;
#pragma omp master
                min_duration = std::min(duration, min_duration);
            }
        }
    }
    auto duration_s = chrono_seconds(min_duration);
    std::cout << "Tested duration: " << duration_s << " s, " << instructions / (1e10 * duration_s)
              << " gI/s " << std::endl;

    auto instructions_per_second = instructions / duration_s;
    instructions = uint64_t(chrono_seconds(kernel_duration) * instructions_per_second);
    instructions -= instructions % 32;

    std::cout << "Set instructions " << instructions << " per iteration " << std::endl;

    return instructions;
}

enum class RaplScope
{
    PCKG,
    CORES,
    SIZE
};

constexpr auto idx(RaplScope scope)
{
    return static_cast<std::size_t>(scope);
}

constexpr auto RaplScopes = { RaplScope::PCKG, RaplScope::CORES };

struct Experiment
{
    my_clock::time_point start;
    my_clock::duration duration;
    std::array<int, 2> op_weights;
    std::array<double, static_cast<size_t>(RaplScope::SIZE)> energy;
};

constexpr std::uint64_t operand(int hw)
{
    if (hw == 0)
    {
        // Turns out you're not allowed to shift something by it's bit-width
        return 0ull;
    }
    uint64_t op = ~0ull;
    return op >> (64 - hw);
}

std::array<std::unique_ptr<x86_energy::SourceCounter>, idx(RaplScope::SIZE)> counters;

void init_rapl()
{
    x86_energy::Mechanism mechanism;
    std::cout << "using x86_energy mechanism " << mechanism.name() << std::endl;

    std::unique_ptr<x86_energy::AccessSource> active_source;

    auto sources = mechanism.available_sources();

    for (auto& source : sources)
    {
        std::cout << "Trying access source: " << source.name() << std::endl;
        try
        {
            source.init();

            active_source = std::make_unique<x86_energy::AccessSource>(std::move(source));
            break;
        }
        catch (std::exception& e)
        {
            std::cout << "Failed to initialize access source: " << source.name()
                      << " error was: " << e.what() << std::endl;
        }
    }

    if (!active_source)
    {
        std::cout
            << "Failed to initialize any available source. x86_energy values won't be available."
            << std::endl;
        throw std::runtime_error("Failed to initialize x86_energy access source.");
    }

    counters[idx(RaplScope::PCKG)] = std::make_unique<x86_energy::SourceCounter>(
        active_source->get(x86_energy::Counter::PCKG, 0));
    try
    {
        counters[idx(RaplScope::CORES)] = std::make_unique<x86_energy::SourceCounter>(
            active_source->get(x86_energy::Counter::CORES, 0));
    }
    catch (std::runtime_error&)
    {
        counters[idx(RaplScope::CORES)] = std::make_unique<x86_energy::SourceCounter>(
            active_source->get(x86_energy::Counter::SINGLE_CORE, 0));
    }
    // counters[idx(RaplScope::DRAM)] =
    // std::make_unique<x86_energy::SourceCounter>(active_source->get(x86_energy::Counter::DRAM,
    // 0));
}

int main(int argc, char* argv[])
{
    if (argc < 4)
    {
        std::cout << "Usage: ./data_rapl_stats <kernel duration in ms> <number of iterations> "
                     "<output filename>"
                  << std::endl;
        return -1;
    }

    my_clock::duration kernel_duration = std::chrono::milliseconds(std::stoi(argv[1]));
    uint64_t iterations = std::stoi(argv[2]);
    std::string output_filename = argv[3];

    std::cout << "Calibration..." << std::endl;
    std::vector<Experiment> experiments;
    experiments.reserve(iterations - 1);

    auto instructions = calibrate(kernel_duration);
    init_rapl();

#pragma omp parallel firstprivate(instructions)
    {
        pcg32 generator; // Uses a fixed seed!

        // Used only on master
        std::array<double, idx(RaplScope::SIZE)> previous_energy;
        my_clock::time_point previous_time;
#pragma omp master
        {
            for (auto scope : RaplScopes)
            {
                previous_energy[idx(scope)] = counters[idx(scope)]->read();
            }
            previous_time = my_clock::now();
        }

        std::vector<uint64_t> data(16, 0x00000000ull);
        for (uint64_t i = 0; i < iterations; i++)
        {
            Experiment ex;
            ex.op_weights[0] = 32 * (generator() % 3);
            // ex.op_weights[1] = 32 * (generator() % 3);
            // For now focus on op0
            ex.op_weights[1] = 0;
            // ex.op_weights[1] = 32 * (i * 3 / iterations);
            auto op0 = operand(ex.op_weights[0]);
            auto op1 = operand(ex.op_weights[1]);
            for (int idx = 0; idx < 8; idx++)
            {
                data[idx] = op0;
                data[idx + 8] = op1;
            }
#pragma omp barrier
            KERNEL(data.data(), instructions);
#pragma omp master
            {
                auto now = my_clock::now();
                ex.duration = now - previous_time;
                ex.start = previous_time;
                for (auto scope : RaplScopes)
                {
                    auto energy = counters[idx(scope)]->read();
                    ex.energy[idx(scope)] = energy - previous_energy[idx(scope)];
                    previous_energy[idx(scope)] = energy;
                }
                previous_time = now;
                if (i > 0)
                {
                    // drop the first experiment because if influence from "before"
                    experiments.emplace_back(ex);
                }
                if (i % 100 == 0)
                {
                    std::cout << "[" << i << " of " << iterations << "]" << std::endl;
                }
            }
        }
    }

    std::cout << "Collected " << experiments.size() << " experiments , writing " << output_filename
              << std::endl;
    std::ofstream csv_file(output_filename);
    csv_file << "start,duration,op0_weight,op1_weight,energy_package,energy_cores\n";
    for (auto ex : experiments)
    {
        csv_file << std::chrono::duration_cast<std::chrono::nanoseconds>(
                        ex.start.time_since_epoch())
                        .count()
                 << "," << chrono_seconds(ex.duration) << "," << ex.op_weights[0] << ","
                 << ex.op_weights[1] << "," << ex.energy[idx(RaplScope::PCKG)] << ","
                 << ex.energy[idx(RaplScope::CORES)] << "\n";
    }
    csv_file.close();
    return 0;
}
