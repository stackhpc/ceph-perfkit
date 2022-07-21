#!/usr/bin/env python3

import argparse
from pathlib import Path, PurePath
import shlex
import subprocess
import string
import random
import sys
import socket
import matplotlib.pyplot as plt

PLOTS = [
        {
            "title": "RADOS Protocol Bandwidth\nClient: {hostname} | Threads: {concurrent_operations}",
            "varname": "bw",
            "y_label": "Bandwidth (MB/s)",
            "name" : "bandwidth"
	    }
    ]

def plot_bar(summary, args, plot, outdir):
    print("Making {name} plot".format(name=plot['name']))
    
    labels = [] 
    for i in summary:
        if i['active_osds'] not in labels:
            labels.append(i['active_osds'])

    seqread_bw = [i['bw'] for i in summary if i['mode'] == 'seqread']
    randread_bw = [i['bw'] for i in summary if i['mode'] == 'randread']
    write_bw = [i['bw'] for i in summary if i['mode'] == 'write']
   
    fig, ax = plt.subplots()
    
    rects_seqread = ax.plot(labels, seqread_bw, label='seqread')
    rects_randread = ax.plot(labels, randread_bw, label='randread')
    rects_write = ax.plot(labels, write_bw, label='write')

    if args.network_line_rate:
        lr_mb = args.network_line_rate * 125
        ax.plot(
            labels,
            [lr_mb]*len(args.devices), 
            label="Network Line Rate ({network_line_rate} Gbps)".format(
                network_line_rate=args.network_line_rate
                )
            )
    ax.set_title(plot['title'].format(
        hostname=socket.gethostname(),
        concurrent_operations=args.concurrent_operations
        )
    )
    ax.set_ylabel(plot['y_label'])
    ax.set_xlabel('OSDs active')
    ax.legend(bbox_to_anchor=(1.04, 1), loc="upper left")
    ax.set_xticks(labels)
    fig.savefig(
        PurePath(
            outdir
            ).joinpath(
            '{hostname}-rados-bench-{name}.png'.format(
                hostname=socket.gethostname(),
                name=plot['name'],
                )
            ), 
            dpi=1000, 
            bbox_inches='tight'
        )


def run_benchmark(benchmark_commands, args, pool_prefix, outdir):
    benchmark_summary = []
    for c in benchmark_commands:
        for d in c['commands']:
            f_cmd = d['cmd'].format(
                    pool_prefix=pool_prefix,
                    suffix=c['rule_suffix'],
                    prefix=args.rule_prefix,
                    runtime=args.runtime,
                    pg_num=args.pg_num,
                    pgp_num=args.pgp_num,
                    size=args.size,
                    min_size=args.min_size,
                    concurrent_operations=args.concurrent_operations
                    )
            print(f_cmd)
            shlex_cmd = shlex.split(f_cmd)
            if d.get('capture_output'):
                output_fn = PurePath(outdir).joinpath(
                    "radosbench_{pool_prefix}_{suffix}.{mode}.out".format(
                        pool_prefix=pool_prefix,
                        suffix=c['active_osds'],
                        mode=d['mode']
                    )
                )
                with open(output_fn, 'w') as ofn:
                    subprocess.run(shlex_cmd, stdout=ofn)
                    
                with open(output_fn, 'r') as ofn:
                    for line in ofn:
                        if line.startswith("Bandwidth"):
                                bw = line.split(":")[1].strip()
                
                benchmark_summary.append(
                    {
                        'mode': d['mode'],
                        'active_osds': c['active_osds'],
                        'bw': float(bw)
                    }
                )

                if args.cleanup:
                    Path(output_fn).unlink()

            else:
                subprocess.run(shlex_cmd)
    
    return benchmark_summary

def generate_radosbench_cmds(args):

    benchmark_commands = []
    for idx,rule_suffix in enumerate(args.rule_suffixes):
        
        if args.active_osds:
            b = {
                'active_osds': args.active_osds[idx],
                'rule_suffix': rule_suffix,
                'commands' : []
            }
        else:
            b = {
                'active_osds': rule_suffix,
                'rule_suffix': rule_suffix,
                'commands' : []
            }
        
        b['commands'].append(
            {
                'cmd' : "ceph osd pool create radosbench_{pool_prefix}_{suffix} {pg_num} {pgp_num} replicated {prefix}{suffix}",
                'capture_output': False
                }
            )
        b['commands'].append(
            {
                'cmd': "ceph osd pool set radosbench_{pool_prefix}_{suffix} size {size}",
                'capture_output': False
                }
            )
        b['commands'].append(
            {
                'cmd': "ceph osd pool set radosbench_{pool_prefix}_{suffix} min_size {min_size}",
                'capture_output': False
                }
            )
        b['commands'].append(
            {
                'cmd': "rados bench -p radosbench_{pool_prefix}_{suffix} {runtime} write -t {concurrent_operations} --no-cleanup",
                'capture_output': True,
                'mode': 'write'
                }
            )
        b['commands'].append(
            {
                'cmd': "rados bench -p radosbench_{pool_prefix}_{suffix} {runtime} seq -t {concurrent_operations}",
                'capture_output': True,
                'mode': 'seqread'
                }
            )
        b['commands'].append(
            {
                'cmd': "rados bench -p radosbench_{pool_prefix}_{suffix} {runtime} rand -t {concurrent_operations}",
                'capture_output': True,
                'mode': 'randread'
                }
            )
        b['commands'].append(
            {
                'cmd': "ceph osd pool delete radosbench_{pool_prefix}_{suffix} radosbench_{pool_prefix}_{suffix} --yes-i-really-really-mean-it",
                'capture_output': False
                }
            )

        benchmark_commands.append(b)
    
    return benchmark_commands

