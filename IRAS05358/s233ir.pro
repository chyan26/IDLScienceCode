@phot_s233
@deredden
@diagrams
@lineregions
@textable
@iracstar
@klfimf
@count
@simklf
@cloudmass
PRO LOADCONFIG
	COMMON share,imgpath, mappath
	
	;Settings for HOME computer
	;imgpath = '/Volumes/disk1s1/Projects/S233IR/'
	;mappath = '/Volumes/disk1s1/Projects/S233IR/'
	
	;Settings for ASIAA computer
	imgpath='/Volumes/data/Projects/S233IR/'
	mappath='/Volumes/data/Projects/S233IR/'
	
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

PRO IMGEXTRACT, cra, cdec, imsize, oim, ohd, nim, nhd
  Compile_opt idl2
  On_error,2

  npar = N_params()

  if ( npar EQ 0 ) then begin
        print,'Syntax - IMGEXTRACT, cra, cdec, oim, ohd, nim, nhd'
        print,'CRA and CDEC must be in decimal DEGREES'
        return
  endif                                                                  
  
  adxy,ohd,cra,cdec,x,y
  rad=fix(imsize/2.0)  
  hextract,oim,ohd,nim,nhd,fix(x-rad+1),fix(x+rad),fix(y-rad+1), fix(y+rad)
  ;print,fix(x-rad+1),fix(x+rad),fix(y-rad+1), fix(y+rad)
  
  return 
END


PRO ALLFOV
  COMMON share,imgpath, mappath
  loadconfig
  
  im1=readfits(imgpath+'S233IR_J_coadd.fits',hd1)
  im2=readfits(imgpath+'S233IR_H_coadd.fits',hd2)
  im3=readfits(imgpath+'S233IR_Ks_coadd.fits',hd3)
  
  cord=sxpar(hd1,"CRVAL*")
  print,cord
  imgextract, 84.747397,35.77946, 2500, im1, hd1, nim1, nhd1
  imgextract, 84.747397,35.77946, 2500, im2, hd2, nim2, nhd2
  imgextract, 84.747397,35.77946, 2500, im3, hd3, nim3, nhd3
  
  ind=where(nim1 eq 0)
  nim1[ind]=44000
  
  ind=where(nim2 eq 0)
  nim2[ind]=44000
  
  ind=where(nim3 eq 0)
  nim3[ind]=44000

  writefits,imgpath+'s233_all_j.fits',nim1,nhd1
  writefits,imgpath+'s233_all_h.fits',nim2,nhd3
  writefits,imgpath+'s233_all_k.fits',nim3,nhd3
  ;image={j:nim1,h:nim2,k:nim3}
  ;header={j:nhd1,h:nhd2,k:nhd3}




END


