PRO CFHTIR_DOREDUC,FILE=file, DARK=dark, FLAT=flat, BADPIX=badpix, SKY=sky,$
		CORRECT_AMPNOISE=correct_ampnoise, INVERTEW = invertew, BIAS =bias
		
	
	datapath='/arrays/cfht_2/chyan/CFHTIR/'
	redpath='/arrays/cfht_2/chyan/qso_ir/'
	prefix='782'
	redprefix = 'red782'
	obj_suffix='o.fits'

	
	dhd = headfits(dark)
	dtime = sxpar(dhd,"EXPTIME")
	
	darkimg = readfits(dark)
	flatimg = readfits(flat)
	
	if keyword_set(BADPIX) eq 1 then begin
		print,'Reading bad pixel =>',badpix
		badpiximg = readfits(badpix)
	endif else begin
		badpiximg = fltarr(1024,1024)
		badpiximg[*,*] = 1
	endelse
	
	if keyword_set(sky) eq 1 then begin
		print,'Reading sky image =>',sky
		skyimg = readfits(redpath+sky)
	endif else begin
		skyimg = fltarr(1024,1024)
		skyimg[*,*] = 0
	endelse

	filelist = datapath+prefix+strcompress(string(file),/remove)+obj_suffix
	redfile = redpath+redprefix+strcompress(string(file),/remove)+obj_suffix
	
	

	for i=0, n_elements(filelist)-1 do begin
	
		hdr=headfits(filelist[i])
		xsize = sxpar(hdr,"NAXIS1")
		ysize = sxpar(hdr,"NAXIS2")
		ncube = sxpar(hdr,"NAXIS3")
		bzero = sxpar(hdr,"BZERO")
		exptime = sxpar(hdr,"EXPTIME")
		
		im = readfits(filelist[i],/SILENT)+bzero
		
		print,strcompress(string(filelist[i]),/remove),$
			median(im),median(abs(im-median(im)))/0.674433

		
		
		im = im - (darkimg*(exptime/dtime))
		im = im/(flatimg)
		print,median(im)
		im = (im-(median(im)*skyimg))
		
		for x=0,xsize-1 do begin
			for y=0,ysize-1 do begin
				im(x,y)=median(im[x,y,*])
			endfor	
		endfor
		
		im = im*badpiximg
		
		;fill median to pixel with 0 value
		inx= where(im eq 0)
		im[inx]=median(im)
		
		;correcting row effect
		if keyword_set(correct_ampnoise) then begin
			row =fltarr(xsize)
			temp = smooth(im,5)
			for y=0, ysize-1 do begin
				row[y] = median(temp[*,y])
			endfor
		
			for y=0, ysize-1 do begin
				im[*,y] = im[*,y] - row
			endfor
		endif 
		
		
		final =fltarr(1024,1024)
		; invert E-W direction
		if keyword_set(invertew) then begin
			print,' invert EW '
			for x=0, xsize-1 do begin
				final[x,*] = im[xsize-1-x,*]
			endfor
		endif else begin
			final = im
		endelse
		
		print,strcompress(string(filelist[i]),/remove),$
			median(final),median(abs(final-median(final)))/0.674433
		
		sxaddpar, hdr, 'BZERO', 0, 'Zero point'
		if keyword_set(bias) then begin
			sxaddpar, hdr, 'CHIPBAIS', 1000, 'Zero point'
			ind = where(final ne 0)
			final[ind] =final[ind]+1000
		endif
		writefits,redfile[i],final,hdr
	endfor

END

