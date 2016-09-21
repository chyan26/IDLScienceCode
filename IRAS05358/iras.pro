PRO LOADCONFIG
	COMMON share,imgpath, mappath
	;Settings for HOME computer
	;imgpath = '/home/chyan/iras/'
	;mappath = '/home/chyan/iras/'
	
	;Settings for ASIAA computer
	imgpath='/arrays/cfht_2/chyan/WIRCam/Project/05BT06/stacked/RED_060503/'
	mappath='/asiaa/home/chyan/IRAS0535+3543/'
	
END

FUNCTION WHEREMAX, array
	s=size(array)
	maxpos=intarr(s(0))
	
	indmax=where(array eq max(array))
	indmax=indmax(0)
	if s(0) eq 1 then maxpos=indmax
	if s(0) eq 2 then begin
	maxpos(0)=indmax mod s(1)
	maxpos(1)=fix(indmax/s(1))
	endif
	
	return,maxpos
END

; This function is used to load mosiacing Ks band and H2 images from disk 
PRO LOADIMAGE, ks, h2, ks_hd, h2_hd
	COMMON share,imgpath
	
	loadconfig
	; Load images
	path=imgpath
	
	im1=readfits(path+'iras05035+3543_H2.fits',hd1)
	im2=readfits(path+'iras05035+3543_Ks.fits',hd2)
	;
	; scale image to the same dimension
	hastrom, im2,hd2,tim2,thd2,hd1
	
	;
	; Generate a header with center at 05:39:13.0 35:45:54.0
	shd=hd1
	sxaddpar,shd,'CRVAL1',84.8041667
	sxaddpar,shd,'CRVAL2',35.765
	;
	; scale image to the same dimension
	hastrom, im1,hd1,tim1,thd1,shd
	hastrom, im2,hd2,tim2,thd2,shd
	
	;
	; cut interesting area
	hextract, tim1, thd1, nim1,nhd1,2024.5,3047.5,2032.5,3055.5
	hextract, tim2, thd2, nim2,nhd2,2025.5,3048.5,2033,3056
	
	
	; Restore raw image
	h2=nim1
	ks=nim2

	ks_hd=nhd2
	h2_hd=nhd1
	return
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
	fwhm=2
	hmin=hlim
	sharplim=[0.2,1.0]
	roundlim=[-1.0,1.0]
	find,im,x1,y1,flux,sharp,round,hmin,fwhm,roundlim,sharplim,/silent
	
	; define zones that should be blocked
	ind=where((x1 ge 450 and x1 le 560 and y1 ge 450 and y1 lt 550) or $
			(x1 ge 600 and x1 le 660 and y1 ge 360 and y1 lt 450) or $
			(x1 ge 530 and x1 le 578 and y1 ge 618 and y1 lt 685) or $
			(x1 ge 530 and x1 le 533 and y1 ge 598 and y1 lt 600) or $
			(x1 ge 610 and x1 le 618 and y1 ge 590 and y1 lt 595),complement=inx)
	
	x=x1[inx]
	y=y1[inx]
	
	; Run aperture photometry
	aper,im,x,y,mag,aperr,sky,skyerr,1,3,[5,8],[0,0],/silent
	id=where((mag ne 99.99) or (mag ne !values.f_nan))
	x=x[id]
	y=y[id]
	mag=mag[id]
	mag1=mag
   
   ;th_image_cont,im,/nocont,crange=[0,50]
	;oplot,x,y,psym=4,color=255
   ;xyouts,x,y,strcompress(string(fix(id)),/remove),color=red
   
   ; Produce PSF based on selected stars
	getpsf,im,x,y,mag,sky,30.0,2.0,gauss,psf,[70,72,75,12,7,1,75,110,25,26,15],$
      6,5,imgpath+'psf.fits'
	; Group all star, the factor 9 is PSF radius+fitting radius from getpsf
   group,x,y,9,ngroup
	; Point spread function fitting
   nstar,im,intarr(n_elements(x)),x,y,mag,sky,ngroup,2.0,30.0,imgpath+'psf.fits'
   
   plot,mag-mag1,psym=1,yrange=[-1,1]
   ;oplot,mag1,psym=2
END

;
; Get 2MASS catalog from network using FITS header.
;
PRO GETCATALOG, hdr, catalog
	spawn,"rm -rf /tmp/2mass_idl.dat"
	spawn,"scat -c tmc 84.8041667 35.765 J2000 -r 160 -n 500 -d> /tmp/2mass_idl.dat"
	readcol,'/tmp/2mass_idl.dat',a,ra,dec,m1,m2,mag
	;ind=where(abs(m2-mag) le 0.9)
	
   catalog={mass,id:0,ra:0.0,dec:0.0,x:0.0,y:0.0,mj:0.0,mh:0.0,mk:0.0}
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
;
; Get 2MASS catalog from network using coordinates.
;
PRO GET2MASS, ra, dec, catalog
	spawn,"rm -rf /tmp/2mass_idl.dat"
	spawn,"scat -c tmc "+strcompress(string(ra),/remove)+" "$
		+strcompress(string(dec),/remove)+" -r 600 -n 2000 -d> /tmp/2mass_idl.dat"
	readcol,'/tmp/2mass_idl.dat',a,ra,dec,m1,m2,mag
	;ind=where(abs(m2-mag) le 0.9)
	
   catalog={std,id:0,ra:0.0,dec:0.0,mj:0.0,mh:0.0,mk:0.0}
   catalog=replicate(catalog,n_elements(ra))
   catalog.id=indgen(n_elements(ra))+1
   catalog.ra=ra
   catalog.dec=dec

   catalog.mj=m1
   catalog.mh=m2
   catalog.mk=mag
END

PRO EXAMBGSTAR, PS=ps
	common share, imgpath, mappath
	loadconfig
	
	resetplt,/all
	if keyword_set(PS) then begin 
		set_plot,'ps'
		device,filename=mappath+'iras_exambgstar.ps',$
			/color,xsize=20,ysize=28,xoffset=1.5,yoffset=0
		
		tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
		red=1
		green=2   
	endif else begin
		red=255
		green=32768    
	endelse
	
	get2mass,84.8041667,35.765,reg1
	get2mass,85.5,36.0,reg2

	h1=histogram(reg1.mk,bin=0.5,min=0,max=18)
	h2=histogram(reg2.mk,bin=0.5,min=0,max=18)
	
	x1=(findgen(n_elements(h1))+1)*0.5
	x2=(findgen(n_elements(h2))+1)*0.5
	!p.multi=[0,1,2]
	plot,x1,h1,psym=10,yrange=[1,500]
	;oplot,x2+1,h2,psym=10,color=255
	oplot,x2,shift(h2,2),psym=10,color=red
	h3=shift(h2,2)
	
	hh=h1-h3
	plot,x1,hh,psym=10,/ylog,yrange=[1,500]
	
	x=alog10(x1)
	y=alog10(hh)
	
	ind=where(alog10(hh) ge 0 and x1 le 15.5,complement=inx)
	       
	coeff=linfit(x1[ind],alog10(hh[ind]),sigma=sigma,yfit=yfit)
	oplot,x1[ind],10^yfit,color=red
	xs=findgen(200)/10
	hs=10^(coeff[1]*xs+coeff[0])
	oplot,xs,hs
	print,coeff[1],sigma[1]
	print,total(hs)/100
	
	if keyword_set(PS) then begin
		device,/close
		set_plot,'x'
	endif
	!p.multi=0
	resetplt,/all

END


PRO GENERATE_MASK, mask, im
	
	; detecting point source
	fwhm=2
	hmin=5
	sharplim=[0.2,1.0]
	roundlim=[-1.0,1.0]
	find,im,x,y,flux,sharp,round,hmin,fwhm,roundlim,sharplim,/silent
	
	; flag unwanted data points
	
	ind=where((x ge 450 and x le 560 and y ge 450 and y lt 550) or $
			(x ge 600 and x le 660 and y ge 360 and y lt 450) or $
			(x ge 530 and x le 578 and y ge 618 and y lt 685) or $
			(x ge 530 and x le 533 and y ge 598 and y lt 600) or $
			(x ge 562 and x le 573 and y ge 357 and y lt 366) or $
			(x ge 453 and x le 481 and y ge 230 and y lt 273) or $
			(x ge 352 and x le 373 and y ge 924 and y lt 959) or $			
			(x ge 558 and x le 631 and y ge 532 and y lt 604) or $			
			(x ge 697 and x le 716 and y ge 522 and y lt 531) or $			
			(x ge 551 and x le 563 and y ge 404 and y lt 424) or $			
			(x ge 610 and x le 618 and y ge 590 and y lt 595),complement=inx)
	;th_image_cont,h2-ks/13,crange=[-5,5],/nocont
	;oplot,x[inx],y[inx],psym=4,color=255
	
	
	; Building star mask
	imst=fltarr(n_elements(im[*,0]),n_elements(im[0,*]))
	mask=fltarr(n_elements(im[*,0]),n_elements(im[0,*]))
	imst[*,*]=0
	mask[*,*]=0
	
	; Building deconvole kernel
	psf=psf_gaussian(npixel=10,fwhm=3)
	
	; Deconvolution using CLEAN algorithm
	for i=0,n_elements(x[inx])-1 do begin
			clean,im,psf,fix(x[inx[i]]),fix(y[inx[i]]),5,3,imconv
			imst=imst+imconv
	endfor
	
	; imconv is the stars in image.
	imconv=convolve(imst,psf)
	ind=where(imconv gt mean(imconv)+0*stddev(imconv), complement=inx)
	mask[ind]=0
	mask[inx]=1

END

PRO OPLOTBOX,x0,x1,y0,y1,COLOR=color, LINESTYLE=linestyle, THICK=thick
	oplot,[x0,x1],[y0,y0],color=color,linestyle=linestyle,thick=thick
	oplot,[x0,x1],[y1,y1],color=color,linestyle=linestyle,thick=thick
	oplot,[x0,x0],[y0,y1],color=color,linestyle=linestyle,thick=thick
	oplot,[x1,x1],[y0,y1],color=color,linestyle=linestyle,thick=thick
	
END

PRO MAP_ALL, ks, h2, PS = ps
	common share, imgpath, mappath
	loadconfig
	
	resetplt,/all
	clearplt,/all
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'iras_all.ps',$
         /color,xsize=20,ysize=20,xoffset=1.5,yoffset=0
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
		blue=3   
   endif else begin
      red=255
      green=32768   
   endelse

	!p.title = "!6 IRAS 0535+3543"
	!x.title = "RA offset(arcmin)"  & !y.title = "Dec offset(arcmin)"
	!p.charsize = 1.3
	
	; Plot grey scale
	th_image_cont,ks,crange=[0,200],/nocont,/nobar,ct=0,/inverse
	
	
	;Plot boxes to indicate sub-regions
	;oplotbox,461,561,461,561,color=red,linestyle=0,thick=1.5
	;oplotbox,450,650,550,750,color=green,linestyle=1,thick=1.5
	;oplotbox,535,665,500,630,color=0,linestyle=2,thick=1.3
	;oplotbox,510,610,390,490,color=red,linestyle=2,thick=1.3
	;oplotbox,560,710,310,460,color=green,linestyle=0,thick=1.5
	;oplotbox,640,740,440,540,color=0,linestyle=2,thick=1.3
	;oplotbox,420,520,210,310,color=red,linestyle=2,thick=1.3
	;oplotbox,300,400,890,990,color=green,linestyle=2,thick=1.3
	;oplotbox,500,600,160,260,color=0,linestyle=2,thick=1.3
	;oplotbox,630,730,670,770,color=0,linestyle=2,thick=1.3
	
	;Plot contour
	resetplt,/x,/y
	levels=[0.5,1,2,4,6]
	tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
	th_image_cont,medsmooth(h2,5),level=levels,/cont,/noerase,c_color=1,$
		xrange=[-2.56,2.56],yrange=[-2.56,2.56]
	
	
	if keyword_set(PS) then begin
		device,/close
		set_plot,'x'
	endif
END




