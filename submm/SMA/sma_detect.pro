PRO SMA_DETECT, START_FIELD, END_FIELD, SIGMA, CONFIG
	common share, dataset
	common share1, im3
	common share2, sf
	fwhm=[2.82,5.48,12,31.0]
	sigma=3.0
	start_field=108
	end_field=108
	config=4
	sf=3
	rate=fltarr(5)
	count=fltarr(5)
	count(*)=0
	rate(*)=0
	dataset='SMA_sky1_50hr'
	im1='/scr1/'+dataset+'/Fits/sma_'
	im2=['a','b','c','d']
	im3='_030526_'
	im4='.fits'
	s1='/scr1/'+dataset+'/Data/submm_source'

	beam_rad=[[0.2,0.15],[0.38,0.32],[0.82,0.80],[2.2,2.3]]


	close,1
	openw,1,'/scr1/'+dataset+'/Detect/sma_detecion_'+im2(config-1)+'_'+strmid(strcompress(string(sigma),/remov),0,3)
	for i=start_field, end_field do begin
	 	print,'Now processing image',i
		;wait,1
		fitsfile=im1+im2(config-1)+im3+strcompress(string(i),/remov)+im4
		sourcefile=s1+strcompress(string(i),/remov)

		read_source,sourcefile,flux,x,y
		im=readfits(fitsfile)
		rms=stddev(im)
		!x.title='!6R.A. offset (arcsec; J2000)'
		!y.title='!6Dec. offset (arcsec; J2000)'
		th_image_cont,im,level=[2*rms,3*rms],xrange=[-18,18]$
			,/aspect,yrange=[-18,18],/nobar,crange=[0.1*rms,5*rms],c_color=0
		rad=[beam_rad(0,config-1),beam_rad(1,config-1)]
		ellipse,center=-17+rad,radii=rad,/fill

		oplot_source,flux,x,y,sigma,rms
		xyouts,-120,115,'('+im2(config-1)+')',charsize=1.3,/data

		data=detect_count(im,fwhm(config-1),sigma,rms,i,config)
		if data(0) eq -1 then begin
			print,'No detection'
			rate(0)=n_elements(x)+rate(0)
			ind=where(flux ge sigma*rms,c)
			rate(1)=c+rate(1)
		endif else begin
			dd=d_rate(flux,x,y,data(0,*),data(1,*),data(2,*),fwhm(config-1),sigma,rms)
			for j=0, n_elements(data(0,*))-1 do begin
				printf,format='(f12.8,f10.4,f10.4,tr4,i3)'$
					,1,data(0,j),-data(1,j)*0.14,data(2,j)*0.14,i
			endfor
			count=dd+count
		endelse
		print,rate
		print,count
	endfor

	count=rate+count
	print,count
	close,1

	openw,1,'/scr1/'+dataset+'/Detect/sma_count_'+im2(config-1)+'_'+strmid(strcompress(string(sigma),/remov),0,3)
	printf,1,'Total No. of source(s) inputed',count(0)-100*(end_field-start_field+1)
	printf,1,'No. of source(s) with f > 3-sigma:',count(1)
	printf,1,'No. of source(s) detected by FIND:',count(2)
	printf,1,'No. of source(s) f > 3-sigma and detected:',count(3)
	printf,1,'No. of source(s) f < 3-sigma but detected:',count(4)
	close,1


	resetplt,/all

end

FUNCTION DETECT_COUNT, IMAGE, FWHM ,SIGMA, RMS, FIELD_NO, CONFIG, DATA
;
;   COUNT
;       Return the detection counts, the first is the expected source
;       number over given sigma. The second is the detected source
;       number using FIND with flux over given sigma.  The last is the
;	number of detected and expected sources.
;
	fwhm=FWHM
	sigma=SIGMA
	im=IMAGE

	common share2

	;th_image_cont,im,level=[2*rms,3*rms],xrange=[-18,18]$
	;	,/aspect,yrange=[-18,18],/nobar,ct=0$
	;	,crange=[0.1*rms,5*rms]

	;imm=smooth2(im,fwhm/sf)
 	imm=im


	auto_find_sma,imm,fwhm,rms,sigma,x_a,y_a,f_a
	;oplot,(x_a-128)/0.14,(y_a-128)/0.14,psym=6,symsize=2
	oplot,(x_a*0.14)-18,(y_a*0.14)-18,psym=6
;

	if keyword_set(x_a) eq 0 then begin
		data=-1
		goto,here
	endif

	avg_bg, 2, field_no, bg_image, config

	;bb=smooth2(bg_image,fwhm/sf)
	bb=bg_image

window,1
wset,1
	th_image_cont,bg_image,level=[2*rms,3*rms],xrange=[-18,18]$
		,/aspect,yrange=[-18,18],/nobar,ct=0$
		,crange=[0.1*rms,5*rms]

	auto_find_sma,bb,fwhm,rms/2,sigma,x_f,y_f,ff
	oplot,x_f*0.14-18,y_f*0.14-18,psym=6
