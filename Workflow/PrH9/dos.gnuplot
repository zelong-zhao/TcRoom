set term png
set output 'dos.png'

# set Fermi energy to correct value
Efermi=32.026
# ... and uncomment the following line
set yzeroaxis lt -1

set xrange[-45:50]
set yrange[0:8]
# set grid
set xlabel "Energy (eV)"
set ylabel "DOS"
#set style fill solid 0.1
set format y "%.1f"

set title "QE DOS"

plot [:][:] \
      'PrH9.dos' u ($1-Efermi):2 notit w l lt 2 lw 1
#     'PrH9.dos' u ($1-Efermi):3 notit w l lt 3 lw 1
#     'PrH9.dos' u ($1-Efermi):3 notit w filledcurve lt 1
#, \
#     'PrH9.dos' u ($1-Efermi):3 notit w l lt 1 lw 2
#pause -1

rep
