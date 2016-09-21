im=readfits('/scr3/Confusion/Fits/sma_d_030411_2.fits')

imm=smooth2(im,10)

;a=moment(im)	
;rms=sqrt(a(1))

rms=stddev(im)
sigma=3.0
fwhm=31
auto_find_sma,imm,fwhm,rms,sigma,x,y,flux


th_image_cont,imm,/aspect,levels=[2*rms,3*rms]

oplot,x,y,psym=5,color=255 
end


;PRO AUTO_FIND_SMA, IM, RMS, SIGMA, X, Y, FLUX
;	hmin=rms*sigma 
;	sharplim=[0.07,1.0]
;	roundlim=[-0.5,1.0]
;	find,im,x,y,flux,sharp,round,hmin,fwhm,roundlim,sharplim,/silent
;END
