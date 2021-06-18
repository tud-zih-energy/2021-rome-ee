#!/bin/bash

source /etc/profile.d/lmod.sh
source /etc/profile.d/zih-a-lmod.sh

HOSTNAME=$(hostname)
echo "HOSTNAME=$HOSTNAME"

KTIME=100
ITERATIONS=100001

for V in shr xor0; do
  if elab ht 2>&1 | grep -q "disabled by BIOS or unsupported"; then
    echo "HT unsupported"
  else
    elab ht enable
    export GOMP_CPU_AFFINITY=0-$(($(nproc) - 1))
    echo "GOMP_CPU_AFFINITY=$GOMP_CPU_AFFINITY"

    elab frequency nominal
    ./BUILD/data_rapl_stats_$V $KTIME $ITERATIONS results/$V/$HOSTNAME-ht-noturbo-${KTIME}ms-$ITERATIONS.csv

#    elab frequency turbo
#    ./BUILD/data_rapl_stats_$V $KTIME $ITERATIONS results/$V/$HOSTNAME-ht-turbo-${KTIME}ms-$ITERATIONS.csv
  fi

  export GOMP_CPU_AFFINITY=0-$(($(nproc) - 1))
  echo "GOMP_CPU_AFFINITY=$GOMP_CPU_AFFINITY"
  elab ht disable

  elab frequency nominal
  ./BUILD/data_rapl_stats_$V $KTIME $ITERATIONS results/$V/$HOSTNAME-noht-noturbo-${KTIME}ms-$ITERATIONS.csv

#  elab frequency turbo
#  ./BUILD/data_rapl_stats_$V $KTIME $ITERATIONS results/$V/$HOSTNAME-noht-turbo-${KTIME}ms-$ITERATIONS.csv
done


KTIME=10000
ITERATIONS=101

for V in xor0; do
  if elab ht 2>&1 | grep -q "disabled by BIOS or unsupported"; then
    echo "HT unsupported"
  else
    elab ht enable
    export GOMP_CPU_AFFINITY=0-$(($(nproc) - 1))
    echo "GOMP_CPU_AFFINITY=$GOMP_CPU_AFFINITY"

    elab frequency nominal
    ./BUILD/data_rapl_stats_$V $KTIME $ITERATIONS results/$V/$HOSTNAME-ht-noturbo-${KTIME}ms-$ITERATIONS.csv

#    elab frequency turbo
#    ./BUILD/data_rapl_stats_$V $KTIME $ITERATIONS results/$V/$HOSTNAME-ht-turbo-${KTIME}ms-$ITERATIONS.csv
  fi

  export GOMP_CPU_AFFINITY=0-$(($(nproc) - 1))
  echo "GOMP_CPU_AFFINITY=$GOMP_CPU_AFFINITY"
  elab ht disable

  elab frequency nominal
  ./BUILD/data_rapl_stats_$V $KTIME $ITERATIONS results/$V/$HOSTNAME-noht-noturbo-${KTIME}ms-$ITERATIONS.csv

#  elab frequency turbo
#  ./BUILD/data_rapl_stats_$V $KTIME $ITERATIONS results/$V/$HOSTNAME-noht-turbo-${KTIME}ms-$ITERATIONS.csv
done
