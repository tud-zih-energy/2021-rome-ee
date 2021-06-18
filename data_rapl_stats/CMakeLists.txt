cmake_minimum_required(VERSION 3.17)
project(data_rapl_stats)

set(CMAKE_CXX_STANDARD 17)

find_package(x86_energy REQUIRED 2.0 CONFIG)
find_package(Threads REQUIRED)
find_package(OpenMP)

add_executable(data_rapl_stats main.cpp)

target_compile_definitions(data_rapl_stats PRIVATE HAVE_X86_ENERGY)
target_link_libraries(data_rapl_stats PRIVATE x86_energy::x86_energy-static)
target_link_libraries(data_rapl_stats PUBLIC OpenMP::OpenMP_CXX)