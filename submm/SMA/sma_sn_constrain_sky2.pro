PRO SMA_SN_CONSTRAIN_SKY2

!p.multi=[0,2,1]
t=findgen(100)+1
total_t=1000
alpha=fltarr(n_elements(t))
beta=fltarr(n_elements(t))
err_a=fltarr(n_elements(t))
err_b=fltarr(n_elements(t))

set_plot,'ps'
device,filename='/home/chyan/Thesis/Latex/sma_sn_constrain_'+$
	strcompress(string(total_t),/remov)+'hr_sky2.eps',/encapsulated,$
	xsize=30,ysize=15


for i=0,n_elements(t)-1 do begin
	sma_constrain_sky2,total_t,t(i),a,b,error_a,error_b
	alpha(i)=-a
	beta(i)=-b
	err_a(i)=error_a
	err_b(i)=error_b
endfor


plot,t,alpha,yrange=[-1,3],thick=2,ystyle=1,ytitle='!6Source count slope'$
	,xtitle='Exposure time per pointing (hours, total time is '+strcompress(string(total_t),/remov)+' hours)'

oplot,t,alpha+err_a,line=2
oplot,t,alpha-err_a,line=2
oplot,[0,100],[1.1,1.1],line=1
xyouts,5,1.21,'Source count slope from simple luminosity evolution'
oplot,[0,100],[0.9,0.9],line=1
xyouts,5,0.71,'Source count slope from complex luminosity evolution'


plot,t,beta,yrange=[1,3],thick=2,ystyle=1,ytitle='!6Source count slope'$
	,xtitle='Exposure time per pointing (hours, total time is '+strcompress(string(total_t),/remov)+' hours)'
oplot,t,beta+err_b,line=2
oplot,t,beta-err_b,line=2
oplot,[0,100],[2,2],line=1
xyouts,5,2.06,'Source count slope from simple luminosity evolution'
oplot,[0,100],[1.7,1.7],line=1
xyouts,5,1.71,'Source count slope from complex luminosity evolution'



device,/close
set_plot,'x'
!p.multi=0

end

PRO sma_constrain_sky2,total_t,obs_t,alpha,beta,error_a,error_b,fp

	epf=1.50
	sig=3.0
	;obs_t=100.0
	;total_t=1000.0


	s=series(0.28,10.0,2000)
	n=sky2_sn(10,2000)

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


	;plot,x,y,/xlog,/ylog,psym=4	;
	;errplot,x,y+w,y-w
	;plots,ss,no,psym=4
	;errplot,ss,no+err,no-err



	error=(w/y)

	ind=where(x ge bp)
	rr=linfit(alog(x(ind)),alog(y(ind)),sigma=sigma,measure_errors=error(ind))
	;rr=linfit(alog(x(ind)),alog(y(ind)),sigma=sigma)

	ind_c=where(x lt bp)
	r2=linfit(alog(x(ind_c)),alog(y(ind_c)),sigma=sigma_c,measure_errors=error(ind_c))

	fp=exp((r2[0]-rr[0])/(rr[1]-r2[1]))
	;print,'fp= ', fp
	ll=series(fp,20.0,100)
	l2=series(0.0,fp,100)


	alpha=r2[1]
	beta=rr[1]

	error_a=sigma_c[1]
	error_b=sigma[1]




end
