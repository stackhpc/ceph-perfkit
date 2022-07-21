#!/usr/bin/env python3

from pathlib import Path, PurePath
import argparse
import json
import os
import shlex
import socket
import sys
import subprocess
import time
import matplotlib.pyplot as plt

PLOTS = [
        {
            "title": "Mutiple disks\nAggregate Bandwidth\nClient: {hostname} | Server: {iperf_server}",
            "varname": "bw",
            "y_label": "Bandwidth (MB/s)",
            "name" : "bandwidth"
	    }
    ]

def run_iperf(args, outdir):
    summary_output = []
    total_disks = len(args.devices)
    for idx in range(1, 1 + total_disks):
        devs_to_test = args.devices[:idx]
        for dev_idx,device in enumerate(devs_to_test):
            device_name = os.path.basename(device)
            output_fn = PurePath(
                outdir
                ).joinpath('iperf-out-{device_name}-{idx}.json'.format(
                    device_name=device_name,
                    idx=idx
                    )
                )
            # iperf3 -c $target -p $((5201 + $j)) -F /dev/$hdd -Z -T $hdd -J > iperf3-$count-$hdd.json &
            iperf_client_cmd = "iperf3 -c {iperf_server} -p {iperf_server_port} -t {time} -F {device} -Z -T {device_name} -J".format(
                iperf_server = args.iperf_server,
                iperf_server_port = args.port_start + dev_idx,
                time = args.runtime,
                device = device,
                device_name = device_name
                )
            print(iperf_client_cmd)
            with open(output_fn, 'w') as f:
                cmd = shlex.split(iperf_client_cmd)
                subprocess.Popen(cmd, stdout=f)
        # This is a hack to ensure that our processes have 
        # completed before moving onto the next tranche
        time.sleep(args.runtime + 0.5 * len(devs_to_test))

    for idx in range(1, 1 + total_disks):
        devs_to_test = args.devices[:idx]
        for dev_idx,device in enumerate(devs_to_test):
            device_name = os.path.basename(device)
            output_fn = PurePath(
                outdir
                ).joinpath('iperf-out-{device_name}-{idx}.json'.format(
                    device_name=device_name,
                    idx=idx
                    )
                )
            print("analysing: {output_fn}".format(output_fn=output_fn))
            f = open(output_fn, 'r')
            data = json.load(f)

            bw = data['end']['sum_sent']['bits_per_second']

            summary_output.append(
                {
                    'count': idx,
                    'device': device,
                    'bw': bw / 8000000
                }
            )
            if args.cleanup:
                Path(output_fn).unlink()

        for device in args.devices:
            if device not in devs_to_test:
                summary_output.append(
                {
                    'count': idx,
                    'device': device,
                    'bw': 0
                }
            )

    return summary_output
        
def plot_bar(summary, args, plot, outdir):
    print("Making {name} plot".format(name=plot['name']))
    labels = [ str(i) for i in range(1, len(args.devices) + 1) ]
    fig, ax = plt.subplots()
    cum_size = [0] * len(args.devices)
    for device in args.devices:
        values = [i[plot['varname']] for i in summary if i['device'] == device]
        ax.bar(labels, values, bottom=cum_size, width=0.9, label=device)

        for a,b in enumerate(cum_size):
            cum_size[a] += values[a]

    if args.network_line_rate:
        lr_mb = args.network_line_rate * 125
        ax.plot(
            labels,
            [lr_mb]*len(args.devices), 
            label="Network Line Rate ({network_line_rate} Gbps)".format(
                network_line_rate=args.network_line_rate
                )
            )
    ax.tick_params(axis='x', which='major', labelsize=4)
    ax.set_title(plot['title'].format(
        hostname=socket.gethostname(),
        iperf_server=args.iperf_server
        )
    )
    ax.set_ylabel(plot['y_label'])
    ax.set_xlabel('OSDs active')
    ax.legend(bbox_to_anchor=(1.04, 1), loc="upper left")
    fig.savefig(
        PurePath(
            outdir
            ).joinpath(
            '{hostname}-aggregate-network-{name}.png'.format(
                hostname=socket.gethostname(),
                name=plot['name'],
                )
            ), 
            dpi=1000, 
            bbox_inches='tight'
        )
    
def parse_args():

    parser = argparse.ArgumentParser(
            description="""Plot the aggregated network read bandwidth of a set of block devices, such as Ceph OSDs, using iperf3.
                           Requires iperf3 servers listening on as many consecutive ports as devices to test."""
            )
    parser.add_argument('iperf_server', metavar='iperf3_server', type=str, help='iperf3 server address')
    parser.add_argument('devices', metavar='device', type=str, nargs='+',
                                help='Block device')
    parser.add_argument('-p', '--port_start', type=int, default=5201, help="First iperf3 server port (assumed consecutive after this) [Default: 5201]." )
    parser.add_argument('-c', '--cleanup', action='store_true', help="Clean up fio job and output JSON files [Default: no]." )
    parser.add_argument('-o', '--outdir', type=str, default='.', help="Output directory for plots and iperf json files [Default: .].")
    parser.add_argument('-r', '--runtime', type=int, default='10', help='iperf3 client time parameter in seconds [Default: 10].')
    parser.add_argument('-n', '--network-line-rate', type=int, help="Network line rate in Gbit" )
    args = parser.parse_args()
    return args

def make_output_directory(outdir):
    p = Path(outdir).resolve()

    p.mkdir(parents=True, exist_ok=True)

    return p

def check_block_devices(devices):
    for device in devices:
        if not Path(device).is_block_device():
            sys.exit("{device} is not a block device, quitting".format(
                device=device)
                )

def main():
    args = parse_args()
    check_block_devices(args.devices)
    outdir = make_output_directory(args.outdir)
    summary = run_iperf(args, outdir)
    for plot in PLOTS:
   	    plot_bar(summary, args, plot, outdir)

if __name__ == '__main__':
    main()
