
PRO CMDCLEAN, cat, rcat, final, AV=av, PS=ps
   COMMON share,setting  
   loadconfig

   ;!p.multi=0
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=setting.pspath+'cmdclean.eps',$
         /color,xsize=25,ysize=15,xoffset=0,yoffset=5,$
         SET_FONT='Helvetica',/TT_FONT,/encapsulated
         
         !p.font=1
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
   endif else begin
      blue=65535
      red=255
      green=32768    
   endelse
  
   if keyword_set(av) then begin
      rmj=rcat.mj+0.282*av
      rmh=rcat.mh+0.175*av
      rmk=rcat.mk+0.112*av    
   endif else begin
      rmj=rcat.mj
      rmh=rcat.mh
      rmk=rcat.mk     
   endelse
  
  
  ; Start an array to store information of removed stars
  index=fltarr(n_elements(cat.mk))
  index[*]=0
  ; Set up the removing critirial 
  dk=0.06
  dhk=0.08
  
  erase & multiplot, [2,1],mxtitsize=2.0,mytitsize=2.0,ygap=0,xgap=0.01,mxTitOffse=1.5
 
   ; Selecting CTTS stars
   ctts=intarr(n_elements(cat.mk))
   ctts[*]=0
   for i=0, n_elements(cat.mj)-1 do begin
         ; left boundary
            y1=1.7*(cat.mh[i]-cat.mk[i])+0.031 
       
         ; right boundary
            y2=1.7*(cat.mh[i]-cat.mk[i])-0.544
            y3=0.58*(cat.mh[i]-cat.mk[i])+0.52
      if ((cat.mj[i]-cat.mh[i]) le y1) and ((cat.mj[i]-cat.mh[i]) ge y2-0.2) $
      and ((cat.mj[i]-cat.mh[i]) ge y3) then begin
          ctts[i]=1;              
      endif
   endfor
  plot,cat.mh-cat.mk,cat.mk,psym=4,xrange=[-1,3],yrange=[20,8],$
      font=1,charsize=2.0,xtickinterval=1,xticks=3,xstyle=1, /nodata,xthick=5.0,ythick=5.0
  
  ; Selecting star in continuum emission area.
  ind=where(cat.group eq 2 and ctts eq 0 ,count3)
  plotsym,0,symsize
  if count3 ne 0 then oplot,cat.mh[ind]-cat.mk[ind],cat.mk[ind],psym=8 
  
  ind=where(cat.group eq 2 and ctts eq 1,count4)
  plotsym,0,symsize,color=blue,/fill
  if count4 ne 0 then oplot,cat.mh[ind]-cat.mk[ind],cat.mk[ind],psym=8   
  ; Selecting stars in HCN region
  inx=where(cat.group eq 1 and ctts eq 1,count2)
  plotsym,0,symsize,color=blue,/fill
  if count2 ne 0 then oplot,cat.mh[inx]-cat.mk[inx],cat.mk[inx],psym=8
  
  ind=where(cat.group eq 1 and ctts eq 0 ,count3)
  plotsym,0,symsize
  if count3 ne 0 then oplot,cat.mh[ind]-cat.mk[ind],cat.mk[ind],psym=8 
  loadiso_zams,iso
  oplot,iso.mh-iso.mk,iso.mk,color=red,thick=5
  
  multiplot
  ;ix=where(cat.group ne 0)
  
  ;plot,cat.mh[ix]-cat.mk[ix],cat.mk[ix],psym=4,xrange=[-1,3],yrange=[20,8],$
  ;    font=1,charsize=2.0,xtickinterval=1,xticks=3,xstyle=1
  ;oplot,iso.mh-iso.mk,iso.mk+11,color=red,thick=5 & multiplot
  plotsym,0,symsize
  plot,rmh-rmk,rmk,psym=8,xrange=[-1,3],yrange=[20,8],$
      font=1,charsize=2.0,xthick=5.0,ythick=5.0
  ;oplot,iso.mh-iso.mk,iso.mk+factor,color=red,thick=5 & multiplot
  multiplot
  ; Now go through all star in reference field
  for i=0,n_elements(rmk)-1 do begin
    ;dk=3*rcat.mkerr[i]
    ;dhk=3*sqrt(rcat.mherr[i]^2-rcat.mkerr[i]^2)
    ;if finite(dhk,/nan) then dhk=3*0.08
    ;print,dk,dhk
    rhk=rmh[i]-rmk[i]
    rk=rmk[i]
    ind=where((cat.mh-cat.mk le rhk+dhk) and (cat.mh-cat.mk ge rhk-dhk) and $
      (cat.mk le rk+dk) and (cat.mk ge rk-dk) and (index ne 1) and (cat.group ne 0), count)
    if count ne 0 then begin
      for j=0,count-1 do begin
         index[ind[j]]=1
      endfor
    endif
    ;print,count
  endfor
  ;print,total(index)
  ;print,index
 
  ;-----------------------------------------
  ; Ploting the stars after clean 
  ;-----------------------------------------
  ;plot,cat.mh-cat.mk,cat.mk,psym=4,xrange=[-1,3],yrange=[20,8],$
  ;    font=1,charsize=2.0,xtickinterval=1,xticks=3,xstyle=1, /nodata
  
  ; Selecting star in continuum emission area.
  ;ind=where(index eq 0 and cat.group eq 2 and ctts eq 0 ,count3)
  ;plotsym,0,symsize
  ;if count3 ne 0 then oplot,cat.mh[ind]-cat.mk[ind],cat.mk[ind],psym=8 
  
  ;ind=where(index eq 0 and cat.group eq 2 and ctts eq 1,count4)
  ;plotsym,0,symsize,color=blue,/fill

  ;if count4 ne 0 then oplot,cat.mh[ind]-cat.mk[ind],cat.mk[ind],psym=8   
  ; Selecting stars in HCN region
  ;inx=where(index eq 0 and cat.group eq 1 and ctts eq 1,count2)
  ;plotsym,0,symsize,color=blue,/fill
  ;if count2 ne 0 then oplot,cat.mh[inx]-cat.mk[inx],cat.mk[inx],psym=8
  
  ;ind=where(index eq 0 and cat.group eq 1 and ctts eq 0 ,count3)
  ;plotsym,0,symsize
  ;if count3 ne 0 then oplot,cat.mh[ind]-cat.mk[ind],cat.mk[ind],psym=8 
  
  inx=where(index eq 0 and cat.group ne 0, count)
  print,count
  ;plot,cat.mh[inx]-cat.mk[inx],cat.mk[inx],psym=4,xrange=[-1,3],yrange=[20,8],$
  ;    font=1,charsize=2.0
  ;oplot,iso.mh-iso.mk,iso.mk+factor,color=red,thick=5 
  
  ;multiplot

  final={x:cat.x[inx],y:cat.y[inx],mj:cat.mj[inx],mh:cat.mh[inx],mk:cat.mk[inx],$
       mjerr:cat.mjerr[inx],mherr:cat.mherr[inx],mkerr:cat.mkerr[inx],group:cat.group[inx],$
       ctts:cat.ctts[inx]}
   

  if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
  endif
  
  ;multiplot,/reset
  
  resetplt,/all
  !p.multi=0



END


PRO CROSSCORR,cat, rcat
  rmj=rcat.mj
  rmh=rcat.mh
  rmk=rcat.mk     
  
  ; Now go through all star in reference field
  for i=0,n_elements(rmk)-1 do begin
    rhk=rmh[i]-rmk[i]
    rk=rmk[i]
    
    hk=abs(rhk-(cat.mh-cat.mk))
    
    hh=histogram(hk,min=0,max=2,bin=0.01)
    ;dk=abs(rk-cat.mk)) 
    
    if i eq 0 then begin
      h=hh
      
     
    endif else begin
      h=h+hh
      ;hh=[hh,hk]
      ;dd=[dd,dk]
    endelse
  endfor  
      plot,h/n_elements(rmk)
   
    
    
END





