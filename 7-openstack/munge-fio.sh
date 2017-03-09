#!/bin/bash

function extract_bw()
{
    op=$1
    file=$2
    grep -o "^ *$op *: io=[^ ]* bw=[^ ]*" $file \
        | sed -e 's/^.*bw=\([0-9.]*\)\([KB/s]*\).*/\1 \2/g' \
        | awk '$2 == "B/s" {print $1 / 1000.0} $2 == "KB/s" { print $1 }'
                              
}

for ((i=1; $i <= 4096; i=$i*2))
do
    echo "$i $(extract_bw write rbd-write-${i}k.dat) $(extract_bw read rbd-read-${i}k.dat)"
done

