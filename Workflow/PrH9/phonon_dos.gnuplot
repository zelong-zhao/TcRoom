set term png
set output 'phonon-dos.png'
set xlabel 'dos'
set ylabel '\Omega qv (cm−1)'
set yrange[0:]
p 'phonon.dos' u 2:1 notitle w l
