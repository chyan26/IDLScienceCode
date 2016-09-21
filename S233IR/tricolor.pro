PRO TRICOLOR

   COMMON share,conf
   
   loadconfig
   symsize=0.7

   i1=readfits(conf.iracpath+'S233IR_I1.fits',hd1)
   i2=readfits(conf.iracpath+'S233IR_I2.fits',hd2)
   i3=readfits(conf.iracpath+'S233IR_I3.fits',hd3)
   i4=readfits(conf.iracpath+'S233IR_I4.fits',hd4)
    
   hrot, i1, hd1, ti1, thd1, -90, -1, -1, 1
   
   hextract, ti1, thd1,ni1,nhd1,426,708,100,388   
   hastrom,i2,hd2,ni2,nhd2,nhd1
   hastrom,i3,hd3,ni3,nhd3,nhd1
   hastrom,i4,hd4,ni4,nhd4,nhd1

   dimension=size(ni2)
   xsize=dimension[1]
   ysize=dimension[2]
   
   ind=where(finite(ni1,/nan))
   ni1[ind]=0
   ind=where(finite(ni2,/nan))
   ni2[ind]=0
   ind=where(finite(ni3,/nan))
   ni3[ind]=0
   ind=where(finite(ni4,/nan))
   ni4[ind]=0
   
   image=bytarr(3,xsize,ysize)
   
   image[0,*,*]=gmascl(ni4, gamma=0.7, MIN=0.1, MAX=0.3*max(ni4))
   image[1,*,*]=GmaScl(ni2, gamma=0.7, MIN=0, MAX=0.2*max(ni2))
   image[2,*,*]=GmaScl(ni1, gamma=0.7, MIN=0, MAX=0.2*max(ni1))
   
   imdisp,image,/axis
END