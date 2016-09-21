


PRO CMDFILTER, FITS=fits, NEWFITS=newfits, REGION=region

   COMMON share,conf
   loadconfig
   
   ; Read information in SED produced FITS files
   tab1=mrdfits(fits,1,mhd,/Silent)
   tab2=mrdfits(fits,2,/Silent)



   mi2=fltarr(n_elements(tab1.flux[0]))
   mi4=fltarr(n_elements(tab1.flux[0]))
   flag=intarr(n_elements(tab1.flux[0]))

   for i=0,n_elements(tab1.(0))-1 do begin
      mi2[i]=-2.5*alog10((tab1[i].flux[4]*1e-3)/179.7)
      mi4[i]=-2.5*alog10((tab1[i].flux[6]*1e-3)/64.13)
      
      x=mi2[i]-mi4[i]
      ;y=-x+14.0
      y=-x+12.8
      
      ; Selecting source with [8.0] magnitude above galaxy line.
      if mi4[i] lt y then flag[i]=1
   endfor


   ind=where(flag eq 1,COMPLEMENT=inx, count)
   plot,mi2[ind]-mi4[ind],mi4[ind],psym=4,xrange=[-1,5],yrange=[15,5],$
      xstyle=1,ystyle=1,$
      xtitle='[4.5] - [8.0]',ytitle='[8.0]',charsize=1.5,$
      xthick=5,ythick=5

   if count ge 1 then begin
      newtab1=tab1[ind]
   end

   for i=0,n_elements(inx)-1 do begin
      print,tab1[inx[i]].source_name,"Reject: Source is under galaxy line in CMD."
   endfor


   if keyword_set(region) then begin
      openw,fileunit, region, /get_lun   
      for i=0, n_elements(inx)-1 do begin
         regstring = 'fk5;circle('+$
                     strcompress(string(tab1[inx[i]].x,format='(F12.7)'),/remove_all)+'d,'+$
                     strcompress(string(tab1[inx[i]].y,format='(F12.7)'),/remove_all)+'d,5") #color = red'+$
                     ' text={'+'} width = 2'
         printf, fileunit, format='(A)', regstring
         
      endfor
      
      close, fileunit
      free_lun,fileunit
      
   endif


   k=0
   for i=0,n_elements(newtab1.source_name)-1 do begin
      ind=where(tab2[*].source_id eq newtab1[i].soure_id, count)
      if count ne 0 then begin 
      
         if k eq 0 then begin
            newtab2=tab2[ind]
            k=1      
         endif else begin
            newtab2=[newtab2,tab2[ind]]
         endelse
      endif    
   end



   if file_test(newfits) then spawn,'rm -rf '+newfits
   mwrfits,newtab1, newfits,mhd,/Silent
   mwrfits,newtab2,newfits,/Silent


END