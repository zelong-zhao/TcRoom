set term png
set output 'phonon-dispersion.png'
set xlabel 'k path'
set ylabel '\omega qv (cm−1)'
#set xrange[0:40]
set yrange[0:]
N = system("awk 'NR==1{print NF}' elph333.freq.gp")
plot for [i=2:N] 'elph333.freq.gp' u 1:i notitle w l
