RAPL accuracy
=============

These plots show the RAPL measurements on AMD Epyc 7502 and the AC reference measurements in relation to each other. 

> Note: We used some of these graphs for Figure 8 in the paper.

Reproduction of results
=======================

The results for this graph were generated using the synthetical workload generator [roco2](https://github.com/tud-zih-energy/roco2). In particular, we used the configuration called [`conway`](https://github.com/tud-zih-energy/roco2/blob/master/src/configurations/conway/experiment.cpp). The [run](https://github.com/tud-zih-energy/roco2/blob/master/run/conway/run.sh) used [lo2s](https://github.com/tud-zih-energy/lo2s) to record a runtime trace. That trace was then [transformed](https://github.com/tud-zih-energy/roco2/blob/master/run/conway/sim.sh) using [HAEC Sim](https://tu-dresden.de/zih/forschung/projekte/haec/simulator?set_language=de) resulting into the phase profile contained here as `conway.tsv`. Finally, the Jupyter notebook `roco-viz.ipnb` was used to generate the graphs.