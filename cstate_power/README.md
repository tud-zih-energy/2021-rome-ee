System idle power depending on C-states
=======================================

These plots show the full system idle power consumption depending on the number of cores in C2 and the used P-state.

> Note: We used some of the generated graphs for Figure 7 in the paper.

Reproduction of results
=======================

The folder contains the executed program and the results directly produced from running the compiled executable. However, the total system power used in the visualization script is dynamically requested from our local measurement infrastructure. 

The script `cstate_power.py` calls the recorded program, which is compiled from the `low_power.c` file using `make`.