PRO MAP_CENTRAL, ks, h2, hdr, PS = ps
	common share, imgpath, mappath
	loadconfig
	
	resetplt,/all	
	clearplt,/all
	if keyword_set(PS) then begin
		set_plot,'ps'
		device,filename=mappath+'iras_central.ps',$
			/color,xsize=20,ysize=20,xoffset=0,yoffset=3
      		
   endif 
	
	; Extracting central area
	hextract,ks, hdr, nks, hks, 461, 561, 461, 561 
	
	!p.title = "!6 IRAS 05358+3543"
	!x.title = "!6RA offset(arcsec)"  & !y.title = "!6Dec offset(arcsec)"
	!p.charsize = 1.3
	
	th_image_cont,nks,crange=[0,300],/nocont,$	
		ct=0,/inverse,/nobar
	
   if keyword_set(PS) then begin 
		tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
		red=1
      green=2
		blue=3
   endif else begin
		red=255
      green=32768
		blue=16711680	
	endelse
	
	;Add star points as IR objects
	loadirtable,irsource
	adxy,hdr,irsource.ra,irsource.dec,xx,yy
	xx=xx-461
	yy=yy-461
	ind=where((xx ge 0 and xx le 100) and (yy ge 0 and yy le 100))
	resetplt,/x,/y
	plotsym2,3,2,/fill
	plots,xx[ind],yy[ind],psym=8,color=red,/data
   
   ; Read clump table and plot
   readcol,imgpath+'clump_central.txt',id,cx,cy,mf,fx,fy,r,flux,npix
   xyouts,cx,cy,strcompress(string(fix(id)),/remove),color=green

	
	; Over plot contours
	hextract,h2, hdr, nh2, hh2, 461, 561, 461, 561 
	levels=median(nh2)+0.15*[3,4,5,10,20,30,40]
	th_image_cont,medsmooth(nh2,5),level=levels,/cont,/noerase,$
		c_color=red,xrange=[15,-15],yrange=[-15,15]
	
	
	
	;Add filled triangle as water maser
	plotsym2,4,2,/fill
	plots,[1.7,-2.3,0.5,-0.3],[-2.3,-3,-5,-4],psym=8,color=3	
	;Add filled circle as deep embedded source
	plotsym2,0,2,/fill
	plots,[1.2],[-4.2],psym=8,color=1
   
	; Over plot CO contour
	redcont=readfits(mappath+'co-cont-red-high.fits',hd1)
	bluecont=readfits(mappath+'co-cont-blue-high.fits',hd2)
	
	hastrom,redcont,hd1,rco,rhd,hh2
	hastrom,bluecont,hd2,bco,bhd,hh2
	
	rstd=stddev(rco)
	th_image_cont,rco,/cont,/noerase,levels=rstd*[3,4,5,6],c_color=blue,$
		c_linestyle=2,c_thick=1.5
   
	rstd=stddev(bco)
	th_image_cont,bco,/cont,/noerase,levels=rstd*[3,4,5,6],c_color=blue,$
		c_linestyle=0,c_thick=1.5
	
	; Over plot 3mm contour
	cont=readfits(mappath+'cont.fits',hd3)
	
	hastrom,cont,hd3,ncnt,nchd,hh2
	
	rstd=stddev(cont)
	th_image_cont,ncnt,/cont,/noerase,levels=rstd*[3,4,5,6,7,8],c_color=green,$
		c_linestyle=0,c_thick=1.5
	
	
			
	if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif
   resetplt,/all
END

PRO MAP_REG1, ks, h2, hdr, PS = ps
	common share, imgpath, mappath
	loadconfig
	
	resetplt,/all	
	clearplt,/all
	if keyword_set(PS) then begin
		set_plot,'ps'
		device,filename=mappath+'iras_reg1.ps',$
			/color,xsize=20,ysize=20,xoffset=0,yoffset=3
	endif
	
	; Plot grey scale
	!p.title = "!6 IRAS 05358+3543 Region 1"
	!p.charsize = 1.3
	th_image_cont,ks[450:650,550:750],crange=[0,200],/nocont,/nobar,ct=0,/inverse
	
	; Plot scale 
	oplot,[20,30],[10,10],thick=2
	xyouts,30,10,'3"'
	
   if keyword_set(PS) then begin 
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
   endif else begin
      red=255
      green=32768 
   endelse
	
	;Add star points as IR objects
	loadirtable,irsource
	adxy,hdr,irsource.ra,irsource.dec,xx,yy
	xx=xx-450
	yy=yy-550
	ind=where((xx ge 0 and xx le 200) and (yy ge 0 and yy le 200))
	;resetplt,/x,/y
	plotsym2,3,2,/fill
	plots,xx[ind],yy[ind],psym=8,color=red


	levels=median(h2)+0.15*[5,10,20,30,40]
	th_image_cont,h2[450:650,550:750],level=levels,/cont,/noerase,c_color=red

   ; Read clump table and plot
   readcol,imgpath+'clump_reg1.txt',id,cx,cy,mf,fx,fy,r,flux,npix
   xyouts,cx,cy,strcompress(string(fix(id)),/remove),color=green
   
   		
	if keyword_set(PS) then begin
		device,/close
		set_plot,'x'
	endif
   resetplt,/all
END

PRO MAP_REG2, ks, h2, hdr, PS = ps
	common share, imgpath, mappath
	loadconfig
	
	resetplt,/all	
	clearplt,/all
	if keyword_set(PS) then begin
		set_plot,'ps'
		device,filename=mappath+'iras_reg2.ps',$
			/color,xsize=20,ysize=20,xoffset=0,yoffset=3
	endif
	
	; Plot grey scale
	!p.title = "!6 IRAS 05358+3543 Region 2"
	!p.charsize = 1.3
	th_image_cont,ks[535:665,500:630],crange=[0,200],/nocont,/nobar,ct=0,/inverse
	
	; Plot scale 
	oplot,[110,120],[125,125],thick=4
	xyouts,122,123,'3"'

	if keyword_set(PS) then begin
		tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
		red=1
      green=2 
	endif else begin
		red=255
      green=32768		
	endelse
	
	;Add star points as IR objects
	loadirtable,irsource
	adxy,hdr,irsource.ra,irsource.dec,xx,yy
	xx=xx-535
	yy=yy-500
	ind=where((xx ge 0 and xx le 130) and (yy ge 0 and yy le 130))
	;resetplt,/x,/y
	plotsym2,3,2,/fill
	plots,xx[ind],yy[ind],psym=8,color=red

	;levels=0.15*(indgen(10)+3)	
	levels=median(h2)+0.15*[3,4,5,10,20,30,40]
	th_image_cont,h2[535:665,500:630],level=levels,/cont,/noerase,c_color=red
   
   ; Read clump table and plot
   readcol,imgpath+'clump_reg2.txt',id,cx,cy,mf,fx,fy,r,flux,npix
   xyouts,cx,cy,strcompress(string(fix(id)),/remove),color=green
		
	if keyword_set(PS) then begin
		device,/close
		set_plot,'x'
	endif
   resetplt,/all
END

PRO MAP_REG3, ks, h2, hdr, PS = ps
	common share, imgpath, mappath
	loadconfig
	
	resetplt,/all	
	clearplt,/all
	if keyword_set(PS) then begin
		set_plot,'ps'
		device,filename=mappath+'iras_reg3.ps',$
			/color,xsize=20,ysize=20,xoffset=0,yoffset=3
	endif

	; Plot grey scale	
	!p.title = "!6 IRAS 05358+3543 Region 3"
	!p.charsize = 1.3
	th_image_cont,ks[510:610,390:490],crange=[0,200],/nocont,/nobar,ct=0,/inverse
	
	; Plot scale 
	oplot,[80,90],[95,95],thick=4
	xyouts,92,95,'3"'
	
	if keyword_set(PS) then begin
		tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
		red=1
      green=2 
	endif else begin
		red=255
      green=32768		
	endelse
	
	;Add star points as IR objects
	loadirtable,irsource
	adxy,hdr,irsource.ra,irsource.dec,xx,yy
	xx=xx-510
	yy=yy-390
	ind=where((xx ge 0 and xx le 100) and (yy ge 0 and yy le 100))
	;resetplt,/x,/y
	plotsym2,3,2,/fill
	plots,xx[ind],yy[ind],psym=8,color=red

	
	
	;levels=0.15*(indgen(10)+3)	
	levels=median(h2)+0.15*[3,4,5,10,20,30,40]
	th_image_cont,h2[510:610,390:490],level=levels,/cont,/noerase,c_color=red
		
   ; Read clump table and plot
   readcol,imgpath+'clump_reg3.txt',id,cx,cy,mf,fx,fy,r,flux,npix
   xyouts,cx,cy,strcompress(string(fix(id)),/remove),color=green
      
   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif
   resetplt,/all
END

PRO MAP_REG4, ks, h2, hdr, PS = ps
	common share, imgpath, mappath
	loadconfig
	
	resetplt,/all	
	clearplt,/all
	if keyword_set(PS) then begin
		set_plot,'ps'
		device,filename=mappath+'iras_reg4.ps',$
			/color,xsize=20,ysize=20,xoffset=0,yoffset=3
	endif
	
	; Plot grey scale
	!p.title = "!6 IRAS 05358+3543 Region 4"
	!p.charsize = 1.3	
	th_image_cont,ks[560:710,310:460],crange=[0,200],/nocont,/nobar,ct=0,/inverse
	
	; Plot scale 
	oplot,[10,20],[10,10],thick=4
	xyouts,20,10,'3"'
	
   if keyword_set(PS) then begin
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2 
   endif else begin
      red=255
      green=32768    
   endelse
	
	;Add star points as IR objects
	loadirtable,irsource
	adxy,hdr,irsource.ra,irsource.dec,xx,yy
	xx=xx-560
	yy=yy-310
	ind=where((xx ge 0 and xx le 100) and (yy ge 0 and yy le 100))
	;resetplt,/x,/y
	plotsym2,3,2,/fill
	plots,xx[ind],yy[ind],psym=8,color=red

	;levels=0.15*(indgen(15)+5)	
	levels=median(h2)+0.15*[5,10,20,30,40]
	th_image_cont,h2[560:710,310:460],level=levels,/cont,/noerase,c_color=red
	;nlevel=median(h2)-reverse(0.15*[5,10,20,30,40])
	;th_image_cont,medsmooth(h2[560:710,310:460],5),level=nlevel,/cont,/noerase,c_color=2

   ; Read clump table and plot
   readcol,imgpath+'clump_reg4.txt',id,cx,cy,mf,fx,fy,r,flux,npix
   xyouts,cx,cy,strcompress(string(fix(id)),/remove),color=green
      
   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif
   resetplt,/all
END


PRO MAP_REG5, ks, h2, hdr, PS = ps
	common share, imgpath, mappath
	loadconfig
	
	resetplt,/all	
	clearplt,/all
	if keyword_set(PS) then begin
		set_plot,'ps'
		device,filename=mappath+'iras_reg5.ps',$
			/color,xsize=20,ysize=20,xoffset=0,yoffset=3
	endif
	
	; Plot grey scale 
	!p.title = "!6 IRAS 05358+3543 Region 5"
	!p.charsize = 1.3
	th_image_cont,ks[640:740,440:540],crange=[0,200],/nocont,/nobar,ct=0,/inverse
	
   ; Plot scale 
   oplot,[10,20],[10,10],thick=4
   xyouts,22,10,'3"'
	
   if keyword_set(PS) then begin
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2 
   endif else begin
      red=255
      green=32768    
   endelse
	
	;Add star points as IR objects
	loadirtable,irsource
	adxy,hdr,irsource.ra,irsource.dec,xx,yy
	xx=xx-640
	yy=yy-440
	ind=where((xx ge 0 and xx le 100) and (yy ge 0 and yy le 100),n)
	plotsym2,3,2,/fill
	if n ne 0 then plots,xx[ind],yy[ind],psym=8,color=red

	;levels=0.15*(indgen(10)+5)	
	levels=median(h2)+0.15*[3,5,10,20,30,40]
	th_image_cont,h2[640:740,440:540],level=levels,/cont,/noerase,c_color=red
   
	; Read clump table and plot
	readcol,imgpath+'clump_reg5.txt',id,cx,cy,mf,fx,fy,r,flux,npix
	xyouts,cx,cy,strcompress(string(fix(id)),/remove),color=green
      
	if keyword_set(PS) then begin
		device,/close
		set_plot,'x'
	endif
	resetplt,/all
END


PRO MAP_REG6, ks, h2, hdr, PS = ps
	common share, imgpath, mappath
	loadconfig
	
	resetplt,/all	
	clearplt,/all
	if keyword_set(PS) then begin
		set_plot,'ps'
		device,filename=mappath+'iras_reg6.ps',$
			/color,xsize=20,ysize=20,xoffset=0,yoffset=3
	endif
	
	; Plot grey scale
	!p.title = "!6 IRAS 05358+3543 Region 6"
	!p.charsize = 1.3
	th_image_cont,ks[415:525,210:320],crange=[0,200],/nocont,/nobar,ct=0,/inverse
	
   ; Plot scale 
   oplot,[10,20],[10,10],thick=4
   xyouts,22,10,'3"'
   
   if keyword_set(PS) then begin
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2 
   endif else begin
      red=255
      green=32768    
   endelse
	
	;Add star points as IR objects
	loadirtable,irsource
	adxy,hdr,irsource.ra,irsource.dec,xx,yy
	xx=xx-415
	yy=yy-210
	ind=where((xx ge 0 and xx le 100) and (yy ge 0 and yy le 100),n)
	plotsym2,3,2,/fill
	if n ne 0 then plots,xx[ind],yy[ind],psym=8,color=red

	;levels=0.15*(indgen(10)*3+5)	
	levels=median(h2)+0.15*[3,5,10,20,30,40]
	th_image_cont,h2[415:525,210:320],level=levels,/cont,/noerase,c_color=red
		
	; Read clump table and plot
	readcol,imgpath+'clump_reg6.txt',id,cx,cy,mf,fx,fy,r,flux,npix
	xyouts,cx,cy,strcompress(string(fix(id)),/remove),color=green
      
	if keyword_set(PS) then begin
		device,/close
		set_plot,'x'
	endif
	resetplt,/all
END

