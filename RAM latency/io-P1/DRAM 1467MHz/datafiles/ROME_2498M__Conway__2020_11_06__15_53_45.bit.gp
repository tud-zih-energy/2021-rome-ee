#gnuplotfile
set title "arch_x86-64.memory_latency.C.pthread.0.read"
set xlabel "data set size [Byte]"
set xtics ("10M" 1.000000e+07,"" 2.000000e+07 1,"" 3.000000e+07 1,"" 4.000000e+07 1,"" 5.000000e+07 1,"" 6.000000e+07 1,"" 7.000000e+07 1,"" 8.000000e+07 1,"" 9.000000e+07 1,"100M" 1.000000e+08,"" 2.000000e+08 1,"" 3.000000e+08 1,"" 4.000000e+08 1,"" 5.000000e+08 1,"" 6.000000e+08 1,"" 7.000000e+08 1,"" 8.000000e+08 1,"" 9.000000e+08 1)
set logscale x 10
set xrange [1.000000e+07:1.000000e+08]
set ytics ("100 " 1.000000e+02,"125 " 1.250000e+02,"150 " 1.500000e+02,"175 " 1.750000e+02,"200 " 2.000000e+02,"225 " 2.250000e+02,"250 " 2.500000e+02,"275 " 2.750000e+02,"300 " 3.000000e+02,"325 " 3.250000e+02,"350 " 3.500000e+02)
set yrange [1.000000e+02:3.500000e+02]
set ylabel "latency [cycles]"
set data style points
set term postscript eps color solid
set output "ROME_2498M__Conway__2020_11_06__15_53_45.bit.gp.eps"
plot "ROME_2498M__Conway__2020_11_06__15_53_45.bit" using 1:2 title 'memory latency CPU0 locally (CPU cycles)', "ROME_2498M__Conway__2020_11_06__15_53_45.bit" using 1:3 title 'memory latency CPU0 accessing CPU28 memory (CPU cycles)', "ROME_2498M__Conway__2020_11_06__15_53_45.bit" using 1:4 title 'memory latency CPU0 locally (time)', "ROME_2498M__Conway__2020_11_06__15_53_45.bit" using 1:5 title 'memory latency CPU0 accessing CPU28 memory (time)'