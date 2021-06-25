#!/bin/sh

FREQUENCIES=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_available_frequencies`

for START in $FREQUENCIES
do
	for TARGET in $FREQUENCIES
	do
		 if [ $START -eq $TARGET ] 
	         then
        	    echo "Skip $START -> $TARGET (same frequency)"
	            continue
        	 fi
		sudo ./ftalat $START $TARGET > ${START}_${TARGET}-out_random_10000.txt

	done
done
