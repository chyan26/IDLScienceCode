
PRO CMDCLEAN, cat, rcat, final, AV=av, PS=ps
   COMMON share,conf  
   loadconfig

   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+'cmdclean.eps',$
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
  dk=0.07
  dhk=0.08
  
  loadavgiso,iso,/all,age=20
  ;loadiso_zams,iso2
  erase & multiplot, [3,1],mxtitsize=2.0,mytitsize=2.0,ygap=0,xgap=0.01,$
   mytitle='Ks',mxTitOffse=1.5
 
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
  plot,cat.mh-cat.mk,cat.mk,psym=4,xrange=[-1,5],yrange=[19,9],ystyle=1,$
      font=1,charsize=2.0,xtickinterval=1,xticks=3,xstyle=1, /nodata
  
  ; Selecting distributed stars.
  ind=where(cat.group eq 3 and ctts eq 0 and cat.mk le 18 ,count3)
  plotsym,0,symsize
  if count3 ne 0 then oplot,cat.mh[ind]-cat.mk[ind],cat.mk[ind],psym=8 
  
  ind=where(cat.group eq 3 and ctts eq 1 and cat.mk le 18 ,count4)
  plotsym,0,symsize,color=blue,/fill
  if count4 ne 0 then oplot,cat.mh[ind]-cat.mk[ind],cat.mk[ind],psym=8   
  ;print,count3,count4

  ; Plot isochrone
  oplot,iso.mh-iso.mk,iso.mk+11.27,color=red,thick=5
  ;oplot,iso2.mh-iso2.mk,iso2.mk+10.27,color=blue,thick=5
  
  multiplot
  ;ix=where(cat.group ne 0)
  
  ;plot,cat.mh[ix]-cat.mk[ix],cat.mk[ix],psym=4,xrange=[-1,3],yrange=[20,8],$
  ;    font=1,charsize=2.0,xtickinterval=1,xticks=3,xstyle=1
  ;oplot,iso.mh-iso.mk,iso.mk+11,color=red,thick=5 & multiplot
  ind=where(rmk le 18)
  plot,rmh[ind]-rmk[ind],rmk[ind],psym=4,xrange=[-1,5],yrange=[19,9],ystyle=1,$
      font=1,charsize=2.0,xstyle=1
  oplot,iso.mh-iso.mk,iso.mk+11.27,color=red,thick=5 & multiplot
  
  ; Now go through all star in reference field
  for i=0,n_elements(rmk)-1 do begin
    rhk=rmh[i]-rmk[i]
    rk=rmk[i]
    ind=where((cat.mh-cat.mk le rhk+dhk) and (cat.mh-cat.mk ge rhk-dhk) and $
      (cat.mk le rk+dk) and (cat.mk ge rk-dk) and (index ne 1) and (cat.group eq 3), count)
    if count ne 0 then begin
      for j=0,count-1 do begin
         index[ind[j]]=1
      endfor
    endif
   endfor
  
  
  ; Remove star in the left side of isochrone
  for i=0,n_elements(cat.mk)-1 do begin
    ihk=interpol(iso.mh-iso.mk,iso.mk+10.27,cat.mk[i])
    if (ihk ge cat.mh[i]-cat.mk[i]) then index[i]=1  
  endfor
  
  ;print,total(index)
  ;print,index
 
  ;-----------------------------------------
  ; Ploting the stars after clean 
  ;-----------------------------------------
  plot,cat.mh-cat.mk,cat.mk,psym=4,xrange=[-1,5],yrange=[19,9],ystyle=1,$
      font=1,charsize=2.0,xtickinterval=1,xticks=3,xstyle=1, /nodata
  
  ; Selecting star in continuum emission area.
  ind=where(index eq 0 and cat.group eq 3 and ctts eq 0 and cat.mk le 18 ,count3)
  plotsym,0,symsize
  if count3 ne 0 then oplot,cat.mh[ind]-cat.mk[ind],cat.mk[ind],psym=8 
  
  ind=where(index eq 0 and cat.group eq 3 and ctts eq 1 and cat.mk le 18,count4)
  plotsym,0,symsize,color=blue,/fill
  if count4 ne 0 then oplot,cat.mh[ind]-cat.mk[ind],cat.mk[ind],psym=8   
  
  inx=where(index eq 0 and cat.group ne 0, count)
  ;print,count
  ;plot,cat.mh[inx]-cat.mk[inx],cat.mk[inx],psym=4,xrange=[-1,3],yrange=[20,8],$
  ;    font=1,charsize=2.0
  oplot,iso.mh-iso.mk,iso.mk+11.27,color=red,thick=5 
  
  multiplot

  final={id:cat.id[inx],x:cat.x[inx],y:cat.y[inx],mj:cat.mj[inx],mh:cat.mh[inx],mk:cat.mk[inx],$
       mjerr:cat.mjerr[inx],mherr:cat.mherr[inx],mkerr:cat.mkerr[inx],group:cat.group[inx]}
   
  print,n_elements(cat.x),n_elements(final.x) 
  if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
  endif
  
  multiplot,/reset
  clearplt,/all
  resetplt,/all
  !p.multi=0



END