#!/bin/bash

# For all fio test configuration files, run the test and collect data
for i in 0 2 4 6 8 10 all
do
    fio journal+$i.fio
    for file in journal+$i-*.log_bw.*.log
    do
        echo $file $(awk '{sum+=$2; n++} END {print sum/n}' $file) >> results-$i.dat
    done
done

# Transpose by device
for dev in journal sdb sdc sdd sde sdf sdg sdh sdi sdj sdk sdl sdm sdn
do
    for i in 0 2 4 6 8 10 all
    do
        dev_bw=$(grep $dev.log_bw results-$i.dat | cut -d ' ' -f 2)
        [ -z "$dev_bw" ] && dev_bw="0"
        echo $i $dev_bw
    done > bw-$dev.dat
done
