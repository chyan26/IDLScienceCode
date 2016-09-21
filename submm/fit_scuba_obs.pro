pro fit_scuba_obs
 
	data=dblarr(4,35)
	close,1
	openr,1,'/home/chyan/Notes/Submm_galaxy/Scuba_obs_data/scuba_data.csv'
	readf,1,data
	close,1

	data(1,*)=10^((data(1,*)-230.5)/169.5)
	data(2,*)=10^((data(2,*)+20.66)/131.66)
	
	set_plot,'ps'
	device,xsize=20,ysize=15,xoffset=1,yoffset=8,$
		file='~chyan/Notes/Submm_galaxy/EPS_file/scuba_count_fit.ps',$
		/encapsulated
	scuba_plot,data(1,*),data(2,*),data(3,*)

	s=(findgen(300)+1)/10
	n1=scott_sn(1.1d4,1.79,0.0,3.13,s)
	n2=barger_sn(3.0d4,1.0,s)
	nn=fltarr(n_elements(n1))
	for i=0, n_elements(n1)-3 do begin
		nn(i)= int_tabulated(s(i+1:n_elements(n1)-1),n1(i+1:n_elements(n1)-1))
	endfor
	oplot,s,nn
	oplot,s,n1
	oplot,s,n2,linestyle=2
	device,/close
	set_plot,'x'
end


;----------------------------------------------------------------------------------
;The following codes are used to plot a figure with different
;  symbol on it.
PRO scuba_plot,x,y,psym_id
	;make a circle symbol as psym=8 to be used later
	a=findgen(17)*(!pi*2/16.)
	usersym,cos(a),sin(a)

	index=where(psym_id eq 2)
	plot,x(index),y(index),psym=psym_id(min(index)),/xlog,$
		/ylog,xrange=[0.1,21],xstyle=1,yrange=[1,1000000]

	for i=4,8 do begin
		index=where(psym_id eq i)
		oplot,x(index),y(index),psym=psym_id(min(index))
	endfor

	;plot the last data, symbol with solid diamond
	x=[-1,0,1,0,-1]
	y=[0,1,0,-1,0]
	usersym,x,y,/fill
	index=where(psym_id eq 9)
	oplot,x(index),y(index),psym=8
end
;---------------------------------------------------------------------------
