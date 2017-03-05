#!/bin/bash -x

# Run the test setup on all pools first, to drive data through the cache
# ... and out the other side
for i in {1..36}
do
    rados -k /etc/ceph/ceph.client.admin.keyring -b $((128*1024)) -p scaleout_$i \
	  bench 60 write -t 64 --no-cleanup | tee scaleout-write-$i.log
done

# Read-back phase
for i in {1..36}
do
    rados -k /etc/ceph/ceph.client.admin.keyring -p scaleout_$i \
	  bench 60 seq -t 64 | tee scaleout-read-$i.log
done

