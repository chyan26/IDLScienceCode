PRO SMA_ALMA_COMPARE

;!p.multi=[0,2,2]
s=(findgen(2000)+1)/100
n=barger_sn(20428.0,1.055,2.252,s)


;---------------------------------------
;  SMA
;---------------------------------------
t=findgen(1000)+1
dd=sma_sen(400,t)
ds_sma=3.0*reform(dd(1,*))

field=350.0/t



ct_sma=barger_sn(20428.0,1.055,2.252,ds_sma)*0.36/3600*field


set_plot,'ps'
device,filename='/home/chyan/Cast_2003/alma_sma_compare.ps'


plot,t,ct_sma,/xlog,/ylog,yrange=[1,1d3],thick=5,xrange=[1,1d3],xstyle=1$
	,xtitle='!6Exposure time per pointing (Hours)'$
	,ytitle='Total detected counts (n)'
drsma=0.44
frsma=0.0

errsma=sqrt(ct_sma)*sqrt(1+frsma)/drsma

ct_smaup=ct_sma+errsma
ct_smalo=ct_sma-errsma
oplot,t,ct_smaup,line=1
oplot,t,ct_smalo,line=1
;---------------------------------------
;  ALMA
;----------------------------
t_alma=findgen(1000)+1
dd=alma_sen(400,t)
ds_alma=2.6*reform(dd(1,*))

field_alma=1000/t_alma


ct_alma=barger_sn(20428.0,1.055,2.252,ds_alma)*field_alma*0.09/3600
dralma=0.81
fralma=0.0

erralma=sqrt(ct_alma)*sqrt(1+fralma)/dralma

ct_almaup=ct_alma+erralma
ct_almalo=ct_alma-erralma

oplot,t,ct_alma,thick=5, line=2
oplot,t,ct_almaup,line=3
oplot,t,ct_almalo,line=3
device,/close

device,filename='/home/chyan/Cast_2003/alma_sma_compare_2.ps'

plot,ct_sma,ds_sma,/xlog,/ylog,xrange=[0.1,10000],yrange=[0.001,1d2]$,
	,xtitle='!6Source counts (n)'$
	,ytitle='3.4-sigma sensitivity'
index=[0,19,29,49,199,499,999]
oplot,ct_sma(index),ds_sma(index),psym=4

oplot,ct_alma,ds_alma
oplot,ct_alma(index),ds_alma(index),psym=4
oplot,[0.1,10000],[1,1],line=1
device,/close
set_plot,'x'
!p.multi=0
end
