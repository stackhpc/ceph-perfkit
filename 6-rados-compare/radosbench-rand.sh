#!/bin/bash -x

pool=benchmark

# Write an amount of data to Ceph, enough to be cacheable
# Make random accesses to the written objects
# Clean up after the test run
for ((bs=1024; $bs <= $((16*1024*1024)); bs=$bs * 2))
do
    rados -k /etc/ceph/ceph.client.admin.keyring -b $bs -p $pool \
      bench 20 write -t 64 --no-cleanup | tee rados-write-rand-$bs.log

    rados -k /etc/ceph/ceph.client.admin.keyring -p $pool \
          bench 60 rand -t 64 | tee rados-read-rand-$bs.log

    rados -p $pool cleanup
done