PRO RESIZEIMAGE, image, header
	COMMON share,imgpath, mappath
	
	loadconfig
	; Load images
	path=imgpath
	
	im1=readfits(path+'S233IR_J_coadd.fits',hd1)
	im2=readfits(path+'S233IR_H_coadd.fits',hd2)
	im3=readfits(path+'S233IR_Ks_coadd.fits',hd3)
	im4=readfits(path+'S233IR_H2_coadd.fits',hd4)
	im5=readfits(path+'S233IR_BrG_coadd.fits',hd5)	
	im6=readfits(path+'S233IR_Kcont_coadd.fits',hd6)
	
	;
	; scale image to the same dimension
	hastrom, im2,hd2,tim2,thd2,hd1
	
	;
	; Generate a header with center at 05:39:13.0 35:45:54.0
	shd=hd1
	sxaddpar,shd,'CRVAL1',84.8041667
	sxaddpar,shd,'CRVAL2',35.765
	sxaddpar,shd,'CRPIX1',2700
	sxaddpar,shd,'CRPIX2',2700
	
	;
	; scale image to the same dimension
	hastrom, im1,hd1,tim1,thd1,shd
	hastrom, im2,hd2,tim2,thd2,shd
	hastrom, im3,hd3,tim3,thd3,shd
	hastrom, im4,hd4,tim4,thd4,shd
	hastrom, im5,hd5,tim5,thd5,shd
	hastrom, im6,hd6,tim6,thd6,shd
	
	;
	; cut interesting area
	
	hextract, tim1, thd1, nim1,nhd1,2188,3211,2188,3211
	hextract, tim2, thd2, nim2,nhd2,2188,3211,2188,3211
	hextract, tim3, thd3, nim3,nhd3,2188,3211,2188,3211
	hextract, tim4, thd4, nim4,nhd4,2188,3211,2188,3211
	hextract, tim5, thd5, nim5,nhd5,2188,3211,2188,3211
	hextract, tim6, thd6, nim6,nhd6,2188,3211,2188,3211

	;
	; Replace nan in image
	;
	repnan, nim1, max(nim1)
	repnan, nim2, max(nim2)
	repnan, nim3, max(nim3)
	repnan, nim4, max(nim4)
	repnan, nim5, max(nim5)
	repnan, nim6, max(nim6)
	
	
	image={j:nim1,h:nim2,k:nim3,h2:nim4,brg:nim5,kcont:nim6}
	header={j:nhd1,h:nhd2,k:nhd3,h2:nhd4,brg:nhd5,kcont:nhd6}
	
	return

END

PRO SAVEFITS, image, header
	COMMON share,imgpath, mappath
	loadconfig
	
	writefits,imgpath+'s233ir_j.fits',image.j,header.j
	writefits,imgpath+'s233ir_h.fits',image.h,header.h
	writefits,imgpath+'s233ir_k.fits',image.k,header.k
	writefits,imgpath+'s233ir_h2.fits',image.h2,header.h2
	writefits,imgpath+'s233ir_brg.fits',image.brg,header.brg
	writefits,imgpath+'s233ir_kcont.fits',image.kcont,header.kcont

END


PRO LOADS233IR, image, header
	COMMON share,imgpath, mappath
	loadconfig
	
	nim1=readfits(imgpath+'s233ir_j.fits',nhd1)
	nim2=readfits(imgpath+'s233ir_h.fits',nhd2)
	nim3=readfits(imgpath+'s233ir_k.fits',nhd3)
	nim4=readfits(imgpath+'s233ir_h2.fits',nhd4)
	nim5=readfits(imgpath+'s233ir_brg.fits',nhd5)
	nim6=readfits(imgpath+'s233ir_kcont.fits',nhd6)
	
	image={j:nim1,h:nim2,k:nim3,h2:nim4,brg:nim5,kcont:nim6}
	header={j:nhd1,h:nhd2,k:nhd3,h2:nhd4,brg:nhd5,kcon:nhd6}

END


PRO RUNSEXTRACTOR
	COMMON share,imgpath, mappath
	loadconfig
	spawn,'sex -c '+imgpath+'sex.conf '+imgpath+'s233ir_j.fits -CHECKIMAGE_NAME '$
		+imgpath+'check_j.fits -CATALOG_NAME '+imgpath+'j.sex -MAG_ZEROPOINT 24.99'$
		+' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
		+' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 3.0,5.0'
		
	spawn,'sex -c '+imgpath+'sex.conf '+imgpath+'s233ir_h.fits -CHECKIMAGE_NAME '$
		+imgpath+'check_h.fits -CATALOG_NAME '+imgpath+'h.sex -MAG_ZEROPOINT 24.93'$
		+' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
		+' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 3.0,5.0'
	
	spawn,'sex -c '+imgpath+'sex.conf '+imgpath+'s233ir_k.fits -CHECKIMAGE_NAME '$
		+imgpath+'check_k.fits -CATALOG_NAME '+imgpath+'k.sex -MAG_ZEROPOINT 25.686'$
		+' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
		+' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 3.0,5.0'
	
	spawn,'sex -c '+imgpath+'sex.conf '+imgpath+'s233ir_h2.fits -CHECKIMAGE_NAME '$
		+imgpath+'check_h2.fits -CATALOG_NAME '+imgpath+'h2.sex'

	spawn,'sex -c '+imgpath+'sex.conf '+imgpath+'s233ir_brg.fits -CHECKIMAGE_NAME '$
		+imgpath+'check_brg.fits -CATALOG_NAME '+imgpath+'brg.sex'

