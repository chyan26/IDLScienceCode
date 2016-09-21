PRO plot_scuba_fit
raw=read_ascii('/home/chyan/Scuba_count/scuba_complete_data.old')

data=reform(raw.field1)

plot,data(0,*),data(1,*),psym=4,/xlog,/ylog,yrange=[1,1d5]$
	,xrange=[0.01,20],xstyle=1,xtitle='Flux (mJy)'$
	,ytitle='Source counts(number per sqr. deg.)'
errplot,data(0,*),data(1,*)+data(2,*),data(1,*)-data(3,*)


s1=series(0.01,20,200)
n1=barger_sn(20428.0,1.055,2.252,s1)
oplot,s1,n1

s2=series(0.23,20,1000)
n2=power_sn(20,1000)
oplot,s2,n2



end
