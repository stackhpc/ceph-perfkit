set terminal x11
set terminal png size 1200,500 truecolor enhanced transparent rounded font "/usr/share/fonts/overpass/Overpass_Regular.ttf"
set output "osd-agg-iperf.png"
set style data histograms
set style histogram rowstacked
set boxwidth 1 relative
set style fill solid 1.0 border -1
set key bottom right
set ylabel "Aggregate Read Bandwidth (MB/s)"
set xlabel "OSDs active"

set xrange [-1:8]
set yrange [0:2000]

set datafile separator "\t"
plot 'iperf3-sdb.dat' using ($2/1000000.0) t "OSD 1" lc rgb "#A00000", \
     'iperf3-sdc.dat' using ($2/1000000.0) t "OSD 2" lc rgb "#B00000", \
     'iperf3-sdd.dat' using ($2/1000000.0) t "OSD 3" lc rgb "#C00000", \
     'iperf3-sde.dat' using ($2/1000000.0) t "OSD 4" lc rgb "#D00000", \
     'iperf3-sdf.dat' using ($2/1000000.0) t "OSD 5" lc rgb "#E00000", \
     'iperf3-sdg.dat' using ($2/1000000.0) t "OSD 6" lc rgb "#F00000", \
     'iperf3-sdh.dat' using ($2/1000000.0) t "OSD 7" lc rgb "#FF0000", \
     'iperf3-sdj.dat' using ($2/1000000.0) t "OSD 8" lc rgb "#00B000", \
     'iperf3-sdk.dat' using ($2/1000000.0) t "OSD 9" lc rgb "#00C400", \
     'iperf3-sdl.dat' using ($2/1000000.0) t "OSD 10" lc rgb "#00D800", \
     'iperf3-sdm.dat' using ($2/1000000.0) t "OSD 11" lc rgb "#00EC00", \
     'iperf3-sdn.dat' using ($2/1000000.0) t "OSD 12" lc rgb "#00FF00", \
     'iperf3-sdi.dat' using ($2/1000000.0):xticlabels(1) t "Journal SSD" lc rgb "#F0D020", \
     1250 t "10G Line rate" lc rgb "#F0A0A0" lw 2

#pause -1
