; This function loads the photometry result of DAOPHOT
PRO DAOPHOT, cat
   COMMON share,conf
   loadconfig
   
   RESTORE,conf.catpath+'dao_j_080330.db'
   
   id=indgen(n_elements(pv_dat[0,*]))
   x=reform(pv_dat[0,*])
   y=reform(pv_dat[1,*])
   mag=reform(pv_dat[7,*])-0.046124
   magerr=reform(pv_dat[8,*])
   
   ; Add 2MASS stars
   id=indgen(n_elements(pv_dat[0,*])+3)
   x=[x,665,305,635]
   y=[y,212,560,392]
   mag=[mag,11.474,12,327,12.371]
   magerr=[magerr,0.022,0.022,0.026]
   ind=where(mag le 25)
   ;jh={id:id,x:x,y:y,mag:mag,magerr:magerr}
   
   jh={id:id[ind],x:x[ind],y:y[ind],mag:mag[ind],magerr:magerr[ind]}
   
   
   RESTORE,conf.catpath+'dao_h_080418.db'
   ;RESTORE,imgpath+'dao_h_080330.db'
   
   id=indgen(n_elements(pv_dat[0,*]))
   x=reform(pv_dat[0,*])
   y=reform(pv_dat[1,*])
   mag=reform(pv_dat[7,*])-0.100760;-0.0857635
   ;mag=reform(pv_dat[7,*])-0.0857635
   magerr=reform(pv_dat[8,*])

   
   ;Adding 2MASS stars
   id=indgen(n_elements(pv_dat[0,*])+7)
   x=[x,161,305,145,665,805,785,635,772]
   y=[y,600,560,238,212,276,496,392,990]
   mag=[mag,11.910,11.586,11.667,10.532,11.857,11.880,10.631,11.952]
   magerr=[magerr,0.016,0.018,0.016,0.016,0.018,0.016,0.021,0.016]
   ind=where(mag le 25)
   hh={id:id[ind],x:x[ind],y:y[ind],mag:mag[ind],magerr:magerr[ind]}
   
   RESTORE,conf.catpath+'dao_k_080418.db'
   ;RESTORE,imgpath+'dao_k_080330.db'
   
   id=indgen(n_elements(pv_dat[0,*]))
   x=reform(pv_dat[0,*])
   y=reform(pv_dat[1,*])
   mag=reform(pv_dat[7,*])-0.152250;-0.142190  
   ;mag=reform(pv_dat[7,*])-0.142190  
   magerr=reform(pv_dat[8,*])

   ;Adding 2MASS stars
   id=indgen(n_elements(pv_dat[0,*])+21)
   x=[x,161,307,213,145,772,611,708,872,786,635,615,650,675,503,497,499,443,$
      665,805,875,935,743]
   y=[y,602,560,446,239,990,800,859,753,496,391,346,353,355,512,194,408,378,$
      212,276,236,150,72]
   mag=[mag,11.796,11.223,12.681,11.206,11.155,12.839,12.823,12.723,11.228,$
      9.251,11.598,11.868,12.588,11.455,12.537,12.665,12.718,9.697,11.489,$
      12.361,12.552,12.834]
   magerr=[magerr,0.019,0.019,0.027,0.019,0.019,0.024,0.024,0.024,0.019,0.019,$
      0.020,0.027,0.041,0.038,0.025,0.025,0.024,0.018,0.019,0.021,0.018,0.027]

   ind=where(mag le 25) 
   kh={id:id[ind],x:x[ind],y:y[ind],mag:mag[ind],magerr:magerr[ind]}

   cat={j:jh,h:hh,k:kh} 

END

