PRO REGISTERCATALOG, cat, final
   COMMON share,conf
   
   loadconfig
   
   ; The first step is to register the catalog
   
   ; Make sure which one can be used as base catalog.
   tag=tag_names(cat)
   tag_index=findgen(n_elements(tag))
   for i=0, n_tags(cat)-1 do begin
      if i eq 0 then begin
         nb=n_elements(cat.(i).x)
         baseindex=i
      endif else begin
         if n_elements(cat.(i).x) ge nb then begin
            nb=n_elements(cat.(i).x)
            baseindex=i
         endif
      endelse 
   endfor
      
   baseind=where(baseindex eq tag_index,count,complement=inx)
   print,'Using '+string(baseind)+'with data size='+string(nb)
      
   ; Initialize the arrays
   xx=fltarr(nb)
   yy=fltarr(nb)
   mj=fltarr(nb)
   mh=fltarr(nb)
   mk=fltarr(nb)
   mjerr=fltarr(nb)
   mherr=fltarr(nb)
   mkerr=fltarr(nb)
   
   mj[*]=-999.0
   mh[*]=-999.0
   mk[*]=-999.0
   mjerr[*]=-999.0
   mherr[*]=-999.0
   mkerr[*]=-999.0
   
   ; Mininum distance in pixels
   d=4.0
   
   j=0
   ; This is the flag for star registered.
   flag0=intarr(n_elements(cat.(tag_index[inx[0]]).x))
   flag1=intarr(n_elements(cat.(tag_index[inx[1]]).x))
   
   
   
   ; Matching the first catalog
   for i=0,n_elements(cat.(baseindex).x)-1 do begin
      x=cat.(baseindex).x[i]
      y=cat.(baseindex).y[i]

      xx[i]=x
      yy[i]=y
      if baseindex eq 0 then mj[i]=cat.(baseindex).mag[i] & mjerr[i]=cat.(baseindex).magerr[i]
      if baseindex eq 1 then mh[i]=cat.(baseindex).mag[i] & mherr[i]=cat.(baseindex).magerr[i]
      if baseindex eq 2 then mk[i]=cat.(baseindex).mag[i] & mkerr[i]=cat.(baseindex).magerr[i]
     

      ; Looking for fist band: cat.(tag_index(inx[0]))      
      dist1=sqrt(((cat.(tag_index[inx[0]]).x-x)^2)+((cat.(tag_index[inx[0]]).y-y)^2))
      ind1=where(dist1 eq min(dist1) and (min(dist1) le d) and (flag0 eq 0), count1)
      if (count1 ne 0) then begin
         if inx[0] eq 0 then mj[i]=cat.(tag_index[inx[0]]).mag[ind1] & mjerr[i]=cat.(tag_index[inx[0]]).magerr[ind1]
         if inx[0] eq 1 then mh[i]=cat.(tag_index[inx[0]]).mag[ind1] & mherr[i]=cat.(tag_index[inx[0]]).magerr[ind1]
         if inx[0] eq 2 then mk[i]=cat.(tag_index[inx[0]]).mag[ind1] & mkerr[i]=cat.(tag_index[inx[0]]).magerr[ind1]
         flag0[ind1]=1
      endif 

      
      ; Looking for second band: cat.(tag_index(inx[1]))
      dist2=sqrt(((cat.(tag_index[inx[1]]).x-x)^2)+((cat.(tag_index[inx[1]]).y-y)^2))
      ind2=where(dist2 eq min(dist2) and (min(dist2) le d) and (flag1 eq 0), count2)
      if (count2 ne 0) then begin
         if inx[1] eq 0 then mj[i]=cat.(tag_index[inx[1]]).mag[ind2] & mjerr[i]=cat.(tag_index[inx[1]]).magerr[ind2]
         if inx[1] eq 1 then mh[i]=cat.(tag_index[inx[1]]).mag[ind2] & mherr[i]=cat.(tag_index[inx[1]]).magerr[ind2]
         if inx[1] eq 2 then mk[i]=cat.(tag_index[inx[1]]).mag[ind2] & mkerr[i]=cat.(tag_index[inx[1]]).magerr[ind2]
         flag1[ind2]=1
      endif 
      
   endfor
   
   ; Now, adding stars not yet registered
   
   ; Looking for not register record
   noregind=where(flag0 eq 0, count)
   
   for i=0,count-1 do begin
      xx=[xx,cat.(tag_index[inx[0]]).x[noregind[i]]]
      yy=[yy,cat.(tag_index[inx[0]]).y[noregind[i]]]

      if inx[0] eq 0 then begin
          mj=[mj,cat.(tag_index[inx[0]]).mag[noregind[i]]] 
          mjerr=[mjerr,cat.(tag_index[inx[0]]).magerr[noregind[i]]]
          mh=[mh,-999.0]
          mherr=[mherr,-999.0]
          mk=[mk,-999.0]
          mkerr=[mkerr,-999.0]
      endif
      if inx[0] eq 1 then begin
          mj=[mj,-999.0]
          mjerr=[mjerr,-999.0]
          mh=[mh,cat.(tag_index[inx[0]]).mag[noregind[i]]]
          mherr=[mherr,cat.(tag_index[inx[0]]).magerr[noregind[i]]]
          mk=[mk,-999.0]
          mkerr=[mkerr,-999.0]
          
      endif    
      if inx[0] eq 2 then begin
          mj=[mj,-999.0]
          mjerr=[mjerr,-999.0]
          mh=[mh,-999.0]
          mherr=[mherr,-999.0]         
          mk=[mk,cat.(tag_index[inx[0]]).mag[noregind[i]]] 
          mkerr=[mkerr,cat.(tag_index[inx[0]]).magerr[noregind[i]]]
       endif   
   endfor
   ;print,'mh',mh[517]
   
   ; Loop again
   noregind=where(flag1 eq 0, count)
   for i=0,count-1 do begin
      x=cat.(tag_index[inx[1]]).x[noregind[i]]
      y=cat.(tag_index[inx[1]]).y[noregind[i]]
      
      dist=sqrt((xx-x)^2+(yy-y)^2)
      distind=where(dist eq min(dist) and (min(dist) le d),distcount)
      if (distcount ne 0) then begin
      if inx[1] eq 0 then mj[distind]=cat.(tag_index[inx[1]]).mag[noregind[i]] & mjerr[i]=cat.(tag_index[inx[1]]).magerr[noregind[i]]
      if inx[1] eq 1 then mh[distind]=cat.(tag_index[inx[1]]).mag[noregind[i]] & mherr[i]=cat.(tag_index[inx[1]]).magerr[noregind[i]]
      if inx[1] eq 2 then mk[distind]=cat.(tag_index[inx[1]]).mag[noregind[i]] & mkerr[i]=cat.(tag_index[inx[1]]).magerr[noregind[i]]     
      flag1[noregind[i]]=1
      endif
   endfor
 
   noregind=where(flag1 eq 0, count)
   for i=0,count-1 do begin
      xx=[xx,cat.(tag_index[inx[1]]).x[noregind[i]]]
      yy=[yy,cat.(tag_index[inx[1]]).y[noregind[i]]]

      if inx[1] eq 0 then begin
          mj=[mj,cat.(tag_index[inx[1]]).mag[noregind[i]]] 
          mjerr=[mjerr,cat.(tag_index[inx[1]]).magerr[noregind[i]]]
          mh=[mh,-999.0]
          mherr=[mherr,-999.0]
          mk=[mk,-999.0]
          mkerr=[mkerr,-999.0]
      endif
      if inx[1] eq 1 then begin
          mj=[mj,-999.0]
          mjerr=[mjerr,-999.0]
          mh=[mh,cat.(tag_index[inx[1]]).mag[noregind[i]]]
          mherr=[mherr,cat.(tag_index[inx[1]]).magerr[noregind[i]]]
          mk=[mk,-999.0]
          mkerr=[mkerr,-999.0]
          
      endif    
      if inx[1] eq 2 then begin
          mj=[mj,-999.0]
          mjerr=[mjerr,-999.0]
          mh=[mh,-999.0]
          mherr=[mherr,-999.0]         
          mk=[mk,cat.(tag_index[inx[1]]).mag[noregind[i]]] 
          mkerr=[mkerr,cat.(tag_index[inx[1]]).magerr[noregind[i]]]
       endif   
   endfor
   id=findgen(n_elements(xx))   
   final={id:id,x:xx,y:yy,mj:mj,mh:mh,mk:mk,$
       mjerr:mjerr,mherr:mherr,mkerr:mkerr}

 
END
