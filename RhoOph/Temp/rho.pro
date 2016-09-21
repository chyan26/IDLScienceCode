PRO LOADCONFIG
	COMMON share,imgpath, mappath
	
	;Settings for HOME computer
	;imgpath = '/Volumes/disk1s1/oph_region34/'
	;mappath = '/Volumes/disk1s1/oph_region34/'
	
	;Settings for ASIAA computer
	;imgpath='/data/chyan/ScienceImages/RhoOph/WIRCam/'
	;mappath='/arrays/cfht/cfht_2/chyan/home/Science/RhoOph/'
	
	imgpath='/Volumes/disk1s1/RhoOph/WIRCam/'
	mappath='/Volumes/disk1s1/RhoOph/WIRCam/'
	
	
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

PRO SAMESIZE
	COMMON share,imgpath, mappath
	loadconfig
	path=imgpath
	file=['oph_region34_Y_coadd.fits',$
			'oph_region34_J_coadd.fits',$
			'oph_region34_H_coadd.fits',$
			'oph_region34_Ks_coadd.fits']
	
	newfile=['oph_Y_coadd.fits',$
			'oph_J_coadd.fits',$
			'oph_H_coadd.fits',$
			'oph_Ks_coadd.fits']

	
	hd=headfits(path+'oph_region34_Y_coadd.fits')
	
	; Because the file size is very large, so change the 
	;  index to run mapping one by one.
	for i=3,3 do begin
		im1=readfits(path+file[i],hd1)
		hastrom, im1,hd1,tim1,thd1,hd
		writefits,imgpath+newfile[i],tim1,thd1
	endfor
	

END


PRO TRICOLOR
	COMMON share,imgpath, mappath
	loadconfig

	cd,imgpath
	spawn,'stiff -c stiff.conf oph_Ks_coadd.fits '$
			+'oph_H_coadd.fits oph_Y_coadd.fits '$
 			+' -GAMMA 1.5 -COLOUR_SAT 1.1 '
			
END

;PRO EXTRACT_REGION3


;END

PRO OBSREGION
	COMMON share,imgpath, mappath
	loadconfig
	fits=imgpath+'OphA_ExtnCambR_F.fits'
	file1=imgpath+'rho_oph.txt'
	file2=imgpath+'rho_oph_yan.txt'

	; Plot background CO map	
	im=readfits(fits)
	hd=headfits(fits)
	im=max(im)-im
	hextract, im, hd, newim, newhd, 150, 314, 150, 290, SILENT = silent
	
	xim=sxpar(newhd,'NAXIS1')
	yim=sxpar(newhd,'NAXIS2')
	xyad,newhd,0,0,a0,d0
	xyad,newhd,xim,yim,a1,d1


	!x.charsize=1.3
	!y.charsize=1.3
	!p.charthick=5.0
	!p.thick=5.0
	!x.thick=8
	!y.thick=8
	set_plot,'ps'

	device,filename=imgpath+'rhoOph_spitzer.eps',/color,xsize=20,ysize=15,xoffset=1.5,yoffset=0
	tvlct,[0,255,0,0,255,255,94,136],[0,0,255,0,255,255,176,76],[0,0,0,255,255,0,113,14]
	;resetplt,/all
	!x.range=[a0,a1]
	!y.range=[d0,d1]
	th_image_cont,newim,/nocont,/nobar,crange=[0,8]
	
	; Plot Spitzer data
	spawn,'ls /Volumes/disk1s1/RhoOph/MIPS/MIPS24',result
	
	for i=0, n_elements(result)-1 do begin
		shd=headfits('/Volumes/disk1s1/RhoOph/MIPS/MIPS24/'+result[i])
		ra=sxpar(shd,'CRVAL1')
		dec=sxpar(shd,'CRVAL2')
		size=sxpar(shd,'NAXIS1')*sxpar(shd,'CDELT2')
		oplotbox,ra-size/2,ra+size/2,dec-size/2,dec+size/2,color=3
		;xyouts,ra,dec,i+1,color=1
	endfor
	
	irac=['/Volumes/disk1s1/RhoOph/IRAC/Field1/rho_oph_irac_field1_ch1.fits',$
			'/Volumes/disk1s1/RhoOph/IRAC/Field2/rho_oph_irac_field2_ch1.fits']
	
	for i=0, n_elements(irac)-1 do begin
		shd=headfits(irac[i])
		ra=sxpar(shd,'CRVAL1')
		dec=sxpar(shd,'CRVAL2')
		size=sxpar(shd,'NAXIS1')*sxpar(shd,'CDELT2')
		oplotbox,ra-size/2,ra+size/2,dec-size/2,dec+size/2,color=1
		;xyouts,ra,dec,i+1,color=1
	end		
	
	readcol,file1,id,pi,sra,sdec,filter,format='(a,a,a,a,a)',comment='#'
	ra=fltarr(n_elements(sra))
	dec=fltarr(n_elements(sra))

	for i=0,n_elements(sra)-1 do begin
		ra[i]=stringad(sra[i])*15
		dec[i]=stringad(sdec[i])
	endfor
	oplotbox,min(ra)-0.2,max(ra)+0.2,min(dec)-0.2,max(dec)+0.2,color=2
	
	
	readcol,file2,id,pi,sra,sdec,format='(a,a,a,a)';,comment='#'
	ra=fltarr(n_elements(sra))
	dec=fltarr(n_elements(sra))

	for i=0,n_elements(sra)-1 do begin
		ra[i]=stringad(sra[i])*15
		dec[i]=stringad(sdec[i])
	endfor
	oplotbox,min(ra)-0.2,max(ra)+0.2,min(dec)-0.2,max(dec)+0.2,color=2
	
	
	;Load IRAC data
	readcol,imgpath+'iracim.tbl',format='(a,i,i,a,i,a,l,f,f,f,f,a,a,i,i)',a,b,c,d,e,f,$
		g,epoch,equ,ra,dec,h,i,naxis1,naxis2  
	
	for i=0,n_elements(ra)-1 do begin
		xsize=naxis1[i]*0.000333*0.5
		ysize=naxis2[i]*0.000333*0.5
		oplotbox,ra[i]-xsize,ra[i]+xsize,dec[i]-ysize,dec[i]+ysize,color=5
	endfor

	device,/close
   resetplt,/all