PRO RUNSEXTRACTOR
   COMMON share,conf
   loadconfig
   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'s233ir_j_ref.fits -CHECKIMAGE_NAME '$
      +conf.fitspath+'refcheck_j.fits -CATALOG_NAME '+conf.catpath+'s233ir_j_ref.sex -MAG_ZEROPOINT 25.0 '$
      +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
      +' -FILTER_NAME '+conf.confpath+'default.conv '$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
      +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '$
      +' -ASSOC_NAME '+conf.confpath+'saturated_ref.list '$
      +' -ASSOC_DATA 2,3 -ASSOC_PARAMS 2,3 -ASSOC_TYPE MAX '$
       +' -ASSOC_RADIUS 10.0 -ASSOCSELEC_TYPE -MATCHED'


   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'s233ir_h_ref.fits -CHECKIMAGE_NAME '$
      +conf.fitspath+'refcheck_h.fits -CATALOG_NAME '+conf.catpath+'s233ir_h_ref.sex -MAG_ZEROPOINT 25.0 '$
      +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
      +' -FILTER_NAME '+conf.confpath+'default.conv '$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
      +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '$
      +' -ASSOC_NAME '+conf.confpath+'saturated_ref.list '$
      +' -ASSOC_DATA 2,3 -ASSOC_PARAMS 2,3 -ASSOC_TYPE MAX '$
      +' -ASSOC_RADIUS 10.0 -ASSOCSELEC_TYPE -MATCHED'

   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'s233ir_k_ref.fits -CHECKIMAGE_NAME '$
      +conf.fitspath+'refcheck_k.fits -CATALOG_NAME '+conf.catpath+'s233ir_k_ref.sex -MAG_ZEROPOINT 25.0 '$
      +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
      +' -FILTER_NAME '+conf.confpath+'default.conv '$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
      +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '$
      +' -ASSOC_NAME '+conf.confpath+'saturated_ref.list '$
      +' -ASSOC_DATA 2,3 -ASSOC_PARAMS 2,3 -ASSOC_TYPE MAX '$
      +' -ASSOC_RADIUS 10.0 -ASSOCSELEC_TYPE -MATCHED'

      
END

