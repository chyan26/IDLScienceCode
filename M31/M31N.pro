PRO LOADCONFIG
	COMMON share,imgpath, mappath
	
	;Settings for HOME computer
	imgpath = '/data/chyan/ScienceImages/M31/NORTH-field/'
	mappath = '/data/chyan/ScienceImages/M31/'
	
;	;Settings for ASIAA computer
;	imgpath='/arrays/cfht/cfht_2/chyan/home/Science/S233IR/'
;	mappath='/arrays/cfht/cfht_2/chyan/home/Science/S233IR/'
	
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

PRO RESIZEIMAGE, image, header
	COMMON share,imgpath, mappath
	
	loadconfig
	; Load images
	path=imgpath
	
	im1=readfits(path+'M31N-J.fits',hd1)
	im2=readfits(path+'M31N-H.fits',hd2)
	im3=readfits(path+'M31N-K.fits',hd3)
	im4=readfits(path+'M31N-H2.fits',hd4)
	im5=readfits(path+'M31N-BrG.fits',hd5)	
	;
	; scale image to the same dimension
	hastrom, im2,hd2,tim2,thd2,hd1
	
	;
	; Generate a header with center at
        ; Right Ascension     00:43:44.257        Declination         41:39:38.51
	shd=hd1
	sxaddpar,shd,'CRVAL1',10.93440604
	sxaddpar,shd,'CRVAL2',41.66069739
	sxaddpar,shd,'CRPIX1',2434.5
	sxaddpar,shd,'CRPIX2',2440.5
	
	;
	; scale image to the same dimension
	hastrom, im1,hd1,tim1,thd1,shd
	hastrom, im2,hd2,tim2,thd2,shd
	hastrom, im3,hd3,tim3,thd3,shd
	hastrom, im4,hd4,tim4,thd4,shd
	hastrom, im5,hd5,tim5,thd5,shd
	
	;
	; cut interesting area
	
	hextract, tim1, thd1, nim1,nhd1,300,4565,425,4600
	hextract, tim2, thd2, nim2,nhd2,300,4565,425,4600
	hextract, tim3, thd3, nim3,nhd3,300,4565,425,4600
	hextract, tim4, thd4, nim4,nhd4,300,4565,425,4600
	hextract, tim5, thd5, nim5,nhd5,300,4565,425,4600

	
	image={j:nim1,h:nim2,k:nim3,h2:nim4,brg:nim5}
	header={j:nhd1,h:nhd2,k:nhd3,h2:nhd4,brg:nhd5}
	
	return

END

PRO SAVEFITS, image, header
	COMMON share,imgpath, mappath
	loadconfig
	
	writefits,imgpath+'M31N-J-res.fits',image.j,header.j
	writefits,imgpath+'M31N-H-res.fits',image.h,header.h
	writefits,imgpath+'M31N-K-res.fits',image.k,header.k
	writefits,imgpath+'M31N-H2-res.fits',image.h2,header.h2
	writefits,imgpath+'M31N-BrG-res.fits',image.brg,header.brg

END


PRO LOADM31, image, header
	COMMON share,imgpath, mappath
	loadconfig
	
	nim1=readfits(imgpath+'M31N-J-res.fits',nhd1)
	nim2=readfits(imgpath+'M31N-H-res.fits',nhd2)
	nim3=readfits(imgpath+'M31N-K-res.fits',nhd3)
	nim4=readfits(imgpath+'M31N-H2-res.fits',nhd4)
	nim5=readfits(imgpath+'M31N-BrG-res.fits',nhd5)
	
	image={j:nim1,h:nim2,k:nim3,h2:nim4,brg:nim5}
	header={j:nhd1,h:nhd2,k:nhd3,h2:nhd4,brg:nhd5}

END




