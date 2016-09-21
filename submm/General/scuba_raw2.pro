PRO scuba_raw2
raw=read_ascii('/home/chyan/Scuba_count/scuba_complete_data.old')

data=reform(raw.field1)

plot,data(0,*),data(1,*),psym=4,/xlog,/ylog,yrange=[1,1d5]$
	,xrange=[0.01,20],xstyle=1
errplot,data(0,*),data(1,*)+data(2,*),data(1,*)-data(3,*)

x=reform(data(0,*))
y=reform(data(1,*))

bp=1.0


weight=fltarr(n_elements(data(0,*)))
weight(*)=(data(2,*)+data(3,*))/2

error=(weight/y)

ind=where(x ge bp)
rr=linfit(alog(x(ind)),alog(y(ind)),sigma=sigma,measure_errors=error(ind))
;rr=linfit(alog(x(ind)),alog(y(ind)),sigma=sigma)


ind_c=where(x lt bp)

r2=linfit(alog(x(ind_c)),alog(y(ind_c)),sigma=sigma_c,measure_errors=error(ind_c))
;r2=linfit(alog(x(ind_c)),alog(y(ind_c)),sigma=sigma_c)

;print,r2
;print,sigma_c


;print,rr
;print,sigma

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

slim=series(0.01,1.0,100)
;slim=0.01
a=exp(r2[0])
b=exp(rr[0])

alpha=-r2[1]
;alpha=-series(r2[1]-sigma_c[1],r2[1]+sigma_c[1],100)

beta=-rr[1]

ib=b*beta/(beta-1)*(fp)^(-beta+1)
ia=a*alpha/(alpha-1)*(slim^(-alpha+1)-fp^(-alpha+1))
i=ia+ib
print,ib
ind=where(i le 44000)
print,i(min(ind)),slim(min(ind))
;print,i(min(ind)),alpha(min(ind))

print,alog(a/b)/(-beta+alpha(min(ind)))
end
