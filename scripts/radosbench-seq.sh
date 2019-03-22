#!/bin/bash -x

#testname=pg8
#pool=benchmarks
testname=$1
pool=$2
bs=$3

function osd_cache_flush()
{
    # Evict everything possible from the page cache on the OSD servers
    for i in {1..4}
    do
        #ssh data-000$i ~stelfer/bin/osd-cache-flush.sh
        #ssh data-000$i /root/ceph-bench-toolkit/6-rados-compare/osd-cache-flush.sh

        ssh data-000$i sync
        echo 3 | ssh data-000$i tail /proc/sys/vm/drop_caches
        ssh data-000$i free
    done
}

mkdir -p $testname

# Run the test setup on all pools first, to drive data through the cache
# ... and out the other side
osd_cache_flush
rados -b $bs -p $pool bench 60 write -t 64 --no-cleanup | tee $testname/$testname-write-$bs.log
#rados -b $bs -p $pool bench 180 write -t 64 --no-cleanup | tee $testname/$testname-write-$bs.log

sleep 4

osd_cache_flush
rados -p $pool bench 30 seq -t 64 | tee $testname/$testname-read-$bs.log
#rados -p $pool cleanup
#sleep 20
