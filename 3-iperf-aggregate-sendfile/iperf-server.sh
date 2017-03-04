#!/bin/bash
# Script to start up a number of iperf instances on a target server,
# listening on consecutive ports
for i in {0..12}
do
    iperf3 -s -p $((5200 + $i)) &
done
wait 
