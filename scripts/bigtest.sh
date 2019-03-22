#!/bin/bash -x

while read min max pool name nodes
do 
    ceph osd pool create $pool 1024 1024
    ceph osd pool set $pool min_size 1
    ceph osd pool set $pool size 1

    ./rados-run.sh $min $max $pool $name $nodes

    ceph osd pool delete $pool $pool --yes-i-really-really-mean-it

    # Process...
    mkdir -p $name
    for ((i=1024; $i <= $((16*1024*1024)); i=$i*2))
    do echo $i 
    done > $name/$name.dat

    for node in $nodes
    do
	(cd $name-$node && ../munge-rados-sizes.sh $name-$node-write $name-$node-read) > $name/$name-${node}.dat
	join -j 1 $name/${name}.dat $name/$name-${node}.dat > $name/${name}.tmp
        mv $name/${name}.tmp $name/$name.dat
    done

    # Allow the deleted objects to exit the system
    sleep 60
done
