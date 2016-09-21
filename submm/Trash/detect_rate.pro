

fit1='/scr1/Confusion/Fits/sma_c_030208_01.fits'
im=mrdfits(fit1,0)
th_image_cont,im,/nocont,range=[0,0.03],/log


fwhm=11.74
hmin=0.00124
find,im,x,y,flux,sharp,round,hmin,fwhm
oplot,x,y,psym=5
end
