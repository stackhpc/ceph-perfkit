#!/bin/bash

# Extract data from each run of radosbench
for i in {1..10}
do 
    echo $i $(grep "Bandwidth (MB/sec):" stig_osd3_${i}.radosbench | cut -d ':' -f 2)
done > radosbench.dat

