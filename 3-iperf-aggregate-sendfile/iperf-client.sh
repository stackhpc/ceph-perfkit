#!/bin/bash

target=$1

# Generate a lookup table of HDDs to include, in a sort-of
# alternating order between SATA controllers
i=0
for dev in sdd sdj sde sdk sdf sdl sdg sdm sdh sdn
do 
    osd[$i]=$dev
    i=$(($i + 1))
done

for ((count=1; $count <= 10; count=$count+1))
do
    echo "Testing $count OSDs..."
    for ((j=0; $j < $count; j=$j+1))
    do
        hdd=${osd[$j]}
	iperf3 -f M -c $target -p $((5201 + $j)) -F /dev/$hdd -Z -T $hdd -J > iperf3-$count-$hdd.json &
    done
    wait
done
