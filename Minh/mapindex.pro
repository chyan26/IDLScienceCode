PRO mapindex



   im1420=readfits('1420mhz_aquila.fits')
   im408=readfits('408mhz_aquila.fits')

   ;S ~ nu^-alpha .  So alpha=-log(S1/s2)/log(nu2/nu1).

   alpha=-alog10(im408/im1420)/alog10(1420/408)
   
   writefits,'alpha.fits',alpha
END