PRO RUNSEX
	COMMON share,imgpath, mappath
	loadconfig

	spawn,'sex -c sex.conf M31N-J-res.fits -CHECKIMAGE_NAME'$
		+' check_j.fits -CATALOG_NAME j.sex -MAG_ZEROPOINT 24.94'$
		+' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
		+' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 3.0,5.0'
		
	spawn,'sex -c sex.conf M31N-J-res.fits,M31N-H-res.fits -CHECKIMAGE_NAME '$
		+' check_h.fits -CATALOG_NAME h.sex -MAG_ZEROPOINT 24.95'$
		+' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
		+' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 3.0,5.0'
	
	spawn,'sex -c sex.conf M31N-J-res.fits,M31N-K-res.fits -CHECKIMAGE_NAME '$
		+' check_k.fits -CATALOG_NAME k.sex -MAG_ZEROPOINT 24.95'$
		+' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
		+' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 3.0,5.0'
	
	
END





PRO GET_PHOTVIS,phot
	COMMON share,imgpath, mappath
	loadconfig
	restore,imgpath+'photvis_k.txt'
	id=n_elements(pv_dat[0,*])+1
	k={id:id,x:reform(pv_dat[0,*]),y:reform(pv_dat[1,*]),mag:reform(pv_dat[7,*])}
	phot={k:k}
END


PRO GET_GOODSTAR, catalog
	COMMON share,imgpath, mappath
	loadconfig
			
	readcol,imgpath+'j.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	index=where(class ge 0.7)
	;index=where(id ne 0)
	j={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index],$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
	
	readcol,imgpath+'h.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	index=where(class ge 0.7)
	;index=where(id ne 0)
	h={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index],$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
	
	readcol,imgpath+'k.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	index=where(class ge 0.7)
	;index=where(id ne 0)
	k={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index],$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
	
	catalog={j:j,h:h,k:k}
END

;
; Get 2MASS catalog from network using FITS header.
;
PRO GET2MASS, hdr, ref
	ra=sxpar(hdr,"CRVAL1")
	dec=sxpar(hdr,"CRVAL2")

	spawn,"rm -rf /tmp/2mass_idl.dat"
	s="scat -c tmc "+string(ra)+string(dec)+" J2000 -r 250 -n 500 -d> /tmp/2mass_idl.dat"
	;print,s
	spawn,s
	;spawn,"scat -c tmc "+string(ra)+string(dec)+"J2000 -r 250 -n 500 -d> /tmp/2mass_idl.dat"
	;ind=where(abs(m2-mag) le 0.9)
	readcol,'/tmp/2mass_idl.dat',a,ra,dec,m1,m2,mag
	adxy,hdr,ra,dec,x,y

	
	ref={id:findgen(n_elements(ra)),ra:ra,dec:dec,x:x,y:y,mj:m1,mh:m2,mk:mag}
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
   getds9region,match.x[ind],match.y[ind],'star_check_h'

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
   getds9region,match.x[ind],match.y[ind],'star_check_k'
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


PRO MKHRDIAGRAM, cat, final, ps=ps
	COMMON share,imgpath, mappath
	
	loadconfig