END


PRO RESIZEIMAGE, image, header
	COMMON share,imgpath, mappath
	
	loadconfig
	; Load images
	path=imgpath
	
	im1=readfits(path+'oph_region34_J_coadd.fits',hd1)
	im2=readfits(path+'oph_region34_H_coadd.fits',hd2)
	im3=readfits(path+'oph_region34_Ks_coadd.fits',hd3)
	im4=readfits(path+'oph_region34_H2_coadd.fits',hd4)
	im5=readfits(path+'oph_region34_BrG_coadd.fits',hd5)	
	;im6=readfits(path+'oph_region34_Kcont_coadd.fits',hd6)
	
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
	
	;
	; cut interesting area
	
	hextract, tim1, thd1, nim1,nhd1,2188,3211,2188,3211
	hextract, tim2, thd2, nim2,nhd2,2188,3211,2188,3211
	hextract, tim3, thd3, nim3,nhd3,2188,3211,2188,3211
	hextract, tim4, thd4, nim4,nhd4,2188,3211,2188,3211
	hextract, tim5, thd5, nim5,nhd5,2188,3211,2188,3211

	;
	; Replace nan in image
	;
	repnan, nim1, max(nim1)
	repnan, nim2, max(nim2)
	repnan, nim3, max(nim3)
	repnan, nim4, max(nim4)
	repnan, nim5, max(nim5)
	
	
	image={j:nim1,h:nim2,k:nim3,h2:nim4,brg:nim5}
	header={j:nhd1,h:nhd2,k:nhd3,h2:nhd4,brg:nhd5}
	
	return

END

PRO RUNSEXTRACTOR
	COMMON share,imgpath, mappath
	loadconfig
;	spawn,'sex -c '+imgpath+'sex.conf '+imgpath+'oph_Y_coadd.fits  '$
;		+' -CATALOG_NAME '+imgpath+'cat_y.sex -MAG_ZEROPOINT 25.0'$
;		+' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 '$
;		+' -PHOT_AUTOAPERS 3.0,5.0'

	spawn,'sex -c '+imgpath+'sex.conf '+imgpath+'oph_J_coadd.fits  '$
		+' -CATALOG_NAME '+imgpath+'cat_j.sex -MAG_ZEROPOINT 25.0'$
		+' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 '$
		+' -PHOT_AUTOAPERS 3.0,5.0'

;	spawn,'sex -c '+imgpath+'sex.conf '+imgpath+'oph_H_coadd.fits  '$
;		+' -CATALOG_NAME '+imgpath+'cat_h.sex -MAG_ZEROPOINT 25.0'$
;		+' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 '$
;		+' -PHOT_AUTOAPERS 3.0,5.0'

;	spawn,'sex -c '+imgpath+'sex.conf '+imgpath+'oph_Ks_coadd.fits  '$
;		+' -CATALOG_NAME '+imgpath+'cat_ks.sex -MAG_ZEROPOINT 25.0'$
;		+' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 '$
;		+' -PHOT_AUTOAPERS 3.0,5.0'
		

