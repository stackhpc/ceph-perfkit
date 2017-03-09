set terminal png size 1200,500 truecolor enhanced transparent rounded font "/usr/share/fonts/overpass/Overpass_Regular.ttf"
set output "rados-uncached-seq.png"
load "plot-seq.gp"

set output "rados-cached-rand.png"
load "plot-rand.gp"
