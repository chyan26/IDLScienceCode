PRO CFHTIR_BUILDBADPIX, DARK=dark, FLAT=flat, FILE=file
	
	
	
	hdr=headfits(dark)
	bzero = sxpar(hdr,"BZERO")
	
	darkimg = readfits(dark)+bzero
	
	badpix = intarr(1024,1024)
	badpix[*,*] = 1
	
	med=median(darkimg)
	mad=median(abs(darkimg-med))/0.674433
	
	ind = where(darkimg ge med+50*mad or darkimg le med-50*mad)
	
	badpix[ind] = fix(0)

	if keyword_set(flat) then begin
		flatimg = readfits(flat)
		inx=where(flatimg ge 1.3 or flatimg le 0.7)
		badpix[inx]=fix(0)
	endif 
	
	sxaddpar, hd, 'SIMPLE', 'T'
	sxaddpar, hd, 'BITPIX', 8, 'Bit per pixel'
	sxaddpar, hd, 'NAXIS', 2 
	sxaddpar, hd, 'NAXIS1', 1024
	sxaddpar, hd, 'NAXIS2', 1024
	writefits,file,badpix,hd

END