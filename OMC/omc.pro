
@photo

PRO LOADCONFIG
   COMMON share,config
   
   ;cubepath='/arrays/cfht_3/chyan/guidecube/'
   ;cubepath='/h/archive/current/instrument/wircam/'
   ;calibpath='/data/ula/wircam/calib/'
   ;datapath='/data/wena/wircam/chyan/gcube/'

   path='/data/chyan/Projects/OMC/'
   fitspath=path
   pspath=path
   
   config={path:path,fitspath:fitspath,pspath:pspath}
END

PRO ROTATEIMAGE
	COMMON share,config
	
	loadconfig
	
	
	im1=config.path+'SP3.6micron.fits'
	im2=config.path+'SP4.5micron.fits'
	im3=config.path+'SP5.8micron.fits'
	im4=config.path+'SP8micron.fits'  
	im5=config.path+'SP24_rotate.fits'
	im6=config.path+'SP70micron.fits' 
	im7=config.path+'SP160micron.fits'
	im8=config.path+'jomcmos5.fits'
	im9=config.path+'homcmos1.fits'
	im10=config.path+'komcmos1.fits'
	
	; Rotate the image
	
	spawn,'remap -j 5:35:23.48 -5:01:32.2 -o '+config.path+'i1.fits '+im1
	spawn,'remap -j 5:35:23.48 -5:01:32.2 -o '+config.path+'i2.fits '+im2
	spawn,'remap -j 5:35:23.48 -5:01:32.2 -o '+config.path+'i3.fits '+im3
	spawn,'remap -j 5:35:23.48 -5:01:32.2 -o '+config.path+'i4.fits '+im4
	spawn,'remap -j 5:35:23.48 -5:01:32.2 -o '+config.path+'m2.fits '+im5
	spawn,'remap -j 5:35:23.48 -5:01:32.2 -o '+config.path+'m3.fits '+im6
	spawn,'remap -j 5:35:23.48 -5:01:32.2 -o '+config.path+'m4.fits '+im7
	spawn,'remap -j 5:35:23.48 -5:01:32.2 -o '+config.path+'j.fits '+im8
	spawn,'remap -j 5:35:23.48 -5:01:32.2 -o '+config.path+'h.fits '+im9
	spawn,'remap -j 5:35:23.48 -5:01:32.2 -o '+config.path+'k.fits '+im10
	

END

PRO RESIZEIMAGE
	COMMON share,config
	
	loadconfig
	
	
	im1=readfits(config.path+'i1.fits',hd1)
	im2=readfits(config.path+'i2.fits',hd2)
	im3=readfits(config.path+'i3.fits',hd3)
	im4=readfits(config.path+'i4.fits',hd4)
	im5=readfits(config.path+'m2.fits',hd5)
	im6=readfits(config.path+'m3.fits',hd6)
	im7=readfits(config.path+'m4.fits',hd7)
	
	im8=readfits(config.path+'j.fits',hd8)
	im9=readfits(config.path+'h.fits',hd9)
	im10=readfits(config.path+'k.fits',hd10)
	;
	; scale image to the same dimension
	hastrom, im5,hd5,tim5,thd5,hd1
	hastrom, im6,hd6,tim6,thd6,hd1
	hastrom, im7,hd7,tim7,thd7,hd1
	
	
	; Determine the center of the image
	center=sxpar(hd1,'CRPIX*')
	print,center
	size=round(20.0/3600.0/sxpar(hd1,'CDELT2'))
	;
	; cut interesting area
	print,center[0]-size-1,center[0]+size,center[1]-size-1,center[1]+size
	hextract, im1, hd1, nim1,nhd1,center[0]-size-1,center[0]+size,center[1]-size-1,center[1]+size
	hextract, im2, hd2, nim2,nhd2,center[0]-size-1,center[0]+size,center[1]-size-1,center[1]+size
	hextract, im3, hd3, nim3,nhd3,center[0]-size-1,center[0]+size,center[1]-size-1,center[1]+size
	hextract, im4, hd4, nim4,nhd4,center[0]-size-1,center[0]+size,center[1]-size-1,center[1]+size
	hextract, tim5, thd5, nim5,nhd5,1139,1203,1287,1351
	hextract, tim6, thd6, nim6,nhd6,1139,1203,1287,1351
	hextract, tim7, thd7, nim7,nhd7,1139,1203,1287,1351
	
	hextract, im8, hd8, nim8,nhd8,479,647,1315,1483
	hextract, im9, hd9, nim9,nhd9,479,647,1315,1483
	hextract, im10, hd10, nim10,nhd10,479,647,1315,1483

	updatehd,nhd8
	updatehd,nhd9
	updatehd,nhd10
	 	
	repnan, nim1, 0
	repnan, nim2, 0
	repnan, nim3, 0
	repnan, nim4, 0
	repnan, nim5, 0
	repnan, nim6, 0
	
	writefits,config.path+'xni1.fits',nim1,nhd1
	writefits,config.path+'xni2.fits',nim2,nhd2
	writefits,config.path+'xni3.fits',nim3,nhd3
	writefits,config.path+'xni4.fits',nim4,nhd4
	writefits,config.path+'ni5.fits',nim5,nhd5
	writefits,config.path+'ni6.fits',nim6,nhd6
	writefits,config.path+'ni7.fits',nim7,nhd7
	
	writefits,config.path+'nj.fits',nim8,nhd8
	writefits,config.path+'nh.fits',nim9,nhd9
	writefits,config.path+'nk.fits',nim10,nhd10

