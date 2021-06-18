#!/usr/bin/env bash

WARMUPTIME=900
RUNTIME=240
PERIOD=1000

STARTDELAY=5000
STOPDELAY=2000

ulimit -n 2048

module load metricq FIRESTARTER/8e7b167
module load lo2s/2019-11-04 scorep_metricq x86_energy scorep_x86_energy

elab frequency nominal
elab ht enable

lo2s -a -X -E instructions -E cpu-cycles -- FIRESTARTER -t $WARMUPTIME

metricq-summary --start-delta=$STARTDELAY --stop-delta=$STOPDELAY -- perf stat --delay=$STARTDELAY --per-socket -x ! -a -e 'cpu-cycles,instructions' -o 'datafiles/nominal-ht-perf.data' -I $PERIOD FIRESTARTER -t $RUNTIME | tail -n 2 > datafiles/nominal-ht-power.csv

elab ht disable

metricq-summary --start-delta=$STARTDELAY --stop-delta=$STOPDELAY -- perf stat --delay=$STARTDELAY --per-socket -x ! -a -e 'cpu-cycles,instructions' -o 'datafiles/nominal-no-ht-perf.data' -I $PERIOD FIRESTARTER -t $RUNTIME | tail -n 2 > datafiles/nominal-no-ht-power.csv