END


PRO GET_GOODSTAR, catalog
	COMMON share,imgpath, mappath
	loadconfig
	
	runsextractor
		
	readcol,imgpath+'j.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	index=where(flag eq 0 and class ge 0.85 and mag le 16.2)
	;index=where(id ne 0)
	j={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index],$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
	
	readcol,imgpath+'h.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	index=where(flag eq 0 and class ge 0.85 and mag  le 15.8)
	;index=where(id ne 0)
	h={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index],$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
	
	readcol,imgpath+'k.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	index=where(flag eq 0 and class ge 0.85 and mag le 15)
	;index=where(id ne 0)
	k={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index],$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
	
	readcol,imgpath+'h2.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	index=where(flag eq 0 and class ge 0.85)
	h2={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index],$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}

	readcol,imgpath+'brg.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	index=where(flag eq 0 and class ge 0.85,cat)
	brg={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index],$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
	
	catalog={j:j,h:h,k:k,h2:h2,brg:brg}	
END

;
; Get 2MASS catalog from network using FITS header.
;
PRO GET2MASS, hdr, ref
	spawn,"rm -rf /tmp/2mass_idl.dat"
	spawn,"scat -c tmc 84.8041667 35.765 J2000 -r 250 -n 500 -d> /tmp/2mass_idl.dat"
	readcol,'/tmp/2mass_idl.dat',a,ra,dec,m1,m2,mag
	ind=where(mag le 15)
	
	adxy,hdr,ra,dec,x,y

	
	ref={id:findgen(n_elements(ra)),ra:ra[ind],dec:dec[ind],x:x[ind],$
		y:y[ind],mj:m1[ind],mh:m2[ind],mk:mag[ind]}
END

;
; Get Porras catalog from file
;
PRO GETPORRAS, hdr, ref
	COMMON share,imgpath, mappath	
	loadconfig
	readcol,imgpath+'porras.cat',id,ra,dec,mj,mjerr,mh,mherr,mk,mkerr,av,m
	;ind=where(abs(m2-mag) le 0.9)
	
	adxy,hdr,ra,dec,x,y

   cmj=mj-11.28-0.270*av
   cmh=mh-11.28-0.142*av      
   cmk=mk-11.28-0.081*av

   ;Selecting NE cluster
   neind=where((((x-537.0)^2 + (y-530.0)^2) le 11000) or $
   (x ge 436 and x le 448 and y ge 454 and y le 471),count)
   group=intarr(n_elements(x))   
   group[neind]=1
   
   swind=where(((x-659.0)^2 + (y-369.0)^2) le 10000 ,count) 
   group[swind]=2

   ind=where((((x-659.0)^2 + (y-369.0)^2) le 10000) $
      or (((x-537.0)^2 + (y-530.0)^2) le 11000 or $
      (x ge 436 and x le 448 and y ge 454 and y le 471)), complement=inx)      
   group[inx]=3
	
	ref={id:findgen(n_elements(ra)),ra:ra,dec:dec,x:x,y:y,mj:mj,mh:mh,mk:mk,$
         mjerr:mjerr,mherr:mherr,mkerr:mkerr,cmj:cmj,cmh:cmh,cmk:cmk,av:av,$
         mass:m,group:group}
END




