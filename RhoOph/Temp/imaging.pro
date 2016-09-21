PRO LOADCONFIG
   COMMON share,config
   
   ;cubepath='/arrays/cfht_3/chyan/guidecube/'
   ;cubepath='/h/archive/current/instrument/wircam/'
   ;calibpath='/data/ula/wircam/calib/'
   ;datapath='/data/wena/wircam/chyan/gcube/'

   path='/data/chyan/ScienceImages/RhoOph/'
   wircampath=path+'WIRCam/'
   fitspath=path+'FITS/'
   pspath=path+'PS/'
   
   config={path:path,wircampath:wircampath,fitspath:fitspath,pspath:pspath}
END
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

; This routine is used to extract dense core in Rho Oph region for Lynn
PRO  DENSECORES

   COMMON share,config
   loadconfig

   ra=[247.89433,24.796350,247.97303]
   dec=[-24.04944,-24.52024,-24.93777]
   
   im1=readfits(config.wircampath+'06AT08_J_coadd.fits',hd1)
   ;im2=readfits(config.wircampath+'06AT08_H_coadd.fits',hd2)
   ;im3=readfits(config.wircampath+'06AT08_KS_coadd.fits',hd3)
   

   imgextract, ra[0],  dec[0],4096, im1, hd1, nim1, nhd1
   ;imgextract, ra[,0],  coord[1,2],4096, im2, hd2, nim2, nhd2
   ;imgextract, coord[0,0],  coord[0,1],4096, im3, hd3, nim3, nhd3

   writefits,setting.fitspath+'core_'+strcompress(string(0+1),/remove)+'j.fits',nim1,nhd1
   ;writefits,setting.fitspath+'core_'+strcompress(string(0+1),/remove)+'j.fits',nim2,nhd3
   ;writefits,setting.fitspath+'core_'+strcompress(string(0+1),/remove)+'j.fits',nim3,nhd3
   



END

