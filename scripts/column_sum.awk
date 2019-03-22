#!/usr/bin/awk -f

{ for(i=2; i <= NF; i+= 2) { write_sum += $i } }
{ for(i=3; i <= NF; i+= 2) { read_sum += $i } }
{ print $1, write_sum, read_sum }
{ write_sum = 0; read_sum = 0 }
