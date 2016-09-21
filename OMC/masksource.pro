PRO MASKSOURCE
   COMMON share,config
   loadconfig
   
   spawn,'ls '+config.rawpath+'[hk][0-9]*.fits',list
   for i=0,n_elements(list)-1 do begin
   
      file=list[i]
      
      
      im=readfits(file,hd)
      med=median(im)
      ;dev=median(im-med)/0.674433
      dev=stddev(im)
      ind=where(im gt med+0.1*dev or im le med-0.1*dev)
      im[ind]=0.0
     
      pos = stregex(file, '[jhk][0-9]+_[0-9]+', length=len)
      bkfile=config.detpath+STRMID(file, pos, len)+'s_bk.fits'
      writefits,bkfile,im,hd
      ;spawn,'sex -c '+config.config+'background.sex '+file+$
      ;      ' -CHECKIMAGE_NAME '+bkfile+$
      ;      ' -PARAMETERS_NAME '+config.config+'default.param'
   endfor
END


