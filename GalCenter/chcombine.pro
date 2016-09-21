	
	file='cs76-ch.fits'
	outfile='cs76-sum.fits'
	
	vel_range=[-75,75]
	
	im=readfits(file,hd)


	del_v=sxpar(hd,'CDELT3')
	ref_v=sxpar(hd,'CRVAL3')
	channel=sxpar(hd,'NAXIS3')

	; Convert velocity to km s-1
	ch_v=(ref_v+(findgen(channel)+1)*del_v)/1000.0
	
	
	; Convert from velocity range to channel range
	; chl_range=[16,31]
	chl_range=round(((vel_range*1000.0)-ref_v)/del_v)-1
	
	
	
	print,chl_range

	for i=chl_range[0],chl_range[1] do begin
		if i eq chl_range[0] then tim=im[*,*,i] else tim=tim+im[*,*,i]
	
	endfor
	
	writefits,outfile,tim,hd
END