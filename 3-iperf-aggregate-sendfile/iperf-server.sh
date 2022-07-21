#!/bin/bash
# Script to start up a number of iperf instances on a target server,
# listening on consecutive ports
set -x
for i in $@
do
    iperf3 -s -p $((5200 + $i)) &
done
wait 
