;
;   This program produce the fitting curve usgin all scuba observation
;     data.
;
;

pro scuba_data
	data=dblarr(4,35)
	close,1
	openr,1,'/home/chyan/Notes/Submm_galaxy/Scuba_obs_data/scuba_data.csv'
	readf,1,data
	close,1

	data(1,*)=10^((data(1,*)-230.5)/169.5)
	data(2,*)=10^((data(2,*)+20.66)/131.66)
	close,1
	openw,1,'/home/chyan/Notes/Submm_galaxy/Text/scuba_data.txt'
	printf,1,data
     	close,1

	x=reform(data(1,*))
	y=reform(data(2,*))
	
	a=findgen(17)*(!pi*2/16.)
	usersym,cos(a),sin(a)
	
	set_plot,'ps'
	device,filename='/home/chyan/Notes/Submm_galaxy/Ps_file/scuba_barger_fit.ps'

	index=where(data(3,*) eq 2)
	plot,x(index),y(index),psym=data(3,min(index)),/xlog,xrange=[0.1,100],xstyle=1,yrange=[1,1.5d4]$
	,/ylog
	for i=4,8 do begin
		index=where(data(3,*) eq i)
		oplot,x(index),y(index),psym=data(3,min(index))
	endfor

	;plot the last data, symbol with solid diamond
	xx=[-1,0,1,0,-1]
	yy=[0,1,0,-1,0]
	usersym,xx,yy,/fill
	index=where(data(3,*) eq 9)
	oplot,x(index),y(index),psym=8
	a=[2.8d4,1.0,2.6]
	weight=fltarr(n_elements(y))
	weight(*)=1/y
	rr=curvefit(x,y,weight,a,function_name='barger_fit')
	oplot,x,rr
	print,a
	ss=(findgen(500)+1)*5/100
	f1=barger_sn(a(0),a(1),a(2),ss)
	;f2=barger_sn(2.9d4,1.0,2.5,ss)	
	;f3=barger_sn(3.0d4,1.0,3.2,ss)
	oplot,ss,f1
	;oplot,ss,f2,linestyle=2
	;oplot,ss,f3,linestyle=5
	device,/close
	set_plot,'x'
end

pro barger_fit,x,a,f,pder
	bx=1/(a[1]+x^a[2])
	f=a[0]*(bx)
	if n_params() ge 4 then $
		pder =[[bx],[-a[0]*(bx^2)],[-a[0]*(x^a[2])*alog(x)*(bx^2)]]
end
