PRO scuba_count

;set_plot,'ps'
;device,filename='/home/chyan/Thesis/Latex/scuba_fits.eps'$
;	,/encapsulated,xsize=20,ysize=20



raw=read_ascii('/home/chyan/Scuba_count/temp')

data=reform(raw.field1)

plot,data(0,*),data(1,*),psym=4,/xlog,/ylog,yrange=[1,5d5]$
	,xrange=[0.1,20],xstyle=1,ystyle=1,xtitle='!6Flux (mJy)'$
	,ytitle='Accumulative source counts (per square degree)'$
	,xcharsize=1.3,ycharsize=1.3
errplot,data(0,*),data(1,*)+data(2,*),data(1,*)-data(3,*)


;fp=1.05
;rr=[11885.9,-1.05062]
;r2=[12351.1,-1.80263]
;xx=series(fp,20.0,100)
;x2=series(0.23,fp,100)
;oplot,x2,rr[0]*x2^rr[1],line=2,thick=2
;oplot,xx,r2[0]*xx^r2[1],line=2,thick=2
;xyouts,0.4,5d4,'Sky 2',/data,charsize=1.5

;fp=1.033
;rr=[11885.9,-0.625103]
;r2=[12351.1,-1.80263]
;xx=series(fp,20.0,100)
;x2=series(0.01,fp,100)
;oplot,x2,rr[0]*x2^rr[1],line=1,thick=2
;oplot,xx,r2[0]*xx^r2[1],line=1,thick=2
;xyouts,0.015,1d5,'Sky 3',/data,charsize=1.5

;s=series(0.01,20,100)
;n=barger_sn(20428.0,1.055,2.252,s)
;oplot,s,n,thick=2
;xyouts,0.015,1d4,'Sky 1',/data,charsize=1.5


;xyouts,0.015,2,'Data points: Scott et al.,2002+ Smail et al.,2002',/data,charsize=1

;device,/close
;set_plot,'x'

end
