#set terminal x11
set terminal png size 1200,500 truecolor enhanced transparent rounded font "/usr/share/fonts/overpass/Overpass_Regular.ttf"
set output "osd-agg-bw.png"
set style data histograms
set style histogram rowstacked
set boxwidth 1 relative
set style fill solid 1.0 border -1
set key bottom right
set ylabel "Aggregate Read Bandwidth (MB/s)"
set xlabel "OSDs active"

set xrange [-1:8.5]
set yrange [0:2000]

set datafile separator " "
plot 'bw-sdb.dat' using ($2/1000.0) t "OSD 1" lc rgb "#782D31", \
     'bw-sdc.dat' using ($2/1000.0) t "OSD 2" lc rgb "#863236", \
     'bw-sdd.dat' using ($2/1000.0) t "OSD 3" lc rgb "#93363B", \
     'bw-sde.dat' using ($2/1000.0) t "OSD 4" lc rgb "#A13B40", \
     'bw-sdf.dat' using ($2/1000.0) t "OSD 5" lc rgb "#9E434A", \
     'bw-sdg.dat' using ($2/1000.0) t "OSD 6" lc rgb "#AF535A", \
     'bw-sdh.dat' using ($2/1000.0) t "OSD 7" lc rgb "#CE6C71", \
     'bw-sdj.dat' using ($2/1000.0) t "OSD 8" lc rgb "#3E6736", \
     'bw-sdk.dat' using ($2/1000.0) t "OSD 9" lc rgb "#396F2E", \
     'bw-sdl.dat' using ($2/1000.0) t "OSD 10" lc rgb "#5D9154", \
     'bw-sdm.dat' using ($2/1000.0) t "OSD 11" lc rgb "#81BA77", \
     'bw-sdn.dat' using ($2/1000.0) t "OSD 12" lc rgb "#A0D898", \
     'bw-journal.dat' using ($2/1000.0):xticlabels(1) t "Journal SSD" lc rgb "#E0DCB3"

#pause -1
