#gnuplotfile
set title "arch_x86-64.throughput.C.pthread.SIMD.multiple-worker-vt-inst-manual"
set xlabel "data set size [Byte]"
set xtics ("10k" 1.000000e+04,"100k" 1.000000e+05,"1M" 1.000000e+06,"10M" 1.000000e+07,"100M" 1.000000e+08,"1G" 1.000000e+09,"10G" 1.000000e+10)
set logscale x 10
set xrange [1.000000e+04:1.000000e+10]
set ytics ("25 " 2.500000e+01,"50 " 5.000000e+01,"75 " 7.500000e+01,"100 " 1.000000e+02,"125 " 1.250000e+02,"150 " 1.500000e+02)
set yrange [2.500000e+01:1.500000e+02]
set ylabel "bandwidth [GB/s]"
set data style points
set term postscript eps color solid
set output "ROME_2498M__Conway__2020_11_12__15_20_56.bit.gp.eps"
plot "ROME_2498M__Conway__2020_11_12__15_20_56.bit" using 1:2 title 'bandwidth 0-1 '