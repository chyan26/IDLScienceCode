PRO RMS_EST_SMA, START_FIELD, END_FIELD, SIGMA
	
	fwhm=[2.75,5.47,11.74,31.0]
	sigma=3.0
	start_field=12
	end_field=13
	rate=fltarr(5)
	config=4
	count=fltarr(5)
	;count(*)=0
	rate(*)=0 	
	
	im1='/scr1/Confusion/Fits/sma_'
	im2=['a','b','c','d']
	im3='_030429_'
	im4='.fits'
	s1='/scr1/Confusion/Data/submm_source'
 
	close,1
	openw,1,'/scr1/Confusion/Detect/sma_detecion_'+strmid(strcompress(string(sigma),/remov),0,3)
	for i=start_field, end_field do begin
 		count(*)=0
		print,'Now processing image',i
		fitsfile=im1+im2(config-1)+im3+strcompress(string(i),/remov)+im4
		sourcefile=s1+strcompress(string(i),/remov)	
		



if keyword_set(x_d) eq 1 then begin
			delvar,x_d
			delvar,y_d
			delvar,f_d
		endif
		detect_count,fwhm(config-1),sigma,fitsfile,sourcefile,count,x_d,y_d,flux,i
		rate=rate+count
	
		for j=0, n_elements(flux)-1 do begin
			printf,format='(f12.8,f10.4,f10.4,tr4,i3)',1,flux(j),-x_d(j)*0.14,y_d(j)*0.14,i
		endfor
	endfor

	close,1

	openw,1,'/scr1/Confusion/Detect/sma_count_'+strmid(strcompress(string(sigma),/remov),0,3)
	printf,1,'Total No. of source(s) inputed',rate(0)
	printf,1,'No. of source(s) with f > 3-sigma:',rate(1)
	printf,1,'No. of source(s) detected by FIND:',rate(2)
	printf,1,'No. of source(s) f > 3-sigma and detected:',rate(3)
	printf,1,'No. of source(s) f < 3-sigma but detected:',rate(4)
	close,1	
	

	resetplt,/all
	
end
 
PRO DETECT_COUNT, FWHM ,SIGMA, FITS, SOURCE, COUNT, X_D, Y_D, FLUX, FIELD_NO
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
		,/aspect,yrange=[-128,128],/nobar,ct=0$
		,crange=[0.1*rms,5*rms]
	oplot_source,f,x,y,sigma,rms,index,c,ind_c
 
	
	x_a=0
	y_a=0
	f_a=0
		
	imm=smooth2(im,9)
 	auto_find_sma,imm,fwhm,rms,sigma,x_a,y_a,f_a
	;oplot,x_a-128,y_a-128,psym=4
	
	x_f=0
	y_f=0
	f_f=0	

	avg_bg, 2, field_no, bg_image
	bb=smooth2(bg_image,9)
	auto_find_sma,bb,fwhm,rms,sigma,x_f,y_f,ff
		
	;set_plot,'ps'
	;device,filename='/scr1/Confusion/Detect/bg_plot_'+strcompress(string(sigma),/remov)
	;!p.multi=[0,2,2]
	window,1
	wset,1
	th_image_cont,bg_image,level=[2*rms,3*rms],xrange=[-128,128]$
		,/aspect,yrange=[-128,128],/nobar,ct=0$
		,crange=[0.1*rms,5*rms]
	if keyword_set(x_f) eq 0 then goto,go
	oplot,x_f-128,y_f-128,psym=2,color=255
	wset,0
	; !p.multi=0
	go:
	;device,/close
	;set_plot,'x'	
	
	if keyword_set(x_f) eq 0 then begin
		x_d=x_a
		y_d=y_a
		flux=f_a
	endif else begin	
		reject_false,x_a,y_a,f_a,x_f,y_f,ff,x_d,y_d,flux
		print,x_d
	endelse
	;wset,0
	if keyword_set(x_d) eq 0 then begin
		count(0)=count(0)+c
		count(4)=count(4)+n_elements(x)	
	endif else begin
		x_d=x_d-128
		y_d=y_d-128
 	
		oplot,x_d,y_d,psym=5,color=255
	
		d_rate,x,y,x_d,y_d,fwhm,index,ind_c,c,count

	endelse
	
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
			if min(r) lt fwhm*5 then begin
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
			if min(r) lt fwhm*5 then begin
				nd=nd+1
			endif else begin
				nd=nd+0
			endelse
		endfor
	endif else begin
		nd=nd+0
	endelse
	final: 

 
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
		x=-1*reform(data.field1(1,*))/0.14
		y=reform(data.field1(2,*))/0.14
	endif else begin
		flux=data.field1(0)
		x=-1*data.field1(1)/0.14
		y=data.field1(2)/0.14
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
		plots,x(index),y(index),psym=6,color=255
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

PRO AUTO_FIND_SMA, IM, FWHM,RMS, SIGMA, X, Y, FLUX
	hmin=rms*sigma 
	sharplim=[0.07,1.0]
	roundlim=[-0.6,1.0]
	find,im,x,y,flux,sharp,round,hmin,fwhm,roundlim,sharplim,/silent
END

PRO AVG_BG, BG_FIELD, FIELD, IMAGE
	name1='/scr1/Confusion/Background/sma_d_030429_'
	name2='_bg'
	name3='.fits'

	data=fltarr(257,257)

	for i=1,bg_field do begin
		filename=name1+strcompress(string(field),/remov)+name2+strcompress(string(i),/remov)+name3
		im=readfits(filename)
		data=im+data
	endfor

	data=data/bg_field		

	image=data

END

PRO REJECT_FALSE, X, Y, F, X_F, Y_F, F_F, X_D, Y_D, FLUX
	flag=bytarr(n_elements(x))
	flag(*)=1
	for i=0, n_elements(x)-1 do begin
		r=(x(i)-x_f)^2+(y(i)-y_f)^2
		if min(r) lt 5 then begin
			flag(i)=0
		endif
	endfor
	
	ind=where(flag eq 1,c)
	if c ne 0 then begin
		x_d=reform(x(ind))
		y_d=reform(y(ind))
		flux=reform(f(ind))
	endif else begin
		goto, out
	endelse
	out:
END
