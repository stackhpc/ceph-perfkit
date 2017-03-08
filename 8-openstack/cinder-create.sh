#!/bin/bash

vol_total=8
vol_gb=125
vol_type=9f312836-ee7d-42fb-b47d-60fa42cc4272

for ((i=0; $i<$vol_total; i=$i+1))
do
    cinder create --volume-type $vol_type --name ceph-$i $vol_gb
done
