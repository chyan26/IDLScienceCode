PRO BUILDMASK
  COMMON share,config
  loadconfig
 	
	spawn,'ls '+config.calibpath+'*twf*.fits',list
  file=config.calibpath+list

	badpix = intarr(1024,1024)
	badpix[*,*] = 1
	print,list
	
	
	;if keyword_set(flat) then begin
	for i=0,n_elements(list)-1 do begin	
		flatimg = readfits(list[i])
		inx=where(flatimg ge 1.3 or flatimg le 0.7)
		badpix[inx]=fix(0)
	endfor 
	
	sxaddpar, hd, 'SIMPLE', 'T'
	sxaddpar, hd, 'BITPIX', 8, 'Bit per pixel'
	sxaddpar, hd, 'NAXIS', 2 
	sxaddpar, hd, 'NAXIS1', 1024
	sxaddpar, hd, 'NAXIS2', 1024
	writefits,config.calibpath+'badpixel.fits',badpix,hd

END