set term png size 800,600
set output 'a2F.png'

set xlabel '\Omega (meV)'
set ylabel 'a2F(\Omega)'
set ytics nomirror
set y2label 'log(\Omega)/\Omega'
set y2tics nomirror
set y2range[0:]

set xrange[0:]

plot 'a2F.dos1' u ($1*13.6*10**3):2 w l,\
'a2F.dos1' u ($1*13.6*10**3):(log($1*13.6*10**3)/($1*13.6*10**3)) w l axes x1y2
pause -1