END

PRO UPDATEHD,HD
	sxaddpar, nhd10, 'CD1_2',0
 	sxaddpar, nhd10, 'CD2_1',0

END

PRO RUNSEXTRACTOR
	COMMON share,config
	loadconfig

	file=['ni1','ni2','ni3','ni4','ni5','ni6','nj','nh','nk']


	for i=0,n_elements(file)-1 do begin
	spawn,'sex -c '+config.path+'default.sex '+config.path+file[i]+'.fits  '$
		+' -PARAMETERS_NAME '+config.path+'default.param '$
		+' -FILTER_NAME '+config.path+'default.conv '$
		+' -STARNNW_NAME '+config.path+'default.nnw '$
		+' -PARAMETERS_NAME '+config.path+'default.param '$
		+' -BACKPHOTO_TYPE GLOBAL '$
		+' -CATALOG_NAME '+config.path+file[i]+'.sex -MAG_ZEROPOINT 25.0'$
		+' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 '$
		+' -PHOT_AUTOAPERS 1.0,2.0'$
		+' -CHECKIMAGE_TYPE  APERTURES -CHECKIMAGE_NAME '$
		+config.path+file[i]+'-check.fits'
	endfor
	
END
PRO GETBACKGROUND
	COMMON share,config
	loadconfig

	file=['ni1','ni2','ni3','ni4','ni5','ni6','nj','nh','nk']

	for i=0,n_elements(file)-1 do begin
	spawn,'sex -c '+config.path+'default.sex '+config.path+file[i]+'.fits  '$
		+' -PARAMETERS_NAME '+config.path+'default.param '$
		+' -FILTER_NAME '+config.path+'default.conv '$
		+' -STARNNW_NAME '+config.path+'default.nnw '$
		+' -PARAMETERS_NAME '+config.path+'default.param '$
		+' -CATALOG_NAME '+config.path+file[i]+'.sex -MAG_ZEROPOINT 25.0'$
		+' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 '$
		+' -PHOT_AUTOAPERS 1.0,2.0'$
		+' -CHECKIMAGE_TYPE  BACKGROUND -CHECKIMAGE_NAME '$
		+config.path+file[i]+'-background.fits '$
		+' -VERBOSE_TYPE  QUIET '
	endfor
	
END


PRO GET2MASS, ref
	COMMON share,config
	loadconfig

	hd=headfits(config.path+'nj.fits')
	ra=strcompress(string(sxpar(hd,'CRVAL1')),/remove)
	dec=strcompress(string(sxpar(hd,'CRVAL2')),/remove)
	size=strcompress(string(sxpar(hd,'NAXIS1')*abs(sxpar(hd,'CD1_1'))*1800),/remove)
	
	spawn,"rm -rf /tmp/2mass_idl.dat"
	spawn,"scat -c tmc "+ra+" "+dec+" J2000 -r "+size+" -n 3000 -d> /tmp/2mass_idl.dat"
	readcol,'/tmp/2mass_idl.dat',a,ra,dec,m1,m2,mag
	
	adxy,hd,ra,dec,x,y

	
	ref={id:findgen(n_elements(ra)),ra:ra,dec:dec,x:x,y:y,mj:m1,mh:m2,mk:mag}
END


PRO GETFLUX
	COMMON share,config
	loadconfig

	file=['ni1','ni2','ni3','ni4','ni5','ni6']
	
	source=['1','2','3','4','6']
	xx=[21,31,22,28,43]
	yy=[40,33,32,24,46]
	
	;f=fltarr(9)
	;e=fltarr(9)
	for j=0,4 do begin
		for i=0,5 do begin
			factor=1.2
			readcol,config.path+file[i]+'.sex',id,iso_ferr,flux, flux_err,mag,magerr,$
				x,y,a,b,flag,/silent	
			ind=where(x ge xx[j]-3 and x le xx[j]+3 and y ge yy[j]-3 and y le yy[j]+3, count)
			
			if (count eq 1) then begin
				print,format='(a2,tr2,a3,tr2,f7.2,tr2,f7.3)',$
					source[j],file[i],0.033846*flux[ind],(a[ind]+b[ind])*3600*factor
		   endif else begin
		   	print,format='(a2,tr2,a3,a)',source[j],file[i],'--------------'
		   endelse
			;e[i]=0.033846*flux_err[ind]
			;print,count
		endfor
	endfor
	;print,f,e
END



