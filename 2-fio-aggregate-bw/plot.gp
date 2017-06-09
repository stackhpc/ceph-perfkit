#set terminal x11
set terminal png size 1200,500 truecolor enhanced transparent rounded font "/usr/share/fonts/overpass/Overpass_Regular.ttf"
set output "osd-agg-bw-ssd-hdd.png"
set style data histograms
set style histogram rowstacked
set boxwidth 1 relative
set style fill solid 1.0 border -1
set key bottom right
set ylabel "Aggregate Read Bandwidth (MB/s)"
set xlabel "OSDs active"

set xrange [-1:12.5]
set yrange [0:2500]

set datafile separator " "
plot 'bw-ssd-hdd-sdd.dat' using ($2/1000.0) t "OSD 1" lc rgb "#782D31", \
     'bw-ssd-hdd-sde.dat' using ($2/1000.0) t "OSD 2" lc rgb "#863236", \
     'bw-ssd-hdd-sdf.dat' using ($2/1000.0) t "OSD 3" lc rgb "#93363B", \
     'bw-ssd-hdd-sdg.dat' using ($2/1000.0) t "OSD 4" lc rgb "#A13B40", \
     'bw-ssd-hdd-sdh.dat' using ($2/1000.0) t "OSD 5" lc rgb "#9E434A", \
     'bw-ssd-hdd-sdj.dat' using ($2/1000.0) t "OSD 6" lc rgb "#3E6736", \
     'bw-ssd-hdd-sdk.dat' using ($2/1000.0) t "OSD 7" lc rgb "#396F2E", \
     'bw-ssd-hdd-sdl.dat' using ($2/1000.0) t "OSD 8" lc rgb "#5D9154", \
     'bw-ssd-hdd-sdm.dat' using ($2/1000.0) t "OSD 9" lc rgb "#81BA77", \
     'bw-ssd-hdd-sdn.dat' using ($2/1000.0):xticlabels(1) t "OSD 10" lc rgb "#A0D898", \
     'bw-ssd-hdd-sdb.dat' using ($2/1000.0) t "Journal 1" lc rgb "#D5A1A6", \
     'bw-ssd-hdd-sdc.dat' using ($2/1000.0) t "Journal 2" lc rgb "#EBBEC3", \
     'bw-ssd-hdd-sdi.dat' using ($2/1000.0) t "Journal 3" lc rgb "#A6C49F"

#pause -1
