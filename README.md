Measurement and Visualization code
==================================

This repository contains the measurement and data visualization code used in the paper "Energy Efficiency Aspects of the AMD Zen 2 Architecture" from Robert Schöne, Thomas Ilsche, Mario Bielert, Markus Velten, Markus Schmidl, and Daniel Hackenberg.

## Disclaimer

For technical reasons, not all visualizations are self-contained. Some of the scripts are missing the measurement code, as we used external tools. Other scripts include live access to our locally deployed measurement infrastructure, which has its persistent storage. For obvious reasons, we cannot provide anonymous access to the internal systems. However, the authors welcome any requests to the missing parts and are willing to provide them if feasible.

## Command-line util `elab`

We developed and installed on all our test machines a helper program called `elab`. We use this program to reliably set specific system parameters, like C-states, P-states, SMT. It is also used in some of the scripts part of this repository. The particular setting reference in any call should be easily derivable. For instance:

- `elab ht on|off|enable|disable` respectively enables and disables SMT, which is done by disabling all but the first thread sibling for every core
- `elab frequency nominal` sets the scaling governor to `userspace` and the used P-state to the nominal frequency of the processor
- `elab frequency turbo` is like `elab frequency nominal`, but also enables turbo frequencies
- `elab cstate ...` allows configuring the available C-states

This program is implemented in Python and provides an API usable from other Python code, which some scripts use. These modules are called `lab_management`.

### Scripts used for Figures and Tables in the paper

- Figure 1: `Green500/charts.ipynb`
- Figure 2: no scripts involved
- Figure 3: `ftalat/analyze_all.ipynb`
- Table I: `mixed-freq/mixed-freq.ipynb`
- Figure 4: `L3-frequencies/memory-latency-Core0-Core1-frequencies-pandas.ipynb`
- Figure 5a: `RAM bandwidth/io-pstates/STREAM-IO_pstates-DRAM_frequencies-all p-states.ipynb`
- Figure 5b: `RAM latency/memory-latency-1S-RAM-frequencies-heatmap.ipynb`
- Figure 6: `firestarter_frequency/plot_actual_frequency.ipynb`
- Figure 7: `cstate_power/charts.ipynb`
- Figure 8: `roco2/roco-viz.ipynb`
- Figure 9: `cstate/parse_C6.ipynb`
- Figure 10: `data_rapl_stats/charts.ipynb`
