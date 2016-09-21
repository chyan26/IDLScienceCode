PRO CFHTIR_BUILDFLAT, FLAT_ON=flat_on, FLAT_OFF=flat_off, FLATNAME=flatname
	
	datapath='/arrays/cfht_2/chyan/CFHTIR/'
	calibpath='/arrays/cfht_2/chyan/qso_ir/calib/'
	prefix='782'
	flt_suffix='f.fits'
	
	;The following are J band flat
	;flat_on=[527,528,529,530,531,538,539,540,541]
	;flat_off=[532,533,534,535,536,542,543,544,545]
	
	;The following are J band flat
	;flat_on=[527,528,529,530,531]
	;flat_off=[532,533,534,535,536]

	
	
	dark = calibpath+'dark_15s_20051221.fits'
	
	
	on_file=datapath+prefix+strcompress(string(flat_on),/remove)+flt_suffix
	off_file=datapath+prefix+strcompress(string(flat_off),/remove)+flt_suffix

	hdr=headfits(on_file[0])
	xsize = sxpar(hdr,"NAXIS1")
	ysize = sxpar(hdr,"NAXIS2")
	ncube = sxpar(hdr,"NAXIS3")
	bzero = sxpar(hdr,"BZERO")
	
	flatonim=fltarr(xsize,ysize,ncube,n_elements(flat_on))
	flatoffim=fltarr(xsize,ysize,ncube,n_elements(flat_off))

	darkimg=readfits(dark)	
	for i=0,n_elements(flat_on)-1 do begin
		;print,filename
		hd = headfits(on_file[i])
		exptime = sxpar(hd,"EXPTIME")
		
		flatonim(*,*,*,i)=(readfits(on_file[i])+bzero)
		for j=0,ncube-1 do begin
			flatonim(*,*,j,i) = flatonim(*,*,j,i)-(darkimg*exptime/15)
		endfor
	endfor

	for i=0,n_elements(flat_off)-1 do begin
		hd = headfits(on_file[i])
		exptime = sxpar(hd,"EXPTIME")
		;print,filename
		flatoffim(*,*,*,i)=(readfits(off_file[i])+bzero)
		for j=0,ncube-1 do begin
			flatoffim(*,*,j,i) = flatoffim(*,*,j,i)-(darkimg*exptime/15)
		endfor
	endfor
	
	im1 = fltarr(1024,1024)
	im2 = fltarr(1024,1024)
	for i=0,1023 do begin
		for j=0,1023 do begin
			im1(i,j)=median(flatonim(i,j,*,*))
			im2(i,j)=median(flatoffim(i,j,*,*))
		endfor	
	endfor
	
	
	final = im1-im2
	final = final /median(final)
	;writefits,calibpath+'/domeflat_'$
	;		+strcompress(string(sxpar(hdr,"WHEELBDE")),/remove)+'_20051221.fits',final,hdr

	writefits,calibpath+flatname,final,hdr
	
end
