PRO LOADCONFIG
	COMMON share,imgpath, mappath
	;Settings for HOME computer
	;imgpath = '/home/chyan/iras/'
	;mappath = '/home/chyan/iras/'
	
	;Settings for ASIAA computer
	imgpath='/arrays/cfht_2/chyan/WIRCam/Project/05BT06/stacked/RED_061227/'
	mappath='/asiaa/home/chyan/IRAS20126/'
	
	return 
END

PRO GETCOORD;,im,CRANGE=crange
	;resetplt,/all
	;th_image_cont,im,/nocont,crange=crange,/nobar,/aspect
	cursor,x,y
	print,x,y

END

; This function is used to load mosiacing Ks band and H2 images from disk 
PRO LOADIMAGE, ks, h2, ks_hd, h2_hd
	COMMON share,imgpath
	
	loadconfig
	; Load images
	path=imgpath
	
	im1=readfits(path+'IRAS20126_H2.fits',hd1)
	im2=readfits(path+'IRAS20126_Ks.fits',hd2)
	;
	; scale image to the same dimension
	hastrom, im2,hd2,tim2,thd2,hd1
	
	;
	; Generate a header with center at 20:14:25.1 +41:13:32.0
	shd=hd1
	sxaddpar,shd,'CRVAL1',303.6045833
	sxaddpar,shd,'CRVAL2', 41.2255555
	;
	; scale image to the same dimension
	hastrom, im1,hd1,tim1,thd1,shd
	hastrom, im2,hd2,tim2,thd2,shd
	
	;
	; cut interesting area
	hextract, tim1, thd1, nim1,nhd1,2024,4072,1536,3584
	hextract, tim2, thd2, nim2,nhd2,2024,4072,1536,3584
	
	
	; Restore raw image
	h2=nim1
	ks=nim2

	ks_hd=nhd2
	h2_hd=nhd1
	return
END

PRO GENERATE_MASK, mask, im
	
	; detecting point source
	fwhm=2
	hmin=400
	sharplim=[0.2,1.0]
	roundlim=[-1.0,1.0]
	find,im,x,y,flux,sharp,round,hmin,fwhm,roundlim,sharplim,/silent
	
	; flag unwanted data points

	ind=where((x ge 351 and x le 546 and y ge 653 and y lt 1120) or $
			(x ge 342 and x le 662 and y ge 1172 and y lt 1236) or $
			(x ge 569 and x le 745 and y ge 1250 and y lt 1333) or $
			(x ge 301 and x le 361 and y ge 829 and y lt 1000) or $
			(x ge 606 and x le 764 and y ge 1329 and y lt 1426),complement=inx)
	th_image_cont,im,/nocont,crange=[0,60],/aspect
	oplot,x[inx],y[inx],color=255,psym=4
	;th_image_cont,h2-ks/13,crange=[-5,5],/nocont
	;oplot,x[inx],y[inx],psym=4,color=255
	
	
	; Building star mask
	imst=fltarr(n_elements(im[*,0]),n_elements(im[0,*]))
	mask=fltarr(n_elements(im[*,0]),n_elements(im[0,*]))
	imst[*,*]=0
	mask[*,*]=0
	
	; Building deconvole kernel
	psf=psf_gaussian(npixel=20,fwhm=6)
	
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
   im=(xim1-xim2*0.9)*mask
   dust=ks-h2

END


PRO IRAS20126
	common share, imgpath, mappath
	loadconfig
	
	; Load image
	loadimage,ks,h2,hd1,hd2
	subtract_cont,ks,h2,dust,im
	
	;th_image_cont,im,crange=[0,50],/nobar,level=[60.0,80.0,120.0]
	
	writefits,mappath+'iras20126_H2.fits',im,hd1
	;th_image_cont,medsmooth(h2-ks*1.1,5),/nocont,crange=[0,100],/aspect

END

