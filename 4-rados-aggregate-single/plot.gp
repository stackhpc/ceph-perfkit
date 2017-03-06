#set terminal x11
set terminal png size 1200,520 truecolor enhanced transparent rounded font "/usr/share/fonts/overpass/Overpass_Regular.ttf"
set output "rados-single-agg.png"
set style data histograms
set style histogram rowstacked
set boxwidth 1 relative
set style fill solid 1.0 border -1
set key bottom right
set ylabel "RADOS Read Bandwidth (MB/s)"
set xlabel "OSDs in Ceph pool"
set grid

set xrange [-2:7.5]
set yrange [0:300]

plot 'iostat-sdb.dat' using 2 t "OSD 1" lc rgb "#782D31", \
     'iostat-sdc.dat' using 2 t "OSD 2" lc rgb "#863236", \
     'iostat-sdd.dat' using 2 t "OSD 3" lc rgb "#93363B", \
     'iostat-sde.dat' using 2 t "OSD 4" lc rgb "#A13B40", \
     'iostat-sdf.dat' using 2 t "OSD 5" lc rgb "#9E434A", \
     'iostat-sdg.dat' using 2 t "OSD 6" lc rgb "#AF535A", \
     'iostat-sdh.dat' using 2 t "OSD 7" lc rgb "#CE6C71", \
     'iostat-sdj.dat' using 2 t "OSD 8" lc rgb "#3E6736", \
     'iostat-sdk.dat' using 2 t "OSD 9" lc rgb "#396F2E", \
     'iostat-sdl.dat' using 2 t "OSD 10" lc rgb "#5D9154", \
     'iostat-sdm.dat' using 2 t "OSD 11" lc rgb "#81BA77", \
     'iostat-sdn.dat' using 2:xticlabels(1) t "OSD 12" lc rgb "#A0D898", \
     'radosbench.dat' using 2 with lines lw 5 lc rgb "#AEAC85" t "RADOS bench", \
     'radosbench.dat' using 2 with points ps 2 lc rgb "#707474" notitle

#pause -1
