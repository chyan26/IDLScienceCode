PRO LOADCONFIG
	COMMON share,imgpath, mappath
	
	;Settings for HOME computer
	;imgpath = '/Volumes/disk1s1/S233IR/'
	;mappath = '/Volumes/disk1s1/S233IR/'
	
	;Settings for ASIAA computer
	imgpath='/arrays/cfht/cfht_2/chyan/home/Science/S233IR/'
	mappath='/arrays/cfht/cfht_2/chyan/home/Science/S233IR/'
	
; 	color=[[255,0,0],]
; tvlct,255,0,0,1                         ; $$ red
; tvlct,240,0,240,2                       ; $$ magenta
; tvlct,245,133,20,3                      ; $$ orange
; tvlct,255,250,0,4                       ; $$ ellow
; tvlct,0,255,0,5                         ; $$ light green
; tvlct,12,158,22,6                       ; $$ green
; tvlct,0,0,255,7                         ; $$ blue
; tvlct,0,225,255,8                       ; $$ ligth blue
; tvlct,138,37,182,9                      ; $$ purple
; tvlct,0,0,0,10                          ; $$ black
	
END

PRO GETASSOC
	COMMON share,imgpath, mappath

	loadconfig
	
	
	RESTORE,imgpath+'photvis_j.db'
	
;		[x,y,rnd,shp,aper,insky,outsky,mag,magerr,sky,skyerr,user_status]
	id=n_elements(pv_dat[0,*])+1
	j={id:id,x:reform(pv_dat[0,*]),y:reform(pv_dat[1,*]),mag:reform(pv_dat[7,*])}
	phot={j:j}
	close,1
	openw,1,imgpath+'stars_cat_j.assoc'
		for i=0, n_elements(pv_dat[0,*])-1 do begin
			printf,1,i+1,pv_dat[0,i],pv_dat[1,i],pv_dat[7,i]
		endfor
	close,1
	
	RESTORE,imgpath+'photvis_h.db'
	
;		[x,y,rnd,shp,aper,insky,outsky,mag,magerr,sky,skyerr,user_status]
	id=n_elements(pv_dat[0,*])+1
	j={id:id,x:reform(pv_dat[0,*]),y:reform(pv_dat[1,*]),mag:reform(pv_dat[7,*])}
	phot={j:j}
	close,1
	openw,1,imgpath+'stars_cat_h.assoc'
		for i=0, n_elements(pv_dat[0,*])-1 do begin
			printf,1,i+1,pv_dat[0,i],pv_dat[1,i],pv_dat[7,i]
		endfor
	close,1
	
	RESTORE,imgpath+'photvis_k.db'
	
;		[x,y,rnd,shp,aper,insky,outsky,mag,magerr,sky,skyerr,user_status]
	id=n_elements(pv_dat[0,*])+1
	j={id:id,x:reform(pv_dat[0,*]),y:reform(pv_dat[1,*]),mag:reform(pv_dat[7,*])}
	phot={j:j}
	close,1
	openw,1,imgpath+'stars_cat_k.assoc'
		for i=0, n_elements(pv_dat[0,*])-1 do begin
			printf,1,i+1,pv_dat[0,i],pv_dat[1,i],pv_dat[7,i]
		endfor
	close,1
END

PRO RUNSEXASSOC
	COMMON share,imgpath, mappath
	loadconfig
	
	; Based on the star list, do photometry on these star first
	spawn,'sex -c '+imgpath+'sex.conf '+imgpath+'s233ir_j.fits -CHECKIMAGE_NAME '$
		+imgpath+'soc_check_j.fits -CATALOG_NAME '+imgpath+'soc_j.sex '$
		+' -PARAMETERS_NAME /arrays/cfht/cfht_2/chyan/home/Science/S233IR/sex_assoc.param'$
		+' -MAG_ZEROPOINT 24.99 -ASSOC_NAME stars_cat_j.assoc'$
		+' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3,4 -ASSOC_TYPE NEAREST'$
		+' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
		+' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 0.0,0.0'

	spawn,'sex -c '+imgpath+'sex.conf '+imgpath+'s233ir_h.fits -CHECKIMAGE_NAME '$
		+imgpath+'soc_check_h.fits -CATALOG_NAME '+imgpath+'soc_h.sex '$
		+' -PARAMETERS_NAME /arrays/cfht/cfht_2/chyan/home/Science/S233IR/sex_assoc.param'$
		+' -MAG_ZEROPOINT 24.93 -ASSOC_NAME stars_cat_h.assoc'$
		+' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3,4 -ASSOC_TYPE NEAREST'$
		+' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
		+' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 0.0,0.0'

	spawn,'sex -c '+imgpath+'sex.conf '+imgpath+'s233ir_k.fits -CHECKIMAGE_NAME '$
		+imgpath+'soc_check_k.fits -CATALOG_NAME '+imgpath+'soc_k.sex '$
		+' -PARAMETERS_NAME /arrays/cfht/cfht_2/chyan/home/Science/S233IR/sex_assoc.param'$
		+' -MAG_ZEROPOINT 25.686 -ASSOC_NAME stars_cat_k.assoc'$
		+' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3,4 -ASSOC_TYPE NEAREST'$
		+' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
		+' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 0.0,0.0'

END


; This function check the background error for 
PRO CHECKPHOTERR, im
	th_image_cont,im,/nocont,/nobar,crange=[0,20]
	cursor,x,y,/data
	xx=fix(x)
	yy=fix(y)
	dim=im[xx-5:xx+5,yy-5:yy+5]
	print,median(dim)
END


