#gnuplotfile
set title "arch_x86-64.throughput.C.pthread.SIMD.multiple-worker-vt-inst-manual"
set xlabel "data set size [Byte]"
set xtics ("10k" 1.000000e+04,"100k" 1.000000e+05,"1M" 1.000000e+06,"10M" 1.000000e+07,"100M" 1.000000e+08,"1G" 1.000000e+09,"10G" 1.000000e+10)
set logscale x 10
set xrange [1.000000e+04:1.000000e+10]
set ytics ("0 " 0.000000e+00,"50 " 5.000000e+01,"100 " 1.000000e+02,"150 " 1.500000e+02,"200 " 2.000000e+02,"250 " 2.500000e+02,"300 " 3.000000e+02,"350 " 3.500000e+02,"400 " 4.000000e+02,"450 " 4.500000e+02)
set yrange [0.000000e+00:4.500000e+02]
set ylabel "bandwidth [GB/s]"
set data style points
set term postscript eps color solid
set output "ROME_2498M__Conway__2020_11_13__03_00_19.bit.gp.eps"
plot "ROME_2498M__Conway__2020_11_13__03_00_19.bit" using 1:2 title 'bandwidth 0-2 '