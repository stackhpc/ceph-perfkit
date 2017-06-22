#set terminal x11
set terminal png size 1200,520 truecolor enhanced transparent rounded font "/usr/share/fonts/overpass/Overpass_Regular.ttf"
set output "rados-single-agg-combined.png"
set style data histograms
set style histogram rowstacked
set boxwidth 1 relative
set style fill solid 1.0 border -1
set key bottom right
set ylabel "RADOS Read Bandwidth (MB/s)"
set xlabel "OSDs in Ceph pool"
set grid

set xrange [-1:12.5]
set yrange [0:1500]

plot 'run-uncached/iostat-sdd.dat' using 2 t "OSD 1" lc rgb "#782D31", \
     'run-uncached/iostat-sde.dat' using 2 t "OSD 2" lc rgb "#863236", \
     'run-uncached/iostat-sdf.dat' using 2 t "OSD 3" lc rgb "#93363B", \
     'run-uncached/iostat-sdg.dat' using 2 t "OSD 4" lc rgb "#A13B40", \
     'run-uncached/iostat-sdh.dat' using 2 t "OSD 5" lc rgb "#9E434A", \
     'run-uncached/iostat-sdj.dat' using 2 t "OSD 6" lc rgb "#3E6736", \
     'run-uncached/iostat-sdk.dat' using 2 t "OSD 7" lc rgb "#396F2E", \
     'run-uncached/iostat-sdl.dat' using 2 t "OSD 8" lc rgb "#5D9154", \
     'run-uncached/iostat-sdm.dat' using 2 t "OSD 9" lc rgb "#81BA77", \
     'run-uncached/iostat-sdn.dat' using 2:xticlabels(1) t "OSD 10" lc rgb "#A0D898", \
     'run-uncached/radosbench.dat' using 2 with lines lw 5 lc rgb "#AEAC85" t "RADOS uncached", \
     'run-uncached/radosbench.dat' using 2 with points ps 2 lc rgb "#707474" notitle, \
     'run-cached/radosbench.dat' using 2 with lines lw 5 lc rgb "#FFAC85" t "RADOS cached", \
     'run-cached/radosbench.dat' using 2 with points ps 2 lc rgb "#707474" notitle, \
     1250 t "10G Line rate" lc rgb "#F0A0A0" lw 2

#pause -1
