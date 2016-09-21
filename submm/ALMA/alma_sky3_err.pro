PRO alma_sky3_err

set_plot,'ps'
device,filename='/home/chyan/Thesis/Latex/alma_sky3_err.eps',$
	/encapsulated,xsize=20,ysize=20

s=series(0.01,10,2000)
n=sky3_sn(10,2000)
plot,s,n,/xlog,/ylog,xrange=[0.1,10],thick=5,xstyle=1,xtitle='!6Flux (mJy)'$
	,ytitle='Source counts (per square degree)',charsize=2.0


ind=where(s le 1.05, COMPLEMENT=ind_c)

na=11885.9
alpha=-1.05062
dna=8158.01
dalpha=0.714003
sa=series(0.01,1.05,2000)
nna=na*sa^alpha
power_sn_err,na,alpha,sa,dna,dalpha,naerr
;oplot,sa,nna
oplot,sa,nna+naerr
oplot,sa,nna-naerr


nb=12351.0
beta=-1.80
dnb=1765.0
dbeta=0.095;
sb=series(1.05,10,2000)
nnb=nb*sb^beta
power_sn_err,nb,beta,sb,dnb,dbeta,nberr
oplot,sb,nnb
oplot,sb,nnb+nberr
oplot,sb,nnb-nberr


alma_constrain_sky2,1000,8,ss,no,err,a0,da0,a1,da1,a,da,b,db,fp

print,a0,da0,a1,da1,a,da,b,db,fp



plots,ss,no,psym=4
errplot,ss,no+err,no-err


nn1=a0*sa^a
power_sn_err,a0,a,sa,da0,da,n1err
;oplot,sa,nn1
oplot,sa,nn1+n1err,line=2
oplot,sa,nn1-n1err,line=2



nn2=a0*sb^b
power_sn_err,a1,b,sb,da1,db,n2err
;oplot,sb,nn2
oplot,sb,nn2+n2err,line=2
oplot,sb,nn2-n2err,line=2



;ind=where(s le fp, COMPLEMENT=ind_c)
;power_sn_err,a_1,beta,s,da_1,dbeta,nberr
;oplot,s(ind_c),n(ind_c)+nberr(ind_c)
;oplot,s(ind_c),n(ind_c)-nberr(ind_c)
;print,nberr
device,/close
set_plot,'x'



end

PRO power_sn_err,a,alpha,s,da,dalpha,nerr
	pa=s^alpha
	palpha=a*s^alpha*alog(s)
	nerr=sqrt(pa^2*da^2+palpha^2*dalpha^2)
end

PRO alma_constrain_sky2,total_t,obs_t,ss,no,err,a_0,da_0,a_1,da_1,alpha,dalpha,beta,dbeta,fp

	epf=1.27
	sig=4.0
	;obs_t=100.0
	;total_t=1000.0


	s=series(0.28,10.0,2000)
	n=sky2_sn(10,2000)

	
	field=total_t/obs_t
	factor=field*0.09/3600

	ds=alma_sen(400,obs_t)
	if sig*ds(1) lt 0.28 then flux=0.28
	no=interpol(n,s,0.28)

	nd=no*factor

	err=epf*sqrt(nd)/factor

	;ss=sig*ds(1)
	ss=flux

	raw=read_ascii('/home/chyan/Scuba_count/scuba_complete_data.old')

	xx=reform(raw.field1(0,*))
	yy=reform(raw.field1(1,*))
	weight=fltarr(n_elements(raw.field1(0,*)))
	weight(*)=(raw.field1(2,*)+raw.field1(3,*))/2
	bp=1.0

	x=fltarr(n_elements(xx)+1)
	x(0:n_elements(x)-2)=xx
	x[n_elements(x)-1]=ss

	y=fltarr(n_elements(yy)+1)
	y(0:n_elements(y)-2)=yy
	y[n_elements(y)-1]=no

	w=fltarr(n_elements(weight)+1)
	w(0:n_elements(w)-2)=weight
	w[n_elements(w)-1]=err


	;plot,x,y,/xlog,/ylog,psym=4	;
	;errplot,x,y+w,y-w
	;plots,ss,no,psym=4
	;errplot,ss,no+err,no-err



	error=(w/y)

	ind=where(x ge bp)
	rr=linfit(alog(x(ind)),alog(y(ind)),sigma=sigma,measure_errors=error(ind))
	
	ind_c=where(x lt bp)
	r2=linfit(alog(x(ind_c)),alog(y(ind_c)),sigma=sigma_c,measure_errors=error(ind_c))

	fp=exp((r2[0]-rr[0])/(rr[1]-r2[1]))
	;print,'fp= ', fp
	ll=series(fp,20.0,100)
	l2=series(0.0,fp,100)

;print,'a_0= ', exp(r2[0]),' da_0 = ',exp(r2[0])*sigma_c[0]
;print,'a_1= ', exp(rr[0]),' da_1 = ',exp(rr[0])*sigma[0]

;print,'alpha=',r2[1],' d = ',sigma_c[1]
;print,'beta=',rr[1],' d = ',sigma[1]

a_0=exp(r2[0]) 
da_0=exp(r2[0])*sigma_c[0]

a_1=exp(rr[0])
da_1=exp(rr[0])*sigma[0]

alpha=r2[1]
dalpha=sigma_c[1]

beta=rr[1]
dbeta=sigma[1]


end
