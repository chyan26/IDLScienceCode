PRO LOADCONFIG
   COMMON share,imgpath, mappath
   ;Settings for HOME computer
   ;imgpath = '/home/chyan/iras/'
   ;mappath = '/home/chyan/iras/'
   
   ;Settings for ASIAA computer
   imgpath='/arrays/cfht_2/chyan/WIRCam/FITS/05BT08/stacked/'
   mappath='/asiaa/home/chyan/M82/'
   
   return 
END

PRO LOADIMAGE, ks, h2, ks_hd, h2_hd
   COMMON share,imgpath
   
   loadconfig
   ; Load images
   path=imgpath
   
   im1=readfits(path+'M82_H2.fits',hd1)
   im2=readfits(path+'M82_Ks.fits',hd2)
   ;
   ; scale image to the same dimension
   hastrom, im2,hd2,tim2,thd2,hd1
   
   ;
   ; Generate a header with center at 05:39:13.0 35:45:54.0
   shd=hd1
   sxaddpar,shd,'CRVAL1',148.9675
   sxaddpar,shd,'CRVAL2',69.2463889
   ;
   ; scale image to the same dimension
   hastrom, im1,hd1,tim1,thd1,shd
   hastrom, im2,hd2,tim2,thd2,shd
   
   th_image_cont,im1,/nocont
   ;
   ; cut interesting area
   hextract, tim1, thd1, nim1,nhd1,2500,4500,2500,4500
   hextract, tim2, thd2, nim2,nhd2,2500,4500,2500,4500
   
   
   ; Restore raw image
   h2=nim1
   ks=nim2

   ks_hd=nhd2
   h2_hd=nhd1
   return
END

PRO M82
   common share, imgpath, mappath
   loadconfig
   
   ; Load image
   loadimage,ks,h2,hd1,hd2
   
   subtract_cont,ks,h2,dust,im
      
end
