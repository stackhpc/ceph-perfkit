#!/bin/bash

journal_dev=/dev/sdi13

for i in $(seq 1 12)
do
    fio_log=sdi-fio-$i.dat
    fio --filename=$journal_dev --direct=1 --rw=write --bs=8k --numjobs=$i --runtime=30 --time_based --group_reporting > $fio_log
done

