pro multiplot_less_basic
!y.style=1 ;setting style such that IDL will exactly draw axes as I want
!x.style=1

multiplot, [0, 4, 2, 0, 0] ;initialize the plot to be 4 columns and 2 rows
p1=!p.position 	;at each plot I save the position keyword for later use
multiplot
p2=!p.position
multiplot
p3=!p.position
multiplot
p4=!p.position
multiplot
p5=!p.position
multiplot
p6=!p.position
multiplot
p7=!p.position
multiplot
p8=!p.position






!p.position=p1	;here I set the position for the plot to match the first plot from above
plot, findgen(10)+0.5, ytickname=replicate('', 20);this ytitle line is to turn yaxis back on
!p.position=p2
plot, findgen(10)+0.5
!p.position=p3
plot, findgen(10)+0.5
!p.position=p4
plot, findgen(10)+0.5
!p.position=p5
!p.position[2]=p2[2];here I edit the position keyword so it spans 2 plot boxes
plot, findgen(10)+0.5,ytickname=replicate('', 20)
!p.position=p7
!p.position[2]=p4[2]
plot, findgen(10)+0.5



;;to reset back to normal (non-multiplot) mode use cleanplot
;;http://astro.uni-tuebingen.de/software/idl/astrolib/plot/cleanplot.html

end

