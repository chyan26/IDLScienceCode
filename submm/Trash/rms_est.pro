PRO RMS_EST_SMA
	!p.multi=[0,3,3]
	set_plot,'ps'
	device,xsize=20,ysize=20,xoffset=1,yoffset=1,/color
	;loadct,0,bottom=100
	fwhm=31
	sigma=3.5	
	start_field=1
	end_field=5
	rate=fltarr(3)
	config=4
	
	im1='/scr1/Mock_sma/Fits/sma_'	
	im2=['a','b','c','d']
	im3='_030306_'
	im4='.fits'
	s1='/scr1/Mock_sma/Data/submm_source
	
	for i=1, field do begin		
			
		fitsfile=im1+im2(config-1)+im3+strcompress(string(i),/remov)+im4

		s1='/scr1/Mock_sma/Data/submm_source
	
		sourcefile=s1+strcompress(string(i),/remov)	

		detect_count,fwhm,sigma,fitsfile,sourcefile,count
		rate=rate+count
		print,i
	endfor
	print,rate
	device,/close
	set_plot,'x'
	resetplt,/all
	!p.multi=[0,0,0,0]
end

PRO DETECT_COUNT, FWHM ,SIGMA, FITS, SOURCE, COUNT
;  
;   COUNT
;       Return the detection counts, the first is the expected source
;       number over given sigma. The second is the detected source
;       number using FIND with flux over given sigma.  The last is the
;	number of detected and expected sources. 
;
	fwhm=FWHM
	sigma=SIGMA
	fitsfile=FITS
	sourcefile=SOURCE

	im=readfits(fitsfile)
	data=read_ascii(sourcefile)
	rms=sxpar(headfits(fitsfile),'rms')
	;rms=stddev(im)
	
	if n_elements(data.field1) gt 3 then begin
		f=reform(data.field1(0,*))
		x=-1*reform(data.field1(1,*))/0.14
		y=reform(data.field1(2,*))/0.14
	endif else begin
		f=data.field1(0)
		x=-1*data.field1(1)/0.14	
		y=data.field1(2)/0.14
	endelse
	;x=-1*reform(data.field1(1,*))/0.14
	;y=reform(data.field1(2,*))/0.14

	;imm=max(im)-im
	th_image_cont,im,level=[2*rms,3*rms],xrange=[-128,128]$
		,/aspect,yrange=[-128,128],/nobar,ct=0
	
	if n_elements(x) ne 1 then begin
		oplot,x,y,psym=4,color=255
	endif

	hmin=sigma*rms
	sharplim=[0.001,1.0]
	roundlim=[-2.0,2.0]
	find,im,x_d,y_d,flux,sharp,round,hmin,fwhm,sharplim,roundlim,/silent

	x_d=x_d-128
	y_d=y_d-128
	oplot,x_d,y_d,psym=2,color=255

	dd=0
	index=where(f ge sigma*rms, c)
	
	if c ne 0 then begin
		for i=0,n_elements(x_d)-1 do begin
			r=(x(index)-x_d(i))^2+(y(index)-y_d(i))^2
			if min(r) lt fwhm^2 then begin
				dd=dd+1
			endif else begin
				dd=dd+0
			endelse	
		endfor	
	endif else begin
		dd=dd+0
	endelse

	count=fltarr(3)
		
	count(0)=c
	count(1)=n_elements(x_d)
	count(2)=dd

end
