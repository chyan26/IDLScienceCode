PRO PLOTFWHM, IM, X, Y, PSFBOX
	print,'1',x,y
	s=size(im)	
	if x-psfbox+1 le 0 or x+psfbox ge s[1] or y-psfbox+1 le 0 $
	or y+psfbox ge s[1] then begin
		print,'This stars is on the edge of image. '+$
		strcompress(string(x),/remove)+' '+$
		strcompress(string(y),/remove)
	endif else begin
		
		;th_image_cont,im
		im1=im[x-psfbox+1:x+psfbox,y-psfbox+1:y+psfbox]
		window,1
		wset,1
		th_image_cont,im1,/nocont
		wset,0
		
		CNTRD, im1, psfbox, psfbox, x1, y1, 3
		
		;x1=psfbox
		;y1=psfbox
		
		;th_image_cont,im1,/nocont
		
		n=0
		flux =fltarr(n_elements(im1))
		r=fltarr(n_elements(im1))
		for i=0,psfbox*2-1 do begin
			for j=0,psfbox*2-1 do begin
				flux[n]=im1[i,j]
				r[n]=sqrt((i-x1)^2+(j-y1)^2)
				n=n+1
			endfor
		endfor
		yfit=gaussfit(r,flux,coeff,sigma=sigma)
		fwhm=coeff[2]
		plot,r,flux,psym=1,xrange=[0,20],yrange=[min(flux),min(flux)],$
		xtitle='Radius', ytitle='Flux',$
		title='X= '+strcompress(string(x1),/remove)+' Y= '+$
		strcompress(string(y1),/remove)+' FWHM= '$
		+strcompress(string(fwhm*0.2),/remove),$
		 charsize=1.2  

		oplot,r,yfit,color=255
	endelse
END

PRO PLOTPSF, IM, X, Y, PSFBOX
	getpsf,im,x,y,12,median(im),gauss,psf
	plot,psf

END


PRO cfhtir_iras17596

	psfbox=32

	file = 'iras17596.fits'
	path = '/arrays/cfht_2/chyan/qso_ir/'
	image='/asiaa/home/chyan/WIRCam_img/sexoptim/red824923o-01.fits'
	
	im=readfits(path+file)
	;im=mrdfits(image,1)
	
	th_image_cont,smooth(im,2),/nocont,crange=[1100,1300],/nobar  
	;th_image_cont,im,/nocont,crange=[11000,14000],/nobar 
	print,'Central AGN.....'
	cursor,x,y,/down
	
	plotpsf, im, x,y,psfbox
	
	;print,'Ref star.....'
	;cursor,x,y,/down
	;CNTRD, im, x, y, x2, y2
	;im2=im[x2-20:x2+20,y2-20:y2+20]
	;im2=im2/median(im2)
	
	;im1=im[x1-20:x1+20,y1-20:y1+20]
	;print,x1,y1
	
	
	
	;im2=im[x2-20:x2+20,y2-20:y2+20]
	;final=im1-im2
	
	;window,1
	;wset,1
	;th_image_cont,final,/nocont,/nobar
	;writefits,path+'iras17596_agn.fits',final
	
	;wset,0
end