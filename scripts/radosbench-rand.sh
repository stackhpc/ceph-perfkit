#!/bin/bash -x

testname=$1
pool=$2
bs=$3

function osd_cache_flush()
{
    # Evict everything possible from the page cache on the OSD servers
    for i in {1..4}
    do
        ssh data-000$i ~stelfer/bin/osd-cache-flush.sh
    done
}

RADOS_ARGS="-c /home/stig/ceph.conf"

mkdir -p $testname

# Write an amount of data to Ceph, enough to be cacheable
# Make random accesses to the written objects
# Clean up after the test run
osd_cache_flush
rados $RADOS_ARGS -b $bs -p $pool bench 20 write -t 64 --no-cleanup | tee $testname/$testname-write-$bs.log

rados $RADOS_ARGS -p $pool bench 60 rand -t 64 | tee $testname/$testname-read-$bs.log

rados $RADOS_ARGS -p $pool cleanup
