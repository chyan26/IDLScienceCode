PRO CLUSTERAGE, cat, PS=ps
   COMMON share,setting
   loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=setting.pspath+'clusterage.eps',$
         /color,xsize=30,ysize=20,xoffset=0.4,yoffset=0,$
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
   
   mag_min=-5.0
   mag_max=5.0
   bin=1
   
   resetplt,/all
   
   ind=where(cat.group ne 0)
   h=histogram(cat.cmk[ind],min=mag_min,max=mag_max,bin=bin)
   xh=(findgen(n_elements(h))*bin)+mag_min
   plot,xh,h,psym=10,yrange=[1,200],xrange=[-5,8],ystyle=1,$
      xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=2.5,$
      xthick=3.0, ythick=3.0, thick=3.0,/ylog,xtitle='K magnitude',ytitle='Star count (N)'
    
   hmax=total(h)
   print,hmax
   ;------------------ Cluster  -----------------------------------------------
   ;age=0.3
   ;simklf,klf,age
   
   
   ;ind=where(cat.group eq 2) 
   ;h=histogram(cat.cmk[ind],min=mag_min,max=mag_max,bin=bin)
   ;xh=(findgen(n_elements(h))*bin)+mag_min
   ;oplot,xh+2.5,h,psym=10,line=1,thick=3
   
   ;ind=where(cat.group eq 1) 
   ;h=histogram(cat.cmk[ind],min=mag_min,max=mag_max,bin=bin)
   ;xh=(findgen(n_elements(h))*bin)+mag_min
   ;oplot,xh,h,psym=10,line=2
   
   ;salpeterimf,m1,n1,rm1
   msimf,m2,n2,rm2
   muenchimf,m3,n3,rm3
   
   
   ;modelklf,rm1,klf1,age=0.5;,factor=1.5
   modelklf,rm2,klf2,age=0.1,factor=1.5
   modelklf,rm3,klf3,age=0.05;,factor=1.5
   
   ;avgklf,mlf
   ;age=0.5
   ;simklf,klf,age
   ;oplot,klf1.xh,klf1.h,color=blue,line=2,thick=4.0
   
   ;oplot,klf2.xh,klf1.h/10.0,color=blue,thick=4.0
   oplot,klf2.xh,klf2.h/6.0,color=blue,thick=4.0
   oplot,klf3.xh,klf3.h/10.0,color=blue,thick=4.0
   ;oplot,klf3.xh,klf3.h,color=blue,line=3,thick=4.0 
 
   ;oplot,mlf.xh2,mlf.hh2,color=red,thick=4 
   
   ;oplot,xh,h,psym=10,yrange=[1,200],xrange=[-5,6],ystyle=1,$
   ;   xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=3.0,$
   ;   xthick=3.0, ythick=3.0, thick=3.0,/ylog,xtitle='K magnitude',ytitle='Star count (N)'
   
   ;simh1=histogram(klf.mk1,min=mag_min,max=mag_max,bin=bin)

   ;xyouts,0,100, 'Age = 0.3 Myr', font=1,charsize=2.4 
   ;xyouts,-4,100, 'Cluster stars', font=1,charsize=2.4 
   ;oplot,klf.xh1,max(h)*klf.h1/max(klf.h1),color=blue,line=2,thick=4.0
   ;oplot,klf.xh2,max(h)*klf.h2/max(klf.h2-1),color=blue,thick=4.0
   ;oplot,klf.xh3,max(h)*klf.h3/max(klf.h3),color=blue,line=3,thick=4.0  & multiplot
   
   ;age=5
   ;simklf,klf,age
   ;ind=where(cat.group eq 1) 
   ;h=histogram(cat.cmk[ind],min=mag_min,max=mag_max,bin=bin)
   ;xh=(findgen(n_elements(h))*bin)+mag_min
   ;plot,xh,h,psym=10,yrange=[1,200],xrange=[-5,6],ystyle=1,$
   ;   xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=3.0,$
   ;   xthick=3.0, ythick=3.0, thick=3.0,/ylog
   
   ;xyouts,0,100, 'Age = 5 Myr', font=1,charsize=2.4
   ;xyouts,-4,100, 'distributes stars', font=1,charsize=2.4
   ;oplot,klf.xh1,max(h)*klf.h1/max(klf.h1),color=blue,line=2,thick=4.0
   ;oplot,klf.xh2,max(h)*klf.h2/max(klf.h2-1),color=blue,thick=4.0
   ;oplot,klf.xh3,max(h)*klf.h3/max(klf.h3),color=blue,line=3,thick=4.0  & multiplot

	;endfor

 
   ;multiplot,[1,1],/init
   resetplt,/all
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif

END



PRO ALLAGE, cat, PS=ps
   COMMON share,setting
   loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=setting.pspath+'allage.eps',$
         /color,xsize=25,ysize=20,xoffset=0.4,yoffset=0,$
         SET_FONT='Helvetica',/TT_FONT,/encapsulated
         
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
   endif else begin
      blue=65535
      red=255
      green=32768    
   endelse
   
   mag_min=-6.0
   mag_max=5.0
   bin=1
   
   ind=where(cat.group eq 2)
   h=histogram(cat.cmk[ind],min=mag_min,max=mag_max,bin=bin)
   xh=(findgen(n_elements(h))*bin)+mag_min
   ind=where(finite(alog10(h), /infinity) or xh le -6) 

   h[ind]=1
   plot,xh,alog10(h)/max(alog10(h)),psym=10,yrange=[0,1.7],xrange=[-5,8],ystyle=1,$
      xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=2.5,$
      xthick=5.0, ythick=5.0, thick=5.0,xtitle='Absolute K magnitude',$
      ytitle='Star count (Log N/factor)'
    
   ;hmax=total(h)
   ;print,hmax
   
   ;oplot,mklf.xh3,mklf.hh3/max(mklf.hh3)
   
   ;mxh=mklf.xh3
   ;mh=mklf.hh3/1.5/max(mklf.hh3)
   ;oplot,mxh,mh*1.5,color=red,line=2,thick=5
   
   ;print,total(h),total(mh)
   ;yfit = GAUSSFIT(mxh[0:23], mh[0:23], a,estimate=[1,2,2], NTERMS=3)
   
     
   ;fwhm=a[2];sqrt(2*alog(2))*a[2]
   ;x1=a[1]-fwhm
   ;x2=a[1]+fwhm
   
   ;oplot,[x1,x2],[1.2,1.2],color=blue,thick=5
 
   
   salpeterimf,m1,n1,rm1
   msimf,m2,n2,rm2
   muenchimf,m3,n3,rm3
 
   modelklf,rm3,klf1,age=1.0
   modelklf,rm3,klf2,age=0.1
   modelklf,rm3,klf3,age=0.05
   
   oplot,klf1.xh,alog10(klf1.h)/max(alog10(klf1.h)),thick=10,color=red
   oplot,klf2.xh,alog10(klf2.h)/max(alog10(klf2.h)),thick=10,color=red,line=3
   oplot,klf3.xh,alog10(klf3.h)/max(alog10(klf3.h)),thick=10,line=1
   ;oplot,xh+1.5,alog10(h)/max(alog10(h)),psym=10,line=4,thick=5
   
   
   ; interpolate the KLF
   ;xx=klf1.xh
   ;yy=alog10(klf1.h)/2.2
   ;uy=interpol(yy,xx,xh)
   ;ind=where(xh le min(xx))
   ;oplot,xh[ind],uy[ind],thick=5,color=red
   
   ;oplot,[2.5,2.5],[0,2],color=green,thick=5,line=2
   ;oplot,[0,0],[0,2],color=green,thick=5,line=2
   ;oplot,[1.5,1.5],[0,2],color=green,thick=5,line=2
   
   ;xyouts,0.9,1.25,'D=2.0kpc',charsize=2.0
   ;xyouts,1.7,1.43,'D=1.2kpc',charsize=2.0
   ;xyouts,-0.5,1.05,'D= 4 kpc',charsize=2.0
   
   ;arrow,0,1.2,1.5,1.2,/data,thick=5,color=blue,/solid,hthick=1
   ;arrow,0,1.35,2.5,1.35,/data,thick=5,color=blue,/solid,hthick=1
   
   ;oplot,[4,5],[1.55,1.55],line=2,thick=5,color=red
   oplot,[4,5],[1.45,1.45],thick=5,color=red
   oplot,[4,5],[1.35,1.35],line=5,thick=5,color=red
   oplot,[4,5],[1.25,1.25],thick=5,line=1
   
   ;xyouts,5.3, 1.52,'1 - 6 Myr',charsize=1.8
   xyouts,5.3, 1.42,'1.0 Myr',charsize=1.8,font=1
   xyouts,5.3, 1.32,'0.1 Myr',charsize=1.8,font=1
   xyouts,5.3, 1.22,'0.05 Myr',charsize=1.8,font=1
   resetplt,/all
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif


