; This function transform the luminosity to stellar mass
PRO STELLARMASS, cat, result, age=age
   COMMON share,conf
   loadconfig

   neage=age
   
   mass=fltarr(n_elements(cat.x))
   
   ; Data of NE cluster
   loadiso_dm,iso,av=0,age=age
   loadiso_sdf,iso1,av=0,age=neage
   
   lowind=where(cat.group ne 0 and cat.cmk ge min(iso.mk),count1) 
   higind=where(cat.group ne 0 and cat.cmk le min(iso.mk) and cat.cmk ge min(iso1.mk),count2)
   inx=where(cat.group eq 1 and cat.cmk le min(iso1.mk),count3)
   
   if count1 ne 0 then mass[lowind]=interpol(iso.mass,iso.mk,cat.cmk[lowind])
   if count2 ne 0 then mass[higind]=interpol(iso1.mass,iso1.mk,cat.cmk[higind])
   if count3 ne 0 then mass[inx]=1000
      
     
   for i=0, n_elements(mass)-1 do begin
      if mass[i] ge 1000 then mass[i]=-999.0
   endfor
   
   ind=where(mass ge 0, count)
   print,"Total mass = ",total(mass[ind])
   print,"Total number = ", count
   result={id:indgen(n_elements(cat.x))+1,x:cat.x,y:cat.y,mj:cat.mj,mh:cat.mh,$
      mk:cat.mk,mjerr:cat.mjerr,mherr:cat.mherr,$
      mkerr:cat.mkerr,cmj:cat.cmj,cmh:cat.cmh,$
      cmk:cat.cmk,av:cat.av,avk:cat.avk,mass:mass,group:cat.group,ctts:cat.ctts}
END

PRO AVGISOMASS, cat, result
   COMMON share,conf
   loadconfig

   
   mass=fltarr(n_elements(cat.x))
   
   d=4000.0
   factor=5.0*alog10(d)-5.0
   ; Data of NE cluster
   loadavgiso,iso,/sdf
   
   
   plot,cat.mh-cat.mk,cat.mk,psym=4,yrange=[20,8],ystyle=1,xrange=[-1,3]
   oplot,iso.mh-iso.mk,iso.mk+factor,color=255
   
   for i=0,n_elements(cat.mk)-1 do begin
      b=cat.mk[i]-1.78*(cat.mh[i]-cat.mk[i])
      
      if cat.mh[i]-cat.mk[i] ge 0 then begin
         xx=getseries(-1.0,cat.mh[i]-cat.mk[i],0.001)
         k1=1.78*xx+b
         
         k2=interpol(iso.mk+factor,iso.mh-iso.mk,xx)
         
         for j=0,n_elements(k1)-1 do begin
            d=sqrt((k1[j]-k2)^2+(xx[j]-xx)^2)
            ind=where(d eq min(d) and min(d) le 0.01,count)
            if count ne 0 then begin
               plots,xx[ind],k1[ind],psym=4,color=65535
               mass[i]=interpol(iso.mass,iso.mk+factor,k1[ind])
               break
            endif
         endfor
         
         oplot,xx,k1,color=255
         ;oplot,xx,k2,psym=4,color=65535
           
;          ind=where(k1-k2 eq min(k1-k2) and min(k1-k2) le 0.01)
;          plots,xx[ind],k1[ind],psym=4,color=255
;          mass[i]=interpol(iso.mass,iso.mk+factor,k1[ind])
;          print,cat.mh[i]-cat.mk[i],cat.mk[i],k1[ind],mass[i]
      endif
   endfor
   
   ;ind=where(cat.group ne 0 and cat.cmk ge min(iso.mk) and cat.cmk le max(iso.mk),count1)
;    ind=where(cat.group ne 0,count1)
;    
;    ;lowind=where(cat.group ne 0 and cat.cmk ge min(iso.mk),count1) 
;    ;higind=where(cat.group ne 0 and cat.cmk le min(iso.mk) and cat.cmk ge min(iso1.mk),count2)
;    inx=where(cat.group eq 1 and cat.cmk le min(iso.mk),count3)
;    
;    if count1 ne 0 then mass[ind]=interpol(iso.mass,iso.mk,cat.cmk[ind])
;    ;if count2 ne 0 then mass[higind]=interpol(iso1.mass,iso1.mk,cat.cmk[higind])
;    if count3 ne 0 then mass[inx]=1000
;       
;      
;    for i=0, n_elements(mass)-1 do begin
;       if mass[i] ge 1000 then mass[i]=-999.0
;    endfor
;    
;    ind=where(mass ge 0, count)
;    print,"Total mass = ",total(mass[ind])
;    print,"Total number = ", count
    result={id:indgen(n_elements(cat.x))+1,x:cat.x,y:cat.y,mj:cat.mj,mh:cat.mh,$
       mk:cat.mk,mjerr:cat.mjerr,mherr:cat.mherr,$
       mkerr:cat.mkerr,mass:mass,group:cat.group,ctts:cat.ctts}


