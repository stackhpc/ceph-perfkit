#!/bin/bash -x

# Run the test setup on all pools first, to drive data through the cache
# ... and out the other side
for i in $(seq 2 2 12 )
do
    rados bench -k /etc/ceph/ceph.client.admin.keyring -b $((128*1024)) 300 -p stig_osd3_$i write --no-cleanup
done

# Read-back phase
for i in $(seq 2 2 12 )
do
    coproc ssh softiron-osd3 iostat 1 > iostat-${i}.dat
    sleep 2

    rados bench -k /etc/ceph/ceph.client.admin.keyring -t 64 30 -p stig_osd3_$i seq | tee stig_osd3_${i}.radosbench

    sleep 2
    kill $COPROC_PID
    sleep 1

done