;	!p.multi=[0,1,2]
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'hrdiagram.ps',$
         /color,xsize=20,ysize=15,xoffset=0.4,yoffset=10
         
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
   endif else begin
	   blue=65535
      red=255
      green=32768    
   endelse

	; The first step is to register the catalog
	
	j=0
	for i=0L,n_elements(cat.j.x)-1 do begin
		
		x=cat.j.x[i]
		y=cat.j.y[i]
		
		dist1=sqrt(((cat.h.x-cat.j.x[i])^2)+((cat.h.y-cat.j.y[i])^2))
		ind1=where(dist1 eq min(dist1) and min(dist1) le 3, count1)
		
		dist2=sqrt(((cat.k.x-cat.j.x[i])^2)+((cat.k.y-cat.j.y[i])^2))
		ind2=where(dist2 eq min(dist2) and min(dist2) le 3, count2)
	
		
		if (count1 ne 0 and count2 ne 0) then begin
			if j eq 0 then begin
				xx=cat.j.x[i]
				yy=cat.j.y[i]
				mj=cat.j.mag[i]
				mh=cat.h.mag[ind1]
				mk=cat.k.mag[ind2]
				j=j+1
			endif
			xx=[xx,cat.j.x[i]]
			yy=[yy,cat.j.y[i]]
			mj=[mj,cat.j.mag[i]]
			mh=[mh,cat.h.mag[ind1]]
			mk=[mk,cat.k.mag[ind2]]
			final={x:xx,y:yy,mj:mj,mh:mh,mk:mk}
		endif
	endfor
	
 	ind=where(final.mj le 20 and final.mh le 20 and final.mk le 20)
	plot,final.mh[ind]-final.mk[ind],final.mj[ind]-final.mh[ind],xtitle='!6H-K',$
		ytitle='J-H',xrange=[-0.5,4.5],yrange=[0,5],xstyle=1,psym=3
	
	;plot,final.mh-final.mk,final.mj-final.mh,psym=3,xtitle='!6H-K',$
	;	ytitle='J-H',xrange=[-0.5,4.5],yrange=[0,5],xstyle=1
	
	; Plot stellar group
	readcol,imgpath+'zams_dwarf.txt',djh,dhk
	oplot,dhk,djh,color=blue
	readcol,imgpath+'zams_gaint.txt',gjh,ghk
	oplot,ghk,gjh,color=blue
	
	aa=(findgen(6)+5)/10
	bb=0.58*aa+0.52
	oplot,aa,bb,line=4,color=blue
	;plot extinction
	
 	arrow,0.0,1.5,0.65,2.61,/data,color=red
 	oplot,[0.37,3.37],[0.66,5.76],line=3,color=red
 	oplot,[0.16,3.16],[0.79,5.89],line=3,color=red
	oplot,[max(aa),3+max(aa)],[max(bb),5.1+max(bb)],line=3,color=red
	print,n_elements(final.mh)
	
	if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
	endif
	

	resetplt,/all
	!p.multi=0

	return 
END

PRO SUBTRACTCON, im
	COMMON share,imgpath, mappath
	
	loadconfig

	newbrg=im.brg-im.k
	newh2=im.h2-im.k
	newline=im.brg-im.h2
	writefits,mappath+'brg.fits',newbrg
	writefits,mappath+'h2.fits',newh2
	writefits,mappath+'line.fits',newline
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
	hflag=intarr(n_elements(cat.h.x))
	
	
	; Initialize the arrays
	xx=fltarr(n_elements(cat.k.x))
	yy=fltarr(n_elements(cat.k.x))
	mj=fltarr(n_elements(cat.k.x))
	mh=fltarr(n_elements(cat.k.x))
	mk=fltarr(n_elements(cat.k.x))
	mjerr=fltarr(n_elements(cat.k.x))
	mherr=fltarr(n_elements(cat.k.x))
	mkerr=fltarr(n_elements(cat.k.x))
	
	; Beginning of the loop
	for i=0L,n_elements(cat.k.x)-1 do begin
		x=cat.k.x[i]
		y=cat.k.y[i]
		
		xx[i]=x
		yy[i]=y
		mk[i]=cat.k.mag[i]
		mkerr[i]=cat.k.magerr[i]

		; Looking for h band
		dist1=sqrt(((cat.h.x-x)^2)+((cat.h.y-y)^2))
		ind1=where(dist1 eq min(dist1) and (min(dist1) le d) and (hflag eq 0), count1)
		if (count1 ne 0) then begin
			mh[i]=cat.h.mag[ind1]
			mherr[i]=cat.h.magerr[ind1]
			hflag[ind1]=1
		endif else begin
			mh[i]=-999.0
			mherr[i]=-999.0
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
	
	final={x:xx,y:yy,mj:mj,mh:mh,mk:mk,$
			mjerr:mjerr,mherr:mherr,mkerr:mkerr}


END


PRO MKCCDIAGRAM, final, ps=ps

	COMMON share,imgpath, mappath
	
	loadconfig

