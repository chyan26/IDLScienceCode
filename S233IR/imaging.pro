PRO IMGEXTRACT, cra, cdec, imsize, oim, ohd, nim, nhd
  Compile_opt idl2
  On_error,2

  npar = N_params()

  if ( npar EQ 0 ) then begin
        print,'Syntax - IMGEXTRACT, cra, cdec, oim, ohd, nim, nhd'
        print,'CRA and CDEC must be in decimal DEGREES'
        return
  endif                                                                  
  
  adxy,ohd,cra,cdec,x,y
  rad=fix(imsize/2.0)  
  hextract,oim,ohd,nim,nhd,fix(x-rad+1),fix(x+rad),fix(y-rad+1), fix(y+rad)
  ;print,fix(x-rad+1),fix(x+rad),fix(y-rad+1), fix(y+rad)
  
  return 
END


;PRO ALLFOV
;  COMMON share,conf
;  loadconfig
  
;  im1=readfits(imgpath+'S233IR_J_coadd.fits',hd1)
;  im2=readfits(imgpath+'S233IR_H_coadd.fits',hd2)
;  im3=readfits(imgpath+'S233IR_Ks_coadd.fits',hd3)
;  im4=readfits(imgpath+'S233IR_H2_coadd.fits',hd4)
;  im5=readfits(imgpath+'S233IR_BrG_coadd.fits',hd5)
;  im6=readfits(imgpath+'S233IR_Kcont_coadd.fits',hd6)
  
;  cord=sxpar(hd1,"CRVAL*")
  ;print,cord
;  imgextract, 84.747397,35.77946, 2500, im1, hd1, nim1, nhd1
;  imgextract, 84.747397,35.77946, 2500, im2, hd2, nim2, nhd2
;  imgextract, 84.747397,35.77946, 2500, im3, hd3, nim3, nhd3
;  imgextract, 84.747397,35.77946, 2500, im4, hd4, nim4, nhd4
;  imgextract, 84.747397,35.77946, 2500, im5, hd5, nim5, nhd5
;  imgextract, 84.747397,35.77946, 2500, im6, hd6, nim6, nhd6 
  
;  ind=where(nim1 eq 0)
;  nim1[ind]=44000
  
;  ind=where(nim2 eq 0)
;  nim2[ind]=44000
  
;  ind=where(nim3 eq 0)
;  nim3[ind]=44000

;  writefits,imgpath+'s233_all_j.fits',nim1,nhd1
;  writefits,imgpath+'s233_all_h.fits',nim2,nhd2
;  writefits,imgpath+'s233_all_k.fits',nim3,nhd3
;  writefits,imgpath+'s233_all_h2.fits',nim4,nhd4
;  writefits,imgpath+'s233_all_brg.fits',nim5,nhd5
;  writefits,imgpath+'s233_all_kcont.fits',nim6,nhd6
  
  ;image={j:nim1,h:nim2,k:nim3}
  ;header={j:nhd1,h:nhd2,k:nhd3}




;END


PRO RESIZEIMAGE, image, header
   COMMON share,conf
   
   loadconfig
   ; Load images
   path=conf.wircampath
   
   im1=readfits(conf.wircampath+'S233IR_J_coadd.fits',hd1)
   im2=readfits(conf.wircampath+'S233IR_H_coadd.fits',hd2)
   im3=readfits(conf.wircampath+'S233IR_Ks_coadd.fits',hd3)
   im4=readfits(conf.wircampath+'S233IR_H2_coadd.fits',hd4)
   im5=readfits(conf.wircampath+'S233IR_BrG_coadd.fits',hd5)  
   im6=readfits(conf.wircampath+'S233IR_Kcont_coadd.fits',hd6)
    
   ; cut interesting area
   imgextract, 84.8041667,35.765, 1024, im1, hd1, nim1, nhd1
   imgextract, 84.8041667,35.765, 1024, im2, hd2, nim2, nhd2
   imgextract, 84.8041667,35.765, 1024, im3, hd3, nim3, nhd3
   imgextract, 84.8041667,35.765, 1024, im4, hd4, nim4, nhd4
   imgextract, 84.8041667,35.765, 1024, im5, hd5, nim5, nhd5
   imgextract, 84.8041667,35.765, 1024, im6, hd6, nim6, nhd6

   ;save images
   writefits,conf.fitspath+'s233ir_j.fits',nim1,nhd1
   writefits,conf.fitspath+'s233ir_h.fits',nim2,nhd2
   writefits,conf.fitspath+'s233ir_k.fits',nim3,nhd3
   writefits,conf.fitspath+'s233ir_h2.fits',nim4,nhd4
   writefits,conf.fitspath+'s233ir_brg.fits',nim5,nhd5
   writefits,conf.fitspath+'s233ir_kcont.fits',nim6,nhd6
   
   ; Now cutting the reference image
   imgextract, 84.66706, 35.702143, 1024, im1, hd1, rim1, rhd1
   imgextract, 84.66706, 35.702143, 1024, im2, hd2, rim2, rhd2
   imgextract, 84.66706, 35.702143, 1024, im3, hd3, rim3, rhd3
   
   writefits,conf.fitspath+'s233ir_j_ref.fits',rim1,rhd1
   writefits,conf.fitspath+'s233ir_h_ref.fits',rim2,rhd3
   writefits,conf.fitspath+'s233ir_k_ref.fits',rim3,rhd3
    
   return

END



PRO LOADS233IR, image, header
   COMMON share,conf
   loadconfig
   
   nim1=readfits(conf.fitspath+'s233ir_j.fits',nhd1)
   nim2=readfits(conf.fitspath+'s233ir_h.fits',nhd2)
   nim3=readfits(conf.fitspath+'s233ir_k.fits',nhd3)
   nim4=readfits(conf.fitspath+'s233ir_h2.fits',nhd4)
   nim5=readfits(conf.fitspath+'s233ir_brg.fits',nhd5)
   nim6=readfits(conf.fitspath+'s233ir_kcont.fits',nhd6)
   
   image={j:nim1,h:nim2,k:nim3,h2:nim4,brg:nim5,kcont:nim6}
   header={j:nhd1,h:nhd2,k:nhd3,h2:nhd4,brg:nhd5,kcon:nhd6}

END

PRO LOADREF, image, header
  COMMON share,conf
  loadconfig
  
  nim1=readfits(conf.fitspath+'s233ir_j_ref.fits',nhd1)
  nim2=readfits(conf.fitspath+'s233ir_h_ref.fits',nhd2)
  nim3=readfits(conf.fitspath+'s233ir_k_ref.fits',nhd3)
  
  image={j:nim1,h:nim2,k:nim3}
  header={j:nhd1,h:nhd2,k:nhd3}


END