PRO MAP_REG7, ks, h2, hdr, PS = ps
	common share, imgpath, mappath
	loadconfig
	
	resetplt,/all	
	clearplt,/all
	
	if keyword_set(PS) then begin
		set_plot,'ps'
		device,filename=mappath+'iras_reg7.ps',$
			/color,xsize=20,ysize=20,xoffset=0,yoffset=3
	endif
	
	; Plot grey scale	
	!p.title = "!6 IRAS 05358+3543 Region 7"
	!p.charsize = 1.3
	th_image_cont,ks[300:400,890:990],crange=[0,200],/nocont,/nobar,ct=0,/inverse
	
   ; Plot scale 
   oplot,[10,20],[10,10],thick=4
   xyouts,22,10,'3"'
   
   if keyword_set(PS) then begin
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2 
   endif else begin
      red=255
      green=32768    
   endelse
	
	;Add star points as IR objects
	loadirtable,irsource
	adxy,hdr,irsource.ra,irsource.dec,xx,yy
	xx=xx-300
	yy=yy-890
	ind=where((xx ge 0 and xx le 100) and (yy ge 0 and yy le 100),n)
	plotsym2,3,2,/fill
	if n ne 0 then plots,xx[ind],yy[ind],psym=8,color=red

	;levels=0.15*(indgen(10)*3+5)	
	levels=median(h2)+0.15*[5,10,25,30,40]
	th_image_cont,h2[300:400,890:990],level=levels,/cont,/noerase,c_color=red
		
	; Read clump table and plot
	readcol,imgpath+'clump_reg7.txt',id,cx,cy,mf,fx,fy,r,flux,npix
	xyouts,cx,cy,strcompress(string(fix(id)),/remove),color=green
      
	if keyword_set(PS) then begin
		device,/close
		set_plot,'x'
	endif
	resetplt,/all
END

PRO MAP_REG8, ks, h2, hdr, PS = ps
   common share, imgpath, mappath
   loadconfig
   
   resetplt,/all  
   clearplt,/all
   
   if keyword_set(PS) then begin
      set_plot,'ps'
      device,filename=mappath+'iras_reg8.ps',$
         /color,xsize=20,ysize=20,xoffset=0,yoffset=3
   endif
   
   ; Plot grey scale 
   !p.title = "!6 IRAS 05358+3543 Region 8"
   !p.charsize = 1.3
   th_image_cont,ks[500:600,160:260],crange=[0,200],/nocont,/nobar,ct=0,/inverse
   
   
   ; Plot scale 
   oplot,[10,20],[10,10],thick=4
   xyouts,22,10,'3"'
   
   if keyword_set(PS) then begin
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2 
   endif else begin
      red=255
      green=32768    
   endelse
   
   ;Add star points as IR objects
   loadirtable,irsource
   adxy,hdr,irsource.ra,irsource.dec,xx,yy
   xx=xx-500
   yy=yy-160
   ind=where((xx ge 0 and xx le 100) and (yy ge 0 and yy le 100),n)
   plotsym2,3,2,/fill
   if n ne 0 then plots,xx[ind],yy[ind],psym=8,color=red

   ;levels=0.15*(indgen(10)*3+5) 
   levels=median(h2)+0.15*[2.5,3,5,10]
   th_image_cont,h2[500:600,160:260],level=levels,/cont,/noerase,c_color=red
      
   ; Read clump table and plot
   readcol,imgpath+'clump_reg8.txt',id,cx,cy,mf,fx,fy,r,flux,npix
   xyouts,cx,cy,strcompress(string(fix(id)),/remove),color=green
      
   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif
   resetplt,/all
END


PRO MAP_REG9, ks, h2, hdr, PS = ps
   common share, imgpath, mappath
   loadconfig
   
   resetplt,/all  
   clearplt,/all
   
   if keyword_set(PS) then begin
      set_plot,'ps'
      device,filename=mappath+'iras_reg9.ps',$
         /color,xsize=20,ysize=20,xoffset=0,yoffset=3
   endif
   
   ; Plot grey scale 
   !p.title = "!6 IRAS 05358+3543 Region 9"
   !p.charsize = 1.3
   th_image_cont,ks[630:730,670:770],crange=[0,200],/nocont,/nobar,ct=0,/inverse
   
   ; Plot scale 
   oplot,[10,20],[10,10],thick=4
   xyouts,22,10,'3"'
   
   if keyword_set(PS) then begin
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2 
   endif else begin
      red=255
      green=32768    
   endelse
   
   ;Add star points as IR objects
   loadirtable,irsource
   adxy,hdr,irsource.ra,irsource.dec,xx,yy
   xx=xx-630
   yy=yy-670
   ind=where((xx ge 0 and xx le 100) and (yy ge 0 and yy le 100),n)
   plotsym2,3,2,/fill
   if n ne 0 then plots,xx[ind],yy[ind],psym=8,color=red

   ;levels=0.15*(indgen(10)*3+5) 
   levels=median(h2)+0.15*[3.5,5,10,15,20,25]
   th_image_cont,h2[630:730,670:770],level=levels,/cont,/noerase,c_color=red
      
   ; Read clump table and plot
   readcol,imgpath+'clump_reg9.txt',id,cx,cy,mf,fx,fy,r,flux,npix
   xyouts,cx,cy,strcompress(string(fix(id)),/remove),color=green
      
   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif
   resetplt,/all
END


PRO GETCOORD,im,CRANGE=crange
	resetplt,/all
	th_image_cont,im,/nocont,crange=crange,/nobar,/aspect
	cursor,x,y
	print,x,y

END

; This routine is use to select area to estimate RMS of a image.
PRO GETSTATS,im,CRANGE=crange
	resetplt,/all
	th_image_cont,im,/nocont,crange=crange,/nobar,/aspect
	print,'select lower-left corner..'
	cursor,x1,y1,/down
 	print,'select upper-right corner..'
	cursor,x2,y2,/down
	
	print,mean(im[x1:x2,y1:y2]),median(im[x1:x2,y1:y2]),stddev(im[x1:x2,y1:y2])

END

PRO LOADIRTABLE, ir_source
	COMMON share,imgpath
	loadconfig
	
	readcol,imgpath+'table1.dat',name,oid,note,rah,ram,ras,decd,decm,decs,mj,$
		emj,mh,emh,mk,emk,$
		format='(A,A,A,I2,I2,F4.1,I2,I2,F4.1,F5.2,F4.2,F5.2,F4.2,F5.2,F4.2)'

			
	ra_1950=fltarr(n_elements(oid))
	de_1950=fltarr(n_elements(oid))
	id=fltarr(n_elements(oid))
	
	for i=0,n_elements(ra_1950)-1 do begin
		id[i]=i
		ra_1950[i]=15.0*(ten(rah[i],ram[i],ras[i]))
		de_1950[i]=ten(decd[i],decm[i],decs[i])
	endfor
	
	; Transform from B1950 to J2000
	jprecess, ra_1950, de_1950, ra_2000, dec_2000
	ra=ra_2000
	dec=dec_2000
	
	ir_source={star,id:fix(id+1),ra:ra,dec:dec,mj:mj,mh:mh,mk:mk}
	 	
END


PRO LOADCLUMPTABLE, file, cata
   
	readcol,file,id,x,y,mflux,xfwhm,yfwhm,r,flux,npix
	cata={clump,id:0,x:0.0,y:0.0,mflux:0.0,xfwhm:0.0,$
			yfwhm:0.0, r:0.0, flux:0.0, npix:0.0}
	cata=replicate(cata,n_elements(id))
	cata.id=id
	cata.x=x
	cata.y=y
	cata.mflux=mflux
	cata.xfwhm=xfwhm
	cata.yfwhm=yfwhm
	cata.r=r
	cata.flux=flux
	cata.npix=npix

END


; This routine load isochrones from disk
PRO LOADISO, file, iso
   readcol,file,n,mint,mact,logt,logg,logl,mv,ub,bv,vr,vi,vk,ri,ik,jh,hk,kl,$
      jk,jl,jl2,km
   iso={iso,n:0,mint:0.0,mact:0.0,logt:0.0,logg:0.0,logl:0.0,mk:0.0} 
   iso=replicate(iso,n_elements(n))
   iso.n=n
   iso.mint=mint
   iso.mact=mact
   iso.logt=logt
   iso.logg=logg
   iso.logl=logl
   iso.mk=mv-vk
END



; This routine is a script for anaylysis the DUST (Ks-H2) image
;  This program loads the IR sources from Porras(2000) and compare
;  the fluxes.
PRO ANALYSIS_DUST, hdr, image, PS=ps
	COMMON share,imgpath,mappath
	loadconfig
	
	if keyword_set(PS) then begin 
		set_plot,'ps'
		device,filename=mappath+'iras_irsource.ps',$
			/color,xsize=20,ysize=20,xoffset=0,yoffset=3
		
		tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
		red=1 
	endif else begin
		red=255		
	endelse
		
	resetplt,/all
	
	; Load IR source list from Porras(2002)
	loadirtable,irsource
	; Transform to x,y 
	adxy, hdr, irsource.ra,irsource.dec,x,y
	
	th_image_cont,image,/nocont,crange=[0,50],/nobar,/aspect,/inverse
	oplot,x,y,psym=4,color=red
	xyouts,x+1,y+1,strcompress(string(fix(irsource.id)),/remove),color=red,charsize=1
	
	; Run aperture photometry
	aper,image,x,y,mag,aperr,sky,skyerr,1,4,[6,8],[0,0],/silent
	ind=where(mag lt 99.999)
	
	if keyword_set(PS) then begin
	endif else begin
		window,1
		wset,1
	endelse
	plot,irsource.mk[ind],mag[ind],psym=4,$
		yrange=[min(mag[ind]),max(mag[ind])],$
		xrange=[min(irsource.mk[ind]),max(irsource.mk[ind])],$
		xtitle="K' magnitude (Porras 2000)",$
		ytitle="Instrumental magnitude"
	
	xyouts,irsource.mk[ind],mag[ind],strcompress(string(fix(irsource.id[ind])),/remove),$
		color=red,charsize=1

	if keyword_set(PS) then begin
		device,/close
		set_plot,'x'
	endif else begin
		wset,0
	endelse
	
	
END

