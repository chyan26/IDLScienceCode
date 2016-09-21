
t=findgen(100)+1
s_alma=alma_sen(400,t)
s_sma=sma_sen(600,t)
s_scuba=8/sqrt(t)

set_plot,'ps'
device,/encapsulated,filename='~chyan/array_sensitivity.eps',$
	xsize=20,ysize=15,yoffset=200,/portrait,xoffset=20
plot,t,s_sma(0,*),linestyle=1,/ylog,/xlog,yrange=[0.005,10],ystyle=1,$
	xtitle='!6Observation Time (Hours)',ytitle='Semsitivity (mJy)',$
	xcharsize=1.3,ycharsize=1.3
oplot,t,s_sma(1,*),linestyle=0
oplot,t,s_sma(2,*),linestyle=2

oplot,t,s_scuba,thick=5
xyouts,30,1.5,'SCUBA Sensitivities',/data

xyouts,25,0.25,'SMA Sensitivities',/data
xyouts,25,0.02,'ALMA Sensitivities',/data
xyouts,50,6.5,'230 GHz',/data
xyouts,50,4.5,'345 GHz',/data
xyouts,50,3,'650 GHz',/data
oplot,[35,45],[6.5,6.5],linestyle=1
oplot,[35,45],[4.5,4.5],linestyle=0
oplot,[35,45],[3,3],linestyle=2

oplot,t,s_alma(0,*),linestyle=1
oplot,t,s_alma(1,*),linestyle=0
oplot,t,s_alma(2,*),linestyle=2
device,/close
end
