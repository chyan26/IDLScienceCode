PRO CFHTIR_BUILDSKY, FILE = file, SKY=sky
	datapath='/arrays/cfht_2/chyan/qso_ir/'
	redpath='/arrays/cfht_2/chyan/qso_ir/'
	prefix='red782'
	obj_suffix='o.fits'

	
	filelist = datapath+prefix+strcompress(string(file),/remove)+obj_suffix
	
	im = fltarr(1024,1024,n_elements(filelist))
	final=fltarr(1024,1024)
	skyimg= fltarr(1024,1024)
	
	
	hdr = headfits(filelist[0])
	
	
	skyrate = fltarr(n_elements(filelist))
	
	
	for i=0, n_elements(filelist)-1 do begin
		hd = headfits(filelist[i])
		exptime = sxpar(hd,"EXPTIME")
		im[*,*,i] = readfits(filelist[i])/exptime
		skyrate[i] = median(im[*,*,i])/exptime
	endfor
	
	skylv_variation = skyrate/median(skyrate)
	
	print,skylv_variation
	
	for i=0, n_elements(filelist)-1 do begin
		im[*,*,i] = im[*,*,i] / skylv_variation[i]
	endfor
	
	
	for x=0,1023 do begin
		for y=0,1023 do begin
			final[x,y]=mean(im[x,y,*])
			skyimg[x,y]=median(im[x,y,*])
		endfor	
	endfor
	
	med=median(skyimg)
	mad=median(abs(skyimg-med))/0.674433
	
	;print,med,mad,stddev(final)
	;put bright star mask
	inx = where(final ge med+5*mad or final le med-5*mad)
	skyimg[inx] = med
	;final[inx]=0
	
	;skyimg = skyimg/median(skyimg)
	
	writefits,redpath+sky,skyimg,hdr

END