;	!p.multi=[0,1,2]
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'hrdiagram.ps',$
         /color,xsize=20,ysize=20,xoffset=0.4,yoffset=10
         
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
   endif else begin
	  blue=65535
      red=255
      green=32768    
   endelse


	; Plot HR diagram

	plot,final.mh-final.mk,final.mj-final.mh,psym=3,xtitle='!6H-K',$
		ytitle='J-H',xrange=[-0.5,2.5],yrange=[0,3],xstyle=1
	
	; Plot stellar group
	;readcol,imgpath+'zams_dwarf.txt',djh,dhk,/SILENT
	loaddwarfiso,djh,dhk
	oplot,dhk,djh,color=blue
	loadgaintiso,gjh,ghk
	
	oplot,ghk,gjh,color=blue
	
	aa=(findgen(6)+5)/10
	bb=0.58*aa+0.52
	oplot,aa,bb,line=4,color=blue
	
	;plot extinction

 	arrow,0.0,1.5,0.65,2.61,/data,color=red
 	oplot,[0.37,3.37],[0.66,5.76],line=3,color=red
 	oplot,[0.16,3.16],[0.79,5.89],line=3,color=red
	oplot,[max(aa),3+max(aa)],[max(bb),5.1+max(bb)],line=3,color=red
	
	
	if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
	endif
	
	resetplt,/all
	!p.multi=0

	return 
END


PRO MKCMD, final, ps=ps

	COMMON share,imgpath, mappath	
	loadconfig

	!p.multi=[0,2,1]
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'cmd_1myr.ps',$
         /color,xsize=40,ysize=20,xoffset=0.4,yoffset=10,$
         SET_FONT='Helvetica Bold',/TT_FONT,/encapsulated
         
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
   endif else begin
	  blue=65535
      red=255
      green=32768    
   endelse

	
	; Plot CMD
; 	plot,final.mj-final.mh,final.mj,psym=3, $
; 		yrange=[-4,-12],ystyle=1,xrange=[-1,3], $
; 		xstyle=1, xtitle='J-H',ytitle='J',charsize=2
	plot,final.mj-final.mk,final.mj,psym=3, $
		yrange=[-4,-12],ystyle=1,xrange=[-1,3], $
		xstyle=1, xtitle='J-K',ytitle='J',charsize=2

	loadiso_dm98,iso,av=0,age=1
	loadiso_dm98,iso1,av=8.0,age=1
	
	oplot,iso.mj-iso.mh,iso.mj,color=red
	oplot,iso1.mj-iso1.mh,iso1.mj,color=red
	for i=0,n_elements(iso.mass)-1,4 do begin
		xyouts,-0.5,iso.mk[i],strcompress(string(iso.mass[i],format='(f5.2)')$
		,/remove),/data
	endfor
		
	
	
	plot,final.mh-final.mk,final.mk,psym=3, $
		yrange=[-5,-13],ystyle=1,xrange=[-1,3], $
		xstyle=1, xtitle='H-Ks',ytitle='Ks',charsize=2
	
	oplot,iso.mh-iso.mk,iso.mk,color=red
	oplot,iso1.mh-iso1.mk,iso1.mk,color=red
	for i=0,n_elements(iso.mass)-1,4 do begin
		xyouts,-0.5,iso.mk[i],strcompress(string(iso.mass[i],format='(f5.2)')$
		,/remove),/data
	endfor
		
	if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
	endif
	
	resetplt,/all
	!p.multi=0

	return 
END

FUNCTION ABSMAG, final, dist
	amag=final
	amag.mj=final.mj-5*(alog10(dist)-1)
	amag.mh=final.mh-5*(alog10(dist)-1)
	amag.mk=final.mk-5*(alog10(dist)-1)
	return,amag
END


PRO M31N
;resizeimage,im,hd
;savefits,im,hd
;loadm31,im,hd
;runsex
;get_goodstar, cat
;get2mass, hd.j, ref
;fluxzp_j,im,cat,ref,/ps
;fluxzp_h,im,cat,ref,/ps
;fluxzp_k,im,cat,ref,/ps
;get_photo,cat1
mkcatalog, cat, final
mkccdiagram, final,/ps
fin=absmag(final,778.0e3)
mkcmd,fin
END

