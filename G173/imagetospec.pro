

;PRO IMAGETOSPEC

	fits='/Volumes/Data/Projects/G173/ARO/CO_s233ir_otf_allbackend.fits'

	im=readfits(fits,hd)
	;im=mrdfits(fits,0,hd)
	naxis3=sxpar(hd,'NAXIS3')
	bzero=sxpar(hd,'BZERO')
	bscale=sxpar(hd,'BSCALE')
	
	dv=sxpar(hd,'CDELT3')
	
	vstart=sxpar(hd,'CRVAL3')-(sxpar(hd,'CRPIX3')*sxpar(hd,'CDELT3'))

	varr=(findgen(naxis3)+1)*dv+vstart


	plot,varr/1000.0,im[334,169,*],psym=10
	

END