; This routine will load the images from disk and produce a 
;  dust image of central region.  The cataloging process is
;  separated into stars and central clusters.  Fluxes of stars
;  are found using IDL/DAOPHOT.  Fluxes of dust clumps are
;  found using clump finder 2D version.
PRO GETSTAR_NE, ks, h2, hd1, PS=ps
	common share, imgpath, mappath
	loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'iras_necluster.ps',$
         /color,xsize=15,ysize=28,xoffset=1.5,yoffset=0
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2   
   endif else begin
      red=255
      green=32768    
   endelse
	
	; Load image
	;loadimage,ks,h2,hd1,hd2
	
	; Set image plotting panel
	!p.multi=[0,1,2]
	
	; Produce dust image
	dust=ks-h2
	
	; cut NE cluster
	hextract, dust, hd1, d, nhd, 421,601,421,601
	
		
	; Find point source and do aperture photometry
	fwhm=2
	hmin=40
	sharplim=[0.2,1.0]
	roundlim=[-1.0,1.0]
	find,d,x,y,flux,sharp,round,hmin,fwhm,roundlim,sharplim,/silent
	ind = where((x ge 71 and x le 136 and y ge 79 and y le 105) or $
		(y lt 20),complement=inx)
	
	; Measure magnitude in different radius
	aper,d,x[inx],y[inx],mag1,aperr,sky,skyerr,1,3,[5,8],[0,0],/silent
	aper,d,x[inx],y[inx],mag2,aperr,sky,skyerr,1,4,[6,9],[0,0],/silent
	aper,d,x[inx],y[inx],mag3,aperr,sky,skyerr,1,5,[7,10],[0,0],/silent
	aper,d,x[inx],y[inx],mag4,aperr,sky,skyerr,1,6,[8,11],[0,0],/silent
	
	mag=fltarr(n_elements(mag1))
	magdev=fltarr(n_elements(mag1))
	for i=0,n_elements(mag1)-1 do mag[i]=mean([mag1[i],mag2[i],mag3[i],mag4[i]])
	for i=0,n_elements(mag1)-1 do	$
		magdev[i]=stddev([mag1[i],mag2[i],mag3[i],mag4[i]])

	; Transform instrumental magnitude to K magnitude
	mk=(0.9767*mag-1.164)
	
	; Transform to absolute magnitude
	dist=1800  ; unit is pc
	ak=1.22 ; transform from av=15.06
	mak=mk-5*(alog10(dist)-1)-ak

	; Plot background grey scale image
	resetplt,/all
	!p.title = "!6 IRAS 0535+3543"
	!x.title = "RA offset(arcsec)"  & !y.title = "Dec offset(arcsec)"
	
	th_image_cont,d,crange=[0,80],/nocont,/nobar,/inverse
	oplot,x[inx],y[inx],psym=4,color=red
	
	; Load IR source list from Porras(2002)
	loadirtable,ir
	; Transform to x,y 
	adxy, nhd, ir.ra,ir.dec,irx,iry
	; Transform K band magnitude to Abs. magnitude
	irmk=ir.mk-5*(alog10(dist)-1)-ak
	
	; Mark on the plot
	index=where(irx ge 0 and irx le 180 and iry ge 20 and iry le 180)
	xyouts,irx[index]+1,iry[index]+1,strcompress(string(fix(ir.id[index])),/remove),color=green
	
	
	; Save image in disk
	writefits,imgpath+'iras05358+3543_NE.fits',d,nhd
	
	; find clumps using clfind2d
	;.run clfind2d clstats2d clplot2d
	;clfind2d, file=imgpath+'iras05358+3543_NE',levels=[20,30,55,140,200]
	;clstats2d, file=imgpath+'iras05358+3543_NE'

	; Inport clump tables
	loadclumptable,imgpath+'clump_ne.txt',clump
	cind=[3,7,10,11,13,15,18,19,23] ; select clumps
	oplot,clump[cind-1].x,clump[cind-1].y,psym=2,color=red   
	resetplt,/all
	; Transform clump flux to magintude
	cmag=0.9767*(25-2.5*alog10(clump[cind-1].flux))-1.164
	cmak=cmag-5*(alog10(dist)-1)-ak
  
  ; Preparing catalog for printing
   xyad,nhd,x,y,a,d
   xyad,nhd,clump.x,clump.y,cra,cdec
   nid=indgen(n_elements(inx))+1
   cid=n_elements(inx)+indgen(n_elements(cind))+1
	
	
   print,'The mean value of Mk ',mean([mak,cmak])
   print,'The median value of Mk ',median([mak,cmak])
      	
	; Put my own ID number to the map
	sid=[nid,cid]
	sx=[x[inx],clump[cind-1].x]
	sy=[y[inx],clump[cind-1].y]
	xyouts,sx+1,sy-5,strcompress(string(fix(sid)),/remove),color=red
	
	; HISTOGRAM of point sources
	hist1=histogram(mak,min=-6.0,max=fix(max(mak))+1,bin=0.5)
	xh=(findgen(n_elements(hist1))-12.0)*0.5
	; HISTOGRAM of clumps
   hist2=histogram(cmak,min=-6.0,max=fix(max(mak))+1,bin=0.5)
	; HISTOGRAM of IR source (K band)
	hist3=histogram(irmk[index],min=0,max=fix(max(mak))+1,bin=0.5)
	
   plot,xh,hist1+hist2,psym=10,yrange=[0,10],line=2,$
      ytitle='!6N', xtitle='!6Absolute magnitude (Ks)'
	oplot,xh,hist1,psym=10,line=3,color=red
   
   yfit=gaussfit(xh,hist1+hist2,sigma=sigma)
   oplot,xh,yfit
	;print,'gaussian',gcoeff 
   ;------------------------------------------------------------
   ; Transform KLF to mass
   
   ; Reading isochrones  
   loadiso,mappath+'Isochrones/iso_e040_0530.UBVRIJHKLM',iso1
   
   ; Transform KL to stellar mass.  There are two methods.
   ; 1. Transform the x-axis of KLF from L to M
   ; 2. Transform Mk of all star to mass than do histogram
   mass=interpol(iso1.mint,iso1.mk,mak)   
   cmass=interpol(iso1.mint,iso1.mk,cmak)
   mxh=interpol(iso1.mint,iso1.mk,xh)
   
   ; Plot a KLF first   
   plot,xh,hist1+hist2,psym=10,line=2,$
      ytitle='!6N', xtitle='!6Absolute magnitude (Ks)',$
	  /ylog,yrange=[0.5,20],ystyle=1,xrange=[min(xh),max(xh)] 
   oplot,xh,hist1+hist2,psym=5
   hist=hist1+hist2
   err=alog10([hist])
   err[where(hist eq 1)]=1.0
   errplot,xh,hist-err,hist+err
   
  
   ;
   ; Fit for alpha value 
   ind=where(alog10(hist) ge 0 and xh le 2.0 and xh ge -2.0)
   coeff=linfit(xh[ind],alog10(hist[ind]),yfit=yfit,sigma=sigma)
   oplot,xh[ind],10^yfit
   print,"Coeffecient = ",coeff
   print,"Sigma = ",sigma
   
   ; Plot using 1st method
   ;plot,mxh,hist1+hist2,psym=5,line=2,$
   ;   ytitle='!6N', xtitle='!6Mass (Ks)',/ylog,$
   ;   yrange=[0.5,20],ystyle=1,xrange=[max(mxh),min(mxh)],xstyle=1;,/xlog
   
      
   m=[mass,cmass]

   mhist=histogram(m,min=0,max=fix(max(m))+1,bin=0.25)
   xmh=(findgen(n_elements(mhist))+0.5)*0.25
   plot,xmh,mhist,psym=10,$
      /xlog,xrange=[100,0.2],xstyle=1,$
      yrange=[0.5,20],ystyle=1,/ylog
   oplot,xmh,mhist,psym=5
   err=alog10([mhist])
   err[where(mhist eq 1)]=1.0
   errplot,xmh,mhist-err,mhist+err
   
   ; Fitting
   yy=alog10(mhist)
   yy[where(mhist eq 1)]=0.0
   ind=where(yy ne -!VALUES.F_INFINITY and xmh ge 1.0 and xmh le 10.0)
   
   coeff=linfit(alog10(xmh[ind]),yy[ind],yfit=yfit,sigma=sigma)
   
   oplot,xmh[ind],10^yfit
   print,"Coeffecient = ",coeff
   print,"Sigma = ",sigma

   print,"Total Mass = ",total(m)
   ; End of mass transformation 
   ;------------------------------------------------------------
   
          
   for i=0,n_elements(inx)-1 do print,format='(i3,2x,f9.5,2x,f9.5,2x,f6.3,2x,f6.3,2x,f7.3)',$
      nid[i],a[inx[i]],d[inx[i]],mk[i],mak[i],mass[i]
   for i=0,n_elements(cind)-1 do print,format='(i3,2x,f9.5,2x,f9.5,2x,f6.3,2x,f6.3,2x,f7.3)',$
      cid[i],cra[cind[i]-1],cdec[cind[i]-1],cmag[i],cmak[i],cmass[i]
   
   print,median([mak,cmak])      
   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif
   resetplt,/all
	!p.multi=0
END

; This routine will load the images from disk and produce a 
;  dust image of SW cluster.  The cataloging process is
;  separated into stars and clumps.  Fluxes of stars
;  are found using IDL/DAOPHOT.  Fluxes of dust clumps are
;  found using clump finder 2D version.
PRO GETSTAR_SW, ks, h2, hd1, PS=ps
	common share, imgpath, mappath
	loadconfig
	
	if keyword_set(PS) then begin 
		set_plot,'ps'
		device,filename=mappath+'iras_swcluster.ps',$
			/color,xsize=15,ysize=28,xoffset=1.5,yoffset=0
		
		tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
		red=1
		green=2   
	endif else begin
		red=255
		green=32768    
	endelse
	; Set image plotting panel
	!p.multi=[0,1,2]
	
	; Produce dust image
	dust=ks-h2
	
	; cut NE cluster
	hextract, dust, hd1, d, nhd,535,729,293,487
	
	; Find point source and do aperture photometry
	fwhm=2
	hmin=54
	sharplim=[0.2,1.0]
	roundlim=[-1.0,1.0]
	find,d,x,y,flux,sharp,round,hmin,fwhm,roundlim,sharplim,/silent
	ind = where((x ge 75 and x le 111 and y ge 76 and y le 108) or $
		(x le 30 and y ge 150),complement=inx)
	
	; Measure magnitude in different radius
	aper,d,x[inx],y[inx],mag1,aperr,sky,skyerr,1,3,[5,8],[0,0],/silent
	aper,d,x[inx],y[inx],mag2,aperr,sky,skyerr,1,4,[6,9],[0,0],/silent
	aper,d,x[inx],y[inx],mag3,aperr,sky,skyerr,1,5,[7,10],[0,0],/silent
	aper,d,x[inx],y[inx],mag4,aperr,sky,skyerr,1,6,[8,11],[0,0],/silent
	
	mag=fltarr(n_elements(mag1))
	magdev=fltarr(n_elements(mag1))
	for i=0,n_elements(mag1)-1 do mag[i]=median([mag1[i],mag2[i],mag3[i],mag4[i]])
	for i=0,n_elements(mag1)-1 do $
		magdev[i]=stddev([mag1[i],mag2[i],mag3[i],mag4[i]])
	
	; Transform instrumental magnitude to K magnitude
	mk=(0.9767*mag-1.164)
	
	; Transform to absolute magnitude
	dist=1800  ; unit is pc
	ak=0.683 ; transform from av=8.44
	mak=mk-5*(alog10(dist)-1)-ak
	
	; Plot background grey scale image
	resetplt,/all
	!p.title = "!6 IRAS 0535+3543"
	!x.title = "RA offset(arcsec)"  & !y.title = "Dec offset(arcsec)"
	
	th_image_cont,d,crange=[0,80],/nocont,/nobar,/inverse
	oplot,x[inx],y[inx],psym=4,color=red
	
	
	; Load IR source list from Porras(2002)
	loadirtable,ir
	; Transform to x,y 
	adxy, nhd, ir.ra,ir.dec,irx,iry
	; Transform K band magnitude to Abs. magnitude
	irmk=ir.mk-5*(alog10(dist)-1)-ak
	index=where(irx ge 0 and irx le 195 and iry ge 0 and iry le 150)
	xyouts,irx[index],iry[index],strcompress(string(fix(ir.id[index])),/remove),color=green
	
	; Save image in disk
	writefits,imgpath+'iras05358+3543_SW.fits',d,nhd
	
	; find clumps using clfind2d
	;.run clfind2d clstats2d clplot2d
	;clfind2d, file=imgpath+'iras05358+3543_SW',levels=[70,100,140,200]
	;clplot2d, file=imgpath+'iras05358+3543_SW'
	;clstats2d, file=imgpath+'iras05358+3543_SW'
	
	; Inport clump tables
	loadclumptable,imgpath+'clump_sw.txt',clump
	cind=[3,6] ; select clumps
	oplot,clump[cind-1].x,clump[cind-1].y,psym=2,color=red   
	
	; Transform clump flux to magintude
	cmag=0.9767*(25-2.5*alog10(clump[cind-1].flux))-1.164
	cmak=cmag-5*(alog10(dist)-1)-ak
	
	
	; Print catalog
	xyad,nhd,x,y,a,d
	xyad,nhd,clump.x,clump.y,cra,cdec
	nid=indgen(n_elements(inx))+1
	cid=n_elements(inx)+indgen(n_elements(cind))+1
	
	print,'The mean value of Mk ',mean([mak,cmak])
	print,'The median value of Mk ',median([mak,cmak])
		
	; Put my own ID number to the map
	sid=[nid,cid]
	sx=[x[inx],clump[cind-1].x]
	sy=[y[inx],clump[cind-1].y]
	xyouts,sx+1,sy-5,strcompress(string(fix(sid)),/remove),color=red
	
	
	; HISTOGRAM of point sources
	hist1=histogram(mak,min=-4.0,max=fix(max(mak))+1,bin=0.5)
	xh=(findgen(n_elements(hist1))-8.0)*0.5
	; HISTOGRAM of clumps
	hist2=histogram(cmak,min=-4.0,max=fix(max(mak))+1,bin=0.5)
	; HISTOGRAM of IR source (K band)
	hist3=histogram(irmk[index],min=0,max=fix(max(mak))+1,bin=0.5)
	
	plot,xh,hist1+hist2,psym=10,yrange=[0,10],line=2,$
		ytitle='!6N', xtitle='!6Absolute magnitude (Ks)'
	oplot,xh,hist1,psym=10,line=3,color=red
	yfit=gaussfit(xh,hist1+hist2,sigma=sigma)
	oplot,xh,yfit
	
	;------------------------------------------------------------
	; Transform KLF to mass
	
	; Reading isochrones  
	loadiso,mappath+'Isochrones/iso_e040_0590.UBVRIJHKLM',iso1
	
	mass=interpol(iso1.mint,iso1.mk,mak)  
	cmass=interpol(iso1.mint,iso1.mk,cmak)
	
	
	; Plot a KLF first   
	plot,xh,hist1+hist2,psym=10,line=2,$
		ytitle='!6N', xtitle='!6Absolute magnitude (Ks)',$
		/ylog,yrange=[0.5,20],ystyle=1,xrange=[min(xh),max(xh)] 
	oplot,xh,hist1+hist2,psym=5
	hist=hist1+hist2
	err=alog10([hist])
	err[where(hist eq 1)]=1.0
	errplot,xh,hist-err,hist+err
	
	
	;
	; Fit for alpha value 
	ind=where(alog10(hist) ge 0 and xh le 2.5 and xh ge -1.0)
	coeff=linfit(xh[ind],alog10(hist[ind]),yfit=yfit,sigma=sigma,measure_errors=1/err[ind])
	oplot,xh[ind],10^yfit
	print,"Coeffecient = ",coeff
	print,"Sigma = ",sigma
	
	; Plot using 1st method
	;plot,mxh,hist1+hist2,psym=5,line=2,$
	;   ytitle='!6N', xtitle='!6Mass (Ks)',/ylog,$
	;   yrange=[0.5,20],ystyle=1,xrange=[max(mxh),min(mxh)],xstyle=1;,/xlog
	
		
	m=[mass,cmass]
	mhist=histogram(m,min=0,max=fix(max(m))+1,bin=0.25)
	xmh=(findgen(n_elements(mhist))+0.5)*0.25
	plot,xmh,mhist,psym=10,$
		/xlog,xrange=[12,0.2],xstyle=1,$
		yrange=[0.5,20],ystyle=1,/ylog
	oplot,xmh,mhist,psym=5
	err=alog10([mhist])
	err[where(mhist eq 1)]=1.0
	errplot,xmh,mhist-err,mhist+err
	
	; Fitting
	yy=alog10(mhist)
	yy[where(mhist eq 1)]=0.0
	ind=where(yy ne -!VALUES.F_INFINITY and xmh ge 1.0 and xmh le 3.0)
	
	coeff=linfit(alog10(xmh[ind]),yy[ind],yfit=yfit,sigma=sigma)
	
	oplot,xmh[ind],10^yfit
	print,"Coeffecient = ",coeff
	print,"Sigma = ",sigma
	
	print,"Total Mass = ",total(m)
	
	; End of mass transformation 
	;------------------------------------------------------------
	
	
	for i=0,n_elements(inx)-1 do print,format='(i3,2x,f9.5,2x,f9.5,2x,f6.3,2x,f6.3,2x,f7.3,2x,i1)',$
		nid[i],a[inx[i]],d[inx[i]],mk[i],mak[i],mass[i],2
	for i=0,n_elements(cind)-1 do print,format='(i3,2x,f9.5,2x,f9.5,2x,f6.3,2x,f6.3,2x,f7.3,2x,i1)',$
		cid[i],cra[cind[i]-1],cdec[cind[i]-1],cmag[i],cmak[i],cmass[i],2
	
	
	if keyword_set(PS) then begin
		device,/close
		set_plot,'x'
	endif
	
	resetplt,/all
	!p.multi=0
	
