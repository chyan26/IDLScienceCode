PRO IMGEXTRACT, cra, cdec, imsize, oim, ohd, nim, nhd, norot=norot
  Compile_opt idl2
  On_error,2

  npar = N_params()

  if ( npar EQ 0 ) then begin
        print,'Syntax - IMGEXTRACT, cra, cdec, oim, ohd, nim, nhd'
        print,'CRA and CDEC must be in decimal DEGREES'
        return
  endif                                                                  
  
  ; Rotate the image
  getrot,ohd,rot
  
  if keyword_set(norot) or rot eq 0 then begin
    adxy,ohd,cra,cdec,x,y
    rad=fix(imsize/2.0)  
    hextract,oim,ohd,nim,nhd,fix(x-rad+1),fix(x+rad),fix(y-rad+1), fix(y+rad)
  endif else begin
    hrot,oim,ohd,nnim,nnhd,rot,-1,-1,2
    adxy,nnhd,cra,cdec,x,y
        print,x,y
    rad=fix(imsize/2.0)  
    hextract,nnim,nnhd,nim,nhd,fix(x-rad+1),fix(x+rad),fix(y-rad+1), fix(y+rad)
  endelse
  
  return 
END




PRO RESIZEIRAC
   COMMON share,conf
   loadconfig
   
   ; Load path
   path=conf.iracpath
   
   ; Program ID for IRAC
   id=['7720960','11069440','22498048']
   
   for i=1, 4 do begin
      im=readfits(conf.iracpath+'SPITZER_I'+strcompress(string(fix(i)),/remove)+'_'+id[0]+'.fits',hd)
      imgextract, 309.65167, 42.62444, 50, im, hd, nim, nhd
      writefits,conf.fitspath+'irac_i'+strcompress(string(fix(i)),/remove)+'.fits',nim,nhd
   endfor

    
   return

END


PRO RESIZEMIPS
   COMMON share,conf
   loadconfig
   
   ; Load path
   path=conf.mipspath
   
   ; Program ID for MIPS
   id=['11071744','22508800','22509056']
   
   for i=1, 2 do begin
      im=readfits(conf.mipspath+'SPITZER_M'+strcompress(string(fix(i)),/remove)+'_'+id[2]+'.fits',hd)
      imgextract, 309.65167, 42.62444, 50, im, hd, nim, nhd,/norot
      writefits,conf.fitspath+'mips_m'+strcompress(string(fix(i)),/remove)+'.fits',nim,nhd
   endfor

    
   return

END




