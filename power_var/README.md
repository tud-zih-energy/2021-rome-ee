### Power Variation with AVX-512

## Compilation

Requires:
* Score-P https://www.vi-hps.org/projects/score-p/ (possibly with PAPI support)
* GCC with support for OpenMP and AVX-512

Build command
```scorep --user --noopenmp --nocompiler gcc -fopenmp vxor_test_high.c -o vxor_test_high```

You can remove the Score-P instrumentation, which will result in a test workload, but no trace.


## Run

Requires:
* Score-P Metric Plugin, which provides you with energy values (if you want to create a trace with energy values that is).

```./vxor_test_high```

* You can change the number of OpenMP Threads with the environment variable `OMP_NUM_THREADS`
* This will write a trace to the given SCOREP_EXPERIMENT_DIRECTORY, default sth like scorep-(date/time)/traces.otf2
