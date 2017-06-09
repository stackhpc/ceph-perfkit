#!/bin/bash
# This script transforms the JSON output from a set of test runs
# into something that gnuplot can process.

for dev in sd{{d..h},{j..n}}
do
    > iperf3-${dev}.dat
done

for ((count=1; $count <= 10; count=$count+1))
do
    for dev in sd{{d..h},{j..n}}
    do
        dev_data=iperf3-$count-$dev.json 
        dev_bwidth=0
        if [[ -f $dev_data ]]
        then
            dev_bwidth=$(jq ".end.sum_sent.bits_per_second/8" $dev_data)
        fi
        echo -e "$count\t$dev_bwidth" >> iperf3-${dev}.dat
    done
done
