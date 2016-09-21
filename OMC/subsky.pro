PRO SKYINFO, list, info
   COMMON share,config
   loadconfig
   
   ;spawn,'ls '+config.detpath+'j[0-9]*_bk.fits',list
   ;spawn,'ls '+config.detpath+'h[0-9]*_bk.fits',hlist
   ;spawn,'ls '+config.detpath+'k[0-9]*_bk.fits',klist
   
   name=strarr(n_elements(list))
   date=fltarr(n_elements(list))
   ra=fltarr(n_elements(list))
   dec=fltarr(n_elements(list))
   
   for i=0, n_elements(list)-1 do begin
      file=list[i]
      pos = stregex(file, '[jhk][0-9]+_[0-9]+', length=len) 
      name[i]=STRMID(file, pos, len)+'s_bk.fits' 
      hd=headfits(file)
      date[i]=ut2julday(sxpar(hd,'DATE'))-2453300.0
      ra[i]=sxpar(hd,'CRVAL1')
      dec[i]=sxpar(hd,'CRVAL2')
   endfor
   
   info={name:name,date:date,ra:ra,dec:dec}
   
END

PRO GENSKYFRAME, list, filename
   COMMON share,config
   loadconfig
   
   mask=readfits(config.calibpath+'badpixel.fits')
   nframe=n_elements(list)
   level=fltarr(nframe)
   cube=fltarr(1024,1024,nframe)
   final=fltarr(1024,1024)
   
   for i=0,nframe-1 do begin
      cube[*,*,i]=readfits(config.detpath+list[i],hd)*mask
      level[i]=median(cube[*,*,i])
   endfor
   
   ratio=level/median(level)
   
   for i=0,nframe-1 do begin
      cube[*,*,i]=cube[*,*,i]/ratio[i]
   endfor
   
   for x=0,1023 do begin
      for y=0,1023 do begin
         final[x,y]=median(cube[x,y,*])
      endfor
   endfor
   writefits,filename,final/median(final)
END

FUNCTION ADJCHIP, im, final
   
   final=im
   line=fltarr(1024)
   for i=0,1023 do begin
      line[i]=median(im[i,*])
   endfor
   
   line=line/median(line)
   
   for i=0,1023 do begin
      final[*,i]=im[*,i]/line[*]
   endfor
   
   return,final
END


PRO SKYPICKER, jlist
   COMMON share,config
   loadconfig
   ;spawn,'ls '+config.detpath+'j[0-9]*_bk.fits',jlist
   skyinfo,jlist,jinfo
   
   for i=0, n_elements(jinfo.name)-1 do begin
      dtime=abs((jinfo.date[i]-jinfo.date)*24.0*60.0)
      ind=where(dtime le 10)
      
      pos = stregex(jinfo.name[i], '[jhk][0-9]+_[0-9]+', length=len)
      detrend=config.rawpath+STRMID(jinfo.name[i], pos, len)+'.fits'
      skyframe=config.detpath+STRMID(jinfo.name[i], pos, len)+'s_sky.fits'
      
      red=config.redpath+STRMID(jinfo.name[i], pos, len)+'p.fits'

      genskyframe,jinfo.name[ind],skyframe
      im=readfits(detrend,hd)
      sky=readfits(skyframe)
      pim=im/sky
      print,'Replace NaN...'
      repnan,pim,0
      fim=adjchip(pim)
      writefits,red,fim,hd
      ;print,jinfo.name[i],skyframe
      ;print,jinfo.name[ind]
   endfor
   


END

PRO SUBSKY

   COMMON share,config
   loadconfig
   spawn,'ls '+config.detpath+'j[0-9]*_bk.fits',jlist
   skypicker,jlist
   spawn,'ls '+config.detpath+'h[0-9]*_bk.fits',hlist
   skypicker,hlist
   spawn,'ls '+config.detpath+'k[0-9]*_bk.fits',klist
   skypicker,klist
   

END