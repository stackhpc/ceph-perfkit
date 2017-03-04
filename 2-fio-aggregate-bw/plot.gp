set terminal x11
set terminal png size 1800,750 truecolor enhanced transparent rounded font "/usr/share/fonts/overpass/Overpass_Regular.ttf"
set output "osd-agg-bw.png"
set style data histograms
set style histogram rowstacked
set boxwidth 1 relative
set style fill solid 1.0 border -1
set key bottom right
set ylabel "Aggregate Read Bandwidth (MB/s)"
set xlabel "OSDs active"

set xrange [-1:8]
set yrange [0:2000]

set datafile separator " "
plot 'bw-sdb.dat' using ($2/1000.0) t "OSD 1" lc rgb "#A00000", \
     'bw-sdc.dat' using ($2/1000.0) t "OSD 2" lc rgb "#B00000", \
     'bw-sdd.dat' using ($2/1000.0) t "OSD 3" lc rgb "#C00000", \
     'bw-sde.dat' using ($2/1000.0) t "OSD 4" lc rgb "#D00000", \
     'bw-sdf.dat' using ($2/1000.0) t "OSD 5" lc rgb "#E00000", \
     'bw-sdg.dat' using ($2/1000.0) t "OSD 6" lc rgb "#F00000", \
     'bw-sdh.dat' using ($2/1000.0) t "OSD 7" lc rgb "#FF0000", \
     'bw-sdj.dat' using ($2/1000.0) t "OSD 8" lc rgb "#00B000", \
     'bw-sdk.dat' using ($2/1000.0) t "OSD 9" lc rgb "#00C400", \
     'bw-sdl.dat' using ($2/1000.0) t "OSD 10" lc rgb "#00D800", \
     'bw-sdm.dat' using ($2/1000.0) t "OSD 11" lc rgb "#00EC00", \
     'bw-sdn.dat' using ($2/1000.0) t "OSD 12" lc rgb "#00FF00", \
     'bw-journal.dat' using ($2/1000.0):xticlabels(1) t "Journal SSD" lc rgb "#F0D020"

#pause -1
