#!/bin/bash -x

min=$1
max=$2
pool=$3
run=$4

# Read in OSD and client IP addresses from pre-seeded files

osd_idx=0
declare -a osd_ip
while read ip
do 
    osd_ip[$osd_idx]="$ip"
    osd_idx=$((osd_idx + 1))
done < osd-ips
osd_count=$osd_idx

client_idx=0
declare -a client_ip
while read ip
do 
    client_ip[$client_idx]="$ip"
    client_idx=$((client_idx + 1))
done < client-ips
client_count=$client_idx


function osd_cache_flush()
{
    # Evict everything possible from the page cache on the OSD servers
    for ((i=0; i<osd_count; i=i+1))
    do
        ssh ${osd_ip[$i]} sync
        echo 3 | ssh ${osd_ip[$i]} sudo tee /proc/sys/vm/drop_caches
    done
}

function osd_sysstat_install()
{
    # Evict everything possible from the page cache on the OSD servers
    for ((i=0; i<osd_count; i=i+1))
    do
        ssh ${osd_ip[$i]} sudo yum install -y sysstat
    done
}

function install_keyring()
{
    for ((i=0; i<client_count; i=i+1))
    do
	target=${client_ip[$i]} 
        ssh $target sudo touch /etc/ceph/ceph.client.benchmark.keyring
        ssh $target sudo chmod 0600 /etc/ceph/ceph.client.benchmark.keyring
        cat ceph.client.benchmark.keyring | ssh $target sudo tee /etc/ceph/ceph.client.benchmark.keyring
    done
}

echo "$run: min=$min max=$max pool=$pool nodes=[$nodelist]"

for ((bs=$min; bs<=$max ; bs=$bs * 2))
do
    osd_cache_flush

    for ((i=0; i<client_count; i=i+1))
    do
        node=${client_ip[$i]}
        mkdir -p $run-$node
	ssh $node sudo rados -n client.benchmark --keyring=/etc/ceph/ceph.client.benchmark.keyring -b $bs -p $pool bench 60 write --run-name bench-$node -t 64 --no-cleanup > $run-$node/$run-$node-write-$bs.log &
    done
    sleep 30
    wait

    osd_cache_flush

    for ((i=0; i<client_count; i=i+1))
    do
        node=${client_ip[$i]}
	ssh $node sudo rados -n client.benchmark --keyring=/etc/ceph/ceph.client.benchmark.keyring -p $pool bench 60 seq --run-name bench-$node -t 64 > $run-$node/$run-$node-read-$bs.log &
    done
    sleep 30
    wait

    # Clear state and allow time for quiescence
    for ((i=0; i<client_count; i=i+1))
    do  
        node=${client_ip[$i]}
        ssh $node sudo rados -n client.benchmark --keyring=/etc/ceph/ceph.client.benchmark.keyring -p $pool cleanup &
    done
    wait
    sleep 30

done