END



PRO CLUSTERIMF, cor, PS=ps
   COMMON share,setting
   loadconfig
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=setting.pspath+'clusterimf.eps',$
         /color,xsize=20,ysize=10,xoffset=0.4,yoffset=0,$
         SET_FONT='Helvetica Bold',/TT_FONT,/encapsulated
         
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
   endif else begin
     blue=65535
      red=255
      green=32768    
   endelse

   ind=where(cor.mass ge -99.0)
  
   x=cor.x[ind]
   y=cor.y[ind]
   
   mass=cor.mass[ind]

   mass_min=0.1
   mass_max=20.0
   bin=0.5
   erase & multiplot, [2,1]   
   
   ind=where(cor.group eq 2)       
   
   print,total(mass[ind])
   h=histogram(mass[ind],min=mass_min,max=mass_max,bin=bin)
   xh=(findgen(n_elements(h))*bin)+mass_min
 ;  plot,xh,h,psym=10,/ylog,xstyle=1,ystyle=1,/xlog,yrange=[0.5,400],xrange=[10,mass_min],$
 ;    xticks=2,ytitle='Number',xtitle='Mass',font=1,charsize=1.5,xthick=3.0,ythick=3.0,$
 ;    thick=3.0
   plot,alog10(xh),alog10(h),psym=10,xstyle=1,ystyle=1,yrange=[0,1.5],xrange=[1,-1],$
     ytitle='Number (Log N)',xtitle='Mass (Log M)',font=1,charsize=1.5,xthick=3.0,ythick=3.0,$
     thick=3.0
   err=alog10([h])
   err[where(h eq 1)]=1.0
   ;errplot,xh,h-err,h+err,symsize=2.0
   yy=alog10(h)
   yy[where(h eq 1)]=0.0
   ind=where(yy ne -!VALUES.F_INFINITY and xh le 20.0 and xh ge 0.05)
   coeff=linfit(alog10(xh[ind]),yy[ind],yfit=yfit,sigma=sigma)
   xyouts,0.7,1.4,'Cluster stars (!9G!X='$
      +string(coeff[1],format='(F5.2)')+'!Z(00B1)!X'+string(sigma[1],format='(F4.2)')$
      +')',font=1,charsize=1.2
   oplot,alog10(xh[ind]),yfit,line=2,thick=2.5,color=red & multiplot
   
   
   print,"Coeffecient = ",coeff
   print,"Sigma = ",sigma
   
   inx=where(cor.group eq 1)
   h=histogram(mass[inx],min=mass_min,max=mass_max,bin=bin)
   xh=(findgen(n_elements(h))*bin)+mass_min
   ind=where(h eq 0 and xh le 5,count) 
   if count ne 0 then h[ind]=1
   
   plot,alog10(xh),alog10(h),psym=10,ystyle=1,yrange=[0,1.5],xrange=[1,-1],$
     font=1,charsize=1.5,xthick=3.0,ythick=3.0,thick=3.0,xstyle=1
   err=alog10([h])
   err[where(h eq 1)]=1.0
   ;errplot,xh,h-err,h+err
   yy=alog10(h)
   yy[where(h eq 1)]=0.0
   ind=where(yy ne -!VALUES.F_INFINITY and xh le 20.0 and xh ge 0.5)
   coeff=linfit(alog10(xh[ind]),yy[ind],yfit=yfit,sigma=sigma)
   xyouts,0.7,1.4,'Distributed Stars (!9G!X='$
      +string(coeff[1],format='(F5.2)')+'!Z(00B1)!X'+string(sigma[1],format='(F4.2)')$
      +')',font=1,charsize=1.2
   oplot,alog10(xh[ind]),yfit,line=2,thick=2.5,color=red& multiplot
   
   
   print,"Coeffecient = ",coeff
   print,"Sigma = ",sigma
   
   
   multiplot,[1,1],/init
   cleanplot,/silent
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif

   
END

