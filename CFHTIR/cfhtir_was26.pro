pro Getdxdy, x, y, x1, y1, dx, dy

	dx = fltarr(n_elements(x)*n_elements(x1))
	dy = fltarr(n_elements(x)*n_elements(x1))
	n = 0L
	for i=0, n_elements(x1)-1 do begin
		for j=0, n_elements(x)-1 do begin
			dx[n] = x1[i] - x[j]
			dy[n] = y1[i] - y[j]
			n = n+1
		endfor
	endfor
	
end


PRO AUTO_FIND, IM, FWHM,RMS, SIGMA, X, Y, FLUX
        hmin=rms*sigma
        sharplim=[0.2,1.0]
        roundlim=[-1.0,1.0]
        find,im,x,y,flux,sharp,round,hmin,fwhm,roundlim,sharplim,/silent
END



PRO cfhtir_stackimage, FILE=file, STACK=stack
	
	datapath='/arrays/cfht_2/chyan/CFHTIR/'
	redpath='/arrays/cfht_2/chyan/qso_ir/'
	prefix='782'
	redprefix = 'red782'
	obj_suffix='o.fits'

	redfile = redpath+stack
	
	;fits1=redpath+redprefix+'758'+obj_suffix
	;fits2=redpath+redprefix+'759'+obj_suffix
	
	fwhm=4
	sigma=8
	
	filelist = redpath+redprefix+strcompress(string(file),/remove)+obj_suffix
	
	fits1=filelist[0]
	im1=readfits(fits1,hdr1)
	ra1=sxpar(hdr1,"RA_DEG")		
	dec1=sxpar(hdr1,"DEC_DEG")		

	rms1=median(abs(im1-median(im1)))/0.67
	auto_find, im1, fwhm,rms1, sigma, X1, Y1, FLUX
		
	for i=1,n_elements(filelist)-1 do begin
				
		xshift=-99999.0
		yshift=-99999.0
		fits2=filelist[i]
		
		im2=readfits(fits2,hdr2)
		
		ra2=sxpar(hdr2,"RA_DEG")		
		dec2=sxpar(hdr2,"DEC_DEG")		
	
		rms2=median(abs(im2-median(im2)))/0.67
		auto_find, im2, fwhm,rms2, sigma, X2, Y2, FLUX
		
		Getdxdy, x1, y1 ,x2, y2, dx, dy
	
		xhist=histogram(abs(dx))
		xx = findgen(n_elements(xhist))
	
		inx= where(xhist eq max(xhist))
		if (ra2-ra1 gt 0) then xshift=-xx(inx[0])
		if (ra2-ra1 eq 0) then xshift=0
		if (ra2-ra1 lt 0) then xshift=xx(inx[0])
	
		yhist=histogram(abs(dy))
		yy = findgen(n_elements(yhist))
		iny= where(yhist eq max(yhist))
		if (dec2-dec1 gt 0) then yshift=yy(iny[0])
		if (dec2-dec1 eq 0) then yshift=0
		if (dec2-dec1 lt 0) then yshift=-yy(iny[0])

		print,xshift,yshift
	
		factor = median(im1)/median(im2)
		im2=im2*factor
	
		print,median(im1),median(im2)
	
		sim=shift(im2,xshift,yshift)
		fim=intarr(1024,1024)
		nim=intarr(1024,1024)
		fim[*,*]=1
		nim[*,*]=1
	
		if (xshift lt 0) then begin 
			sim[1023+xshift:1023,*] = 0
			nim[1023+xshift:1023,*] = nim[1023+xshift:1023,*]-1
		endif
		if (xshift gt 0) then begin
			sim[0:xshift,*] = 0
			nim[0:xshift,*] = 0
		endif
		if (yshift lt 0) then begin
			sim[*,1023+yshift:1023] = 0
			nim[*,1023+yshift:1023] = 0
		endif
		if (yshift gt 0) then begin
			sim[*,0:yshift] = 0
			nim[*,0:yshift]=0 
		endif
	
	
		final=(im1+sim)/(fim+nim)
		;th_image_cont, fim+nim,/nocont
		;th_image_cont,shift(im2,xshift,yshift),/nocont,crange=[100,300]
	endfor
	writefits,redfile,final,hdr1	

END

