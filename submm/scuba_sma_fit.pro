PRO scuba_sma_fit
set_plot,'ps'
device,filename='/home/chyan/Thesis/EPS_file/scuba_sma_fit.eps'$
	,/encapsulated,/color,xsize=20,ysize=20

raw=read_ascii('/home/chyan/Scuba_count/scuba_sma_mock')
data=reform(raw.field1)

s=size(data)-1
TVLCT, [0,255,0,0], [0,0,255,0], [0,0,0,255]

plot,data(0,0:s(2)-1),data(1,0:s(2)-1),psym=4,/xlog,/ylog,yrange=[1,1d5]$
	,xrange=[0.1,20],xstyle=1,xtitle='!6Flux (mJy)'$
	,ytitle='Cumulative source count (N per square deg.)'
errplot,data(0,0:s(2)-1),data(1,0:s(2)-1)+data(2,0:s(2)-1),data(1,0:s(2)-1)-data(3,0:s(2)-1)

plots,data(0,s(2)),data(1,s(2)),psym=4,color=1
errplot,data(0,s(2)),data(1,s(2))+data(2,s(2)),data(1,s(2))-data(3,s(2))


weight=fltarr(n_elements(data(0,*)))
a=[2.8d4,1.0,2.6]
x=reform(data(0,*))
y=reform(data(1,*))
weight(*)=(1/((data(2,*)+data(3,*))/2))^2

rr=curvefit(x,y,weight,a,sigma,function_name='barger_fit')
print,a
print,sigma
print,sigma/a
s=series(0.1,20,500)
n=barger_sn(a(0),a(1),a(2),s)
nn=barger_sn(20428,1.055,2.252,s)
oplot,s,n

device,/close
set_plot,'x'
end

pro barger_fit,x,a,f,pder
	bx=1/(a[1]+x^a[2])
	f=a[0]*(bx)
	if n_params() ge 4 then $
		pder =[[bx],[-a[0]*(bx^2)],[-a[0]*(x^a[2])*alog(x)*(bx^2)]]
end
