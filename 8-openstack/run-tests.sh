#!/bin/bash

# For a given number of fio test cases (each with a dedicated
# configuration file), perform read and write tests and collect
# results into a set of output data files.

for i in 1 2 4 8 16 32 64 128 256 512 1024 2048 4096
do
	fio -f rbd-write-${i}k.fio > rbd-write-${i}k.dat
	fio -f rbd-read-${i}k.fio > rbd-read-${i}k.dat
done