def setcrushmap(crushmap):
    subprocess.run(
        shlex.split(
            "ceph osd setcrushmap -i {crushmap}".format(
                crushmap=crushmap
            )
        )
    )

def make_output_directory(outdir):
    p = Path(outdir).resolve()

    p.mkdir(parents=True, exist_ok=True)

    return p

def parse_args():
    parser = argparse.ArgumentParser(
            description="""Run read and write RADOS benchmarks on a series of Ceph pools targeting differing numbers of OSDs.\n
                           A crushmap specifying rules for each of the pools should already be created and supplied."""
            )
    # positional
    parser.add_argument('crushmap', type=str,
                                help='Path to a compiled crushmap to use with the test')
    parser.add_argument('rule_suffixes', metavar='rule_suffix', type=int, nargs='+',
                                help='Integer specifying the rule name suffix.')
    
    # required
    required_arguments = parser.add_argument_group('required arguments')
    required_arguments.add_argument('-p', '--rule_prefix', required=True, type=str, help="A common prefix for each CRUSH rule." )
    
    # optional
    parser.add_argument('-d', '--dry-run', action='store_true', help="Print a list of commands to screen without running benchmarks [Default: no]." )
    parser.add_argument('-a', '--active-osds', nargs='+', type=int, help="Number of active OSDs for each CRUSH rule. If not specified, \'rule_suffixes\' is used." )
    parser.add_argument('-c', '--cleanup', action='store_true', help="Clean up RADOS bench output files [Default: no]." )
    parser.add_argument('-o', '--outdir', type=str, default='.', help="Output directory for plots and RADOS bench output files [Default: .].")
    parser.add_argument('-r', '--runtime', type=int, default='30', help='RADOS bench time parameter in seconds [Default: 30].')
    parser.add_argument('-pg', '--pg_num', type=int, default=128, help="pg_num for benchmark pool. [Default: 128]" )
    parser.add_argument('-pgp', '--pgp_num', type=int, default=128, help="pgp_num for benchmark pool. [Default: 128]" )
    parser.add_argument('-s', '--size', type=int, default=3, help="Size of the benchmark pool. [Default: 3]" )
    parser.add_argument('-m', '--min-size', type=int, default=1, help="Mininum size of the benchmark pool. [Default: 1]" )
    parser.add_argument('-t', '--concurrent_operations', type=int, default=16, help="RADOS bench concurrent_operations [Default: 16]" )
    parser.add_argument('-n', '--network-line-rate', type=int, help="Network line rate in Gbit" )

    args = parser.parse_args()
    return args

def main():
    args = parse_args()

    if len(args.active_osds) != len(args.rule_suffixes):
        sys.exit(
            "There are {ao} sets of active OSDs and {rs} rule_suffixes".format(
                ao=len(args.active_osds),
                rs=len(args.rule_suffixes)
            )
        )

    # Make a random string to prefix the pool name for this run
    pool_prefix = ''.join(random.choice(string.ascii_lowercase) for i in range(10))

    benchmark_commands = generate_radosbench_cmds(args)
    if args.dry_run:
        for c in benchmark_commands:
            for d in c['commands']:
                print(d['cmd'].format(
                    pool_prefix=pool_prefix,
                    suffix=c['rule_suffix'],
                    prefix=args.rule_prefix,
                    runtime=args.runtime,
                    pg_num=args.pg_num,
                    pgp_num=args.pgp_num,
                    size=args.size,
                    min_size=args.min_size,
                    concurrent_operations=args.concurrent_operations
                    ))
    else:
        outdir = make_output_directory(args.outdir)
        setcrushmap(args.crushmap)
        benchmark_summary = run_benchmark(benchmark_commands, args, pool_prefix, outdir)
        for plot in PLOTS:
   	        plot_bar(benchmark_summary, args, plot, outdir)


if __name__ == '__main__':
    main()