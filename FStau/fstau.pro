PRO LOADCONFIG
	COMMON share,imgpath, mappath
	
	;Settings for ASIAA computer
	imgpath='/arrays/cfht_3/chyan/06BT13/processed/'
	mappath='/arrays/cfht_3/chyan/06BT13/processed/'
	
	return 
END

PRO GETCOORD;,im,CRANGE=crange
	;resetplt,/all
	;th_image_cont,im,/nocont,crange=crange,/nobar,/aspect
	cursor,x,y
	print,x,y

END

;
; This function takes two sets of catalogue and do a matching
;    to register star detected by any routine
;
PRO MATCH_CATALOG,x1,y1,mag1,x2,y2,mag2,x,y,fmag1,fmag2
	; x1		: vector of X positions of field star (by FIND)
	; y1		: vector of Y positions of field star(by FIND)
	; mag1	: vector of Ks band magnitudes of field star (by APER)	
	; x2		: vector of X positions of catalog star
	; y2		: vector of Y positions of catalog star
	; mag2	: vector of Ks band magnitudes of catalog star
	
	flag=intarr(n_elements(x2))
	flag[*]=0
	x=0
	y=0
	fmag1=0
	fmag2=0
	
	; first find the distance between 2 catalog
	h=histogram(sqrt((x1[0]-x2)^2+(y1[0]-y2)^2),bin=1)
	hx=n_elements(h)
	for i=0,n_elements(x1)-1 do begin
		h=histogram(sqrt((x1[i]-x2)^2+(y1[i]-y2)^2),bin=1)
		hx=h+hx
	endfor
	
	n=0
	flag=intarr(n_elements(y2))
	for i=0,n_elements(x1)-1 do begin
		dist=sqrt((x1[i]-x2)^2+(y1[i]-y2)^2)
		if min(dist) le 3 then begin
			ind = where(dist eq min(dist))
			if flag[ind] ne 0 then break
			if n eq 0 then begin
				x=x1[i]
				y=y1[i]
				fmag1=mag1[i]
				fmag2=mag2[ind]
			endif else begin
				x=[x,x1[i]]
				y=[y,y1[i]]
				fmag1=[fmag1,mag1[i]]
				fmag2=[fmag2,mag2[ind]]
			endelse				
			n=n+1
			flag[ind]=1
		endif 
	endfor
	
	coeff=poly_fit(fmag1,fmag2,1,yfits)
	
	plot,fmag1,fmag2,$
		psym=4,charsize=1.3,$
		xrange=[max(fmag1),min(fmag1)],yrange=[max(fmag2),min(fmag2)],$
		xtitle='!6Instrumental Magitude (m_inst)',ytitle='2MASS Magitude (M)',$
		title='M = '+strcompress(string(coeff[1]),/remove)+'m_inst'+'+('+$
			strcompress(string(coeff[0]),/remove)+')'
	coeff=poly_fit(fmag1,fmag2,1,yfits)	
	oplot,fmag1,yfits,color=255
	
	;print,coeff
	;print,fmag1[0],fmag2[0]
	;print,fmag1[0]*coeff[1]+coeff[0]
END

;
; This subroutine did a photometric meseasurement using PSF fitting.  In the 
;   beginning, it first find out all point sources.  Then, specifiy stars to 
;   be selected as PSF.  Finally, it fits all star for instumental magnitude.
;   Note: this program is used to do phtometry for field stars, not for cloudy
;     area.
PRO DAOPHOT, im, x,y,mag
   common share, imgpath, mappath
   loadconfig
	
	
	hlim=median(im)+3*stddev(im)
	
	; detecting point source
	fwhm=3
	hmin=hlim
	sharplim=[0.2,1.0]
	roundlim=[-1.0,1.0]
	find,im,x1,y1,flux,sharp,round,hmin,fwhm,roundlim,sharplim,/silent
	th_image_cont,im,/nocont,crange=[0,100]
	
	ind=where((x1 ge 450 and x1 le 617 and y1 ge 417 and y1 lt 588) or $
		(x1 ge 707 and x1 le 754 and y1 ge 655 and y1 lt 699),complement=inx)
	
	x=x1[inx]
	y=y1[inx]
	
	; Run aperture photometry
	aper,im,x,y,mag,aperr,sky,skyerr,1,3,[5,8],[0,0],/silent
	id=where((mag ne 99.99) or (mag ne !values.f_nan))
	x=x[id]
	y=y[id]
	mag=mag[id]
	;mag1=mag
   
   ;th_image_cont,im,/nocont,crange=[0,50]
	;oplot,x,y,psym=4,color=255
   ;xyouts,x,y,strcompress(string(fix(id)),/remove),color=red
   
   ; Produce PSF based on selected stars
	;getpsf,im,x,y,mag,sky,30.0,2.0,gauss,psf,[70,72,75,12,7,1,75,110,25,26,15],$
    ;  6,5,imgpath+'psf.fits'
	; Group all star, the factor 9 is PSF radius+fitting radius from getpsf
   ;group,x,y,9,ngroup
	; Point spread function fitting
   ;nstar,im,intarr(n_elements(x)),x,y,mag,sky,ngroup,2.0,30.0,imgpath+'psf.fits'
   
   ;plot,mag-mag1,psym=1,yrange=[-1,1]
   ;oplot,mag1,psym=2
