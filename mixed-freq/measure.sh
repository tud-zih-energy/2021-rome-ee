#!/bin/sh

FREQS="1500 2200 2500"

gcc -fopenmp while_true.c -o ./while_true_omp
gcc while_true.c -o ./while_true

taskset -c 1,2,3 ./while_true_omp &

elab frequency 1500

for FREQ0 in $FREQS
do
	elab frequency --cpus 0 $FREQ0
	for FREQ1 in $FREQS
	do
		elab frequency --cpus 1,2,3 $FREQ1
		taskset -c 0 timeout 120 perf stat -I 1000  -e cycles -x , -o mixed_${FREQ0}_${FREQ1}.csv ./while_true
	done
done

killall while_true_omp
