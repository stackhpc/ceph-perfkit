#!/bin/bash

# Run fio configurations containing only HDDs.
# Build up from 1 to 10 HDDs concurrently active.

for i in {1..10}
do
    fio hdd-read-$i.fio
    for file in hdd-read-$i-*.log_bw.*.log
    do
        echo $file $(awk '{sum+=$2; n++} END {print sum/n}' $file) >> results-$i.dat
    done
done

# Transpose by device
for dev in sdd sde sdf sdg sdh \
           sdj sdk sdl sdm sdn
do
    for i in {1..10}
    do
        dev_bw=$(grep $dev.log_bw results-$i.dat | cut -d ' ' -f 2)
        [ -z "$dev_bw" ] && dev_bw="0"
        echo $i $dev_bw
    done > bw-$dev.dat
done