END

; This routine will load the images from disk and produce a 
;  dust image of filed stars.  
PRO GETSTAR_FS, ks, h2, hd1, PS=ps, CAT=cat
	common share, imgpath, mappath
	loadconfig
	
	if keyword_set(PS) then begin 
		set_plot,'ps'
		device,filename=mappath+'iras_fieldstar.ps',$
			/color,xsize=15,ysize=28,xoffset=1.5,yoffset=0
		
		tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
		red=1 
	endif else begin
		red=255     
	endelse
	; Set image plotting panel
	!p.multi=[0,1,2]
	
	; Produce dust image
	dust=ks-h2
	
	th_image_cont,dust,crange=[0,50],/nocont,/nobar,/inverse
	
	; Find point source and do aperture photometry
	fwhm=2
	;hmin=50
	hmin=15
	sharplim=[0.2,1.0]
	roundlim=[-1.0,1.0]
	find,dust,x,y,flux,sharp,round,hmin,fwhm,roundlim,sharplim,/silent
	ind=where((x ge 535 and x le 729 and y ge 293 and y le 487) or $
		(x ge 421 and x le 601 and y ge 421and y le 601),complement=inx)
	
	xx=x[inx]
	yy=y[inx]
	oplot,xx,yy,psym=4,color=red
	xyouts,xx+5,yy,strcompress(string(indgen(n_elements(xx))),/remove),$
		color=red,charsize=0.5
	
	; Measure magnitude in different radius
	aper,dust,xx,yy,mag,aperr,sky,skyerr,1,3,[5,8],[0,0],/silent
	;aper,dust,x[inx],y[inx],mag2,aperr,sky,skyerr,1,4,[6,9],[0,0],/silent
	;aper,dust,x[inx],y[inx],mag3,aperr,sky,skyerr,1,5,[7,10],[0,0],/silent
	;aper,dust,x[inx],y[inx],mag4,aperr,sky,skyerr,1,6,[8,11],[0,0],/silent
	
	getpsf,dust,xx,yy,mag,sky,30.0,2.0,gauss,psf,[112,95,105,81,44,21],$
		6,5,imgpath+'psf_fs.fits'
	; Group all star, the factor 9 is PSF radius+fitting radius from getpsf
	group,xx,yy,9,ngroup
	; Point spread function fitting
	nstar,dust,indgen(n_elements(xx)),xx,yy,mag,sky,ngroup,2.0,30.0,imgpath+'psf_fs.fits',/silent
	
	
	
	; Transform instrumental magnitude to K magnitude
	mk=(0.9767*mag-1.164)
	
	; Analysis apperent K magnitude and try to do correction
	hk=histogram(mk,min=0,bin=0.5)
	xs=(findgen(n_elements(hk))+1)*0.5
	plot,xs,hk,psym=10,/ylog,yrange=[1,100],xrange=[9,20]
	ind=where(xs ge 10 and xs lt 19 and hk ne 0)
	coeff=linfit(xs[ind],alog10(hk[ind]),sigma=sigma,yfit=yfit)
	;print,coeff[1],sigma[1]
	
	oplot,xs[ind],10^yfit
	oplot,xs,10^(0.248*xs-1.785)/10,line=1;-1.785
	
	h_ori=10^(coeff[1]*xs+coeff[0])
	h_mem=10^(0.248*xs-1.785)/10
	factor=h_mem/h_ori
	nhk=round(hk*factor)
	oplot,xs,nhk,psym=10,color=red
	print,nhk
	
	; Based on the corrected histogram, reselect stars to satisfy 
	;  new condition
	n=0
	for i=0,n_elements(xs)-1 do begin
		if nhk[i] gt 0 then begin
			cand=where(mk ge xs[i]-0.5 and mk le xs[i],count)
			if n eq 0 and count gt 0 then begin 
				nmk = mk[cand[0:nhk[i]-1]]
				nxx = xx[cand[0:nhk[i]-1]]
				nyy = yy[cand[0:nhk[i]-1]]
				n=n+1 
			endif else begin
				if count gt 0 then begin
					nmk=[nmk,mk[cand[0:nhk[i]-1]]]
					nxx=[nxx,xx[cand[0:nhk[i]-1]]]
					nyy=[nxx,yy[cand[0:nhk[i]-1]]]
				endif
			endelse
		endif
	endfor

	mk=nmk
	xx=nxx
	yy=nyy
	;oplot,xs,kk,psym=10,line=3
	
		
	; Transform to absolute magnitude
	dist=1800.0  ; unit is pc
	ak=0.395     ; transform from av=8.44
	mak=mk-5*(alog10(dist)-1)-ak
	
	;
	h=histogram(mak,min=-2,max=7,bin=0.5)
	xh=((findgen(n_elements(h))-4)+0.5)*0.5
	;oplot,[xh(where(h eq max(h))+1),xh(where(h eq max(h))+1)],[0,100]
	
	plot,xh,h,psym=10,yrange=[0,60],xrange=[-1,10],xstyle=1,$
		ytitle='!6N', xtitle='!6Absolute magnitude (Ks)'
	
	;yfit=gaussfit(xh,h,sigma=sigma)
	;oplot,xh,yfit

	; Print catalog
	xyad,hd1,xx,yy,a,d
	nid=indgen(n_elements(xx))+1
	;for i=0,n_elements(xx)-1 do print,format='(i3,2x,f9.5,2x,f9.5,2x,f6.3,2x,f6.3)',$
	;	nid[i],a[i],d[i],mk[i],mak[i]
	
	print,'The mean value of Mk ',mean([mak])
	print,'The median value of Mk ',median([mak])
	;------------------------------------------------------------
	; Transform KLF to mass
	
	; Reading isochrones  
	loadiso,mappath+'Isochrones/iso_e040_0659.UBVRIJHKLM',iso1
	
	
	; Transform KL to stellar mass.  There are two methods.
	; 1. Transform the x-axis of KLF from L to M
	; 2. Transform Mk of all star to mass than do histogram
	mass=interpol(iso1.mint,iso1.mk,mak)   
	mxh=interpol(iso1.mint,iso1.mk,xh)
	
	; Plot a KLF first   
	plot,xh,h,psym=10,$
		ytitle='!6N', xtitle='!6Absolute magnitude (Ks)',$
		/ylog,yrange=[0.5,200],ystyle=1,xrange=[min(xh),max(xh)] 
	err=alog10([h])
	err[where(h eq 0)]=0
	errplot,xh,h-err,h+err
	
	; Fitting alpha value
	ind=where(alog10(h) ge 0 and xh le 6.5 and xh ge -2.0)
	coeff=linfit(xh[ind],alog10(h[ind]),yfit=yfit,sigma=sigma)
	oplot,xh[ind],10^yfit
	print,"Coeffecient = ",coeff
	print,"Sigma = ",sigma
		
	; Transform to mass using second method   
	m=[mass]
	mhist=histogram(m,min=0,max=fix(max(m))+1,bin=0.35)
	xmh=(findgen(n_elements(mhist))+0.5)*0.35
	plot,xmh,mhist,psym=10,yrange=[0.5,200],ystyle=1,/ylog,$
		xrange=[10,0.2],/xlog
	err=alog10([mhist])
	err[where(mhist eq 1)]=1.0
	errplot,xmh,mhist-err,mhist+err
	
	; Fitting
	yy=alog10(mhist)
	yy[where(mhist eq 1)]=0.0
	ind=where(yy ne -!VALUES.F_INFINITY and xmh ge 0.5)
	
	coeff=linfit(alog10(xmh[ind]),yy[ind],yfit=yfit,sigma=sigma)
	
	oplot,xmh[ind],10^yfit
	print,"Coeffecient = ",coeff
	print,"Sigma = ",sigma
	
	print,"Total Mass = ",total(m)
		
	; End of mass transformation 
	;------------------------------------------------------------
	
	; Print catalog  
	for i=0,n_elements(xx)-1 do print,format='(i3,2x,f9.5,2x,f9.5,2x,f6.3,2x,f6.3,2x,f6.3,2x,i2)',$
		nid[i],a[i],d[i],mk[i],mak[i],mass[i],3
		
	if keyword_set(PS) then begin
		device,/close
		set_plot,'x'
	endif
	resetplt,/all
	
	!p.multi=0
   
END

PRO GETKLF,PS = ps
   common share, imgpath, mappath
   loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'iras_klf.ps',$
         /color,xsize=15,ysize=28,xoffset=1.5,yoffset=0
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1 
   endif else begin
      red=255     
   endelse
   
   ; Set image plotting panel
   !p.multi=[0,1,2]
   resetplt,/all
  
   ; Read catalog
   readcol,mappath+'s233_star.cat',id,ra,dec,mk,amk,mass,flag
   
   ;
	h1=histogram(mk,min=0,bin=0.5)
	xx=(findgen(n_elements(h1))+1)*0.5
	plot,xx,h1,psym=10,/ylog,yrange=[1,100],xrange=[9,20]
	ind=where(xx ge 10 and xx lt 19 and h1 ne 0)
	coeff=linfit(xx[ind],alog10(h1[ind]),sigma=sigma,yfit=yfit)
	oplot,xx[ind],10^yfit
	oplot,xx,10^(0.248*xx-1.785)/10,line=1;-1.785
	print,coeff[1],sigma[1]
	;----------------------------------------------------------
   ;  Here begins the analysis of ALL area      
   ;plot
   h=histogram(amk,min=-6,max=7,bin=0.5)
   xh=((findgen(n_elements(h))-12)+0.5)*0.5
   plot,xh,h,psym=10, $
      xtitle='!6Absolute magnitude (Ks)',xrange=[min(xh),max(xh)],xstyle=1,$
      ytitle='!6N',/ylog,yrange=[0.5,100],ystyle=1
   ; Overlay error bar
   err=sqrt(h)
   err[where(h eq 1)]=1.0
   errplot,xh,h-err,h+err
   
   ;
   ; Fit for alpha value 
   ind=where(alog10(h) ge 0 and xh le 5.5)
   coeff=linfit(xh[ind],alog10(h[ind]),yfit=yfit,sigma=sigma)
   oplot,xh[ind],10^yfit
   print,"Coeffecient = ",coeff
   print,"Sigma = ",sigma
      
   mh=histogram(mass,min=0,max=max(mass)+1,bin=0.25)
   mx=(findgen(n_elements(mh))+0.5)*0.25
     
   plot,mx,mh,psym=10,$
   /ylog,yrange=[0.5,150],ystyle=1,$
   /xlog,xrange=[100,0.2],xstyle=1,/nodata,$
   xtitle='Mass',ytitle='!6N'
   oplot,mx,mh,psym=4
   
   ; Plot errbar
   err=sqrt(mh)
   err[where(h eq 1)]=1.0
   errplot,mx,mh-err,mh+err
   
   ; Fitting two curves
   ind=where(alog10(mh) ge 0 and mx ge 0.2 and mx le 100)
   
   coeff1=linfit(alog10(mx[ind]),alog10(mh[ind]),yfit=yfit1,sigma=sigma1)
   
   oplot,mx[ind],10^yfit1
   
   print,"Coeffecient 1 = ",coeff1
   print,"Sigma 1 = ",sigma1
  
   ; Calculate the stellar mass
   raoff=3600*(ra-84.8041667)
   decoff=3600*(dec-35.765)
   idx=where(raoff ge -70 and raoff le 50 and decoff ge -90 and decoff le 70)
   print,total(mass[idx])
   print,total(mass)
   ;----------------------------------------------------------
   ; 
   
   ;----------------------------------------------------------
   ; Here begins the analysis of NE cluster
   
   
   ; Set image plotting panel
   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif
   resetplt,/all

   !p.multi=0
   
