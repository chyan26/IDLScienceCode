PRO TELESCOPE_COMP_SKY1

;!p.multi=[0,2,2]

s=series(0.01,20,1000)
n=barger_sn(20284,1.033,2.25,s)
t_total=1000


set_plot,'ps'
device,filename='/home/chyan/Temp/alma_sma_compare_sky1a.eps'$
	,/encapsulated,xsize=20,ysize=20
;!p.multi=[0,2,1]
plot,[1,1d4],[1,1d4],/nodata,/xlog,/ylog,yrange=[1,1d4],xrange=[1,1d3],xstyle=1$
	,xtitle='!6Exposure time per pointing (Hours)',xcharsize=1.5$
	,ytitle='Total detected counts (n)',ycharsize=1.5
;---------------------------------------
;  SMA
;---------------------------------------
t=findgen(t_total)+1
dd=sma_sen(400,t)
ds_sma=3.0*reform(dd(1,*))
field=t_total/t
;ct_sma=barger_sn(20428.0,1.055,2.252,ds_sma)*0.36/3600*field
ct_sma=interpol(n,s,ds_sma)*0.36/3600*field

oplot,t,ct_sma,thick=5
drsma=0.84
frsma=0.17

errsma=sqrt(ct_sma)*sqrt(1+frsma)/drsma

ct_smaup=ct_sma+errsma
ct_smalo=ct_sma-errsma
oplot,t,ct_smaup,line=1
oplot,t,ct_smalo,line=1
xyouts,600,3,'SMA',charsize=1.3

;---------------------------------------
;  ALMA
;----------------------------
t_alma=findgen(t_total)+1
dd=alma_sen(400,t)
ds_alma=4.0*reform(dd(1,*))

field_alma=t_total/t_alma


;ct_alma=barger_sn(20428.0,1.055,2.252,ds_alma)*field_alma*0.09/3600
ct_alma=interpol(n,s,ds_alma)*field_alma*0.09/3600

dralma=0.81
fralma=0.0

erralma=sqrt(ct_alma)*sqrt(1+fralma)/dralma

ct_almaup=ct_alma+erralma
ct_almalo=ct_alma-erralma

oplot,t,ct_alma,thick=5, line=2
oplot,t,ct_almaup,line=3
oplot,t,ct_almalo,line=3

xyouts,200,2,'ALMA',charsize=1.3
;---------------------------------
; SCUBA
;---------------------------------
t_scuba=findgen(t_total)+1
ds_scuba=3*8.0/sqrt(t_scuba)
; 4.0 is for SCUBA 8-mJy survey
; 8.0 is for standard SCUBA sensitivity
field_scuba=t_total/t_scuba
;ct_scuba=barger_sn(20428.0,1.055,2.252,ds_scuba)*1.7*field_scuba/3600

ct_scuba=interpol(n,s,ds_scuba)*1.7*field_scuba/3600



oplot,t_scuba,ct_scuba,thick=5, line=3

xyouts,200,8,'SCUBA',charsize=1.3
;----------------------------------
; SCUBA+
;----------------------------------
t_scubap=findgen(t_total)+1
ds_scubap=3*4.0/sqrt(t_scuba)
; 4.0 is for SCUBA 8-mJy survey
; 8.0 is for standard SCUBA sensitivity
field_scuba=t_total/t_scubap
;ct_scubap=barger_sn(20428.0,1.055,2.252,ds_scubap)*1.7*field_scuba/3600

ct_scubap=interpol(n,s,ds_scubap)*1.7*field_scuba/3600


oplot,t_scubap,ct_scubap,thick=5, line=3
xyouts,200,15,'SCUBA+',charsize=1.3
;-------------------------------------------------
; Bolocam
;-------------------------------------------------
t_bolocam=findgen(t_total)+1
ds_bolocam=3*0.006/sqrt(t_bolocam)
field_bolobam=t_total/t_bolocam
;ct_bolocam=barger_sn(20428.0,1.055,2.252,ds_scubap)*2.1*field_scuba/3600
ct_bolocam=interpol(n,s,ds_scubap)*2.1*field_scuba/3600

oplot,t_bolocam,ct_bolocam,thick=5, line=5
xyouts,200,40,'BOLOCAM/LMT',charsize=1.3
;----------------------------------
; SCUBA2
;----------------------------------
t_scuba2=findgen(t_total)+1
ds_scuba2=3*4.0/sqrt(t_scuba)
; 4.0 is for SCUBA 8-mJy survey
; 8.0 is for standard SCUBA sensitivity
field_scuba2=t_total/t_scuba2
ct_scuba2=interpol(n,s,ds_scuba2)*64*field_scuba/3600
oplot,t_scuba2,ct_scuba2,thick=5, line=3
xyouts,200,1000,'SCUBA-2',charsize=1.3

;----------------------------------
;  HHSMT
;----------------------------------
t_hht=findgen(t_total)+1
ds_hht=3*10.0/sqrt(t_scuba)
; sensitivity of HHT bolometer is 10 mJy per hour
field_hht=t_total/t_hht
ct_hht=interpol(n,s,ds_hht)*8.76*field_hht/3600
oplot,t_hht,ct_hht,thick=5, line=3
xyouts,200,1000,'HHSMT',charsize=1.3


device,/close
!p.multi=0
;-------------------------------------------------------------------
;device,filename='/home/chyan/Thesis/EPS_file/alma_sma_compare_2_sky1.eps'$;
;	,/encapsulated

device,filename='/home/chyan/Temp/alma_sma_compare_sky1b.eps'$
	,/encapsulated,xsize=20,ysize=20


plot,ct_sma,ds_sma,/xlog,/ylog,xrange=[0.1,1d5],yrange=[0.001,1d2]$,
	,xtitle='!6Source counts (n)',ystyle=1,xcharsize=1.5$
	,ytitle='Sensitivity (mJy)',ycharsize=1.5
index=[0,49,199,499,999]
oplot,ct_sma(index),ds_sma(index),psym=4

oplot,ct_alma,ds_alma
oplot,ct_alma(index),ds_alma(index),psym=4
xyouts,ct_alma(index(0))+1,ds_alma(index(0))-1,'ALMA'

oplot,ct_scuba,ds_scuba
oplot,ct_scuba(index),ds_scuba(index),psym=4

oplot,ct_scubap,ds_scubap
oplot,ct_scubap(index),ds_scubap(index),psym=4

oplot,ct_scuba2,ds_scuba2
oplot,ct_scuba2(index),ds_scuba2(index),psym=4

oplot,ct_bolocam,ds_bolocam
oplot,ct_bolocam(index),ds_bolocam(index),psym=4

oplot,[0.1,1d5],[1,1],line=1

xyouts,ct_sma(index(4))-1.1,ds_sma(index(4)),'SMA',charsize=1.3
xyouts,ct_alma(index(2))+1,ds_alma(index(2)),'ALMA',charsize=1.3
xyouts,ct_scuba(index(0)),ds_scuba(index(0)),'SCUBA',charsize=1.3
xyouts,ct_scubap(index(0))+20,ds_scubap(index(0)),'SCUBA+',charsize=1.3
xyouts,ct_scuba2(index(0))+200,ds_scuba2(index(0)),'SCUBA-2',charsize=1.3
xyouts,ct_bolocam(index(0))+30,ds_bolocam(index(0)),'BOLOCAM/LMT(1.2mm)',charsize=1.3











device,/close
set_plot,'x'
!p.multi=0
end