;
; This function takes two sets of catalogue and do a matching
;    to register star detected by any routine
;
PRO MATCH_CATALOG,x1,y1,mag1,merr1,x2,y2,mag2,match
	; x1	: vector of X positions of field star (by FIND)
	; y1	: vector of Y positions of field star(by FIND)
	; mag1	: vector of Ks band magnitudes of field star (by APER)
	; merr1  : vector of magnitudes error of star (by APER)	
	; x2	: vector of X positions of catalog star (2MASS)
	; y2	: vector of Y positions of catalog star (2MASS)
	; mag2	: vector of Ks band magnitudes of catalog star
	; match : structure that stores the matched catalog
	; .x	:  vector of X positions of matched stars
	; .y	:  vector of Y positions of matched stars
	; .fmag1:  vector of instrumental magnitude
	; .fmag2:  vector of magnitude of catalog stars (2MASS) 
	flag=intarr(n_elements(x2))
	flag[*]=0
	x=0
	y=0
	fmag1=0
	fmag2=0

	n=0
	for i=0,n_elements(x1)-1 do begin
		dist=sqrt((x1[i]-x2)^2+(y1[i]-y2)^2)
		ind=where(dist eq min(dist) and min(dist) le 5,count)
		
		if (count ne 0) then begin
			if flag[ind] eq 0 then begin
				if n eq 0 then begin
					x=x1[i]
					y=y1[i]
					fmag1=mag1[i]
					fmag2=mag2[ind]
					magerr=merr1[i]
				endif else begin
					x=[x,x1[i]]
					y=[y,y1[i]]
					fmag1=[fmag1,mag1[i]]
					fmag2=[fmag2,mag2[ind]]
					magerr=[magerr,merr1[i]]
				endelse				
				
				n=n+1
				flag[ind]=1	
			endif
		endif
	endfor
	
	match={id:findgen(n_elements(x)),x:x,y:y,fmag1:fmag1,fmag2:fmag2,magerr:magerr}
	
END

PRO FLUXZP_J, im, catalog, ref, ps=ps
	COMMON share,imgpath, mappath
	
	loadconfig
	!p.multi=[0,1,2]
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'fluxzp_j.ps',$
         /color,xsize=15,ysize=25,xoffset=1.5,yoffset=0
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2   
   endif else begin
      red=255
      green=32768    
   endelse

	MATCH_CATALOG,catalog.j.x, catalog.j.y, catalog.j.mag,catalog.j.magerr,$
		 ref.x, ref.y, ref.mj, match
	err=match.magerr
	
	catmag=match.fmag1
	refmag=match.fmag2
	
	s=catmag-refmag
	s_weight= 1 / err
	s_best= total(s_weight*s)/total(s_weight)

	th_image_cont,60-im.j,/nocont,/nobar,crange=[0,60]
	oplot,match.x,match.y,psym=4,color=red
			
	plot,refmag,s,psym=6,yrange=[-2.0,2.0],$
		xtitle='!6Magnitude from 2MASS Catalog',ytitle='Deteced - 2MASS',$
		title='!6J Band'

	oplot,[min(refmag),max(refmag)],[s_best,s_best]
	errplot,refmag,catmag-refmag-err,catmag-refmag+err
	print,s_best,median(s)

   if keyword_set(PS) then begin
	     device,/close
      set_plot,'x'
   endif
   resetplt,/all
	!p.multi=0

END

PRO FLUXZP_H, im, catalog, ref,ps=ps
	COMMON share,imgpath, mappath
	
	loadconfig
	!p.multi=[0,1,2]
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'fluxzp_h.ps',$
         /color,xsize=15,ysize=25,xoffset=1.5,yoffset=0
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2   
   endif else begin
      red=255
      green=32768    
   endelse
	
	MATCH_CATALOG,catalog.h.x, catalog.h.y, catalog.h.mag, catalog.h.magerr,$
		 ref.x, ref.y, ref.mh, match
	err=match.magerr
	
	catmag=match.fmag1
	refmag=match.fmag2
	
	s=catmag-refmag
	s_weight= 1 / err
	s_best= total(s_weight*s)/total(s_weight)
	
	th_image_cont,60-im.h,/nocont,/nobar,crange=[0,60]
	oplot,match.x,match.y,psym=4,color=red

	
	plot,refmag,s,psym=6,yrange=[-2.0,2.0],$
		xtitle='!6Magnitude from 2MASS Catalog',ytitle='Deteced - 2MASS',$
		title='!6H Band'

	oplot,[min(refmag),max(refmag)],[s_best,s_best]
	errplot,refmag,catmag-refmag-err,catmag-refmag+err
	print,s_best,median(s)
   
	if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif

   ind=where(s ge 0.5 and refmag le 13.5)
   ;getds9region,match.x[ind],match.y[ind],'star_check_h'

   resetplt,/all
	!p.multi=0

