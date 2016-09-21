

PRO IMAGESTACK
   COMMON share,config
   loadconfig
   
   spawn,'ls '+config.redpath+'k*pw.fits',list
   
   for i=0, n_elements(list)-1 do begin
      file=list[i]
      pos = stregex(file, '[jhk][0-9]+_[0-9]+', length=len)
      cat=config.redpath+STRMID(file, pos, len)+'pw.cat'
      
      spawn,'sex -c '+config.config+'stack.sex '+file+$
         ' -CATALOG_NAME '+cat+$
         ' -CHECKIMAGE_TYPE NONE'+$
         ' -PARAMETERS_NAME '+config.config+'stack.param'
   endfor
   ;spawn,'scamp -c '+config.config+'scamp.conf '+config.redpath+'j*pw.cat'
   ;spawn,'mv *.png '+config.redpath
END