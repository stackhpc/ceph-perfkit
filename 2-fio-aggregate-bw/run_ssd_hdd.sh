#!/bin/bash

# Run a concurrent combination of SSD journals and HDDs.
# Include increasing numbers of HDDs in the test configuration.

for i in {0..10}
do
    fio ssd-hdd-read-$i.fio
    for file in ssd-hdd-read-$i-*.log_bw.*.log
    do
        echo $file $(awk '{sum+=$2; n++} END {print sum/n}' $file) >> ssd-hdd-read-$i.dat
    done
done

# Transpose by device
for dev in sdd sde sdf sdg sdh \
           sdj sdk sdl sdm sdn \
           sdb sdc sdi
do
    for i in {0..10}
    do
        dev_bw=$(grep $dev.log_bw ssd-hdd-read-$i.dat | cut -d ' ' -f 2)
        [ -z "$dev_bw" ] && dev_bw="0"
        echo $i $dev_bw
    done > bw-ssd-hdd-$dev.dat
done
