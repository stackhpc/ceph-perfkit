set terminal png size 900,650 large truecolor enhanced transparent rounded font "/usr/share/fonts/overpass/Overpass_Regular.ttf"

set style data lines
set key top left
set xlabel "Object Size (KB)"
set grid

set logscale x 2
set xrange [16:8192]
set yrange [0:70000]

set title "RADOS Object Bandwidth"
set output "rados-total.png"
set ylabel "Object Bandwidth (MB/s)"
plot 'lvm_957/lvm_957-total.dat' using ($1/1000.0):3 with linespoints lw 2 lc rgb "#008040" title "reads", \
     'lvm_957/lvm_957-total.dat' using ($1/1000.0):2 with linespoints lw 2 lc rgb "#804000" title "writes", \

set title "RADOS Object Reads - per client"
set output "rados-reads-stacked.png"
set ylabel "Object Read Bandwidth (MB/s)"
plot 'lvm_957/lvm_957.dat' using ($1/1000.0):3 with linespoints lw 2 lc rgb "#7f523f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($3+$5) with linespoints lw 2 lc rgb "#7f663f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($3+$5+$7) with linespoints lw 2 lc rgb "#727f3f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($3+$5+$7+$9) with linespoints lw 2 lc rgb "#5f7f3f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($3+$5+$7+$9+$11) with linespoints lw 2 lc rgb "#4c7f3f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($3+$5+$7+$9+$11+$13) with linespoints lw 2 lc rgb "#3f7f46" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($3+$5+$7+$9+$11+$13+$15) with linespoints lw 2 lc rgb "#3f7f59" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($3+$5+$7+$9+$11+$13+$15+$17) with linespoints lw 2 lc rgb "#3f7f6c" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($3+$5+$7+$9+$11+$13+$15+$17+$19) with linespoints lw 2 lc rgb "#3f7f7f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($3+$5+$7+$9+$11+$13+$15+$17+$19+$21) with linespoints lw 2 lc rgb "#3f6c7f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($3+$5+$7+$9+$11+$13+$15+$17+$19+$21+$23) with linespoints lw 2 lc rgb "#3f597f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($3+$5+$7+$9+$11+$13+$15+$17+$19+$21+$23+$25) with linespoints lw 2 lc rgb "#3f467f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($3+$5+$7+$9+$11+$13+$15+$17+$19+$21+$23+$25+$27) with linespoints lw 2 lc rgb "#4c3f7f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($3+$5+$7+$9+$11+$13+$15+$17+$19+$21+$23+$25+$27+$29) with linespoints lw 2 lc rgb "#5f3f7f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($3+$5+$7+$9+$11+$13+$15+$17+$19+$21+$23+$25+$27+$29+$31) with linespoints lw 2 lc rgb "#723f7f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($3+$5+$7+$9+$11+$13+$15+$17+$19+$21+$23+$25+$27+$29+$31+$33) with linespoints lw 2 lc rgb "#7f3f79" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($3+$5+$7+$9+$11+$13+$15+$17+$19+$21+$23+$25+$27+$29+$31+$33+$35) with linespoints lw 2 lc rgb "#7f3f65" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($3+$5+$7+$9+$11+$13+$15+$17+$19+$21+$23+$25+$27+$29+$31+$33+$35+$37) with linespoints lw 2 lc rgb "#7f3f52" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($3+$5+$7+$9+$11+$13+$15+$17+$19+$21+$23+$25+$27+$29+$31+$33+$35+$37+$39) with linespoints lw 2 lc rgb "#7f3f3f" notitle, \
     'lvm_957/lvm_957-total.dat' using ($1/1000.0):3 with linespoints lw 2 lc rgb "#000000" title "19 clients"

set yrange [0:70000]

set title "RADOS Object Writes - per client"
set output "rados-writes-stacked.png"
set ylabel "Object Write Bandwidth (MB/s)"
plot 'lvm_957/lvm_957.dat' using ($1/1000.0):2 with linespoints lw 2 lc rgb "#7f523f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($2+$4) with linespoints lw 2 lc rgb "#7f663f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($2+$4+$6) with linespoints lw 2 lc rgb "#727f3f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($2+$4+$6+$8) with linespoints lw 2 lc rgb "#5f7f3f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($2+$4+$6+$8+$10) with linespoints lw 2 lc rgb "#4c7f3f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($2+$4+$6+$8+$10+$12) with linespoints lw 2 lc rgb "#3f7f46" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($2+$4+$6+$8+$10+$12+$14) with linespoints lw 2 lc rgb "#3f7f59" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($2+$4+$6+$8+$10+$12+$14+$16) with linespoints lw 2 lc rgb "#3f7f6c" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($2+$4+$6+$8+$10+$12+$14+$16+$18) with linespoints lw 2 lc rgb "#3f7f7f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($2+$4+$6+$8+$10+$12+$14+$16+$18+$20) with linespoints lw 2 lc rgb "#3f6c7f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($2+$4+$6+$8+$10+$12+$14+$16+$18+$20+$22) with linespoints lw 2 lc rgb "#3f597f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($2+$4+$6+$8+$10+$12+$14+$16+$18+$20+$22+$24) with linespoints lw 2 lc rgb "#3f467f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($2+$4+$6+$8+$10+$12+$14+$16+$18+$20+$22+$24+$26) with linespoints lw 2 lc rgb "#4c3f7f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($2+$4+$6+$8+$10+$12+$14+$16+$18+$20+$22+$24+$26+$28) with linespoints lw 2 lc rgb "#5f3f7f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($2+$4+$6+$8+$10+$12+$14+$16+$18+$20+$22+$24+$26+$28+$30) with linespoints lw 2 lc rgb "#723f7f" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($2+$4+$6+$8+$10+$12+$14+$16+$18+$20+$22+$24+$26+$28+$30+$32) with linespoints lw 2 lc rgb "#7f3f79" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($2+$4+$6+$8+$10+$12+$14+$16+$18+$20+$22+$24+$26+$28+$30+$32+$34) with linespoints lw 2 lc rgb "#7f3f65" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($2+$4+$6+$8+$10+$12+$14+$16+$18+$20+$22+$24+$26+$28+$30+$32+$34+$36) with linespoints lw 2 lc rgb "#7f3f52" notitle, \
     'lvm_957/lvm_957.dat' using ($1/1000.0):($2+$4+$6+$8+$10+$12+$14+$16+$18+$20+$22+$24+$26+$28+$30+$32+$34+$36+$38) with linespoints lw 2 lc rgb "#7f3f3f" notitle, \
     'lvm_957/lvm_957-total.dat' using ($1/1000.0):2 with linespoints lw 2 lc rgb "#000000" title "19 clients"
