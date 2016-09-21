PRO MKCATALOG, cat, final, select=select
   COMMON share,setting 
   loadconfig
   
   ; The first step is to register the catalog
   
   ; Mininum distance in pixels
   d=3.0
   
   j=0
   ; This is the flag for star registered.
   jflag=intarr(n_elements(cat.j.x))
   hflag=intarr(n_elements(cat.h.x))
   
   
   ; Initialize the arrays
   xx=fltarr(n_elements(cat.k.x))
   yy=fltarr(n_elements(cat.k.x))
   mj=fltarr(n_elements(cat.k.x))
   mh=fltarr(n_elements(cat.k.x))
   mk=fltarr(n_elements(cat.k.x))
   mjerr=fltarr(n_elements(cat.k.x))
   mherr=fltarr(n_elements(cat.k.x))
   mkerr=fltarr(n_elements(cat.k.x))
   
   ; Beginning of the loop
   for i=0,n_elements(cat.k.x)-1 do begin
      x=cat.k.x[i]
      y=cat.k.y[i]
      
      xx[i]=x
      yy[i]=y
      mk[i]=cat.k.mag[i]
      mkerr[i]=cat.k.magerr[i]

      ; Looking for H band
      dist1=sqrt(((cat.h.x-x)^2)+((cat.h.y-y)^2))
      ind1=where(dist1 eq min(dist1) and (min(dist1) le d) and (hflag eq 0), count1)
      if (count1 ne 0) then begin
         mh[i]=cat.h.mag[ind1]
         mherr[i]=cat.h.magerr[ind1]
         hflag[ind1]=1
      endif else begin
         mh[i]=-999.0
         mherr[i]=-999.0
      endelse
      
      ; Looking for J band
      dist2=sqrt(((cat.j.x-x)^2)+((cat.j.y-y)^2))
      ind2=where(dist2 eq min(dist2) and min(dist2) le 3 and (jflag eq 0), count2)
      if (count2 ne 0) then begin
         mj[i]=cat.j.mag[ind2]
         mjerr[i]=cat.j.magerr[ind2]
         jflag[ind2]=1
      endif else begin
         mj[i]=-999.0
         mjerr[i]=-999.0
      endelse
      
      
   endfor

  ;Group stars for HCN related and continuum related
  ; Selecting star within the HCN contour
  group=intarr(n_elements(xx))
  dist=sqrt(((xx-547)^2)+((yy-532)^2))
  i1=where(dist le 250)
   group[i1]=1
   
  ; Selecting star within the continuum contour
  dist=sqrt(((xx-587)^2)+((yy-610)^2))
  i2=where(dist le 135)
  group[i2]=2
   
   
  ; Pick up CTTS
  ctts=intarr(n_elements(mk))
  ctts[*]=0
   ; Selecting CTTS stars
   for i=0, n_elements(mk)-1 do begin
         ; left boundary
            y1=1.7*(mh[i]-mk[i])+0.031 
       
         ; right boundary
            y2=1.7*(mh[i]-mk[i])-0.544
            y3=0.58*(mh[i]-mk[i])+0.52
      if ((mj[i]-mh[i]) le y1) and ((mj[i]-mh[i]) ge y2-0.2) $
      and ((mj[i]-mh[i]) ge y3) then begin
          ctts[i]=1;              
      endif
   endfor

      
  ; Set the limiting magnitude of each filter
   mjlim=20.0
   mhlim=19.5
   mklim=19.0

   mjlim2=0
   mhlim2=0
   mklim2=0
   
   
   if keyword_set(select) then begin 
	   ;eliminate stars only detected in K band 
	   ind=where((mk ge 17.5 and mj eq -999.0 and mh eq -999.0) or (mk ge mklim) $
	   or (mh ge mhlim) or (mj ge mjlim) or (mj le mjlim2) or (mh le mhlim2) $
	   or (mk le mklim2) or (group eq 0) or (group eq 1),complement=inx)
   endif else begin
   	;eliminate stars only detected in K band 
	   ind=where((mk ge 17.5 and mj eq -999.0 and mh eq -999.0) or (mk ge mklim) $
	   or (mh ge mhlim) or (mj ge mjlim) or (mj le mjlim2) or (mh le mhlim2) $
	   or (mk le mklim2),complement=inx)   	
   endelse
   ;ind=where(mk ge 0)
   id=indgen(n_elements(inx))
   
   final={id:id,x:xx[inx],y:yy[inx],mj:mj[inx],mh:mh[inx],mk:mk[inx],$
       mjerr:mjerr[inx],mherr:mherr[inx],mkerr:mkerr[inx],group:group[inx],ctts:ctts[inx]}
  
  ;Group stars for HCN related and continuum related
   
   ;final={x:xx[inx],y:yy[inx],mj:mj[inx],mh:mh[inx],mk:mk[inx],$
   ;      mjerr:mjerr[inx],mherr:mherr[inx],mkerr:mkerr[inx],group:group[inx],ctts:ctts[inx]}


END