END

; This function plots the dust and H2 emssion of NE cluster.  Two panels
;  will in one figure. left one is dust emssion and right panle is H2 and
;  its contour.
PRO MAP_NE, ks, h2, hd1, PS=ps
	common share, imgpath, mappath
	loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'iras_mapne.ps',$
         /color,xsize=30,ysize=15,xoffset=1.5,yoffset=0,$
         /landscape
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2   
   endif else begin
      red=255
      green=32768    
   endelse
		
	; Set image plotting panel
	!p.multi=[0,2,1]
	
	; Produce dust image
	dust=ks-h2
	
	; cut NE cluster
	hextract, dust, hd1, d, nhd, 421,601,421,601
	hextract, h2, hd1, h, nhd, 421,601,421,601
	
	; Plot background grey scale image
	resetplt,/all
	!p.title = "!6 IRAS 0535+3543"
	!x.title = "RA offset(arcsec)"  & !y.title = "Dec offset(arcsec)"
	!x.range = [-27,27] & !y.range = [-27,27]
	th_image_cont,d,crange=[0,250],/nocont,/nobar,/inverse
	levels=median(h2)+0.20*[3,4,5,10,12,15]
	th_image_cont,medsmooth(h,4),level=levels,crange=[0,4],/nobar,c_color=red,/inverse
	
	; Save image in disk
	writefits,imgpath+'iras05358+3543_NE.fits',d,nhd
	
      
   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif
   resetplt,/all
	!p.multi=0
END

PRO MAP_SPITZER, ks, h2, hd1, PS=ps
   common share, imgpath, mappath
   loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'iras_spitzer.ps',$
         /color,xsize=20,ysize=20,xoffset=0,yoffset=2
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
	  ;!p.multi=[0,2,2]
	  clearplt,/all   
   endif else begin
      red=255
      green=32768    
   endelse
   ;!p.multi=[0,2,2]
   ; Set image plotting panel
   
   ; Load spitzer image
   i1=readfits(mappath+'SpitzerData/SPITZER_I1_11068416_0000_4_E2031067_maic.fits',i1hd)
   i2=readfits(mappath+'SpitzerData/SPITZER_I2_11068416_0000_4_E2031588_maic.fits',i2hd)
   i3=readfits(mappath+'SpitzerData/SPITZER_I3_11068416_0000_4_E2031996_maic.fits',i3hd)
   i4=readfits(mappath+'SpitzerData/SPITZER_I4_11068416_0000_4_E2033460_maic.fits',i4hd)
   
   dust=ks-h2
   ; cut NE cluster
   hextract, dust, hd1, d, nhd, 200,750,244,740
   
   ; align images
   hastrom,i1,i1hd,ni1,ni1hd,nhd
   hastrom,i2,i2hd,ni2,ni2hd,nhd
   hastrom,i3,i3hd,ni3,ni3hd,nhd
   hastrom,i4,i4hd,ni4,ni4hd,nhd
   
   ; Plot 3.6 micron contour
   th_image_cont,d,crange=[0,80],/nocont,/nobar,/inverse
   th_image_cont,ni1,levels=0.4+0.04*[50,60,80,100,150,200,400,800,1000,2000,4000,6000,8000],$
      /nobar,c_color=red,/noerase,/cont
   
   ; Plot 4.5 micron contour
   th_image_cont,d,crange=[0,50],/nocont,/nobar,/inverse
   th_image_cont,ni2,levels=0.5+0.03*[50,60,80,100,150,200,400,800,1000,2000,4000,6000,8000],$
      /nobar,c_color=red,/noerase,/cont
    
   ; Plot 5.8 micron contour
   th_image_cont,d,crange=[0,50],/nocont,/nobar,/inverse
   th_image_cont,ni3,levels=4.0+0.2*[50,60,80,100,150,200,400,800,1000,2000,4000,6000],$
      /nobar,c_color=red,/noerase,/cont
  
   ; Plot 8.0 micron contour
   th_image_cont,d,crange=[0,50],/nocont,/nobar,/inverse
   th_image_cont,ni4,levels=16.0+0.6*[50,60,80,100,150,200,400,800,1000,2000,4000,6000],$
      /nobar,c_color=red,/noerase,/cont
   
   writefits,imgpath+'wircamk_s233ir_ks.fits',d,nhd  
   writefits,imgpath+'spitzer_s233ir_i1.fits',ni1,ni1hd  
   writefits,imgpath+'spitzer_s233ir_i2.fits',ni2,ni1hd  
   writefits,imgpath+'spitzer_s233ir_i3.fits',ni3,ni1hd  
   writefits,imgpath+'spitzer_s233ir_i4.fits',ni4,ni1hd  
      
   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif
   !p.multi=0
   resetplt,/all

END

PRO DOPHOT
   common share, imgpath, mappath
   loadconfig
   
   dust=readfits(imgpath+'iras05358+0535_resize_dust.fits',hdr)
   i1=readfits(mappath+'SpitzerData/SPITZER_I1_11068416_0000_4_E2031067_maic.fits',hd1)
   i2=readfits(mappath+'SpitzerData/SPITZER_I2_11068416_0000_4_E2031588_maic.fits',hd2)
   i3=readfits(mappath+'SpitzerData/SPITZER_I3_11068416_0000_4_E2031996_maic.fits',hd3)
   i4=readfits(mappath+'SpitzerData/SPITZER_I4_11068416_0000_4_E2033460_maic.fits',hd4)
   hrot, i1, hd1, ti1, thd1, -90, -1, -1, 1
   
   hextract, ti1, thd1,ni1,nhd1,426,708,100,388   
   hastrom,i2,hd2,ni2,nhd2,nhd1
   hastrom,i3,hd3,ni3,nhd3,nhd1
   hastrom,i4,hd4,ni4,nhd4,nhd1
   
	;ni1=readfits(imgpath+'spitzer_s233ir_i1.fits',hd1)
   ;ni2=readfits(imgpath+'spitzer_s233ir_i2.fits',hd2)
   ;ni3=readfits(imgpath+'spitzer_s233ir_i3.fits',hd3)
   ;ni4=readfits(imgpath+'spitzer_s233ir_i4.fits',hd4)

	
	
	;aperphot,dust,3.0,20.0,catk,crange=[0,100],file=mappath+'wircam_ks_phot.txt',$
	;	loadxy=mappath+'wircam_ks_xyout.txt'

   ;aperphot,ni1,11.0,3.0,cat1,crange=[0,20],file=mappath+'spitzer_i1.txt'$
   ;   ,loadxy=mappath+'xypos.txt'
   ;aperphot,ni2,11.0,3.0,cat2,crange=[0,70],file=mappath+'spitzer_i2.txt',$
   ;   loadxy=mappath+'xypos.txt'
   ;aperphot,ni3,11.0,3.0,cat3,crange=[0,100],file=mappath+'spitzer_i3.txt',$
   ;   loadxy=mappath+'xypos.txt'
   ;aperphot,ni4,11.0,3.0,cat4,crange=[0,300],file=mappath+'spitzer_i4.txt',$
   ;   loadxy=mappath+'xypos.txt'
   
   ;aperphot,ni1,4.0,5.0,cat1,crange=[0,20],file=mappath+'spitzer_i1.txt'
   ;aperphot,ni2,4.0,5.0,cat2,crange=[0,20],file=mappath+'spitzer_i2.txt'
   ;aperphot,ni3,4.0,5.0,cat3,crange=[0,100],file=mappath+'spitzer_i3.txt'
   ;aperphot,ni4,4.0,5.0,cat4,crange=[0,300],file=mappath+'spitzer_i4.txt'

   aperphot,ni1,4.0,1.0,cat1,crange=[0,20],file=mappath+'spitzer_i1.txt'$
      ,loadxy=mappath+'xypos.txt'
   aperphot,ni2,4.0,5.0,cat2,crange=[0,70],file=mappath+'spitzer_i2.txt',$
      loadxy=mappath+'xypos.txt'
   aperphot,ni3,4.0,5.0,cat3,crange=[0,100],file=mappath+'spitzer_i3.txt',$
      loadxy=mappath+'xypos.txt'
   aperphot,ni4,4.0,5.0,cat4,crange=[0,300],file=mappath+'spitzer_i4.txt',$
      loadxy=mappath+'xypos.txt'

END

