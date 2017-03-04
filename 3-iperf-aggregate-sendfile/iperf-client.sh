#!/bin/bash

target=$1

# Generate a lookup table of HDDs to include, in a sort-of
# alternating order between SATA controllers
i=0
for hdd in sdb sdj sdc sdk sdd sdl sde sdm sdf sdn sdg sdh
do 
    osd[$i]=$hdd
    i=$(($i + 1))
done
ssd=sdi

for ((count=0; $count <= 12; count=$count+2))
do
    echo "Testing $count OSDs..."
    iperf3 -f M -c $target -p 5200 -F /dev/$ssd -Z -T $ssd -J > iperf3-$count-$ssd.json &
    for ((j=0; $j < $count; j=$j+1))
    do
        hdd=${osd[$j]}
	iperf3 -f M -c $target -p $((5201 + $j)) -F /dev/$hdd -Z -T $hdd -J > iperf3-$count-$hdd.json &
    done
    wait
done