wset,0

	if keyword_set(x_f) eq 0 then begin
		x_d=x_a
		y_d=y_a
		flux=f_a
	endif else begin
		reject_false,x_a,y_a,f_a,x_f,y_f,ff,x_d,y_d,flux,rms
	endelse

	if keyword_set(x_d) eq 0 then begin
		data=-1
		goto,here
	endif else begin;
		x_d=x_d*0.14-18
		y_d=y_d*0.14-18
		;oplot,x_d,y_d,psym=5,color=255
		oplot,x_d,y_d,psym=5,symsize=2
		data=fltarr(3,n_elements(x_d))
		data(0,*)=flux
		data(1,*)=x_d
		data(2,*)=y_d
	endelse
	print,data
	print,rms
	here:
	return,data
END


FUNCTION D_RATE, FLUX, X, Y, F_D, X_D, Y_D, FWHM, RMS, SIGMA, COUNT
	x=X
	y=Y
	x_d=X_D
	y_d=Y_D
	fwhm=FWHM


	dd=0   ;dd gives the detection no. for sources flux > 3-sigma and detected
	nd=0   ;ad gives the detection no. for sources flux < 3-sigma but detected

	index=where(flux ge rms*sigma, c, complement=ind_c)

	if c ne 0 then begin
		for i=0,n_elements(x_d)-1 do begin
			r=(x(index)-x_d(i))^2+(y(index)-y_d(i))^2
			if sqrt(min(r))/0.14 lt fwhm then begin
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
			if sqrt(min(r))/0.14 lt fwhm then begin
				nd=nd+1
			endif else begin
				nd=nd+0
			endelse
		endfor
	endif else begin
		nd=nd+0
	endelse
	;print,nd
	final:



	count=fltarr(5)
	count(0)=n_elements(x)
	count(1)=c
	count(2)=n_elements(x_d)
	count(3)=dd
	count(4)=nd
	return,count

END

PRO READ_SOURCE, FILE, FLUX, X, Y
	file=FILE
	flux=FLUX
	x=X
	y=Y
	data=read_ascii(file)
	if n_elements(data.field1) gt 3 then begin
		flux=reform(data.field1(0,*))
		x=-1*reform(data.field1(1,*))
		y=reform(data.field1(2,*))
	endif else begin
		flux=data.field1(0)
		x=-1*data.field1(1)
		y=data.field1(2)
	endelse
END

PRO OPLOT_SOURCE, FLUX, X, Y, SIGMA, RMS
	flux=FLUX
	x=X
	y=Y
	sigma=SIGMA
	rms=RMS
	index=INDEX    ; sources where f > given sigma level
	no=NO          ; number of sources where f > given sigma level
	ind_c=IND_C    ; sources where f < given sigma level
	;index=where(flux ge sigma*rms, c, complement=ind_c)
 	index=where(flux ge sigma*rms, c)
	ind_c=where(flux gt 0.00005 and flux lt sigma*rms)


	if n_elements(index) eq 1 and index(0) eq -1 then goto, next
	if c ne 1 then begin
		plots,x(index),y(index),psym=6,symsize=2
	endif else begin
		plots,x(index),y(index),psym=6,symsize=2
	endelse

	next:
	if ind_c(0) eq -1 then goto,final
	if n_elements(ind_c) ne 1 then begin
		oplot,x(ind_c),y(ind_c),psym=1,symsize=2
	endif else begin
		plots,x(ind_c),y(ind_c),psym=1,symsize=2
	endelse
	final:
	no=c
END

PRO AUTO_FIND_SMA, IM, FWHM,RMS, SIGMA, X, Y, FLUX
	hmin=rms*sigma
	sharplim=[0.07,1.0]
	roundlim=[-100.0,100.0]
	find,im,x,y,flux,sharp,round,hmin,fwhm,roundlim,sharplim,/silent
END

PRO AVG_BG, BG_FIELD, FIELD, IMAGE, CONFIG
	common share;, dataset, im3
	common share1
	name1='/scr1/'+dataset+'/Background/sma_'
	name2=['a','b','c','d']
	name3=im3
	name4='_bg'
	name5='.fits'

	data=fltarr(257,257)

	for i=1,bg_field do begin
		filename=name1+name2(config-1)+name3+strcompress(string(field),/remov)+name4+strcompress(string(i),/remov)+name5
		im=readfits(filename)
		data=im+data
	endfor

	data=data/bg_field

	image=data

END

PRO REJECT_FALSE, X, Y, F, X_F, Y_F, F_F, X_D, Y_D, FLUX, RMS
	flag=bytarr(n_elements(x))
	flag(*)=1
	for i=0, n_elements(x)-1 do begin
		r=(x(i)-x_f)^2+(y(i)-y_f)^2
		ind=where(r eq min(r))
		if min(r) lt 25 and min(abs(f(i)-f_f(ind))) lt 3*rms then begin
		;if min(r) lt 49 then begin
			flag(i)=0
		endif
	endfor


	;index=where(flag eq 1)
	for i=0, n_elements(x)-1 do begin
		if f(i) lt rms then begin
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
