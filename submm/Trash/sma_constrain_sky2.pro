PRO sma_constrain_sky2,total_t,obs_t,alpha,beta,error_a,error_b,fp

	epf=2.27
	sig=3.0
	;obs_t=100.0
	;total_t=1000.0


	s=series(0.23,10.0,2000)
	n=power_sn(10,2000)

	field=total_t/obs_t
	factor=field*0.36/3600

	ds=sma_sen(400,obs_t)
	no=interpol(n,s,sig*ds(1))

	nd=no*factor

	err=epf*sqrt(nd)/factor

	ss=sig*ds(1)


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


	plot,x,y,/xlog,/ylog,psym=4	;
	errplot,x,y+w,y-w
	;plots,ss,no,psym=4
	;errplot,ss,no+err,no-err



	error=(w/y)

	ind=where(x ge bp)
	rr=linfit(alog(x(ind)),alog(y(ind)),sigma=sigma,measure_errors=error(ind))
	;rr=linfit(alog(x(ind)),alog(y(ind)),sigma=sigma)

	ind_c=where(x lt bp)
	r2=linfit(alog(x(ind_c)),alog(y(ind_c)),sigma=sigma_c,measure_errors=error(ind_c))

	fp=exp((r2[0]-rr[0])/(rr[1]-r2[1]))
	print,'fp= ', fp
	ll=series(fp,20.0,100)
	l2=series(0.0,fp,100)


	alpha=r2[1]
	beta=rr[1]

	error_a=sigma_c[1]
	error_b=sigma[1]




end