PRO GETREFSTAR, catalog
   COMMON share,conf 
   loadconfig

   ; eliminate saturated stars

   readcol,conf.catpath+'s233ir_j_ref.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   ;index=where(flag eq 0 and class ge 0.85 and mag le 16.2)
   index=where(id ne 0)
   j={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.0470991,$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   readcol,conf.catpath+'s233ir_h_ref.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   ;index=where(flag eq 0 and class ge 0.85 and mag  le 15.8)
   index=where(id ne 0)
   h={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.0766993,$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   readcol,conf.catpath+'s233ir_k_ref.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   ;index=where(flag eq 0 and class ge 0.85 and mag le 15)
   index=where(id ne 0)
   k={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.207300,$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   
   catalog={j:j,h:h,k:k}   
END


;
; This function takes two sets of catalogue and do a matching
;    to register star detected by any routine
;
PRO MATCH_CATALOG,x1,y1,mag1,merr1,x2,y2,mag2,match
   ; x1  : vector of X positions of field star (by FIND)
   ; y1  : vector of Y positions of field star(by FIND)
   ; mag1   : vector of Ks band magnitudes of field star (by APER)
   ; merr1  : vector of magnitudes error of star (by APER)  
   ; x2  : vector of X positions of catalog star (2MASS)
   ; y2  : vector of Y positions of catalog star (2MASS)
   ; mag2   : vector of Ks band magnitudes of catalog star
   ; match : structure that stores the matched catalog
   ; .x  :  vector of X positions of matched stars
   ; .y  :  vector of Y positions of matched stars
   ; .fmag1:  vector of instrumental magnitude
   ; .fmag2:  vector of magnitude of catalog stars (2MASS) 
   flag=intarr(n_elements(x2))
   flag[*]=0
   x=0
   y=0
   fmag1=0
   fmag2=0

   n=0
   for i=0,n_elements(x1)-1 do begin
      dist=sqrt((x1[i]-x2)^2+(y1[i]-y2)^2)
      ind=where(dist eq min(dist) and min(dist) le 5,count)
      
      if (count ne 0) then begin
         if flag[ind] eq 0 then begin
            if n eq 0 then begin
               x=x1[i]
               y=y1[i]
               fmag1=mag1[i]
               fmag2=mag2[ind]
               magerr=merr1[i]
            endif else begin
               x=[x,x1[i]]
               y=[y,y1[i]]
               fmag1=[fmag1,mag1[i]]
               fmag2=[fmag2,mag2[ind]]
               magerr=[magerr,merr1[i]]
            endelse           
            
            n=n+1
            flag[ind]=1 
         endif
      endif
   endfor
   match={id:findgen(n_elements(x)),x:x,y:y,fmag1:fmag1,fmag2:fmag2,magerr:magerr}
   
END


PRO MKCATALOG, cat, final
   COMMON share,conf
   
   loadconfig
   
   ; The first step is to register the catalog
   
   ; Mininum distance in pixels
   d=3.0
   
   j=0
   ; This is the flag for star registered.
   jflag=intarr(n_elements(cat.j.x))
   kflag=intarr(n_elements(cat.k.x))
   
   
   ; Initialize the arrays
   xx=fltarr(n_elements(cat.h.x))
   yy=fltarr(n_elements(cat.h.x))
   mj=fltarr(n_elements(cat.h.x))
   mh=fltarr(n_elements(cat.h.x))
   mk=fltarr(n_elements(cat.h.x))
   mjerr=fltarr(n_elements(cat.h.x))
   mherr=fltarr(n_elements(cat.h.x))
   mkerr=fltarr(n_elements(cat.h.x))
   
   ; Beginning of the loop
   for i=0,n_elements(cat.h.x)-1 do begin
      x=cat.h.x[i]
      y=cat.h.y[i]
      
      xx[i]=x
      yy[i]=y
      mh[i]=cat.h.mag[i]
      mherr[i]=cat.h.magerr[i]

      ; Looking for k band
      dist1=sqrt(((cat.k.x-x)^2)+((cat.k.y-y)^2))
      ind1=where(dist1 eq min(dist1) and (min(dist1) le d) and (kflag eq 0), count1)
      if (count1 ne 0) then begin
         mk[i]=cat.k.mag[ind1]
         mkerr[i]=cat.k.magerr[ind1]
         kflag[ind1]=1
      endif else begin
         mk[i]=-999.0
         mkerr[i]=-999.0
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
   
   
   ; Set the limiting magnitude of each filter
   mjlim=35.0
   mhlim=35.0
   mklim=35.0

   ;eliminate stars only detected in K band 
   ind=where((mk ge 17.5 and mj eq -999.0 and mh eq -999.0) or (mk ge mklim) $
   and (mh or mhlim) and (mj or mjlim), complement=inx)
   id=indgen(n_elements(inx))
   
   final={id:id,x:xx[inx],y:yy[inx],mj:mj[inx],mh:mh[inx],mk:mk[inx],$
       mjerr:mjerr[inx],mherr:mherr[inx],mkerr:mkerr[inx]}

 
END

PRO GROUPSTAR, cat,final
  
   xx=cat.x
   yy=cat.y
   
   ;Selecting NE cluster
   neind=where((((xx-537.0)^2 + (yy-530.0)^2) le 11000) or $
   (xx ge 436 and xx le 448 and yy ge 454 and yy le 471),count)
   
   group=intarr(n_elements(xx))   
   group[neind]=1
   
   swind=where(((xx-659.0)^2 + (yy-369.0)^2) le 10000 ,count) 
   group[swind]=2

   ind=where((((xx-659.0)^2 + (yy-369.0)^2) le 10000) $
      or (((xx-537.0)^2 + (yy-530.0)^2) le 11000 or $
      (xx ge 436 and xx le 448 and yy ge 454 and yy le 471)), complement=inx)      
   group[inx]=3

    final={id:cat.id,x:cat.x,y:cat.y,mj:cat.mj,mh:cat.mh,mk:cat.mk,$
            mjerr:cat.mjerr,mherr:cat.mherr,mkerr:cat.mkerr,group:group}
            
END













