pro CFHTIR_BUILDDARK

	path='/arrays/cfht_2/chyan/CFHTIR/'
	prefix='7831'
	drk_suffix='d.fits'
	
	dark=[49,50,51,52,53,54,55]
	
	temp=fltarr(1024,1024)	
	for i=0,n_elements(dark)-1 do begin
	
		filename=path+prefix+strcompress(string(dark(i)),/remove)+drk_suffix
		hdr=headfits(filename)
		ext=sxpar(hdr,"NAXIS3")
		exptime = sxpar(hdr,"EXPTIME")
		bzero = sxpar(hdr,"BZERO")
		drkim=fltarr(1024,1024,ext)
		drkim=readfits(filename)+bzero
		for x=0, 1023 do begin
			for y=0, 1023 do begin
				temp[x,y]=median(drkim[x,y,*])
			endfor
		endfor
		writefits,'/arrays/cfht_2/chyan/qso_ir/calib/dark_'$
			+strcompress(string(fix(exptime)),/remove)+'s_20051221.fits',temp,hdr
	endfor

end