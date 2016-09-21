PRO LOADCONFIG
	COMMON share,imgpath, mappath
	
	;Settings for HOME computer
	imgpath = '/Volumes/disk1s1/PerseusA/'
	mappath = '/Volumes/disk1s1/PerseusA/'
	
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
	
	im1=readfits(path+'07BT04_BrG_coadd.fits',hd1)
	im2=readfits(path+'07BT04_H2_coadd.fits',hd2)
	
	;
	; scale image to the same dimension
	hastrom, im2,hd2,tim2,thd2,hd1
	
	;
	; Generate a header with center at 05:39:13.0 35:45:54.0
	shd=hd1
	sxaddpar,shd,'CRVAL1',4.995066533E+01
	sxaddpar,shd,'CRVAL2',4.152215308E+01
	sxaddpar,shd,'CRPIX1',3470.5
	sxaddpar,shd,'CRPIX2',3.552500000E+03
	
	;
	; scale image to the same dimension
	hastrom, im1,hd1,tim1,thd1,shd
	hastrom, im2,hd2,tim2,thd2,shd
	
	;
	; cut interesting area
	
	hextract, tim1, thd1, nim1,nhd1,2956,3988,2929,3953
	hextract, tim2, thd2, nim2,nhd2,2955.5,3987.5,2929,3953

	;
	; Replace nan in image
	;
	;repnan, nim1, max(nim1)
	;repnan, nim2, max(nim2)
	;repnan, nim3, max(nim3)
	;repnan, nim4, max(nim4)
	;repnan, nim5, max(nim5)
	
	
	image={brg:nim1,h2:nim2}
	header={brg:nhd1,h2:nhd2}
	
	return

END

PRO SAVEFITS, image, header
	COMMON share,imgpath, mappath
	loadconfig
	
	writefits,imgpath+'perseus_a_h2.fits',image.h2,header.h2
	writefits,imgpath+'perseus_a_brg.fits',image.brg,header.brg

END

PRO LOADPERA, image, header
	COMMON share,imgpath, mappath
	loadconfig
	
	nim1=readfits(imgpath+'perseus_a_h2.fits',nhd1)
	nim2=readfits(imgpath+'perseus_a_brg.fits',nhd2)
	
	image={h2:nim1,brg:nim2}
	header={h2:nhd1,brg:nhd2}

END
PRO GENERATE_MASK, mask, im
	
	; detecting point source
	fwhm=3
	hmin=5
	sharplim=[0.2,1.0]
	roundlim=[-1.0,1.0]
	find,im,x,y,flux,sharp,round,hmin,fwhm,roundlim,sharplim,/silent
	
	; flag unwanted data points
	
	ind=where((x ge 387 and x le 691 and y ge 412 and y lt 634),$
		complement=inx)
	; Building star mask
	imst=fltarr(n_elements(im[*,0]),n_elements(im[0,*]))
	mask=fltarr(n_elements(im[*,0]),n_elements(im[0,*]))
	imst[*,*]=0
	mask[*,*]=0
	
	; Building deconvole kernel
	psf=psf_gaussian(npixel=10,fwhm=10)
	
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


FUNCTION FILTER_BUTTERWORTH, IM
	; Filtering, usig butterworth algorithm
	filter = butterworth(size(im,/dimension),cutoff=7)
	fim = fft(fft(im, -1)* filter,1)
	
	ffim=double(fim)
	return, ffim
END


PRO SUBTRACT_CONT, brg, h2, hd
   common share, imgpath, mappath
   loadconfig
   generate_mask,mask,h2
   
   ; Masking bright stars
   nim1=h2*mask
   nim2=brg*mask
   
   ; Replace masked pixel with linear interpolation
   fixbadpix,nim1,mask,xim1
   fixbadpix,nim2,mask,xim2
   
   ; Image subtraction to get H2 image
   im=(xim2-xim1*0.85)*mask

   
   writefits,imgpath+'test.fits',im,hd

END




PRO PERA
	COMMON share,imgpath, mappath
	loadconfig
	
	resizeimage,im,hd
	savefits,im,hd
	loadpera,im,hd
	;writefits,imgpath+'test.fits',im.brg-im.h2*0.8
	subtract_cont,im.brg,im.h2,hd
END




