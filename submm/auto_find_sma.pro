PRO AUTO_FIND_SMA, IM, FWHM,RMS, SIGMA, X, Y, FLUX
	hmin=rms*sigma 
	sharplim=[0.07,1.0]
	roundlim=[-0.5,1.0]
	find,im,x,y,flux,sharp,round,hmin,fwhm,roundlim,sharplim,/silent
END
