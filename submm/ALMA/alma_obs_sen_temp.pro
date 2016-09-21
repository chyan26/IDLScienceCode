PRO alma_count_improve
;!p.multi=[0,2,2]

epf=1.23
sigma=3.3
obs_t=1
total_t=1


s=series(0.01,10,2000)
n=barger_sn(20428.0,1.055,2.252,s)

field=total_t/obs_t
factor=field*0.36/3600

ds=alma_sen(400,obs_t)
no=interpol(n,s,sigma*ds(1))

nd=no*factor

err=epf*sqrt(nd)

ss=sigma*ds(1)

plot,s,n,/xlog,/ylog,line=1
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


;a=[3d4,0.0,2.5]



rr=curvefit(x,y,w,a,sigma,function_name='barger_fit')
print,a
print,sigma
print,sigma/a


nf=barger_sn(a(0),a(1),a(2),s)
;print,nf
oplot,s,nf,line=0

error=alog(weight/y)

ind=where(x ge bp)
rr=linfit(alog(x(ind)),alog(y(ind)),sigma=sigma,measure_errors=error(ind))
;rr=linfit(alog(x(ind)),alog(y(ind)),sigma=sigma)


ind_c=where(x lt bp)

r2=linfit(alog(x(ind_c)),alog(y(ind_c)),sigma=sigma_c,measure_errors=error(ind_c))


fp=exp((r2[0]-rr[0])/(rr[1]-r2[1]))
print,'fp= ', fp

xx=series(fp,20.0,100)
x2=series(0.0,fp,100)

oplot,xx,exp(rr[0])*xx^rr[1]
oplot,x2,exp(r2[0])*x2^r2[1]


print,'a_0= ', exp(r2[0]),' da_0 = ',exp(r2[0])*sigma_c[0]
print,'a_1= ', exp(rr[0]),' da_1 = ',exp(rr[0])*sigma[0]

print,'alpha=',r2[1],' d = ',sigma_c[1]
print,'beta=',rr[1],' d = ',sigma[1]



end


pro barger_fit,x,a,f,pder
	bx=1/(a[1]+x^a[2])
	f=a[0]*(bx)
	if n_params() ge 4 then $
		pder =[[bx],[-a[0]*(bx^2)],[-a[0]*(x^a[2])*alog(x)*(bx^2)]]
end

