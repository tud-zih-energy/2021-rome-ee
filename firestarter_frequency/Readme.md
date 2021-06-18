FIRESTARTER
===========

These plots show the maximum full system power consumption achieve using [FIRESTARTER](https://github.com/tud-zih-energy/FIRESTARTER).

> Note: We used the generated graph for Figure 6 in the paper.

Reproduction of results
=======================

The folder contains the results produced from running FIRESTARTER. However, the total system power used in the visualization script is dynamically requested from our local measurement infrastructure. Additionally, we use [lo2s](https://github.com/tud-zih-energy/lo2s) to record the runtime. Plugins used are:
- [scorep_metricq](https://github.com/score-p/scorep_plugin_metricq)
- [scorep_x86_energy](https://github.com/score-p/scorep_plugin_x86_energy)


## Contained data

 * `lo2s_trace_2020-11-23T19-07-31/` FIRESTARTER run with default memory-access pattern
 * `lo2s_trace_2020-11-24T22-45-58/` FIRESTARTER run with memory-access pattern L3_L:25,L2_L:91,L1_2LS_256:72,L1_LS_256:82,REG:75
