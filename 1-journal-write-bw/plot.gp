#set terminal x11
set terminal png size 1200,500 truecolor enhanced transparent rounded
set output "journal-write-bw.png"

set style data boxes
set style fill transparent solid 0.5 border -1

set ylabel "Aggregate Write Bandwidth (MB/s)"
set xlabel "Concurrent Write Operations"

set xrange [-1:12]
set yrange [0:500]

plot 'journal_write_bw.dat' using ($2/1000.0):xticlabels(1) lc rgb "#E0DAB3" notitle

#pause -1
