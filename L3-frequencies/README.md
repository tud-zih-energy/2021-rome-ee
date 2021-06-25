L3 Cache frequencies
====================

These plots show the  L3-cache latencies in a mixed frequency set-up.

> Note: We used some of these graphs for Figure 4 in the paper.

Reproduction of results
=======================

While the `datafiles` folders contain all measurement data, the measurement tool is not part of this repository. We used the *memory_latency* kernel of the [x86-membench](https://fusionforge.zih.tu-dresden.de/plugins/mediawiki/wiki/benchit/index.php/X86membench) extension for [BenchIT](https://tu-dresden.de/zih/forschung/projekte/benchit). 
The folders contain `.bit` files, which include setup information and results for each measurement, as well as accompanying `.gp` files, which may be used create plots of individual measurements using `gnuplot`.
Depending on the version of `gnuplot` available to you, the line `set data style points` might have to be commented out/deleted for the scripts to work.
The setup information found in these result files may be used to configure the *memory_latency* kernel's `PARAMETERS` file, found in the kernel's directory.
Please note that the configuration parameters were chosen to fit our system and may not work (e.g. the `BENCHIT_KERNEL_{HUGEPAGES|HUGEPAGE_DIR} ` parameters if hugepages have not been mounted explicitly) or not produce identical/useful results on other setups. 
The benchmark may be configured and run via the BenchIT GUI or manually by configuring the `PARAMETERS` file, running the `COMPILE.SH` script found in the kernel's directory and the `RUN.SH` script in the BenchIT root directory.
The x86-membench benchmarks are designed for x86_64 systems and will not work on other architectures.
