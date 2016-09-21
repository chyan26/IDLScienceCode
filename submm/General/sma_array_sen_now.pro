
t=findgen(100)+1

sigma=5

s1_sma=sigma*sma_sen(800,t)
s2_sma=sigma*sma_sen(700,t)
s3_sma=sigma*sma_sen(600,t)
s4_sma=sigma*sma_sen(500,t)

s_scuba=8/sqrt(t)

set_plot,'ps'
device,/encapsulated,filename='~chyan/Notes/sma_array_sensitivity.eps',$
	xsize=20,ysize=15,yoffset=200,/portrait,xoffset=20
plot,t,s1_sma(1,*),linestyle=0,/ylog,/xlog,yrange=[1,50],ystyle=1,$
	xtitle='!6Observation Time (Hours)',ytitle='5-sigma Sensitivity (mJy)',$
	xcharsize=1.3,ycharsize=1.3,xrange=[1,60],xstyle=0

oplot,t,s2_sma(1,*),linestyle=1
oplot,t,s3_sma(1,*),linestyle=2
oplot,t,s4_sma(1,*),linestyle=3


oplot,t,s_scuba,thick=5
xyouts,30,1.5,'SCUBA Sensitivities',/data

;xyouts,25,0.25,'SMA Sensitivities',/data
;xyouts,25,0.02,'ALMA Sensitivities',/data

xyouts,35,40,'Tsys = 800 K',/data
xyouts,35,35,'Tsys = 700 K',/data
xyouts,35,30,'Tsys = 600 K',/data
xyouts,35,25,'Tsys = 500 K',/data

oplot,[25,30],[40,40],linestyle=0
oplot,[25,30],[35,35],linestyle=1
oplot,[25,30],[30,30],linestyle=2
oplot,[25,30],[25,25],linestyle=3


oplot,[8,8],[1,100],linestyle=0
oplot,[56,56],[1,100],linestyle=0

;oplot,t,s_alma(0,*),linestyle=1
;oplot,t,s_alma(1,*),linestyle=0
;oplot,t,s_alma(2,*),linestyle=2
device,/close
end