END

PRO FLUXZP_K, im, catalog, ref, ps=ps
	COMMON share,imgpath, mappath
	
	loadconfig
	!p.multi=[0,1,2]
   if keyword_set(PS) then begin 
   	!x.charsize=1.3
	!y.charsize=1.3
	!p.charthick=5.0
	!x.thick=8
	!y.thick=8

      set_plot,'ps'
      device,filename=mappath+'fluxzp_k.ps',$
         /color,xsize=15,ysize=25,xoffset=1.5,yoffset=0
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2   
   endif else begin
      red=255
      green=32768    
   endelse

	MATCH_CATALOG,catalog.k.x, catalog.k.y, catalog.k.mag, catalog.k.magerr,$
		 ref.x, ref.y, ref.mk, match
	err=match.magerr
	
	
	catmag=match.fmag1
	refmag=match.fmag2
	
	s=catmag-refmag
	s_weight= 1 / err
	s_best= total(s_weight*s)/total(s_weight)
	ind=where(s ge 0)
	th_image_cont,60-im.k,/nocont,/nobar,crange=[0,60]
	oplot,match.x,match.y,psym=4,color=red

	
	plot,refmag,s,psym=6,yrange=[-2.0,2.0],$
		xtitle='!6Magnitude from 2MASS Catalog',ytitle='Deteced - 2MASS',$
		title='!6Ks Band'

	oplot,[min(refmag),max(refmag)],[s_best,s_best]
	oplot,[min(refmag),max(refmag)],[median(s),median(s)],line=3
	errplot,refmag,catmag-refmag-err,catmag-refmag+err
	print,s_best,median(s)
	
	if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif
   
   ind=where(s ge 0.5 and refmag le 13)
   ;getds9region,match.x[ind],match.y[ind],'star_check_k'
   resetplt,/all
	!p.multi=0

END


; This function is used to get the photometry information of all stars except the bow
;  shocks
PRO GET_PHOTO,cat
	COMMON share,imgpath, mappath
	loadconfig
	
	readcol,imgpath+'j.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	;index=where(flag eq 0 and class ge 0.55)
	index=where(id ne  0)
	j={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index],$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
		
	
	readcol,imgpath+'h.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	index=where(flag eq 0 and class ge 0.85)
	index=where(id ne 0)
	h={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index],$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
	
	readcol,imgpath+'k.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	;index=where(flag eq 0 and class ge 0.85)
	index=where(id ne 0)
	k={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index],$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
	cat={j:j,h:h,k:k}	
END


