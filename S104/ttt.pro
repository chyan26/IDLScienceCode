
   COMMON share,conf
   loadconfig

   
   mass=fltarr(n_elements(cat.x))
   
   d=2000.0
   factor=5.0*alog10(d)-5.0
   ; Data of NE cluster
   loadavgiso,iso,/sdf
   
   
   plot,cat.mh-cat.mk,cat.mk,psym=4,yrange=[20,8],ystyle=1,xrange=[-1,3]
   oplot,iso.mh-iso.mk,iso.mk+factor,color=255
   
   for i=0,1 do begin
      b=cat.mk[i]-1.78*(cat.mh[i]-cat.mk[i])
      
      if cat.mh[i]-cat.mk[i] ge 0 then begin
         xx=getseries(0.0,cat.mh[i]-cat.mk[i],0.01)
         k1=1.78*xx+b
         
         k2=interpol(iso.mk+factor,iso.mh-iso.mk,xx)
;          
;          ind=where(k1-k2 eq min(k1-k2) and min(k1-k2) le 0.01)
;          plots,xx[ind],k1[ind],psym=4,color=255
;          mass[i]=interpol(iso.mass,iso.mk+factor,k1[ind])
;          print,cat.mh[i]-cat.mk[i],cat.mk[i],k1[ind],mass[i]
      endif
   endfor
END