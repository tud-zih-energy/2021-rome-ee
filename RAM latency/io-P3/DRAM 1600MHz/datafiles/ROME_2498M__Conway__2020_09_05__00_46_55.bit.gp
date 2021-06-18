#gnuplotfile
set title "arch_x86-64.memory_latency.C.pthread.0.read"
set xlabel "data set size [Byte]"
set xtics ("10k" 1.000000e+04,"" 2.000000e+04 1,"" 3.000000e+04 1,"" 4.000000e+04 1,"" 5.000000e+04 1,"" 6.000000e+04 1,"" 7.000000e+04 1,"" 8.000000e+04 1,"" 9.000000e+04 1,"100k" 1.000000e+05,"" 2.000000e+05 1,"" 3.000000e+05 1,"" 4.000000e+05 1,"" 5.000000e+05 1,"" 6.000000e+05 1,"" 7.000000e+05 1,"" 8.000000e+05 1,"" 9.000000e+05 1,"1M" 1.000000e+06,"" 2.000000e+06 1,"" 3.000000e+06 1,"" 4.000000e+06 1,"" 5.000000e+06 1,"" 6.000000e+06 1,"" 7.000000e+06 1,"" 8.000000e+06 1,"" 9.000000e+06 1,"10M" 1.000000e+07,"" 2.000000e+07 1,"" 3.000000e+07 1,"" 4.000000e+07 1,"" 5.000000e+07 1,"" 6.000000e+07 1,"" 7.000000e+07 1,"" 8.000000e+07 1,"" 9.000000e+07 1,"100M" 1.000000e+08,"" 2.000000e+08 1,"" 3.000000e+08 1,"" 4.000000e+08 1,"" 5.000000e+08 1,"" 6.000000e+08 1,"" 7.000000e+08 1,"" 8.000000e+08 1,"" 9.000000e+08 1,"1G" 1.000000e+09,"" 2.000000e+09 1,"" 3.000000e+09 1,"" 4.000000e+09 1,"" 5.000000e+09 1,"" 6.000000e+09 1,"" 7.000000e+09 1,"" 8.000000e+09 1,"" 9.000000e+09 1)
set logscale x 10
set xrange [1.000000e+04:1.000000e+09]
set ytics ("0 " 0.000000e+00,"100 " 1.000000e+02,"200 " 2.000000e+02,"300 " 3.000000e+02,"400 " 4.000000e+02,"500 " 5.000000e+02,"600 " 6.000000e+02)
set yrange [0.000000e+00:6.000000e+02]
set ylabel "latency [cycles]"
set data style points
set term postscript eps color solid
set output "ROME_2498M__Conway__2020_09_05__00_46_55.bit.gp.eps"
plot "ROME_2498M__Conway__2020_09_05__00_46_55.bit" using 1:2 title 'memory latency CPU0 locally (CPU cycles)', "ROME_2498M__Conway__2020_09_05__00_46_55.bit" using 1:3 title 'memory latency CPU0 accessing CPU4 memory (CPU cycles)', "ROME_2498M__Conway__2020_09_05__00_46_55.bit" using 1:4 title 'memory latency CPU0 locally (time)', "ROME_2498M__Conway__2020_09_05__00_46_55.bit" using 1:5 title 'memory latency CPU0 accessing CPU4 memory (time)'