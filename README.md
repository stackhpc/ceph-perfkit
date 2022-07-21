## Ceph perfkit
Tools for benchmarking Ceph clusters

### Install
```bash
git clone https://github.com/stackhpc/ceph-perfkit
cd ceph-perfkit
python3 -m venv venv
source venv/bin/activate
pip install -U pip && pip install -r requirements.txt
```

Most tools require privileged access to devices to test them, so you'll need to run them as `root` or with `sudo`.

### journal-write-bw
Evaluate the IO bandwidth and IOPs of a single disk with multiple concurrent IO processes.

Useful for benchmarking the performance of a Ceph journal device.

```
./1-journal-write-bw/fio-single-disk-io.py --help
usage: fio-single-disk-io.py [-h] [-c] [-o OUTDIR] [-b BS] [-m MODE] [-r RUNTIME] [-f FILESIZE] device max_numjobs

Plot the aggregated bandwidth and IO characteristics of a single block device with mutiple processes using fio.

positional arguments:
  device                Block device
  max_numjobs           Maximum number of fio jobs to test.

options:
  -h, --help            show this help message and exit
  -c, --cleanup         Clean up fio job and output JSON files [Default: no].
  -o OUTDIR, --outdir OUTDIR
                        Output directory for plots and fio job and json files [Default: .].
  -b BS, --bs BS        fio bs parameter [Default: 8k].
  -m MODE, --mode MODE  fio rw parameter [Default: write].
  -r RUNTIME, --runtime RUNTIME
                        fio runtime parameter in seconds [Default: 30].
  -f FILESIZE, --filesize FILESIZE
                        fio filesize parameter [Default: 2G].
```

### fio-aggregate-bw
Evaluate the IO bandwidth and IOPs of multiple disks attached to a single OSD host.

Useful for benchmarking the performance of Ceph OSD disks attached to an OSD host.

```
./2-fio-aggregate-bw/fio-agg-disk-io.py --help
usage: fio-agg-disk-io.py [-h] [-c] [-o OUTDIR] [-b BS] [-m MODE] [-r RUNTIME] [-f FILESIZE] device [device ...]

Plot the aggregated bandwidth and IO characteristics of a set of block devices, such as Ceph OSDs, using fio.

positional arguments:
  device                Block device

options:
  -h, --help            show this help message and exit
  -c, --cleanup         Clean up fio job and output JSON files [Default: no].
  -o OUTDIR, --outdir OUTDIR
                        Output directory for plots and fio job and json files [Default: .].
  -b BS, --bs BS        fio bs parameter [Default: 8k].
  -m MODE, --mode MODE  fio rw parameter [Default: read].
  -r RUNTIME, --runtime RUNTIME
                        fio runtime parameter in seconds [Default: 30].
  -f FILESIZE, --filesize FILESIZE
                        fio filesize parameter [Default: 2G].
```

### iperf-aggregate-sendfile
Evaluate the read bandwidth of multiple disks attached to a single OSD host over TCP using `iperf3`.

Useful for benchmarking the inter-node performance of Ceph OSD nodes.

Requires `iperf3` servers listening on as many ports as you have OSD disks that you want to test the performance of.

```bash
# On server, to benchmark 24 disks
./3-iperf-aggregate-sendfile/iperf-server.sh {1..24}
```

```bash
# On client
./3-iperf-aggregate-sendfile/iperf3-client-agg-disk-io.py <iperf-server-address> /dev/sd{a..x}
```

```bash
./3-iperf-aggregate-sendfile/iperf3-client-agg-disk-io.py --help
usage: iperf3-client-agg-disk-io.py [-h] [-p PORT_START] [-c] [-o OUTDIR] [-r RUNTIME] [-n NETWORK_LINE_RATE] iperf3_server device [device ...]

Plot the aggregated network read bandwidth of a set of block devices, such as Ceph OSDs, using iperf3. Requires iperf3 servers listening on as many consecutive ports as devices to
test.

positional arguments:
  iperf3_server         iperf3 server address
  device                Block device

options:
  -h, --help            show this help message and exit
  -p PORT_START, --port_start PORT_START
                        First iperf3 server port (assumed consecutive after this) [Default: 5201].
  -c, --cleanup         Clean up fio job and output JSON files [Default: no].
  -o OUTDIR, --outdir OUTDIR
                        Output directory for plots and iperf json files [Default: .].
  -r RUNTIME, --runtime RUNTIME
                        iperf3 client time parameter in seconds [Default: 10].
  -n NETWORK_LINE_RATE, --network-line-rate NETWORK_LINE_RATE
                        Network line rate in Gbit
```

### rados-scaleout
Evaluate the seqread/randread/write bandwidth of ceph pools targeting increasing numbers of OSDs in turn. This tool is intended to be run using a custom CRUSH map, which defines rules incorporating increasing numbers of OSDs. An example crushmap is provided in `5-rados-scaleout/crush-scaleout.map`, but it is important that this adapted to your environment and **provided as a compiled crushmap**.

```bash
./rados-bench-scaleout.py --help
usage: rados-bench-scaleout.py [-h] -p RULE_PREFIX [-d] [-a ACTIVE_OSDS [ACTIVE_OSDS ...]] [-c] [-o OUTDIR] [-r RUNTIME] [-pg PG_NUM] [-pgp PGP_NUM] [-s SIZE] [-m MIN_SIZE]
                               [-t CONCURRENT_OPERATIONS] [-n NETWORK_LINE_RATE]
                               crushmap rule_suffix [rule_suffix ...]

Run read and write RADOS benchmarks on a series of Ceph pools targeting differing numbers of OSDs. A crushmap specifying rules for each of the pools should already be created and
supplied.

positional arguments:
  crushmap              Path to a compiled crushmap to use with the test
  rule_suffix           Integer specifying the rule name suffix.

options:
  -h, --help            show this help message and exit
  -d, --dry-run         Print a list of commands to screen without running benchmarks [Default: no].
  -a ACTIVE_OSDS [ACTIVE_OSDS ...], --active-osds ACTIVE_OSDS [ACTIVE_OSDS ...]
                        Number of active OSDs for each CRUSH rule. If not specified, 'rule_suffixes' is used.
  -c, --cleanup         Clean up RADOS bench output files [Default: no].
  -o OUTDIR, --outdir OUTDIR
                        Output directory for plots and RADOS bench output files [Default: .].
  -r RUNTIME, --runtime RUNTIME
                        RADOS bench time parameter in seconds [Default: 30].
  -pg PG_NUM, --pg_num PG_NUM
                        pg_num for benchmark pool. [Default: 128]
  -pgp PGP_NUM, --pgp_num PGP_NUM
                        pgp_num for benchmark pool. [Default: 128]
  -s SIZE, --size SIZE  Size of the benchmark pool. [Default: 3]
  -m MIN_SIZE, --min-size MIN_SIZE
                        Mininum size of the benchmark pool. [Default: 1]
  -t CONCURRENT_OPERATIONS, --concurrent_operations CONCURRENT_OPERATIONS
                        RADOS bench concurrent_operations [Default: 16]
  -n NETWORK_LINE_RATE, --network-line-rate NETWORK_LINE_RATE
                        Network line rate in Gbit

required arguments:
  -p RULE_PREFIX, --rule_prefix RULE_PREFIX
                        A common prefix for each CRUSH rule.
```