PRO PHOTOBANDS, PS=ps
   common share, imgpath, mappath
   loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'iras_band.ps',$
         /color,xsize=20,ysize=20,xoffset=0,yoffset=2
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2   
   endif else begin
      red=255
      green=32768    
   endelse
   
   dust=readfits(imgpath+'iras05358+0535_resize_dust.fits',hdr)
   i1=readfits(mappath+'SpitzerData/SPITZER_I1_11068416_0000_4_E2031067_maic.fits',hd1)
   i2=readfits(mappath+'SpitzerData/SPITZER_I2_11068416_0000_4_E2031588_maic.fits',hd2)
   i3=readfits(mappath+'SpitzerData/SPITZER_I3_11068416_0000_4_E2031996_maic.fits',hd3)
   i4=readfits(mappath+'SpitzerData/SPITZER_I4_11068416_0000_4_E2033460_maic.fits',hd4)
   
   hrot, i1, hd1, ti1, thd1, -90, -1, -1, 1
   
   hextract, ti1, thd1,ni1,nhd1,426,708,100,388   
   hastrom,i2,hd2,ni2,nhd2,nhd1
   hastrom,i3,hd3,ni3,nhd3,nhd1
   hastrom,i4,hd4,ni4,nhd4,nhd1
   
 	;ni1=readfits(imgpath+'spitzer_s233ir_i1.fits',nhd1)
   ;ni2=readfits(imgpath+'spitzer_s233ir_i2.fits',nhd2)
   ;ni3=readfits(imgpath+'spitzer_s233ir_i3.fits',nhd3)
   ;ni4=readfits(imgpath+'spitzer_s233ir_i4.fits',nhd4)
  
   loadphot,mappath+'wircam_ks_phot.txt',hdr,catk
   loadphot,mappath+'spitzer_i1.txt',nhd1,cati1
   loadphot,mappath+'spitzer_i2.txt',nhd2,cati2
   loadphot,mappath+'spitzer_i3.txt',nhd3,cati3
   loadphot,mappath+'spitzer_i4.txt',nhd4,cati4
   
   getcatalog,hdr,std
   
   ;hextract, dust, hdr, d, nhd, 200,750,244,740
   ;catk.x=catk.x-200
   ;catk.y=catk.y-244
   ;ind=where(catk.x ge 0 and catk.x le 550 and catk.y ge 0 and catk.y le 496)
   ind=where(catk.x ne 0)
	
   th_image_cont,dust,/nocont,crange=[0,50],/nobar,/inverse
   oplot,catk[ind].x,catk[ind].y,psym=4,color=red
   ;xyouts,catk[ind].x,catk[ind].y,strcompress(string(catk[ind].id),/remove),$
   ;   color=red,charsize=0.5
   
   ;!p.multi=[0,2,2]
   th_image_cont,ni1,/nocont,crange=[0,10],/nobar,/inverse
   oplot,cati1.x,cati1.y,psym=4,color=red
   ;xyouts,cati1.x,cati1.y,strcompress(string(cati1.id),/remove),color=red,charsize=0.8

   th_image_cont,ni2,/nocont,crange=[0,10],/nobar,/inverse
   oplot,cati2.x,cati2.y,psym=4,color=red
   ;xyouts,cati2.x,cati2.y,strcompress(string(cati2.id),/remove),color=red,charsize=0.8
   
   th_image_cont,ni3,/nocont,crange=[0,50],/nobar,/inverse
   oplot,cati3.x,cati3.y,psym=4,color=red
   xyouts,cati3.x,cati3.y,strcompress(string(cati3.id),/remove),color=red,charsize=0.8
   
   th_image_cont,ni4,/nocont,crange=[0,100],/nobar,/inverse
   oplot,cati4.x,cati4.y,psym=4,color=red
   xyouts,cati4.x,cati4.y,strcompress(string(cati4.id),/remove),color=red,charsize=0.8
      
   
   
   
   ; Correcting magnitude and do flux transfrom to mJy 
   catk.mag=0.996*catk.mag-1.79233
   catk.flux=10^((7.06-catk.mag)/2.5)*1e-23/phertz2pmicron(2.146) 
   
   
   cati1.mag=48.60-2.5*alog10(cati1.flux*0.0021*1e-3*1e-23)
   cati2.mag=48.60-2.5*alog10(cati2.flux*0.0021*1e-3*1e-23)
   cati3.mag=48.60-2.5*alog10(cati3.flux*0.0021*1e-3*1e-23)
   cati4.mag=48.60-2.5*alog10(cati4.flux*0.0021*1e-3*1e-23)
   
   ; Transform Fv to vFv
   catk.flux=10^((7.06-catk.mag)/2.5)*1e-23/phertz2pmicron(2.146)      
   cati1.flux=cati1.flux*33.846*1e-6*1e-23/phertz2pmicron(3.56)
   cati2.flux=cati2.flux*33.846*1e-6*1e-23/phertz2pmicron(4.52)
   cati3.flux=cati3.flux*33.846*1e-6*1e-23/phertz2pmicron(5.73)
   cati4.flux=cati4.flux*33.846*1e-6*1e-23/phertz2pmicron(7.91)
   
	catk.err=10^((7.06-(0.996*(25-2.5*alog10(catk.err))-1.792))/2.5)*1e-23/phertz2pmicron(2.146) 
	cati1.err=cati1.err*33.846*1e-6*1e-23/phertz2pmicron(3.56)
	cati2.err=cati2.err*33.846*1e-6*1e-23/phertz2pmicron(4.52)
	cati3.err=cati3.err*33.846*1e-6*1e-23/phertz2pmicron(5.73)
	cati4.err=cati4.err*33.846*1e-6*1e-23/phertz2pmicron(7.91)
	
   regstars,catk,cati1,cati2,cati3,cati4,final
   
   !p.multi=0
    
   lamda=[2.145,3.6,4.5,5.8,8.0]
   !p.multi=[0,4,4]
	
	g1=where(final.rflux ge final.flux1 and $
			final.flux1 ge final.flux2 and $
			final.flux2 ge final.flux3 and $
			final.flux3 ge final.flux4)
	
	a=fltarr(n_elements(final.x))
   for i=0, n_elements(final.x)-1 do begin
		vfv=[final[i].rflux,final[i].flux1,final[i].flux2,$
			final[i].flux3,final[i].flux4]
		err=[final[i].rferr,final[i].err1,final[i].err2,$
			final[i].err3,final[i].err4]
		
			
		vfv1=[final[i].flux1,final[i].flux2,$
			final[i].flux3,final[i].flux4]
		err1=[final[i].err1,final[i].err2,$
			final[i].err3,final[i].err4]
		
			
		
		coef=linfit(alog10([3.6,4.5,5.8,8.0]),alog10(vfv1),sigma=sigma,yfit=yfit)
		a[i]=coef[1]
		;plot,lamda,vfv,psym=4,$
		;	title=strcompress(string(final[i].id),/remove)+' '+$
		;	strcompress(string(coef[1]),/remove),$
		;	/xlog,/ylog
		;oplot,[3.6,4.5,5.8,8.0],10^yfit
		;errplot,lamda,vfv-err,vfv+err
		
	endfor

   !p.multi=0
   
   ;th_image_cont,dust,/nocont,crange=[0,50],/nobar,/inverse
   
   ;g1=where(a gt 0.0 and a lt 2.0)
   ;g2=where(a gt -2 and a lt -1)
   ;g3=where(a lt -2)
  
	g1=where(final.rflux ge final.flux1 and $
			final.flux1 ge final.flux2 and $
			final.flux2 ge final.flux3 and $
			final.flux3 ge final.flux4)
	
	g2=where(a gt -1.26 and a lt 0.7)
	g3=where(a ge 0.7)
	g4=where((final.rflux ge final.flux1 and $
			final.flux1 ge final.flux2 and $
			final.flux2 ge final.flux3 and $
			final.flux3 ge final.flux4) or $
			a gt -1.26,complement=inx)
	
	print,'TOTAL =',n_elements(final.x)
	print,'Stars =',n_elements(g1)
	print,'Hot excess=',n_elements(g2)
	print,'YSOs=',n_elements(g3)
	
	; Plot stars
	th_image_cont,dust,/nocont,crange=[0,50],/nobar,/inverse
	plotsym2, 0, 2		;circle
	oplot,final[g1].x,final[g1].y,psym=8,color=red
	;xyouts,final[g1].x,final[g1].y,strcompress(string(final[g1].id),/remove),color=red,charsize=0.8  
	
	; Plot flat spectrum
	th_image_cont,dust,/nocont,crange=[0,50],/nobar,/inverse
	plotsym2, 4, 2		;triangle
	oplot,final[g2].x,final[g2].y,psym=8,color=red
	
	; Plot rising spectrum
	th_image_cont,dust,/nocont,crange=[0,50],/nobar,/inverse
	plotsym2, 8, 2		;square
	oplot,final[g3].x,final[g3].y,psym=8,color=red
	
	; Plot other spectrum
	th_image_cont,dust,/nocont,crange=[0,50],/nobar,/inverse
	oplot,final[inx].x,final[inx].y,psym=4,color=red
	
	!p.multi=[0,4,4]
	; Plot spetrum
	for i=0, n_elements(final.x)-1 do begin
		id1=where(g1 eq i,c1)
		id2=where(g2 eq i,c2)
		id3=where(g3 eq i,c3)
		;print,i,id1,c1
		if c1 gt 0 then begin
			vfv=[final[i].rflux,final[i].flux1,final[i].flux2,$
				final[i].flux3,final[i].flux4]
			err=[final[i].rferr,final[i].err1,final[i].err2,$
				final[i].err3,final[i].err4]
			coef=linfit(alog10(lamda),alog10(vfv),sigma=sigma,yfit=yfit)
			plot,lamda,vfv,psym=4,$
				title=strcompress(string(final[i].id),/remove)+' '+$
				strcompress(string(coef[1]),/remove),$
				/xlog,/ylog
			oplot,lamda,10^yfit
		endif
		
		if c2 gt 0 then begin
			vfv=[final[i].rflux,final[i].flux1,final[i].flux2,$
				final[i].flux3,final[i].flux4]
			err=[final[i].rferr,final[i].err1,final[i].err2,$
				final[i].err3,final[i].err4]
			
			vfv1=[final[i].rflux,final[i].flux1,final[i].flux2]
			err1=[final[i].rferr,final[i].err1,final[i].err2]
			lam1=[2.145,3.6,4.5]
			coef=linfit(alog10([lam1]),alog10(vfv1),sigma=sigma,yfit=yfit)
			plot,lamda,vfv,psym=4,$
				title=strcompress(string(final[i].id),/remove)+' '+$
				strcompress(string(coef[1]),/remove),$
				/xlog,/ylog
			oplot,lam1,10^yfit
			
			vfv2=[final[i].flux2,final[i].flux3,final[i].flux4]
			err2=[final[i].err2,final[i].err3,final[i].err4]
   			lam2=[4.5,5.8,8.0]
			coef=linfit(alog10([lam2]),alog10(vfv2),sigma=sigma,yfit=yfit)
			oplot,lam2,10^yfit
		endif 
		if c3 gt 0 then begin
			vfv=[final[i].rflux,final[i].flux1,final[i].flux2,$
				final[i].flux3,final[i].flux4]
			err=[final[i].rferr,final[i].err1,final[i].err2,$
				final[i].err3,final[i].err4]
			
			vfv1=[final[i].rflux,final[i].flux1,final[i].flux2]
			err1=[final[i].rferr,final[i].err1,final[i].err2]
			lam1=[2.145,3.6,4.5]
			coef=linfit(alog10([lam1]),alog10(vfv1),sigma=sigma,yfit=yfit)
			plot,lamda,vfv,psym=4,$
				title=strcompress(string(final[i].id),/remove)+' '+$
				strcompress(string(coef[1]),/remove),$
				/xlog,/ylog
			oplot,lam1,10^yfit
			
			vfv2=[final[i].flux2,final[i].flux3,final[i].flux4]
			err2=[final[i].err2,final[i].err3,final[i].err4]
   			lam2=[4.5,5.8,8.0]
			coef=linfit(alog10([lam2]),alog10(vfv2),sigma=sigma,yfit=yfit)
			oplot,lam2,10^yfit
		endif 
	endfor
	   
   ;xyouts,final.x,final.y,strcompress(string(final.id),/remove),color=red,charsize=0.8  
   
   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif
   !p.multi=0
   resetplt,/all

END


PRO IRACCOLOR, PS=ps
   common share, imgpath, mappath
   loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'iras_iraccolor.ps',$
         /color,xsize=20,ysize=20,xoffset=0,yoffset=2
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2   
   endif else begin
      red=255
      green=32768    
   endelse
   i1=readfits(mappath+'SpitzerData/SPITZER_I1_11068416_0000_4_E2031067_maic.fits',hd1)
   i2=readfits(mappath+'SpitzerData/SPITZER_I2_11068416_0000_4_E2031588_maic.fits',hd2)
   i3=readfits(mappath+'SpitzerData/SPITZER_I3_11068416_0000_4_E2031996_maic.fits',hd3)
   i4=readfits(mappath+'SpitzerData/SPITZER_I4_11068416_0000_4_E2033460_maic.fits',hd4)
   ;repnan,i1,0
   ;repnan,i2,0
   ;repnan,i3,0
   ;repnan,i4,0
	
   hrot, i1, hd1, ti1, thd1, -90, -1, -1, 1
   
   hextract, ti1, thd1,ni1,nhd1,426,708,100,388   
   hastrom,i2,hd2,ni2,nhd2,nhd1
   hastrom,i3,hd3,ni3,nhd3,nhd1
   hastrom,i4,hd4,ni4,nhd4,nhd1
   
   th_image_cont,ni1,crange=[0,10],/nocont,/nobar,/inverse
   oplotbox,95,121,125,151,color=red
   oplotbox,174,201,98,128,color=red
   oplotbox,128,169,130,153,color=red
   oplotbox,168,203,136,174,color=red
	
   
   hextract, ni1, nhd1,ni1g1,nhd1g1,95,121,125,151
   hastrom,ni2,nhd2,ni2g1,nhd2g1,nhd1g1
   hastrom,ni3,nhd3,ni3g1,nhd3g1,nhd1g1
   hastrom,ni4,nhd4,ni4g1,nhd4g1,nhd1g1
   
   ; For region 1   
   !p.multi=[0,2,2]
   th_image_cont,ni1,crange=[0,10],/nocont,/nobar,/inverse
   oplotbox,95,121,125,151,color=red
   
	coeff=linfit(reform(ni4g1),reform(ni1g1),yfit=yfit)
	plot,reform(ni4g1),reform(ni1g1),psym=3,title='R= '+strcompress(string(coeff[1]),/remove),$
		xtitle='I4',ytitle='I1',charsize=1.2
	oplot,reform(ni4g1),yfit,color=red
	
   coeff=linfit(reform(ni4g1),reform(ni2g1),yfit=yfit)
	plot,reform(ni4g1),reform(ni2g1),psym=3,title='R= '+strcompress(string(coeff[1]),/remove),$
		xtitle='I4',ytitle='I1',charsize=1.2
	oplot,reform(ni4g1),yfit,color=red
   
	coeff=linfit(reform(ni4g1),reform(ni3g1),yfit=yfit)
	plot,reform(ni4g1),reform(ni3g1),psym=3,title='R= '+strcompress(string(coeff[1]),/remove),$
		xtitle='I4',ytitle='I1',charsize=1.2
	oplot,reform(ni4g1),yfit,color=red
   
	
   hextract, ni1, nhd1,ni1g2,nhd1g2,174,201,98,128
   hastrom,ni2,nhd2,ni2g2,nhd2g2,nhd1g2
   hastrom,ni3,nhd3,ni3g2,nhd3g2,nhd1g2
   hastrom,ni4,nhd4,ni4g2,nhd4g2,nhd1g2
   th_image_cont,ni1,crange=[0,10],/nocont,/nobar,/inverse
   oplotbox,174,201,98,128,color=red
	
	ind=where(ni4g2 ge 0 and ni1g2 ge 0)
	coeff=linfit(reform(ni4g2[ind]),reform(ni1g2[ind]),yfit=yfit)
	plot,reform(ni4g2),reform(ni1g2),psym=3,title='R= '+strcompress(string(coeff[1]),/remove),$
		xtitle='I4',ytitle='I1',charsize=1.2
	oplot,reform(ni4g2[ind]),yfit,color=red
	
   coeff=linfit(reform(ni4g2[ind]),reform(ni2g2[ind]),yfit=yfit)
	plot,reform(ni4g2),reform(ni2g2),psym=3,title='R= '+strcompress(string(coeff[1]),/remove),$
		xtitle='I4',ytitle='I1',charsize=1.2
	oplot,reform(ni4g2[ind]),yfit,color=red
   
	coeff=linfit(reform(ni4g2[ind]),reform(ni3g2[ind]),yfit=yfit)
	plot,reform(ni4g2),reform(ni3g2),psym=3,title='R= '+strcompress(string(coeff[1]),/remove),$
		xtitle='I4',ytitle='I1',charsize=1.2
	oplot,reform(ni4g2[ind]),yfit,color=red

   hextract, ni1, nhd1,ni1g3,nhd1g3,128,169,130,153
   hastrom,ni2,nhd2,ni2g3,nhd2g3,nhd1g3
   hastrom,ni3,nhd3,ni3g3,nhd3g3,nhd1g3
   hastrom,ni4,nhd4,ni4g3,nhd4g3,nhd1g3
   th_image_cont,ni1,crange=[0,10],/nocont,/nobar,/inverse
   oplotbox,128,169,130,153,color=red
   
	ind=where(ni1g3 ge 0 and ni2g3 ge 0 and ni3g3 ge 0 and ni4g3 ge 0 and ni4g3 le 100)
	coeff=linfit(reform(ni4g3[ind]),reform(ni1g3[ind]),yfit=yfit)
	plot,reform(ni4g3),reform(ni1g3),psym=3,title='R= '+strcompress(string(coeff[1]),/remove),$
		xtitle='I4',ytitle='I1',charsize=1.2
	oplot,reform(ni4g3[ind]),yfit,color=red
	
   coeff=linfit(reform(ni4g3[ind]),reform(ni2g3[ind]),yfit=yfit)
	plot,reform(ni4g3),reform(ni2g3),psym=3,title='R= '+strcompress(string(coeff[1]),/remove),$
		xtitle='I4',ytitle='I1',charsize=1.2
	oplot,reform(ni4g3[ind]),yfit,color=red
   
	coeff=linfit(reform(ni4g3[ind]),reform(ni3g3[ind]),yfit=yfit)
	plot,reform(ni4g3),reform(ni3g3),psym=3,title='R= '+strcompress(string(coeff[1]),/remove),$
		xtitle='I4',ytitle='I1',charsize=1.2
	oplot,reform(ni4g3[ind]),yfit,color=red
   
	hextract, ni1, nhd1,ni1g4,nhd1g4,168,203,136,174
   hastrom,ni2,nhd2,ni2g4,nhd2g4,nhd1g4
   hastrom,ni3,nhd3,ni3g4,nhd3g4,nhd1g4
   hastrom,ni4,nhd4,ni4g4,nhd4g4,nhd1g4
   th_image_cont,ni1,crange=[0,10],/nocont,/nobar,/inverse
   oplotbox,168,203,136,174,color=red
	
	ind=where(ni1g4 ge 0 and ni2g4 ge 0 and ni3g4 ge 0 and ni4g4 ge 0 and ni4g4 le 100)
	coeff=linfit(reform(ni4g4[ind]),reform(ni1g4[ind]),yfit=yfit)
	plot,reform(ni4g4),reform(ni1g4),psym=3,title='R= '+strcompress(string(coeff[1]),/remove),$
		xtitle='I4',ytitle='I1',charsize=1.2
	oplot,reform(ni4g4[ind]),yfit,color=red
	
   coeff=linfit(reform(ni4g4[ind]),reform(ni2g4[ind]),yfit=yfit)
	plot,reform(ni4g4),reform(ni2g4),psym=3,title='R= '+strcompress(string(coeff[1]),/remove),$
		xtitle='I4',ytitle='I1',charsize=1.2
	oplot,reform(ni4g4[ind]),yfit,color=red
   
	coeff=linfit(reform(ni4g4[ind]),reform(ni3g4[ind]),yfit=yfit)
	plot,reform(ni4g4),reform(ni3g4),psym=3,title='R= '+strcompress(string(coeff[1]),/remove),$
		xtitle='I4',ytitle='I1',charsize=1.2
	oplot,reform(ni4g4[ind]),yfit,color=red
            
   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif
   !p.multi=0
   resetplt,/all

