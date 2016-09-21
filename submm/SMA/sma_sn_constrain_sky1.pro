PRO SMA_SN_CONSTRAIN_SKY1


	t=findgen(100)+1
	total_t=1000
	slope=fltarr(n_elements(t))
	err=fltarr(n_elements(t))

	set_plot,'ps'
	device,filename='/home/chyan/Thesis/Latex/sma_sn_constrain_'+$
		strcompress(string(total_t),/remov)+'hr_sky1.eps',/encapsulated,xsize=20,ysize=20


	for i=0,n_elements(t)-1 do begin
		sma_constrain_sky1,total_t,t(i),a,b
		slope(i)=a
		err(i)=b
	endfor


	plot,t,slope,xrange=[1,max(t)],yrange=[1.8,2.5],thick=2,ystyle=1,ytitle='!6Source count slope',charsize=2.0$
		,xtitle='Exposure time per pointing (hous, total time is '+strcompress(string(total_t),/remov)+' hours)'

	oplot,t,slope+err,line=2
	oplot,t,slope-err,line=2

	oplot,[0,100],[2,2],line=1
	xyouts,20,2.01,'Source count slope from simple luminosity evolution'
	device,/close
	set_plot,'x'


end





PRO sma_constrain_sky1,total_t,obs_t,slope,erro

	epf=1.29
	sig=3.0
	obs_t=obs_t
	total_t=total_t


	s=series(0.01,10,2000)
	n=barger_sn(20284.0,1.033,2.2486,s)

	field=total_t/obs_t
	factor=field*0.36/3600

	ds=sma_sen(400,obs_t)
	no=interpol(n,s,sig*ds(1))

	nd=no*factor

	err=epf*sqrt(nd)

	ss=sig*ds(1)


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


	;plot,xx,yy,/xlog,/ylog,psym=4	;
	;errplot,xx,yy+raw.field1(2,*),yy-raw.field1(3,*)
	;plots,ss,no,psym=4
	;errplot,ss,no+(err/factor),no-(err/factor)


	a=[3d4,0.0,2.5]



	rr=curvefit(x,y,w,a,sigma,function_name='barger_fit')

	slope=a(2)
	erro=sigma(2)


end


pro barger_fit,x,a,f,pder
	bx=1/(a[1]+x^a[2])
	f=a[0]*(bx)
	if n_params() ge 4 then $
		pder =[[bx],[-a[0]*(bx^2)],[-a[0]*(x^a[2])*alog(x)*(bx^2)]]
end
