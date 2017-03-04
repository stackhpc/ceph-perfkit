#!/bin/bash

# Extract data for each dev
# Transpose to produce a plot data file
for i in $(seq 2 2 12)
do 
    > iostat-${dev}.dat
    ./munge_iostat.awk iostat-${i}.dat | \
        while read dev bw
        do
            echo $i $bw >> iostat-${dev}.dat
        done
done

