#!/bin/bash

# Running locally on the SoftIron OSD server, which has had the journal SSD
# repartitioned to add a small test partition at the end of the device (sdi13)
# We have also installed fio from SLES repos.  
#
# Gather write performance results for various numbers of concurrent jobs, 
# simulating the activity of OSD processes interacting with the journal

journal_dev=/dev/sdi13

for i in $(seq 1 12)
do
    fio_log=sdi-fio-$i.dat
    fio --filename=$journal_dev --direct=1 --rw=write --bs=8k --numjobs=$i --runtime=30 --time_based --group_reporting > $fio_log
done

