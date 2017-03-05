#!/bin/bash

for i in {1..36}
do
	echo "$i $(awk '$1=="Bandwidth" {print $3}' scaleout-write-$i.log) $(awk '$1=="Bandwidth" {print $3}' scaleout-read-$i.log)"
done
