#!/bin/bash -x

# Run the test setup on all pools first, to drive data through the cache
# ... and out the other side
for ((bs=1024; $bs <= $((16*1024*1024)); bs=$bs * 2))
do
    rados -k /etc/ceph/ceph.client.admin.keyring -b $bs -p benchmark \
      bench 600 write -t 64 --no-cleanup | tee scaleout-write-$bs.log

    rados -k /etc/ceph/ceph.client.admin.keyring -p benchmark \
	  bench 60 seq -t 64 | tee scaleout-read-$bs.log

    rados -p benchmark cleanup
done

