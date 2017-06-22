#!/bin/bash -x
# This script is run on the rados bench client.
# It must have passwordless ssh access to root on the target OSD server.

osd_server=10.4.99.104

# Create an empty pool with the given number of OSDs in it (1..10)
# Run the test setup on all specified pools first, to drive data through the cache
# ... and out the other side
for i in $*
do
    sudo ceph osd pool create stig_osd3_$i 128 128 replicated rule_osd3_$i
    sudo ceph osd pool set stig_osd3_$i size 2
    sudo ceph osd pool set stig_osd3_$i min_size 1
done

# let the dust settle...
#sleep 30

for i in $*
do
    sudo rados bench -k /etc/ceph/ceph.client.admin.keyring -b $((4*1024*1024)) 300 -p stig_osd3_$i write --no-cleanup
done

# Read-back phase
for i in $*
do
    coproc ssh root@$osd_server iostat 1 > iostat-${i}.dat
    sleep 2

    sudo rados bench -k /etc/ceph/ceph.client.admin.keyring -t 64 30 -p stig_osd3_$i seq | tee stig_osd3_${i}.radosbench

    sleep 2
    kill $COPROC_PID
    sleep 1

done

# Delete the pool and the data held in it
for i in $*
do
    sudo ceph osd pool delete stig_osd3_$i stig_osd3_$i --yes-i-really-really-mean-it
done

