#set terminal x11
set terminal png size 1200,500 truecolor enhanced transparent rounded font "/usr/share/fonts/overpass/Overpass_Regular.ttf"
set output "rados-scaleout.png"
set key top left
set ylabel "RADOS Object Bandwidth (MB/s)"
set xlabel "OSDs in Ceph pool"

set xrange [0:38]
set yrange [0:1000]

plot 'rados-scaleout.dat' using 1:2 with linespoints lw 4 lc rgb "#E0DAB3" t "RADOS write", \
     'rados-scaleout.dat' using 1:3 with linespoints lw 4 lc rgb "#707474" t "RADOS read"

#pause -1
