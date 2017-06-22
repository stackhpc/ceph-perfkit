#!/bin/bash

# Transform an fio result data file into a columnar file for use in Gnuplot

for i in $(seq 1 12)
do
    fio_log=sdi-fio-$i.dat
    journal_bw=$(cat $fio_log | grep 'write: io=.*, bw=.*,' | grep -o 'bw=[0-9]*' | grep -o '[0-9]*')
    echo $i $journal_bw
done > journal_write_bw.dat

