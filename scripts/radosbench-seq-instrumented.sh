#!/bin/bash -x

#testname=pg8
#pool=benchmarks
testname=$1
pool=$2
bs=$3
monitor_pids=""

function osd_cache_flush()
{
    # Evict everything possible from the page cache on the OSD servers
    for i in {1..4}
    do
        #ssh data-000$i ~stelfer/bin/osd-cache-flush.sh
        ssh data-000$i /root/ceph-bench-toolkit/6-rados-compare/osd-cache-flush.sh
    done
}

function osd_instrumentation_setup()
{
#    coproc osd1_iostat ssh data-0001 iostat -p -x 1 > osd1_iostat-$bs.dat
#    coproc osd2_iostat ssh data-0002 iostat -p -x 1 > osd2_iostat-$bs.dat
#    coproc osd3_iostat ssh data-0003 iostat -p -x 1 > osd3_iostat-$bs.dat
#    coproc osd4_iostat ssh data-0004 iostat -p -x 1 > osd4_iostat-$bs.dat
#
#    coproc osd1_cpustat ssh data-0001 mpstat -P ALL -u 1 > osd1_cpustat-$bs.dat
#    coproc osd2_cpustat ssh data-0002 mpstat -P ALL -u 1 > osd2_cpustat-$bs.dat
#    coproc osd3_cpustat ssh data-0003 mpstat -P ALL -u 1 > osd3_cpustat-$bs.dat
#    coproc osd4_cpustat ssh data-0004 mpstat -P ALL -u 1 > osd4_cpustat-$bs.dat
#
#    coproc osd1_irqstat ssh data-0001 mpstat -I CPU 1 > osd1_irqstat-$bs.dat
#    coproc osd2_irqstat ssh data-0002 mpstat -I CPU 1 > osd2_irqstat-$bs.dat
#    coproc osd3_irqstat ssh data-0003 mpstat -I CPU 1 > osd3_irqstat-$bs.dat
#    coproc osd4_irqstat ssh data-0004 mpstat -I CPU 1 > osd4_irqstat-$bs.dat
#
#    coproc osd1_softirqstat ssh data-0001 mpstat -I SCPU 1 > osd1_softirqstat-$bs.dat
#    coproc osd2_softirqstat ssh data-0002 mpstat -I SCPU 1 > osd2_softirqstat-$bs.dat
#    coproc osd3_softirqstat ssh data-0003 mpstat -I SCPU 1 > osd3_softirqstat-$bs.dat
#    coproc osd4_softirqstat ssh data-0004 mpstat -I SCPU 1 > osd4_softirqstat-$bs.dat
#
    action=$1
    monitor_pids=""
    while read host task cmd
    do 
	ssh $host $cmd > $testname/$task-$action-$bs.dat &
	monitor_pids="$monitor_pids $!"
    done << EOF
data-0001 osd1_iostat iostat -d -y -p -x 1
data-0002 osd2_iostat iostat -d -y -p -x 1
data-0003 osd3_iostat iostat -d -y -p -x 1
data-0004 osd4_iostat iostat -d -y -p -x 1
data-0001 osd1_cpustat mpstat -P ALL -u 1
data-0002 osd2_cpustat mpstat -P ALL -u 1
data-0003 osd3_cpustat mpstat -P ALL -u 1
data-0004 osd4_cpustat mpstat -P ALL -u 1
data-0001 osd1_irqstat mpstat -I CPU 1
data-0002 osd2_irqstat mpstat -I CPU 1
data-0003 osd3_irqstat mpstat -I CPU 1
data-0004 osd4_irqstat mpstat -I CPU 1
data-0001 osd1_softirqstat mpstat -I SCPU 1
data-0002 osd2_softirqstat mpstat -I SCPU 1
data-0003 osd3_softirqstat mpstat -I SCPU 1
data-0004 osd4_softirqstat mpstat -I SCPU 1
EOF
}

function osd_instrumentation_fini()
{
    kill $monitor_pids
    wait $monitor_pids
}

mkdir -p $testname

# Run the test setup on all pools first, to drive data through the cache
# ... and out the other side
osd_cache_flush
osd_instrumentation_setup write
rados -b $bs -p $pool bench 120 write -t 64 --no-cleanup | tee $testname/$testname-write-$bs.log
osd_instrumentation_fini

osd_cache_flush
osd_instrumentation_setup read
rados -p $pool bench 60 seq -t 64 | tee $testname/$testname-read-$bs.log
osd_instrumentation_fini
rados -p $pool cleanup

