PRO sma_count_improve
;!p.multi=[0,2,2]

epf=2.27
sig=3.0
obs_t=100
total_t=1000

s=series(0.01,10,2000)
n=barger_sn(20284.0,1.033,2.2486,s)

field=total_t/obs_t
factor=field*0.36/3600

ds=sma_sen(400,obs_t)
no=interpol(n,s,sig*ds(1))
;print,sig*ds(1)

nd=no*factor

err=epf*sqrt(nd)

ss=sig*ds(1)

plot,s,n,/xlog,/ylog,line=1,xrange=[0.1,10],xtitle='!6Flux(mJy)',ytitle='Souce count (per square deg.)'
plots,ss,no,psym=4
errplot,ss,(nd+err)/factor,(nd-err)/factor



raw=read_ascii('/home/chyan/Scuba_count/scuba_complete_data.old')
xx=reform(raw.field1(0,*))
yy=reform(raw.field1(1,*))
weight=fltarr(n_elements(raw.field1(0,*)))
weight(*)=(1/((raw.field1(2,*)+raw.field1(3,*))/2))^2

x=fltarr(n_elements(xx)+1)
x(0:n_elements(x)-2)=xx
x[n_elements(x)-1]=ss

y=fltarr(n_elements(yy)+1)
y(0:n_elements(y)-2)=yy
y[n_elements(y)-1]=no

w=fltarr(n_elements(weight)+1)
w(0:n_elements(w)-2)=weight
w[n_elements(w)-1]=1/(err/factor)


a=[3d4,0.0,2.5]



rr=curvefit(x,y,w,a,sigma,function_name='barger_fit')
print,a(2)
print,sigma(2)
;print,sigma/a


nf=barger_sn(a(0),a(1),a(2),s)
;print,nf
oplot,s,nf,line=0


end


pro barger_fit,x,a,f,pder
	bx=1/(a[1]+x^a[2])
	f=a[0]*(bx)
	if n_params() ge 4 then $
		pder =[[bx],[-a[0]*(bx^2)],[-a[0]*(x^a[2])*alog(x)*(bx^2)]]
end
