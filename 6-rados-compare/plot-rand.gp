set key top left
set ylabel "RADOS Object Bandwidth (MB/s)"
set xlabel "Object size (KB)"
set grid

set logscale x 2
set xrange [0.5:32768]
set yrange [0:4000]

plot 'rados-rand-dell/rados-rand-dell.dat' using ($1/1000.0):2 with linespoints lw 4 lc rgb "#782D31" t "Reference write", \
     'rados-rand-softiron/rados-rand-softiron.dat' using ($1/1000.0):2 with linespoints lw 4 lc rgb "#3A5D33" t "SoftIron write", \
     'rados-rand-dell/rados-rand-dell.dat' using ($1/1000.0):3 with linespoints lw 4 lc rgb "#C29396" t "Reference read", \
     'rados-rand-softiron/rados-rand-softiron.dat' using ($1/1000.0):3 with linespoints lw 4 lc rgb "#80AE77" t "SoftIron read"
