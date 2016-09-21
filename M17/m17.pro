PRO LOADCONFIG
	COMMON share,imgpath, mappath
	
	;Settings for HOME computer
	imgpath = '/Volumes/disk1s1/Projects/M17/'
	mappath = '/Volumes/disk1s1/Projects/M17/'
	
	;Settings for ASIAA computer
	;imgpath='/arrays/cfht/cfht_2/chyan/home/Science/m17_region1/'
	;mappath='/arrays/cfht/cfht_2/chyan/home/Science/m17_region1/'
	
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
	
	im1=readfits(path+'m17_region1_J_coadd.fits',hd1)
	im2=readfits(path+'m17_region1_H_coadd.fits',hd2)
	im3=readfits(path+'m17_region1_Ks_coadd.fits',hd3)
	im4=readfits(path+'m17_region1_H2_coadd.fits',hd4)
	
	;
	; scale image to the same dimension
	hastrom, im2,hd2,tim2,thd2,hd1
	
	;
	; Generate a header with center at 05:39:13.0 35:45:54.0
	shd=hd1
	;sxaddpar,shd,'CRVAL1',84.8041667
	;sxaddpar,shd,'CRVAL2',35.765
	;sxaddpar,shd,'CRPIX1',2700
	;sxaddpar,shd,'CRPIX2',2700
	
	;
	; scale image to the same dimension
	hastrom, im1,hd1,tim1,thd1,shd
	hastrom, im2,hd2,tim2,thd2,shd
	hastrom, im3,hd3,tim3,thd3,shd
	hastrom, im4,hd4,tim4,thd4,shd
	
	;
	; cut interesting area
	
	;hextract, tim1, thd1, nim1,nhd1,2188,3211,2188,3211
	;hextract, tim2, thd2, nim2,nhd2,2188,3211,2188,3211
	;hextract, tim3, thd3, nim3,nhd3,2188,3211,2188,3211
	;hextract, tim4, thd4, nim4,nhd4,2188,3211,2188,3211
	;hextract, tim5, thd5, nim5,nhd5,2188,3211,2188,3211

	;
	; Replace nan in image
	;
	ind=where(tim1 eq 0)
	tim1[ind]=20000

	ind=where(tim2 eq 0)
	tim2[ind]=20000

	ind=where(tim3 eq 0)
	tim3[ind]=20000

	ind=where(tim4 eq 0)
	tim4[ind]=4000
		
	
	image={j:tim1,h:tim2,k:tim3,h2:tim4}
	header={j:thd1,h:thd2,k:thd3,h2:thd4}
	
	return

END
PRO SAVEFITS, image, header
	COMMON share,imgpath, mappath
	loadconfig
	
	writefits,imgpath+'m17_region1_j.fits',smooth(image.j,2),header.j
	writefits,imgpath+'m17_region1_h.fits',smooth(image.h,2),header.h
	writefits,imgpath+'m17_region1_k.fits',smooth(image.k,2),header.k
	writefits,imgpath+'m17_region1_h2.fits',smooth(image.h2,2),header.h2
;	writefits,imgpath+'m17_region1_brg.fits',image.brg,header.brg

END


PRO DOSTIFF
	COMMON share,imgpath, mappath
	loadconfig
	
	cd,imgpath
	spawn, 'stiff -c stiff.conf m17_region1_k.fits '$
		+'m17_region1_h.fits m17_region1_j.fits '$
		+'-GAMMA 1.5 -COLOUR_SAT 1.1 -MIN_LEVEL 0.01'
END


PRO M17
	COMMON share,imgpath, mappath
	loadconfig
	
	resizeimage,im,hd
	savefits,im,hd
	dostiff
END