; This function transform the luminosity to stellar mass
PRO STELLARMASS, cat, result
   COMMON share,conf
   loadconfig

   neage=0.25  
   swage=0.5
   fsage=1.5
   
   mass=fltarr(n_elements(cat.x))
   
   ; Data of NE cluster
   t=neage
   t1=neage
   loadiso_dm,iso,av=0,age=t
   loadiso_sdf,iso1,av=0,age=neage
   ;loadiso_bm,iso2,av=0,age=t1
   
   lowind=where(cat.group eq 1 and cat.cmk ge min(iso.mk),count1) 
   higind=where(cat.group eq 1 and cat.cmk le min(iso.mk) and cat.cmk ge min(iso1.mk),count2)
   inx=where(cat.group eq 1 and cat.cmk le min(iso1.mk),count3)
   
   if count1 ne 0 then mass[lowind]=interpol(iso.mass,iso.mk,cat.cmk[lowind])
   if count2 ne 0 then mass[higind]=interpol(iso1.mass,iso1.mk,cat.cmk[higind])
   if count3 ne 0 then mass[inx]=7.0
   ;if count3 ne 0 then mass[inx]=1000
   print,count3
   ; Data of SW cluster
   t=swage
   t1=swage
   loadiso_dm,iso,av=0,age=t
   loadiso_sdf,iso1,av=0,age=swage
   ;loadiso_bm,iso2,av=0,age=t1
   
   lowind=where(cat.group eq 2 and cat.cmk ge min(iso.mk),count1) 
   higind=where(cat.group eq 2 and cat.cmk le min(iso.mk) and cat.cmk ge min(iso1.mk),count2)
   inx=where(cat.group eq 2 and cat.cmk le min(iso1.mk),count3)
   
   if count1 ne 0 then mass[lowind]=interpol(iso.mass,iso.mk,cat.cmk[lowind])
   if count2 ne 0 then mass[higind]=interpol(iso1.mass,iso1.mk,cat.cmk[higind])
   if count3 ne 0 then mass[inx]=7.0
        
   ; Data of field stars
   t=fsage
   loadiso_dm,iso,av=0,age=t
   loadiso_sdf,iso1,av=0,age=fsage
   
   
   lowind=where(cat.group eq 3 and cat.cmk ge min(iso.mk),count1) 
   higind=where(cat.group eq 3 and cat.cmk le min(iso.mk) and cat.cmk ge min(iso1.mk),count2)
   inx=where(cat.group eq 3 and cat.cmk le min(iso1.mk),count3)
   
   if count1 ne 0 then mass[lowind]=interpol(iso.mass,iso.mk,cat.cmk[lowind])
   if count2 ne 0 then mass[higind]=interpol(iso1.mass,iso1.mk,cat.cmk[higind])
   if count3 ne 0 then mass[inx]=1000
   
   for i=0, n_elements(mass)-1 do begin
      if mass[i] ge 70 then mass[i]=-999.0
   endfor
   
   
   ind=where(cat.group eq 1 and mass ge 0)
   print,"NE mass = ",total(mass[ind])
   
   ind=where(cat.group eq 2 and mass ge 0)
   print,"SW mass = ",total(mass[ind])

   ind=where(cat.group eq 3 and mass ge 0)
   print,"DS mass = ",total(mass[ind])
   
   ind=where(mass ge 0)
   print,"Total mass = ",total(mass[ind])
   result={id:cat.id,x:cat.x,y:cat.y,mj:cat.mj,mh:cat.mh,$
      mk:cat.mk,mjerr:cat.mjerr,mherr:cat.mherr,$
      mkerr:cat.mkerr,cmj:cat.cmj,cmh:cat.cmh,$
      cmk:cat.cmk,av:cat.av,avk:cat.avk,mass:mass,group:cat.group}
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
   bin=0.20
   erase & multiplot, [2,1]   
   
   ind=where(cor.group eq 2)       
   
   print,total(mass[ind])
   h=histogram(mass[ind],min=mass_min,max=mass_max,bin=bin)
   xh=(findgen(n_elements(h))*bin)+mass_min
 ;  plot,xh,h,psym=10,/ylog,xstyle=1,ystyle=1,/xlog,yrange=[0.5,400],xrange=[10,mass_min],$
 ;    xticks=2,ytitle='Number',xtitle='Mass',font=1,charsize=1.5,xthick=3.0,ythick=3.0,$
 ;    thick=3.0
   plot,xh,h,psym=10,/ylog,xstyle=1,ystyle=1,/xlog,yrange=[0.5,400],xrange=[20,mass_min],$
     ytitle='Number',xtitle='Mass',font=1,charsize=1.5,xthick=3.0,ythick=3.0,$
     thick=3.0
   err=alog10([h])
   err[where(h eq 1)]=1.0
   errplot,xh,h-err,h+err,symsize=2.0
   yy=alog10(h)
   yy[where(h eq 1)]=0.0
   ind=where(yy ne -!VALUES.F_INFINITY and xh le 20.0 and xh ge 0.05)
   coeff=linfit(alog10(xh[ind]),yy[ind],yfit=yfit,sigma=sigma)
   xyouts,8,250,'Cluster stars (!9G!X='$
      +string(coeff[1],format='(F5.2)')+'!Z(00B1)!X'+string(sigma[1],format='(F4.2)')$
      +')',font=1,charsize=1.2
   oplot,xh[ind],10^yfit,line=2,thick=2.5,color=red & multiplot
   
   
   print,"Coeffecient = ",coeff
   print,"Sigma = ",sigma
   
   inx=where(cor.group eq 1)
   h=histogram(mass[inx],min=mass_min,max=mass_max,bin=bin)
   xh=(findgen(n_elements(h))*bin)+mass_min
   plot,xh,h,psym=10,/ylog,ystyle=1,/xlog,yrange=[0.5,400],xrange=[20,0.1],$
     font=1,charsize=1.5,xthick=3.0,ythick=3.0,thick=3.0,xstyle=1
   err=alog10([h])
   err[where(h eq 1)]=1.0
   errplot,xh,h-err,h+err
   yy=alog10(h)
   yy[where(h eq 1)]=0.0
   ind=where(yy ne -!VALUES.F_INFINITY and xh le 20.0 and xh ge 0.5)
   coeff=linfit(alog10(xh[ind]),yy[ind],yfit=yfit,sigma=sigma)
   xyouts,8,250,'Distributed Stars (!9G!X='$
      +string(coeff[1],format='(F5.2)')+'!Z(00B1)!X'+string(sigma[1],format='(F4.2)')$
      +')',font=1,charsize=1.2
   oplot,xh[ind],10^yfit,line=2,thick=2.5,color=red& multiplot
   
   
   print,"Coeffecient = ",coeff
   print,"Sigma = ",sigma
   
   
   multiplot,[1,1],/init
   cleanplot,/silent
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif

   
END

