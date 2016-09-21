PRO RHOOBJREGION, cat
   COMMON share,imgpath, mappath,mippath
   loadconfig
   
   x=cat.x
   y=cat.y
   
   regname = 'objregion.reg'
   regpath = mappath
   regfile = regpath+regname
   
   openw,fileunit, regfile, /get_lun   
   for i=0,n_elements(x)-1 do begin
      ext=0 
      if cat.mj[i] ge 0 then begin
         regstring = 'tile '+strcompress(string(ext),/remove_all)+'; image; circle('+$
                     strcompress(string(x[i]),/remove_all)+','+$
                     strcompress(string(y[i]),/remove_all)+',7) #color = blue'
         printf, fileunit, format='(A)', regstring
      endif
      if cat.mh[i] ge 0 then begin
         regstring = 'tile '+strcompress(string(ext),/remove_all)+'; image; circle('+$
                     strcompress(string(x[i]),/remove_all)+','+$
                     strcompress(string(y[i]),/remove_all)+',5) #color = green'
         printf, fileunit, format='(A)', regstring
      endif
      if cat.mk[i] ge 0 then begin
         regstring = 'tile '+strcompress(string(ext),/remove_all)+'; image; box('+$
                     strcompress(string(x[i]),/remove_all)+','+$
                     strcompress(string(y[i]),/remove_all)+',5,5,5,5) #color = red'
         printf, fileunit, format='(A)', regstring
      endif
      
   endfor
   close, fileunit
   free_lun,fileunit

END

PRO GETDS9REGION, x, y, name, color=color
   COMMON share,imgpath, mappath 
   loadconfig

   regname = name+'.reg'
   regpath = mappath
   regfile = regpath+regname
   
   ;x=cat.x
   ;y=cat.y
   id=indgen(n_elements(x))
   
   openw,fileunit, regfile, /get_lun   
   index = where(id eq 1)
   for i=0L, n_elements(x)-1 do begin
      ext=0 
      regstring = 'tile '+strcompress(string(ext),/remove_all)+'; image; circle('+$
                    strcompress(string(x[i]),/remove_all)+','+$
                    strcompress(string(y[i]),/remove_all)+',5) #color ='+color
      printf, fileunit, format='(A)', regstring
   endfor
   
   close, fileunit
   free_lun,fileunit
END
