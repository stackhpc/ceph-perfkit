#!/bin/bash -x

sync
echo 3 > /proc/sys/vm/drop_caches
free

