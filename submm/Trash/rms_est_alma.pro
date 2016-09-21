PRO RMS_EST_ALMA, START_FIELD, END_FIELD, SIGMA
	
	fwhm=14.0
	;sigma=3.0
	;start_field=1
	;end_field=1
	rate=fltarr(5)
	config=1
	 	

	im1='/scr1/Mock_alma_0418_nsn_at/Fits/alma_'
        im2=['1','2','3','4']
        im3='_030418_'
        im4='.fits'
	
	s1='/scr1/Mock_alma_0418_nsn_at/Data/submm_source'
 	
	
	close,1
	openw,1,'/scr1/Mock_alma_0418_nsn_at/Detect/alma_detecion_'+strmid(strcompress(string(sigma),/remov),0,3)
	for i=start_field, end_field do begin
 		print,'Now processing image',i
		fitsfile=im1+im2(config-1)+im3+strcompress(string(i),/remov)+im4
 
		sourcefile=s1+strcompress(string(i),/remov)
 
		detect_count,fwhm(config-1),sigma,fitsfile,sourcefile,count,x_d,y_d,flux
		rate=rate+count
		for j=0, n_elements(flux)-1 do begin
			printf,format='(f12.8,f10.4,f10.4,tr4,i3)',1,flux(j),-x_d(j)*0.14,y_d(j)*0.14,i
		endfor
	endfor

	close,1
	
	openw,1,'/scr1/Confusion/Detect/alma_count_'+strmid(strcompress(string(sigma),/remov),0,3)
	printf,1,'Total No. of source(s) inputed',rate(4)
	printf,1,'No. of source(s) with f > 3-sigma:',rate(0)
	printf,1,'No. of source(s) detected by FIND:',rate(1)
	printf,1,'No. of source(s) f > 3-sigma and detected:',rate(2)
	printf,1,'No. of source(s) f < 3-sigma but detected:',rate(3)
	close,1	

	resetplt,/all
	
end
 
PRO DETECT_COUNT, FWHM ,SIGMA, FITS, SOURCE, COUNT, X_D, Y_D, FLUX
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
	
	
	rms=stddev(im)
 
	read_source,sourcefile,f,x,y	
 	
	th_image_cont,im,level=[2*rms,3*rms],xrange=[-128,128]$
		,/aspect,yrange=[-128,128],/nobar,ct=3$
		,crange=[0.1*rms,5*rms]
	oplot_source,f,x,y,sigma,rms,index,c,ind_c
 
	
	imm=smooth2(im,6)
	
 	auto_find_sma,imm,fwhm,rms,sigma,x_d,y_d,flux

	x_d=x_d-128
	y_d=y_d-128
 
	oplot,x_d,y_d,psym=5,color=255
	
	d_rate,x,y,x_d,y_d,fwhm,index,ind_c,c,count
	
END


PRO D_RATE, X, Y, X_D, Y_D, FWHM, INDEX, IND_C, NUMBER, COUNT
	x=X
	y=Y
	x_d=X_D
	y_d=Y_D
	fwhm=FWHM
	number=NUMBER  ; no. of input source that f > given sigma level
 	count=COUNT

	c=number
	
	dd=0   ;dd gives the detection no. for sources flux > 3-sigma and detected
	nd=0   ;ad gives the detection no. for sources flux < 3-sigma but detected
 

	if c ne 0 then begin
		for i=0,n_elements(x_d)-1 do begin
			r=(x(index)-x_d(i))^2+(y(index)-y_d(i))^2
			if min(r) lt fwhm then begin
				dd=dd+1
			endif else begin
				dd=dd+0
			endelse
		endfor
	endif else begin
		dd=dd+0
	endelse
 	
	if ind_c(0) eq -1 then goto, final
	if n_elements(ind_c) ne 0 then begin
		for i=0,n_elements(x_d)-1 do begin
			r=(x(ind_c)-x_d(i))^2+(y(ind_c)-y_d(i))^2
			if min(r) lt fwhm then begin
				nd=nd+1
			endif else begin
				nd=nd+0
			endelse
		endfor
	endif else begin
		nd=nd+0
	endelse
	final: 

	count=fltarr(5)
 
	count(0)=c
	count(1)=n_elements(x_d)
	count(2)=dd
	count(3)=nd
 	count(4)=n_elements(x)
END

PRO READ_SOURCE, FILE, FLUX, X, Y
	file=FILE
	flux=FLUX
	x=X
	y=Y
	data=read_ascii(file)
	if n_elements(data.field1) gt 3 then begin
		flux=reform(data.field1(0,*))
		x=-1*reform(data.field1(1,*))/0.07
		y=reform(data.field1(2,*))/0.07
	endif else begin
		flux=data.field1(0)
		x=-1*data.field1(1)/0.07
		y=data.field1(2)/0.07
	endelse
END

PRO OPLOT_SOURCE, FLUX, X, Y, SIGMA, RMS, INDEX, NO, IND_C
	flux=FLUX
	x=X
	y=Y
	sigma=SIGMA
	rms=RMS
	index=INDEX    ; sources where f > given sigma level
	no=NO          ; number of sources where f > given sigma level
	ind_c=IND_C    ; sources where f < given sigma level
	index=where(flux ge sigma*rms, c, complement=ind_c)
 	
	if n_elements(index) eq 1 and index(0) eq -1 then goto, next
	if c ne 1 then begin
		plots,x(index),y(index),psym=6,color=255
	endif else begin
		plots,x(index),y(index),psym=1,color=255
	endelse
 
	next:	
	if ind_c(0) eq -1 then goto,final
	if n_elements(ind_c) ne 1 then begin
		oplot,x(ind_c),y(ind_c),psym=1,color=255
	endif else begin
		plots,x(ind_c),y(ind_c),psym=1,color=255
	endelse
	final:

	no=c
END

PRO AUTO_FIND_ALMA, IM, FWHM,RMS, SIGMA, X, Y, FLUX
	hmin=rms*sigma 
	sharplim=[0.2,1.0]
	roundlim=[-1.0,1.0]
	find,im,x,y,flux,sharp,round,hmin,fwhm,roundlim,sharplim,/silent
END