END

PRO INTERLINFIT, x ,y
   
   coeff=linfit(x,y,sigma=sigma,yfit=yfit)
   
   oplot,x,yfit
END

PRO LOADPHOT,file, hdr, cat
   
   readcol,file,id,x,y,flux,mag,err
   
	ind=where(flux ge 0)
	cat={catalog,id:0,x:0.0,y:0.0,ra:0.0,dec:0.0,mag:0.0,flux:0.0,err:0.0} 
   cat=replicate(cat,n_elements(x[ind]))
   cat.id=fix(id[ind])
   
   xyad,hdr,x[ind],y[ind],ra,dec
   cat.x=x[ind]
   cat.y=y[ind]
   cat.ra=ra
   cat.dec=dec
   
   cat.flux=flux[ind]
   cat.mag=mag[ind]
	cat.err=err[ind]
END


FUNCTION phertz2pmicron, micron
   
   c=double(299792458.00)
   con=(c/(c/micron)^2)/(1e06)

   return,con
END

; This rotine is used to analyze the dust sed based on seleceted area.
PRO DUSTSED, PS=ps
   common share, imgpath, mappath
   loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'iras_dustsed.ps',$
         /color,xsize=20,ysize=20,xoffset=0,yoffset=2
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2   
   endif else begin
      red=255
      green=32768    
   endelse
	dust=readfits(imgpath+'iras05358+0535_resize_dust.fits',hdr)
	i1=readfits(mappath+'SpitzerData/SPITZER_I1_11068416_0000_4_E2031067_maic.fits',hd1)
	i2=readfits(mappath+'SpitzerData/SPITZER_I2_11068416_0000_4_E2031588_maic.fits',hd2)
	i3=readfits(mappath+'SpitzerData/SPITZER_I3_11068416_0000_4_E2031996_maic.fits',hd3)
	i4=readfits(mappath+'SpitzerData/SPITZER_I4_11068416_0000_4_E2033460_maic.fits',hd4)
	
	hrot, i1, hd1, ti1, thd1, -90, -1, -1, 1
	
	hextract, ti1, thd1,ni1,nhd1,426,708,100,388   
	hastrom,dust,hdr,nd,nhdr,nhd1
	hastrom,i2,hd2,ni2,nhd2,nhd1
	hastrom,i3,hd3,ni3,nhd3,nhd1
	hastrom,i4,hd4,ni4,nhd4,nhd1
	if keyword_set(PS) then set_plot,'x'	
	th_image_cont,ni1,/nocont,crange=[0,10],/nobar
	x=[0]
	y=[0]   

	n=0
	!mouse.button=2
	while (!mouse.button ne 4) do begin
		cursor,a,b,/down
		if !mouse.button eq 1 then begin

		if n eq 0 then begin
			x=a
			y=b;
		endif
		x=[x,a]
		y=[y,b]         
		n=n+1     	;
		oplotbox,a-4,a+4,b-4,b+4,color=255		
		xyouts,a,b,strcompress(string(n),/remove),color=255
;	  
	  endif
	endwhile
	if keyword_set(PS) then set_plot,'ps'
	
	
	th_image_cont,ni1,/nocont,crange=[0,10],/inverse,/nobar
	for i=0,n_elements(x)-1 do begin
		oplotbox,x[i]-4,x[i]+4,y[i]-4,y[i]+4,color=red		
		xyouts,x[i],y[i],strcompress(string(i),/remove),color=red
	endfor
	!p.multi=[0,4,4]
	for i=0,n_elements(x)-1 do begin
		
		f1=10^((7.06-(0.996*(25-2.5*alog10(getflux(nd,x[i],y[i],4)))-1.792))/2.5)*1e-23/phertz2pmicron(2.146) 	
		f2=getflux(ni1,x[i],y[i],4)*0.0021*1e-3*1e-23/phertz2pmicron(3.56)
		f3=getflux(ni2,x[i],y[i],4)*0.0021*1e-3*1e-23/phertz2pmicron(4.52)
		f4=getflux(ni3,x[i],y[i],4)*0.0021*1e-3*1e-23/phertz2pmicron(5.73)
		f5=getflux(ni4,x[i],y[i],4)*0.0021*1e-3*1e-23/phertz2pmicron(7.91)
		
		lamda=[2.145,3.6,4.5,5.8,8.0]

	plot,lamda,[f1,f2,f3,f4,f5],psym=5,/ylog,/xlog,title=strcompress(string(i),/remove)
    
	endfor   
   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif
   !p.multi=0
   resetplt,/all

END

; This function is used to get the flux from XY positions.
FUNCTION GETFLUX, im, x, y, radius
	skyap=radius+2
	flux=total(im[x-radius:x+radius,y-radius:y+radius])
	sky=total(im[x-skyap:x+skyap,y-skyap:y+skyap])-$
		total(im[x-radius:x+radius,y-radius:y+radius])
	
	nbox=n_elements(flux)
	nsky=n_elements(sky)
	npix=nsky-nbox
	
	fx=flux;-(sky*(nbox/npix))
	
	;if keyword_set(wircam) then begin
	;	vfv=10^((7.06-(0.996*(25-2.5*alog10(fx))-1.792))/2.5)*1e-23/phertz2pmicron(2.146)
	;endif else begin
		
	;endelse
	
	return,fx
END


PRO SAVESUBREGION, hdr, im, x1, x2, y1, y2, im_name
	common share, imgpath, mappath
	loadconfig
	hextract, im, hdr, nim,nhdr,x1,x2,y1,y2
	writefits,imgpath+im_name,nim,nhdr
	
END


FUNCTION FILTER_BUTTERWORTH, IM
	; Filtering, usig butterworth algorithm
	filter = butterworth(size(im,/dimension),cutoff=7)
	fim = fft(fft(im, -1)* filter,1)
	
	ffim=double(fim)
	return, ffim
END


PRO SUBTRACT_CONT, ks, h2, dust, im
   common share, imgpath, mappath
   loadconfig
   generate_mask,mask,h2
   
   ; Masking bright stars
   nim1=h2*mask
   nim2=ks*mask
   
   ; Replace masked pixel with linear interpolation
   fixbadpix,nim1,mask,xim1
   fixbadpix,nim2,mask,xim2
   
   ; Image subtraction to get H2 image
   im=(xim1-xim2/10)*mask
   dust=ks-h2

END

PRO PLOTSED
   lamda=(findgen(100000)+1)*1000
   bb_star=planck(lamda,6000)
   plot,lamda,bb_star,/xlog,/ylog
   
   bb_1000k=planck(lamda,1000)
   oplot,lamda,bb_1000k
   oplot,lamda,bb_star+bb_1000k,psym=4
END


; This program loads all clump table at once and translate the coordinate from 
;  XY to RA,Dec.
PRO MKKNOTTABLE, im, hd1
   common share, imgpath, mappath
   loadconfig
   
   file=['clump_central.txt','clump_reg1.txt','clump_reg2.txt','clump_reg3.txt'$
         ,'clump_reg4.txt','clump_reg5.txt','clump_reg6.txt','clump_reg7.txt'$
         ,'clump_reg8.txt','clump_reg9.txt']
   xoffset=[461,450,535,510,560,640,415,300,500,630]
   yoffset=[461,550,500,390,310,440,210,890,160,670]
   
   
   for i=0,n_elements(file)-1 do begin      
      readcol,imgpath+file[i],id,cx,cy,mf,fx,fy,r,f,n
      if i eq 0 then begin
         x=cx+xoffset[i]
         y=cy+yoffset[i]
         mflux=mf
         fwhmx=fx
         fwhmy=fy
         radius=r
         flux=f
         npix=n
      endif else begin
      x=[x,cx+xoffset[i]]
      y=[y,cy+yoffset[i]]
      mflux=[mflux,mf]
      fwhmx=[fwhmx,fx]
      fwhmy=[fwhmy,fy]
      radius=[radius,r]
      flux=[flux,f]
      npix=[npix,n]
      endelse      
   endfor
   xyad,hd1,x,y,ra,dec
   
   mh=20.0-alog10(flux)
   mk=1.015*mh-4.520
   mj=10^((7.06-mk)/2.5)*1000
   id=indgen(n_elements(x))+1
   for i=0,n_elements(x)-1 do begin
      print,format='(i3,2x,f9.5,2x,f9.5,2x,f9.3)',$
      id[i],ra[i],dec[i],mj[i]
   endfor
   th_image_cont, im,crange=[0,1],/nocont
   oplot,x,y,psym=4,color=255 

END



PRO IRAS
	common share, imgpath, mappath
	loadconfig
	
	; Load image
	loadimage,ks,h2,hd1,hd2
	
	subtract_cont,ks,h2,dust,im

	; Plot Ks grey scale and H2 contour
	map_all,dust,im,hd1,/ps
	
	; Plot Central area
	map_central,dust,im,hd1,/ps
	
	; Plot Regions
	map_reg1,dust,im,hd1,/ps
	map_reg2,dust,im,hd1,/ps
	map_reg3,dust,im,hd1,/ps
	map_reg4,dust,im,hd1,/ps
	map_reg5,dust,im,hd1,/ps
	map_reg6,dust,im,hd1,/ps
	map_reg7,dust,im,hd1,/ps
	map_reg8,dust,im,hd1,/ps
	map_reg9,dust,im,hd1,/ps
	

	savesubregion,hd1,im,461,561,461,561,'iras_central.fits'
	savesubregion,hd1,im,450,650,550,750,'dust_reg1.fits'
	savesubregion,hd1,im,535,665,500,630,'dust_reg2.fits'
	savesubregion,hd1,im,510,610,390,490,'dust_reg3.fits'
	savesubregion,hd1,im,560,710,310,460,'dust_reg4.fits'
	savesubregion,hd1,im,640,740,440,540,'dust_reg5.fits'
	savesubregion,hd1,im,415,525,210,320,'dust_reg6.fits'
	savesubregion,hd1,im,300,400,890,990,'dust_reg7.fits'
	savesubregion,hd1,im,500,600,160,260,'dust_reg8.fits'   
	savesubregion,hd1,im,630,730,670,770,'dust_reg9.fits'


	; Analysis the DUST map and compare with previous work
	analysis_dust,hd1,dust	


   
   ; Analysis the NW cluster
   getstar_ne,ks,h2,hd1
   
   ; Analysis the SW cluster
   getstar_sw,ks,h2,hd1

   ; Analysis the field star cluster
   getstar_fs,ks,h2,hd1
      	
	; Write FITS file
	writefits,imgpath+'iras05358+0535_resize_dust.fits',dust,hd1
	writefits,imgpath+'iras05358+0535_resize_h2em.fits',im,hd2
end


