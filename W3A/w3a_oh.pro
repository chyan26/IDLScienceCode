PRO LOADCONFIG
	COMMON share,imgpath, mappath
	
	;Settings for HOME computer
	imgpath = '/Volumes/disk1s1/WIRCamPR/W3A_FITS/'
	mappath = '/Volumes/disk1s1/WIRCamPR/W3A_FITS/'
	
	;Settings for ASIAA computer
	;imgpath='/arrays/cfht/cfht_2/chyan/home/Science/S233IR/'
	;mappath='/arrays/cfht/cfht_2/chyan/home/Science/S233IR/'
	
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
	
	im1=readfits(path+'W3OH_1_J_coadd.fits',hd1)
	im2=readfits(path+'W3OH_1_H_coadd.fits',hd2)
	im3=readfits(path+'W3OH_1_H2_coadd.fits',hd3)
	
	;
	; scale image to the same dimension
	hastrom, im2,hd2,tim2,thd2,hd1
	
	;
	; Generate a header with center at 05:39:13.0 35:45:54.0
	shd=hd1
	;sxaddpar,shd,'CRVAL1',3.680630145E+01
	;sxaddpar,shd,'CRVAL2',6.182565699E+01
	;sxaddpar,shd,'CRPIX1',2537
	;sxaddpar,shd,'CRPIX2',2543.5
	
	;
	; scale image to the same dimension
	hastrom, im1,hd1,tim1,thd1,shd
	hastrom, im2,hd2,tim2,thd2,shd
	hastrom, im3,hd3,tim3,thd3,shd
	
	;
	; cut interesting area
	
	;hextract, tim1, thd1, nim1,nhd1,400,4650,2630,4680
	;hextract, tim2, thd2, nim2,nhd2,400,4650,2630,4680
	;hextract, tim3, thd3, nim3,nhd3,400,4650,2630,4680

	
	
	image={j:tim1,h:tim2,h2:tim3}
	header={j:thd1,h:thd2,h2:thd3}
	
	return

END
PRO SAVEFITS, image, header
	COMMON share,imgpath, mappath
	loadconfig
	
	ind=where(image.j eq 0)
	image.j[ind]=400
	ind=where(image.h eq 0)
	image.h[ind]=400
	ind=where(image.h2 eq 0)
	image.h2[ind]=400
	
	writefits,imgpath+'w3oh_j.fits',image.j,header.j
	writefits,imgpath+'w3oh_h.fits',image.h,header.h
	writefits,imgpath+'w3oh_h2.fits',image.h2,header.h2

END

PRO DOSTIFF
	COMMON share,imgpath, mappath
	loadconfig
	
	cd,imgpath
	spawn, 'stiff -c stiff.conf w3oh_h2.fits w3oh_h.fits w3oh_j.fits '$
		+'-GAMMA 1.7 -COLOUR_SAT 1.2 -MIN_LEVEL 0.01 -MAX_LEVEL 0.995'
END

PRO GO
	resizeimage,im,hd
	savefits,im,hd   
	dostiff
END