PRO cfhtir_stack_was26, FILE=file, STACK=stack
	
	datapath='/arrays/cfht_2/chyan/CFHTIR/'
	redpath='/arrays/cfht_2/chyan/qso_ir/'
	prefix='782'
	redprefix = 'red782'
	obj_suffix='o.fits'

	redfile = redpath+stack
	
	;fits1=redpath+redprefix+'758'+obj_suffix
	;fits2=redpath+redprefix+'759'+obj_suffix
	
	fwhm=4
	sigma=8
	
	filelist = redpath+redprefix+strcompress(string(file),/remove)+obj_suffix
	
	fits1=filelist[0]
	im1=readfits(fits1,hdr1)
	ra1=sxpar(hdr1,"RA_DEG")		
	dec1=sxpar(hdr1,"DEC_DEG")		

	;rms1=median(abs(im1-median(im1)))/0.67
	th_image_cont,im1,/nocont,crange=[0,3000]
	print,'Click on AGN...'
	cursor,x,y,/down
	CNTRD, im1, x, y, x1, y1, 8
	print,'x1=',x1,',y1',y1
	
	;auto_find, im1, fwhm,rms1, sigma, X1, Y1, FLUX
		
	for i=1,n_elements(filelist)-1 do begin
				
		xshift=-99999.0
		yshift=-99999.0
		fits2=filelist[i]
		
		im2=readfits(fits2,hdr2)
		
		ra2=sxpar(hdr2,"RA_DEG")		
		dec2=sxpar(hdr2,"DEC_DEG")		
	
		;rms2=median(abs(im2-median(im2)))/0.67
		;auto_find, im2, fwhm,rms2, sigma, X2, Y2, FLUX
		th_image_cont,im2,/nocont,crange=[0,3000]
		cursor,a,b,/down
		CNTRD, im2, a, b, x2, y2, 8
		if a eq -1 or b eq -1 then goto, here
		print,'x2=',x2,',y2',y2
		
		dx=x2-x1
		dy=y2-y1
		if (ra2-ra1 gt 0) then xshift=-dx
		if (ra2-ra1 eq 0) then xshift=0
		if (ra2-ra1 lt 0) then xshift=dx
		
	
		
		if (dec2-dec1  gt 0) then yshift=dy
		if (dec2-dec1  eq 0) then yshift=0
		if (dec2-dec1  lt 0) then yshift=-dy
		
		print,xshift,yshift
	
		factor = median(im1)/median(im2)
		im2=im2*factor
	
		print,median(im1),median(im2)
	
		sim=shift(im2,xshift,yshift)
		fim=intarr(1024,1024)
		nim=intarr(1024,1024)
		fim[*,*]=1
		nim[*,*]=1
	
		if (xshift lt 0) then begin 
			sim[1023+xshift:1023,*] = 0
			nim[1023+xshift:1023,*] = nim[1023+xshift:1023,*]-1
		endif
		if (xshift gt 0) then begin
			sim[0:xshift,*] = 0
			nim[0:xshift,*] = 0
		endif
		if (yshift lt 0) then begin
			sim[*,1023+yshift:1023] = 0
			nim[*,1023+yshift:1023] = 0
		endif
		if (yshift gt 0) then begin
			sim[*,0:yshift] = 0
			nim[*,0:yshift]=0 
		endif
	
	
		final=(im1+sim)/(fim+nim)
		;th_image_cont, fim+nim,/nocont
		;th_image_cont,shift(im2,xshift,yshift),/nocont,crange=[100,300]
		here:
		wait, 0.5
	endfor
	writefits,redfile,final,hdr1	

END


;
; Main program begins from here
;
PRO CFHTIR_WAS26
	
	datapath = '/arrays/cfht_2/chyan/CFHTIR/'
	redpath = '/arrays/cfht_2/chyan/qso_ir/'
	calibpath =  redpath+'calib/'

	
	list=[628,628,629,630,631,$
	      	632,633,634,635,636,$
		637,638,639,640,641,$
		642,643,644,645,646,$
		647,648,649,650,651,$
		652,653,654,655]
	
	
	;cfhtir_doreduc, file = list, dark = calibpath+'dark_60s_20051221.fits',$
	;	 flat=calibpath+'domeflat_j_20051221.fits',$
	;	 badpix=calibpath+'badpix_20051223.fits'
	
	;cfhtir_buildsky, file=list, sky='sky_pg0844_20060108.fits'
	
	;cfhtir_doreduc, file = list, dark = calibpath+'dark_60s_20051221.fits',$
	;	 flat=calibpath+'domeflat_j_20051221.fits', sky='sky_pg0844_20060108.fits',$
	;	 badpix=calibpath+'badpix_20051223.fits',bias=1000,/invertew
	
	cfhtir_stack_was26, file = list, stack='was26.fits'
	
END