PRO MKCATALOG, cat, final
	COMMON share,imgpath, mappath
	
	loadconfig
	
	; The first step is to register the catalog
	
	; Mininum distance in pixels
	d=3.0
	
	j=0
	; This is the flag for star registered.
	jflag=intarr(n_elements(cat.j.x))
	kflag=intarr(n_elements(cat.k.x))
	
	
	; Initialize the arrays
	xx=fltarr(n_elements(cat.h.x))
	yy=fltarr(n_elements(cat.h.x))
	mj=fltarr(n_elements(cat.h.x))
	mh=fltarr(n_elements(cat.h.x))
	mk=fltarr(n_elements(cat.h.x))
	mjerr=fltarr(n_elements(cat.h.x))
	mherr=fltarr(n_elements(cat.h.x))
	mkerr=fltarr(n_elements(cat.h.x))
	
	; Beginning of the loop
	for i=0,n_elements(cat.h.x)-1 do begin
		x=cat.h.x[i]
		y=cat.h.y[i]
		
		xx[i]=x
		yy[i]=y
		mh[i]=cat.h.mag[i]
		mherr[i]=cat.h.magerr[i]

		; Looking for k band
		dist1=sqrt(((cat.k.x-x)^2)+((cat.k.y-y)^2))
		ind1=where(dist1 eq min(dist1) and (min(dist1) le d) and (kflag eq 0), count1)
		if (count1 ne 0) then begin
			mk[i]=cat.k.mag[ind1]
			mkerr[i]=cat.k.magerr[ind1]
			kflag[ind1]=1
		endif else begin
			mk[i]=-999.0
			mkerr[i]=-999.0
		endelse
		
		; Looking for J band
		dist2=sqrt(((cat.j.x-x)^2)+((cat.j.y-y)^2))
		ind2=where(dist2 eq min(dist2) and min(dist2) le 3 and (jflag eq 0), count2)
		if (count2 ne 0) then begin
			mj[i]=cat.j.mag[ind2]
			mjerr[i]=cat.j.magerr[ind2]
			jflag[ind2]=1
		endif else begin
			mj[i]=-999.0
			mjerr[i]=-999.0
		endelse
		
		
	endfor
	

   ;Selecting NE cluster
   neind=where((((xx-537.0)^2 + (yy-530.0)^2) le 11000) or $
   (xx ge 436 and xx le 448 and yy ge 454 and yy le 471),count)
   group=intarr(n_elements(xx))   
   group[neind]=1
   
   swind=where(((xx-659.0)^2 + (yy-369.0)^2) le 10000 ,count) 
   group[swind]=2

   ind=where((((xx-659.0)^2 + (yy-369.0)^2) le 10000) $
      or (((xx-537.0)^2 + (yy-530.0)^2) le 11000 or $
      (xx ge 436 and xx le 448 and yy ge 454 and yy le 471)), complement=inx)      
   group[inx]=3

   ;eliminate stars only detected in K band 
   ind=where((mk ge 17.5 and mj eq -999.0 and mh eq -999.0) or (mk ge 19.0) $
   and (mh or 19.5) and (mj or 20.0), complement=inx)
   id=indgen(n_elements(inx))
    final={id:id,x:xx[inx],y:yy[inx],mj:mj[inx],mh:mh[inx],mk:mk[inx],$
            mjerr:mjerr[inx],mherr:mherr[inx],mkerr:mkerr[inx],group:group[inx]}


END

PRO GETDS9TEXT, text,x, y, name, color=color
  COMMON share,imgpath, mappath 
  loadconfig

  regname = name+'.reg'
  regpath = mappath
  regfile = regpath+regname
  
  ;x=cat.x
  ;y=cat.y
  id=indgen(n_elements(x))
  
  openw,fileunit, regfile, /get_lun 
  index = where(id eq 1)
  ;printf, fileunit, 'global color=green dashlist=8 3 width=1 font="helvetica 10 normal" select=1 high lite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1 physical'
  for i=0, n_elements(x)-1 do begin
    print,x[i],i
    ext=0 
    regstring = '# text('+$
                    strcompress(string(x[i]),/remove_all)+','+$
                    strcompress(string(y[i]),/remove_all)+') width=2 '+$
                    ' text= {'+strcompress(string(text[i]),/remove_all)+'}'
    printf, fileunit, format='(A)', regstring
  endfor
  
  close, fileunit
  free_lun,fileunit


END

PRO GETDS9REGION, x, y, name, color=color
	COMMON share,imgpath, mappath	
	loadconfig

	regname = name+'.reg'
	regpath = mappath
	regfile = regpath+regname
	
	;x=cat.x
	;y=cat.y
	id=indgen(n_elements(x))
	
	openw,fileunit, regfile, /get_lun	
	index = where(id eq 1)
	for i=0, n_elements(x)-1 do begin
		ext=0	
		regstring = 'tile '+strcompress(string(ext),/remove_all)+'; image; circle('+$
                    strcompress(string(x[i]),/remove_all)+','+$
                    strcompress(string(y[i]),/remove_all)+',10) #color ='+color
		printf, fileunit, format='(A)', regstring
	endfor
	
	close, fileunit
	free_lun,fileunit
