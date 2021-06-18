#gnuplotfile
set title "arch_x86-64.memory_latency.C.pthread.0.read"
set xlabel "data set size [Byte]"
set xtics ("1M" 1.000000e+06,"" 2.000000e+06 1,"" 3.000000e+06 1,"" 4.000000e+06 1,"" 5.000000e+06 1,"" 6.000000e+06 1,"" 7.000000e+06 1,"" 8.000000e+06 1,"" 9.000000e+06 1,"10M" 1.000000e+07,"" 2.000000e+07 1,"" 3.000000e+07 1,"" 4.000000e+07 1,"" 5.000000e+07 1,"" 6.000000e+07 1,"" 7.000000e+07 1,"" 8.000000e+07 1,"" 9.000000e+07 1)
set logscale x 10
set xrange [1.000000e+06:1.000000e+07]
set ytics ("15 " 1.500000e+01,"17.5 " 1.750000e+01,"20 " 2.000000e+01,"22.5 " 2.250000e+01,"25 " 2.500000e+01,"27.5 " 2.750000e+01,"30 " 3.000000e+01,"32.5 " 3.250000e+01,"35 " 3.500000e+01,"37.5 " 3.750000e+01,"40 " 4.000000e+01)
set yrange [1.500000e+01:4.000000e+01]
set ylabel "latency [cycles]"
set data style points
set term postscript eps color solid
set output "ROME_2498M__Conway__2020_10_14__14_32_38.bit.gp.eps"
plot "ROME_2498M__Conway__2020_10_14__14_32_38.bit" using 1:2 title 'memory latency CPU0 locally (CPU cycles)', "ROME_2498M__Conway__2020_10_14__14_32_38.bit" using 1:3 title 'memory latency CPU0 locally (time)'