END

PRO GET_GOODSTAR, catalog
	COMMON share,imgpath, mappath
	loadconfig
	
	;runsextractor
		
	readcol,imgpath+'cat_j.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	index=where(flag eq 0 and class ge 0.90)
	;index=where(id ne 0)
	j={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]+0.0368616 ,$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
	
	readcol,imgpath+'cat_h.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	index=where(flag eq 0 and class ge 0.90)
	;index=where(id ne 0)
	h={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.138691,$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
	
	readcol,imgpath+'cat_ks.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	index=where(flag eq 0 and class ge 0.90)
	;index=where(id ne 0)
	k={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.132373,$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
	

	catalog={j:j,h:h,k:k}	
END




PRO GET2MASS, ref
	COMMON share,imgpath, mappath
	loadconfig

	hd=headfits(imgpath+'oph_Y_coadd.fits')
	ra=strcompress(string(sxpar(hd,'CRVAL1')),/remove)
	dec=strcompress(string(sxpar(hd,'CRVAL2')),/remove)
	size=strcompress(string(sxpar(hd,'NAXIS1')*abs(sxpar(hd,'CD1_1'))*1800),/remove)
	
	spawn,"rm -rf /tmp/2mass_idl.dat"
	spawn,"scat -c tmc "+ra+" "+dec+" J2000 -r "+size+" -n 3000 -d> /tmp/2mass_idl.dat"
	readcol,'/tmp/2mass_idl.dat',a,ra,dec,m1,m2,mag
	
	adxy,hd,ra,dec,x,y

	
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
	for i=0L,n_elements(x1)-1 do begin
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

PRO FLUXZP_J, catalog, ref, ps=ps
	COMMON share,imgpath, mappath
	
	loadconfig
	;!p.multi=[0,1,2]
   if keyword_set(PS) then begin 
   	!x.charsize=1.3
	!y.charsize=1.3
	!p.charthick=5.0
	!x.thick=8
	!y.thick=8

      set_plot,'ps'
      device,filename=mappath+'fluxzp_j.ps',$
         /color,xsize=15,ysize=15,xoffset=1.5,yoffset=0
      
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
	ind=where(s le 0.4)
	s_weight= 1 / err[ind]
	s_best= total(s_weight*s[ind])/total(s_weight)

	;th_image_cont,60-im.j,/nocont,/nobar,crange=[0,60]
	;oplot,match.x,match.y,psym=4,color=red
			
	plot,refmag[ind],s[ind],psym=6,yrange=[-2.0,2.0],$
		xtitle='!6Magnitude from 2MASS Catalog',ytitle='2MASS - Detected',$
		title='!6J Band'

	oplot,[min(refmag),max(refmag)],[s_best,s_best]
	;errplot,refmag,catmag-refmag-err,catmag-refmag+err
	print,s_best,median(s)

   if keyword_set(PS) then begin
	     device,/close
      set_plot,'x'
   endif
   resetplt,/all
	!p.multi=0

END
PRO FLUXZP_H, catalog, ref,ps=ps
	COMMON share,imgpath, mappath
	
	loadconfig
	;!p.multi=[0,1,2]
   if keyword_set(PS) then begin       	
    !x.charsize=1.3
	!y.charsize=1.3
	!p.charthick=5.0
	!x.thick=8
	!y.thick=8

      set_plot,'ps'
      device,filename=mappath+'fluxzp_h.ps',$
         /color,xsize=15,ysize=15,xoffset=1.5,yoffset=0
      
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
	ind=where(s le 0.4)
	s_weight= 1 / err[ind]
	s_best= total(s_weight*s[ind])/total(s_weight)
	
	;th_image_cont,60-im.h,/nocont,/nobar,crange=[0,60]
	;oplot,match.x,match.y,psym=4,color=red

	
	plot,refmag[ind],s[ind],psym=6,yrange=[-2.0,2.0],$
		xtitle='!6Magnitude from 2MASS Catalog',ytitle='2MASS - Detected',$
		title='!6H Band'

	oplot,[min(refmag),max(refmag)],[s_best,s_best]
	;errplot,refmag,catmag-refmag-err,catmag-refmag+err
	print,s_best,median(s)
   
	if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif
   resetplt,/all
	!p.multi=0

END

PRO FLUXZP_K, catalog, ref, ps=ps
	COMMON share,imgpath, mappath
	
	loadconfig
	;!p.multi=[0,1,2]
   if keyword_set(PS) then begin   
    !x.charsize=1.3
	!y.charsize=1.3
	!p.charthick=5.0
	!x.thick=8
	!y.thick=8

      set_plot,'ps'
      device,filename=mappath+'fluxzp_k.ps',$
         /color,xsize=15,ysize=15,xoffset=1.5,yoffset=0
      
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
	ind=where(s le 0.8)
	s_weight= 1 / err[ind]
	s_best= total(s_weight*s[ind])/total(s_weight)
	
	;th_image_cont,60-im.k,/nocont,/nobar,crange=[0,60]
	;oplot,match.x,match.y,psym=4,color=red

	
	plot,refmag[ind],s[ind],psym=6,yrange=[-2.0,2.0],$
		xtitle='!6Magnitude from 2MASS Catalog',ytitle='2MASS - Detected',$
		title='!6Ks Band'

	oplot,[min(refmag),max(refmag)],[s_best,s_best]
	oplot,[min(refmag),max(refmag)],[median(s),median(s)],line=3
	;errplot,refmag,catmag-refmag-err,catmag-refmag+err
	print,s_best,median(s)
	
	if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif
   resetplt,/all
	!p.multi=0

END



PRO MKCATALOG, cat, final
	COMMON share,imgpath, mappath
	
	loadconfig
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
				mjerr=cat.j.magerr[i]
				mh=cat.h.mag[ind1]
				mk=cat.k.mag[ind2]
				mherr=cat.h.magerr[ind1]
				mkerr=cat.k.magerr[ind2]
				j=j+1
			endif else begin
			xx=[xx,cat.j.x[i]]
			yy=[yy,cat.j.y[i]]
			mj=[mj,cat.j.mag[i]]
			mjerr=[mjerr,cat.j.magerr[i]]
			mh=[mh,cat.h.mag[ind1]]
			mk=[mk,cat.k.mag[ind2]]
			mherr=[mherr,cat.h.magerr[ind1]]
			mkerr=[mkerr,cat.k.magerr[ind2]]
			endelse
		endif
	endfor
	
	final={x:xx,y:yy,mj:mj,mh:mh,mk:mk,$
			mjerr:mjerr,mherr:mherr,mkerr:mkerr}


END

PRO MKCCDIAGRAM, final, ps=ps

	COMMON share,imgpath, mappath
	
	loadconfig

;	!p.multi=[0,1,2]
   if keyword_set(PS) then begin
      	!x.charsize=1.3
	!y.charsize=1.3
	!p.charthick=5.0
	!x.thick=8
	!y.thick=8
	!p.thick=5.0
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

	plot,final.mh-final.mk,final.mj-final.mh,psym=4,xtitle='!6H-K',$
		ytitle='J-H',xrange=[-0.5,2.5],yrange=[0,3],xstyle=1
	
	; Plot stellar group
	readcol,imgpath+'zams_dwarf.txt',djh,dhk,/SILENT
	oplot,dhk,djh,color=blue,thick=5
	readcol,imgpath+'zams_gaint.txt',gjh,ghk,/SILENT
	oplot,ghk,gjh,color=blue
	
	aa=(findgen(6)+5)/10
	bb=0.58*aa+0.52
	oplot,aa,bb,line=4,color=blue
	;plot extinction
	
 	arrow,0.0,1.5,0.65,2.61,/data,color=red,thick=5
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
   	!x.charsize=1.3
	!y.charsize=1.3
	!p.charthick=5.0
	!x.thick=8
	!y.thick=8

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
	plot,final.mj-final.mh,final.mj,psym=3, $
		yrange=[15,0],ystyle=1,xrange=[-1,5], $
		xstyle=1, xtitle='J-H',ytitle='J',charsize=2
	; Points of SW cluster
	;ind=where(final.x ge 564 and final.x le 745 and final.y ge 286 $
	;	and final.y le 449)		
	;oplot,final.mj[ind]-final.mh[ind],final.mj[ind],psym=4	
	
	; Data of NE cluster
	;ind=where(((final.x-510.0)^2 + (final.y-520.0)^2) le 15000)
	;oplot,final.mj[ind]-final.mh[ind],final.mj[ind],psym=6	

	loadpmsiso,iso,av=0,age=10
	loadpmsiso,iso1,av=5.0,age=10
	
	oplot,iso.mj-iso.mh,iso.mj,color=red
	oplot,iso1.mj-iso1.mh,iso1.mj,color=red
	;for i=0,n_elements(iso.mass)-1,4 do begin
	;	xyouts,-0.5,iso.mk[i],strcompress(string(iso.mass[i],format='(f5.2)')$
	;	,/remove),/data
	;endfor
		
	
	
	plot,final.mh-final.mk,final.mk,psym=3, $
		yrange=[13,0],ystyle=1,xrange=[-1,5], $
		xstyle=1, xtitle='H-Ks',ytitle='Ks',charsize=2
	; Points of SW cluster
	;ind=where(final.x ge 564 and final.x le 745 and final.y ge 286 $
	;	and final.y le 449)		
	;oplot,final.mh[ind]-final.mk[ind],final.mk[ind],psym=4	
	
	; Data of NE cluster
	;ind=where(((final.x-510.0)^2 + (final.y-520.0)^2) le 15000)
	;oplot,final.mh[ind]-final.mk[ind],final.mk[ind],psym=6	
	
	oplot,iso.mh-iso.mk,iso.mk,color=red
	oplot,iso1.mh-iso1.mk,iso1.mk,color=red
	;for i=0,n_elements(iso.mass)-1,4 do begin
	;	xyouts,-0.5,iso.mk[i],strcompress(string(iso.mass[i],format='(f5.2)')$
	;	,/remove),/data
	;endfor
		
	if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
	endif
	
	resetplt,/all
	!p.multi=0

	return 
END

PRO LOADPMSISO, iso, av=av,age=age

; This function loads the PMS isochrone of DM98
	COMMON share,imgpath, mappath	
	loadconfig
  
	if N_params() lt 1 then begin
		print,'Syntax - LOADPMSISO, iso, Av=value'
		return
	endif

	age_allow=[1,2,3,5,7,10]
	inx=where(age eq age_allow)
 	
	if total(inx) eq -1 then begin
 		print,'Error - Age = 1|2|3|5|7|10'
 		return
 	endif
	
	
	
	; First, load the MS isochrone from Marigo et al. (2007)	
; 	iyr=[6.0,6.3,6.45,6.70,6.85,7.0]
; 	readcol,imgpath+'isochrone.dat',yr,m,m1,l,t,g,mb,u,b,v,r,i,j,h,k,/silent
; 	; select year=3 Myr, 20> Mass > 3.0
; 	yy=iyr[inx]
;  	ind=where(yr eq yy[0] and m le 20 and m gt 3.0)
; 
; 	iso_jh=j[ind]-h[ind]
; 	iso_j=j[ind]
; 	iso_hk=h[ind]-k[ind]
; 	iso_k=k[ind]
; 	iso_m=m[ind]
	
	file='dm98_'+strcompress(string(fix(age)),/remove)+'m.iso'
	readcol,imgpath+file,mm,l,t,/silent
	ind=where(t ge 3.43)
	mm=mm[ind]
	l=l[ind]
	t=t[ind]
	
	; Calculate the BC value based on the paper by Flower, 1996, ApJ, 469
	readcol,imgpath+'bctable_flower96.txt',bv,te,bc,/silent	
	
	n_bc=interpol(bc,te,t)
	mv=(4.74-2.5*l)-n_bc
	
	readcol,imgpath+'ci_teff_class_5.dat',s,te,vk,jh,hk, $
		format='(a,f,f,f,f,f)',/silent
	te=alog10(te)
	vj=vk-jh-hk
	
	mj=mv-interpol(vj,te,t)
	mk=mv-interpol(vk,te,t)
	
	njh=interpol(jh,te,t)
	nhk=interpol(hk,te,t)
	;oplot,njh,mj

; 	iso_jh=reform([reverse(iso_jh),reverse(njh)])
; 	iso_j=reform([reverse(iso_j),reverse(mj)])
; 	iso_k=reform([reverse(iso_k),reverse(mk)])
; 	iso_h=iso_j-iso_jh
;	iso_m=reform([reverse(iso_m),reverse(mm)])
	
	iso_jh=reform([reverse(njh)])
	iso_j=reform([reverse(mj)])
	iso_k=reform([reverse(mk)])
	
	iso_h=iso_j-iso_jh
	iso_m=reform([reverse(mm)])
	
	if keyword_set(av) then begin
		iso_j=iso_j+0.282*av
		iso_k=iso_k+0.112*av
		iso_h=iso_h+0.175*av		
	endif

	
	iso={mj:iso_j,mh:iso_h,mk:iso_k,mass:iso_m}
END

FUNCTION ABSMAG, final, dist
	amag=final
	amag.mj=final.mj-5*(alog10(dist)-1)
	amag.mh=final.mh-5*(alog10(dist)-1)
	amag.mk=final.mk-5*(alog10(dist)-1)
	return,amag
END

PRO RHO

	get_goodstar,cat
	get2mass,ref
	
END