END

PRO  ISOPLOT
	COMMON share,imgpath, mappath	
	loadconfig

	
	loadiso_dm98,iso1,av=0,age=1
	loadiso_dm98,iso2,av=0,age=2
	loadiso_dm98,iso3,av=0,age=3
	loadiso_dm98,iso5,av=0,age=5
	loadiso_dm98,iso7,av=0,age=7
	loadiso_dm98,iso10,av=0,age=10
	
	plot,iso1.mh-iso1.mk,iso1.mk, $
		yrange=[13,-5],ystyle=1,xrange=[-0.5,0.5], $
		xstyle=1, xtitle='H-Ks',ytitle='Ks',charsize=2

	oplot,iso2.mh-iso2.mk,iso2.mk
	oplot,iso3.mh-iso3.mk,iso3.mk
	oplot,iso5.mh-iso5.mk,iso5.mk
	oplot,iso7.mh-iso7.mk,iso7.mk
	oplot,iso10.mh-iso10.mk,iso10.mk

END





FUNCTION ABSMAG, final, dist
	amag=final
	amag.mj=final.mj-5*(alog10(dist)-1)
	amag.mh=final.mh-5*(alog10(dist)-1)
	amag.mk=final.mk-5*(alog10(dist)-1)
	return,amag
END


PRO QUICKRUN
  loads233ir,im,hd
  daophot,cat
  mkcatalog,cat,final

  getporras,hd.j,porrascat
   
  ; Star count and compare with Porras 2000   
  starcount, cat  
  clustercount,final,porrascat
  
  absmag=absmag(final,1800.0)
  
  mkccdiagram, absmag,/ps
  mkcmd,absmag, /ps
  
  ; Correcting extinction
  newderedden, absmag, corrcat
   
  ; Compare KLF
  klfcomp,corrcat,porrascat,/ps
  
   		   
  ; Age estimation 
  getageplot,corrcat,/ps 
   
  ; Calculate the mass based on MLR
  getmass,corrcat, all 
   
  ; Plot IMFs of clusters
  clusterimf,all,/ps
  allimf,all,/ps
  
   
  iraccatalog,irac
  mergecat,all,irac,merge
  mksed,merge
  	
END


PRO S233IR
	resizeimage,im,hd
	savefits,im,hd
	loads233ir,im,hd
	get_goodstar, cat
	get2mass, hd.j, ref
	getporras,hd,j,ref
	fluxzp_j,im,cat,ref,/ps
	fluxzp_h,im,cat,ref,/ps
	fluxzp_k,im,cat,ref,/ps
	
    daophot,cat
	mkcatalog,cat,final

   ; Star count and compare with Porras 2000   
   starcount, cat  
   getporras,hd.j,porrascat
   clustercount,final,porrascat
   
   ; Absolite magnitude
   absmag=absmag(final,1800.0)
   porabs=absmag(porrascat,1800.0)
   
   ; Making diagrams
   mkccdiagram, absmag,/ps
	mkcmd,absmag, /ps
   
   ; Correcting extinction
   newderedden, absmag, corrcat
   newderedden, porabs, porcor

   ; Compare KLF
   klfcomp,corrcat,porrascat,/ps
   fieldklfcomp,corrcat,porrascat
   		   
   ; Age estimation 
   getageplot,corrcat
  
   ; Calculate the mass based on MLR
   getmass,corrcat, all 
   
	; Plot IMFs of clusters
   clusterimf,all
   allimf,all
   
   dustmap,corrcat 
   clusterklf,all,porrascat
   klf,all
   
   
   iraccatalog,irac
   mergecat,all,irac,merge
   mksed,merge
   
   textable,merge
   
   subtract_cont,im,line
   savelineimg,line,hd
END

