PRO LOADAVGISO, iso, DM=dm, SDF=sdf, CHECKPLT=checkplt, PS=ps

age=[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20]

mk=(findgen(111)-10)/10
mmj=fltarr(n_elements(age),n_elements(mk))
mmh=fltarr(n_elements(age),n_elements(mk))
mm=fltarr(n_elements(age),n_elements(mk))

mj=fltarr(n_elements(mk))
mh=fltarr(n_elements(mk))
mass=fltarr(n_elements(mk))

;plot,[]
if keyword_set(checkplt) then begin
   plot,[-1,2],[10,-1],yrange=[10,-1],xrange=[-1,2],ytitle='Ks',xtitle='H - Ks',/nodata
endif 

if keyword_set(checkplt) and keyword_set(ps) then begin
      set_plot,'ps'
      device,filename='checkavgiso.eps',$
         /color,xsize=20,ysize=15,xoffset=0.4,yoffset=10,$
         SET_FONT='Helvetica',/TT_FONT,/encapsulated
         
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3

      plot,[-1,2],[10,-1],yrange=[10,-1],xrange=[-1,2],ytitle='Ks',xtitle='H - Ks',/nodata
endif 



for i=0,n_elements(age)-1 do begin
  if keyword_set(sdf) then begin
      loadiso_sdf,iso,age=age[i]
  endif else begin
      loadiso_dm,iso,age=age[i]
  endelse
  
  if keyword_set(checkplt) then begin
      oplot,iso.mh-iso.mk,iso.mk
  endif
  
  for j=0,n_elements(mk)-1 do begin
      if mk[j] ge min(iso.mk) and mk[j] le max(iso.mk) then begin
         mmh[i,j]=interpol(iso.mh,iso.mk,mk[j])
         mmj[i,j]=interpol(iso.mj,iso.mk,mk[j])
         mm[i,j]=interpol(iso.mass,iso.mk,mk[j])     
      endif
  endfor
endfor


for j=0,n_elements(mk)-1 do begin
   ind=where(mmh[*,j] ne 0, count)    
   if count ne 0 then mh[j]=mean(mmh[ind,j]) 
   ind=where(mmj[*,j] ne 0, count)    
   if count ne 0 then mj[j]=mean(mmj[ind,j])
   ind=where(mm[*,j] ne 0, count)    
   if count ne 0 then mass[j]=mean(mm[ind,j])     
        
endfor


ind=where(mh ne 0 and mass le 7.0)
iso={mj:mj[ind],mh:mh[ind],mk:mk[ind],mass:mass[ind]}

if keyword_set(checkplt) then begin
   oplot,mh[ind]-mk[ind], mk[ind],color=255
endif 

if keyword_set(checkplt) and keyword_set(PS) then begin
   oplot,mh[ind]-mk[ind], mk[ind],color=red,thick=5

   device,/close
   set_plot,'x'
endif 


END