END




PRO KLFAGE, cat, mklf, PS=ps
   COMMON share,setting
   loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=setting.pspath+'allage.eps',$
         /color,xsize=25,ysize=20,xoffset=0.4,yoffset=0,$
         SET_FONT='Helvetica',/TT_FONT,/encapsulated
         
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
   endif else begin
      blue=65535
      red=255
      green=32768    
   endelse
   
   mag_min=-6.0
   mag_max=5.0
   bin=1
   
   ind=where(cat.group ne 0)
   h=histogram(cat.cmk[ind],min=mag_min,max=mag_max,bin=bin)
   xh=(findgen(n_elements(h))*bin)+mag_min
   ind=where(finite(alog10(h), /infinity) or xh le -6) 

   h[ind]=1
   plot,xh,alog10(h),psym=10,yrange=[0,1.7],xrange=[-5,8],ystyle=1,$
      xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=2.5,$
      xthick=3.0, ythick=3.0, thick=5.0,xtitle='Absolute K magnitude',$
      ytitle='Star count (Log N)'
    
   ;hmax=total(h)
   ;print,hmax
   
   ;oplot,mklf.xh3,mklf.hh3/max(mklf.hh3)
   
   mxh=mklf.xh3
   mh=mklf.hh3/1.5/max(mklf.hh3)
   oplot,mxh,mh*1.8,color=red,line=2,thick=5
   
   ;print,total(h),total(mh)
   yfit = GAUSSFIT(mxh[0:23], mh[0:23], a,estimate=[1,2,2], NTERMS=3)
   
     
   fwhm=a[2];sqrt(2*alog(2))*a[2]
   x1=a[1]-fwhm
   x2=a[1]+fwhm
   
   ;oplot,[x1,x2],[1.2,1.2],color=blue,thick=5
 
   
   salpeterimf,m1,n1,rm1
   msimf,m2,n2,rm2
   muenchimf,m3,n3,rm3
 
   modelklf,rm3,klf1,age=0.5
   modelklf,rm3,klf2,age=0.1
   modelklf,rm3,klf3,age=0.05
   
   oplot,klf1.xh,alog10(klf1.h)/max(alog10(klf1.h))*1.3,thick=5,color=red
   ;oplot,klf2.xh,alog10(klf2.h)/max(alog10(klf2.h))*1.3,thick=5,color=red,line=3
   oplot,klf3.xh,alog10(klf3.h)/max(alog10(klf3.h))*1.3,thick=5,line=1
   ;oplot,xh+1.5,alog10(h)/max(alog10(h)),psym=10,line=4,thick=5
   
   
   ; interpolate the KLF
   ;xx=klf1.xh
   ;yy=alog10(klf1.h)/2.2
   ;uy=interpol(yy,xx,xh)
   ;ind=where(xh le min(xx))
   ;oplot,xh[ind],uy[ind],thick=5,color=red
   
   ;oplot,[2.5,2.5],[0,2],color=green,thick=5,line=2
   oplot,[0.5,0.5],[0,2],color=green,thick=5,line=2
   oplot,[2.0,2.0],[0,2],color=green,thick=5,line=2
   
   xyouts,0.9,1.45,'D=2.0kpc',charsize=2.0
   ;xyouts,1.7,1.43,'D=1.2kpc',charsize=2.0
   xyouts,-0.5,1.25,'D= 4 kpc',charsize=2.0
   
   arrow,2.0,1.4,0.5,1.4,/data,thick=5,color=blue,/solid,hthick=1
   ;arrow,0,1.35,2.5,1.35,/data,thick=5,color=blue,/solid,hthick=1
   
   oplot,[4,5],[1.55,1.55],line=2,thick=5,color=red
   oplot,[4,5],[1.45,1.45],thick=5,color=red
   ;oplot,[4,5],[1.35,1.35],line=3,thick=5,color=red
   oplot,[4,5],[1.35,1.35],thick=5,line=1
   
   xyouts,5.3, 1.54,'1 - 6 Myr',charsize=1.8
   xyouts,5.3, 1.44,'0.5 Myr',charsize=1.8
  ; xyouts,5.3, 1.34,'0.1 Myr',charsize=1.8
   xyouts,5.3, 1.34,'0.05 Myr',charsize=1.8
   resetplt,/all
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif


END