; This function loads the photometry result of DAOPHOT
PRO DAOPHOT, cat
	COMMON share,imgpath, mappath
	loadconfig
	
	RESTORE,imgpath+'dao_j_080330.db'
	
	id=indgen(n_elements(pv_dat[0,*]))
	x=reform(pv_dat[0,*])
	y=reform(pv_dat[1,*])
	mag=reform(pv_dat[7,*])-0.046124
	magerr=reform(pv_dat[8,*])
	
	; Add 2MASS stars
	id=indgen(n_elements(pv_dat[0,*])+3)
	x=[x,665,305,635]
	y=[y,212,560,392]
	mag=[mag,11.474,12,327,12.371]
	magerr=[magerr,0.022,0.022,0.026]
	ind=where(mag le 25)
	;jh={id:id,x:x,y:y,mag:mag,magerr:magerr}
	
	jh={id:id[ind],x:x[ind],y:y[ind],mag:mag[ind],magerr:magerr[ind]}
	
	
	RESTORE,imgpath+'dao_h_080418.db'
	;RESTORE,imgpath+'dao_h_080330.db'
	
	id=indgen(n_elements(pv_dat[0,*]))
	x=reform(pv_dat[0,*])
	y=reform(pv_dat[1,*])
	mag=reform(pv_dat[7,*])-0.100760;-0.0857635
	;mag=reform(pv_dat[7,*])-0.0857635
	magerr=reform(pv_dat[8,*])

	
	;Adding 2MASS stars
	id=indgen(n_elements(pv_dat[0,*])+7)
	x=[x,161,305,145,665,805,785,635,772]
	y=[y,600,560,238,212,276,496,392,990]
	mag=[mag,11.910,11.586,11.667,10.532,11.857,11.880,10.631,11.952]
	magerr=[magerr,0.016,0.018,0.016,0.016,0.018,0.016,0.021,0.016]
	ind=where(mag le 25)
	hh={id:id[ind],x:x[ind],y:y[ind],mag:mag[ind],magerr:magerr[ind]}
	
	RESTORE,imgpath+'dao_k_080418.db'
	;RESTORE,imgpath+'dao_k_080330.db'
	
	id=indgen(n_elements(pv_dat[0,*]))
	x=reform(pv_dat[0,*])
	y=reform(pv_dat[1,*])
	mag=reform(pv_dat[7,*])-0.152250;-0.142190  
	;mag=reform(pv_dat[7,*])-0.142190  
	magerr=reform(pv_dat[8,*])

	;Adding 2MASS stars
	id=indgen(n_elements(pv_dat[0,*])+21)
	x=[x,161,307,213,145,772,611,708,872,786,635,615,650,675,503,497,499,443,$
		665,805,875,935,743]
	y=[y,602,560,446,239,990,800,859,753,496,391,346,353,355,512,194,408,378,$
		212,276,236,150,72]
	mag=[mag,11.796,11.223,12.681,11.206,11.155,12.839,12.823,12.723,11.228,$
		9.251,11.598,11.868,12.588,11.455,12.537,12.665,12.718,9.697,11.489,$
		12.361,12.552,12.834]
	magerr=[magerr,0.019,0.019,0.027,0.019,0.019,0.024,0.024,0.024,0.019,0.019,$
		0.020,0.027,0.041,0.038,0.025,0.025,0.024,0.018,0.019,0.021,0.018,0.027]

	ind=where(mag le 25)	
	kh={id:id[ind],x:x[ind],y:y[ind],mag:mag[ind],magerr:magerr[ind]}

	cat={j:jh,h:hh,k:kh}	

END


PRO LOADPHOT,cat
	COMMON share,imgpath, mappath
	loadconfig

	readcol,imgpath+'soc_j.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	RESTORE,imgpath+'photvis_aper_j.db'
	
	;index=where(flag eq 0 and class ge 0.55)
	index=where(id ne  0)
	j={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index],$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
	id=[id,indgen(n_elements(pv_dat[0,*]))+max(id)+1]
	x=[x,reform(pv_dat[0,*])]
	y=[y,reform(pv_dat[1,*])]
	mag=[mag,reform(pv_dat[7,*])-0.01]
	magerr=[magerr,reform(pv_dat[8,*])]
	
	jh={id:id,x:x,y:y,mag:mag,magerr:magerr}
		
	readcol,imgpath+'soc_h.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	RESTORE,imgpath+'photvis_aper_h.db'
	
	index=where(flag eq 0 and class ge 0.85)
	index=where(id ne 0)
	h={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index],$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
	id=[id,indgen(n_elements(pv_dat[0,*]))+max(id)+1]
	x=[x,reform(pv_dat[0,*])]
	y=[y,reform(pv_dat[1,*])]
	mag=[mag,reform(pv_dat[7,*])-0.07]
	magerr=[magerr,reform(pv_dat[8,*])]
	
	hh={id:id,x:x,y:y,mag:mag,magerr:magerr}
	
	readcol,imgpath+'soc_k.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	RESTORE,imgpath+'photvis_aper_k.db'

	;index=where(flag eq 0 and class ge 0.85)
	index=where(id ne 0)
	k={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index],$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
	
	id=[id,indgen(n_elements(pv_dat[0,*]))+max(id)+1]
	x=[x,reform(pv_dat[0,*])]
	y=[y,reform(pv_dat[1,*])]
	mag=[mag,reform(pv_dat[7,*])+0.686]
	magerr=[magerr,reform(pv_dat[8,*])]
	
	kh={id:id,x:x,y:y,mag:mag,magerr:magerr}
		
	
	cat={j:jh,h:hh,k:kh}	


END