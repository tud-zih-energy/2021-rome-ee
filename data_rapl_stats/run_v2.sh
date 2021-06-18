#!/bin/bash

source /etc/profile.d/lmod.sh
source /etc/profile.d/zih-a-lmod.sh

HOSTNAME=$(hostname)
echo "HOSTNAME=$HOSTNAME"

KTIME=100
ITERATIONS=300001

for V in xor0 shr; do
  if elab ht 2>&1 | grep -q "disabled by BIOS or unsupported"; then
    echo "HT unsupported"
    elab frequency nominal
    export GOMP_CPU_AFFINITY=0-$(($(nproc) - 1))
    echo "GOMP_CPU_AFFINITY=$GOMP_CPU_AFFINITY"
    ./BUILD/data_rapl_stats_v2_$V $KTIME $ITERATIONS results/$V/$HOSTNAME-noht-noturbo-${KTIME}ms-$ITERATIONS.csv
  else
    elab ht enable
    elab frequency nominal
    export GOMP_CPU_AFFINITY=0-$(($(nproc) - 1))
    echo "GOMP_CPU_AFFINITY=$GOMP_CPU_AFFINITY"
    ./BUILD/data_rapl_stats_v2_$V $KTIME $ITERATIONS results/$V/$HOSTNAME-ht-noturbo-${KTIME}ms-$ITERATIONS.csv
  fi
done


KTIME=10000
ITERATIONS=3001

for V in xor0 shr; do
  if elab ht 2>&1 | grep -q "disabled by BIOS or unsupported"; then
    echo "HT unsupported"
    elab frequency nominal
    export GOMP_CPU_AFFINITY=0-$(($(nproc) - 1))
    echo "GOMP_CPU_AFFINITY=$GOMP_CPU_AFFINITY"
    ./BUILD/data_rapl_stats_v2_$V $KTIME $ITERATIONS results/$V/$HOSTNAME-noht-noturbo-${KTIME}ms-$ITERATIONS.csv
  else
    elab ht enable
    elab frequency nominal
    export GOMP_CPU_AFFINITY=0-$(($(nproc) - 1))
    echo "GOMP_CPU_AFFINITY=$GOMP_CPU_AFFINITY"
    ./BUILD/data_rapl_stats_v2_$V $KTIME $ITERATIONS results/$V/$HOSTNAME-ht-noturbo-${KTIME}ms-$ITERATIONS.csv
  fi
done
