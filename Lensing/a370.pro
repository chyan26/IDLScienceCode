PRO LOADCONFIG
	COMMON share,imgpath, mappath
	
	;Settings for HOME computer
	;imgpath = '/Volumes/disk1s1/A370/'
	;mappath = '/Volumes/disk1s1/A370/'
	
	;Settings for ASIAA computer
	imgpath='/data/chyan/ScienceImages/Lensing/'
	mappath='/data/chyan/ScienceImages/Lensing/'

	
END		


PRO RESIZEIMAGE, image, header
	COMMON share,imgpath, mappath
	
	loadconfig
	; Load images
	path=imgpath
	
	im1=readfits(path+'A370_J_coadd.fits',hd1)
	im2=readfits(path+'A370_H_coadd.fits',hd2)
	im3=readfits(path+'A370_Ks_coadd.fits',hd3)
	
	;
	; scale image to the same dimension
	hastrom, im2,hd2,tim2,thd2,hd1
	
	;
	; Generate a header with center at 05:39:13.0 35:45:54.0
	shd=hd1
	
	;
	; scale image to the same dimension
	hastrom, im1,hd1,tim1,thd1,shd
	hastrom, im2,hd2,tim2,thd2,shd
	hastrom, im3,hd3,tim3,thd3,shd
	
	;
	; cut interesting area
	
; 	hextract, tim1, thd1, nim1,nhd1,2188,3211,2188,3211
; 	hextract, tim2, thd2, nim2,nhd2,2188,3211,2188,3211
; 	hextract, tim3, thd3, nim3,nhd3,2188,3211,2188,3211
; 	hextract, tim4, thd4, nim4,nhd4,2188,3211,2188,3211
; 	hextract, tim5, thd5, nim5,nhd5,2188,3211,2188,3211

	;
	; Replace nan in image
	;
; 	repnan, nim1, max(nim1)
; 	repnan, nim2, max(nim2)
; 	repnan, nim3, max(nim3)
; 	repnan, nim4, max(nim4)
; 	repnan, nim5, max(nim5)

	ind=where(tim1 ge 200)
	tim1[ind]=200
	ind=where(tim1 le -10)
	tim1[ind]=-10

	ind=where(tim2 ge 200)
	tim2[ind]=200
	ind=where(tim2 le -10)
	tim2[ind]=-10

		
	ind=where(tim3 ge 500)
	tim3[ind]=500
	ind=where(tim3 le -20)
	tim3[ind]=-20
	
	image={j:tim1,h:tim2,k:tim3}
	header={j:thd1,h:thd2,k:thd3}
	
	return

END

PRO SAVEFITS, image, header
	COMMON share,imgpath, mappath
	loadconfig
	
	writefits,imgpath+'A370_j.fits',image.j,header.j
	writefits,imgpath+'A370_h.fits',image.h,header.h
	writefits,imgpath+'A370_k.fits',image.k,header.k

END

PRO DOSTIFF
	COMMON share,imgpath, mappath
	loadconfig

	cd,imgpath
	spawn,'stiff -c stiff.conf A370_k.fits '$
			+'A370_h.fits A370_j.fits '$
 			+'-GAMMA 1.5 -COLOUR_SAT 4.0 '$
			+'-MIN_LEVEL 0.6 -MAX_LEVEL 0.9999'
 			;+'-MIN_TYPE MANUAL -MIN_LEVEL -20 '$
; 			+'-MAX_TYPE MANUAL -MAX_LEVEL 80'
END

PRO A370
	COMMON share,imgpath, mappath
	loadconfig
	resizeimage,im,hd
	savefits,im,hd
	dostiff
END