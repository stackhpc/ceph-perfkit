#set terminal x11
set terminal png size 1200,500 truecolor enhanced transparent rounded font "/usr/share/fonts/overpass/Overpass_Regular.ttf"
set output "rados-single-agg.png"
set style data histograms
set style histogram rowstacked
set boxwidth 1 relative
set style fill solid 1.0 border -1
set key bottom right
set ylabel "RADOS Read Bandwidth (MB/s)"
set xlabel "OSDs in Ceph pool"

set xrange [-1:8]
set yrange [0:500]

plot 'iostat-sdb.dat' using 2 t "OSD 1" lc rgb "#A00000", \
     'iostat-sdc.dat' using 2 t "OSD 2" lc rgb "#B00000", \
     'iostat-sdd.dat' using 2 t "OSD 3" lc rgb "#C00000", \
     'iostat-sde.dat' using 2 t "OSD 4" lc rgb "#D00000", \
     'iostat-sdf.dat' using 2 t "OSD 5" lc rgb "#E00000", \
     'iostat-sdg.dat' using 2 t "OSD 6" lc rgb "#F00000", \
     'iostat-sdh.dat' using 2 t "OSD 7" lc rgb "#FF0000", \
     'iostat-sdj.dat' using 2 t "OSD 8" lc rgb "#00B000", \
     'iostat-sdk.dat' using 2 t "OSD 9" lc rgb "#00C400", \
     'iostat-sdl.dat' using 2 t "OSD 10" lc rgb "#00D800", \
     'iostat-sdm.dat' using 2 t "OSD 11" lc rgb "#00EC00", \
     'iostat-sdn.dat' using 2:xticlabels(1) t "OSD 12" lc rgb "#00FF00", \
     'radosbench.dat' using 2 with lines lw 5 lc rgb "#E0DAB3" t "RADOS bench", \
     'radosbench.dat' using 2 with points ps 2 lc rgb "black" notitle

#pause -1
