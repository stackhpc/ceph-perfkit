#!/bin/bash -x

run_name=$1
pool=benchmark

#min_size=1024
min_size=32768
max_size=$((4*1024*1024))
#max_size=$((8*1024*1024))

#for nodes in 1 2 3 4 8 12 16 20 30 40 50
for nodes in 20
do
    test_name=$run_name
    test_nodes=$(< client-ips)
    #test_name=$run_name-$nodes
    #test_nodes=$(head -n $nodes hosts-sshable.dat)

    ./rados-run.sh $min_size $max_size $pool $test_name $test_nodes

    # Process...
    mkdir -p $test_name
    for ((i=$min_size; $i <= $max_size; i=$i*2))
    do echo $i 
    done > $test_name/$test_name.dat

    for node in $test_nodes
    do
        (cd $test_name-$node && ../munge-rados-sizes.sh $test_name-$node-write $test_name-$node-read) > $test_name/$test_name-$node.dat
        join -j 1 $test_name/$test_name.dat $test_name/$test_name-$node.dat > $test_name/$test_name.tmp
        mv $test_name/$test_name.tmp $test_name/$test_name.dat
    done

    ./column_sum.awk < $test_name/$test_name.dat > $test_name/$test_name-total.dat

done
