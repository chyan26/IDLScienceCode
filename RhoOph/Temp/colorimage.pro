PRO LOADCONFIG
   COMMON share,config
   
   ;Settings for HOME computer
   imgpath = '/data/chyan/ScienceImages/RhoOph/WIRCam/'
   
   config={path:imgpath}  
END


PRO RESIZEIMAGE
   COMMON share,config
   
   loadconfig
   
   
   im1=readfits(config.path+'06AT08_J_coadd.fits',hd1)
   im2=readfits(config.path+'06AT08_H_coadd.fits',hd2)
   im3=readfits(config.path+'06AT08_Ks_coadd.fits',hd3)
   ;
   ; Generate a header with center 
   shd=hd1
   sxaddpar,shd,'CRVAL1',246.541340
   sxaddpar,shd,'CRVAL2',-24.416663
   sxaddpar,shd,'CRPIX1',3500
   sxaddpar,shd,'CRPIX2',3500
    
   ; scale image to the same dimension
   ;hastrom, im1,hd1,tim1,thd1,shd
   ;'hastrom, im2,hd2,tim2,thd2,shd
   ;hastrom, im3,hd3,tim3,thd3,shd
   
   
   ; Determine the center of the image
   center=sxpar(hd1,'CRPIX*')
   print,center
   size=3500
   ;
   ; cut interesting area
   print,center[0]-size-1,center[0]+size,center[1]-size-1,center[1]+size
   hextract, im1, hd1, nim1,nhd1,center[0]-size-1,center[0]+size,center[1]-size-1,center[1]+size
   hextract, im2, hd2, nim2,nhd2,center[0]-size-1,center[0]+size,center[1]-size-1,center[1]+size
   hextract, im3, hd3, nim3,nhd3,center[0]-size-1,center[0]+size,center[1]-size-1,center[1]+size
      
   repnan, nim1, 0
   repnan, nim2, 0
   repnan, nim3, 0
   
   writefits,config.path+'central_oph_j.fits',nim1,nhd1
   writefits,config.path+'central_oph_h.fits',nim2,nhd2
   writefits,config.path+'central_oph_k.fits',nim3,nhd3

END

PRO PROCIMG
   COMMON share,config
   
   im1=readfits(config.path+'central_oph_j.fits',hd1)
   im2=readfits(config.path+'central_oph_h.fits',hd2)
   im3=readfits(config.path+'central_oph_k.fits',hd3)

   writefits,config.path+'j.fits',smooth(im1,3),hd1
   writefits,config.path+'h.fits',smooth(im2,3),hd2
   writefits,config.path+'k.fits',smooth(im3,3),hd3
  
   
END