END

PRO PHOTOMETRY, im, hdr

	daophot,im,x,y,mag
	getcatalog,hdr,cat
	match_catalog,x,y,mag,cat.x,cat.y,cat.mk,xx,yy,m1,m2
END


;
;
; Get 2MASS catalog from network using FITS header.
;
PRO GETCATALOG, hdr, catalog
	;
	; First of all, extract the center coordinate from header.
	;   then convert this coordinate from xy to AD
	xcoord=sxpar(hdr,"NAXIS1")/2
	ycoord=sxpar(hdr,"NAXIS2")/2
	
	xyad, hdr, xcoord, ycoord, ira, idec

	;
	; Calculate the radius of in the unit of arcsecond.
	;
	radius=xcoord*0.3
	
	spawn,"rm -rf /tmp/2mass_idl.dat"
	spawn,"scat -c tmc "+strcompress(string(ira),/remove)+" "+strcompress(string(idec),/remove)+$
		" J2000 -r "+strcompress(string(2*radius),/remove)+" -n 2000 -d> /tmp/2mass_idl.dat"
	readcol,'/tmp/2mass_idl.dat',a,ra,dec,m1,m2,mag
	;ind=where(abs(m2-mag) le 0.9)
	
   catalog={id:0,ra:0.0,dec:0.0,x:0.0,y:0.0,mj:0.0,mh:0.0,mk:0.0}
   catalog=replicate(catalog,n_elements(ra))
   catalog.id=indgen(n_elements(ra))+1
   catalog.ra=ra
   catalog.dec=dec

	adxy,hdr,ra,dec,x,y
	catalog.x=x
   catalog.y=y
   catalog.mj=m1
   catalog.mh=m2
   catalog.mk=mag
END


; This function is used to load mosiacing Ks band and H2 images from disk 
PRO LOADIMAGE, ks, h2, ks_hd, h2_hd
	COMMON share,imgpath
	
	loadconfig
	; Load images
	path=imgpath
	
	im1=readfits(path+'tauFS_H2.fits',hd1)
	im2=readfits(path+'tauFS_Ks.fits',hd2)
	;
	; scale image to the same dimension
	hastrom, im2,hd2,tim2,thd2,hd1
	
	;
	; Generate a header with center at 20:14:25.1 +41:13:32.0
	shd=hd1
	sxaddpar,shd,'CRVAL1',65.40150763
	sxaddpar,shd,'CRVAL2',27.05161469
	
	;
	; scale image to the same dimension
	hastrom, im1,hd1,tim1,thd1,shd
	hastrom, im2,hd2,tim2,thd2,shd
	
	;
	; cut interesting area
	hextract, tim1, thd1, nim1,nhd1,888,1912,932,1956
	hextract, tim2, thd2, nim2,nhd2,888.5,1912.5,932,1956
	
	;sxaddpar,nhd2,'CRVAL1',65.51001667
	;sxaddpar,nhd2,'CRVAL2',27.95903889
	;sxaddpar,nhd2,'CRPIX1',1409
	;sxaddpar,nhd2,'CRPIX2',1450

	; Restore raw image
	h2=nim1
	ks=nim2

	ks_hd=nhd2
	h2_hd=nhd1
	return
END



PRO fstau
	common share, imgpath, mappath
	loadconfig
	
	loadimage,ks,h2,hd1,hd2
	th_image_cont,h2-(ks*2),/nocont,crange=[0,200]
	
	writefits,mappath+'fstau_h2_line.fits',h2-(ks*2),hd1
	
END