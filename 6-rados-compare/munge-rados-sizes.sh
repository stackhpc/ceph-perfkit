#!/bin/bash

write_stem=$1
read_stem=$2

for ((i=1024; $i <= $((16*1024*1024)); i=$i*2))
do
	[[ -f $write_stem-$i.log ]] && echo "$i $(awk '$1=="Bandwidth" {print $3}' $write_stem-$i.log) $(awk '$1=="Bandwidth" {print $3}' $read_stem-$i.log)"
done
