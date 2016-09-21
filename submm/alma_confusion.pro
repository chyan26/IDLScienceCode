
n0=20428.0
a=1.055
beta=2.252
s=series(0.01,20,2000)

n=barger_sn(n0,a,beta,s)

t=findgen(10000)+1


dd=sma_sen(400,t)
ds_sma=3.0*reform(dd(1,*))
ct_sma=barger_sn(20428.0,1.055,2.252,ds_sma)*0.005/3600
plot,t,ct_sma,/xlog,/ylog,xtitle='!6Observation time(hours)'$
	,ytitle='Probability of detecting source(s) within synthsis beam(N)'



dd=alma_sen(400,t)
ds_alma=3.0*reform(dd(1,*))

ct_alma=barger_sn(20428.0,1.055,2.252,ds_alma)*0.0002/3600
oplot,t,ct_alma,line=1
end
