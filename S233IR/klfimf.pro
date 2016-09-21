
; this subroutine plot all age estimation together
PRO GETAGEPLOT, cat, PS=ps
   COMMON share,conf 
   loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+'allage.eps',$
         /color,xsize=40,ysize=15,xoffset=0.4,yoffset=0,$
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
   bin=0.5
   
   !p.font=1
   !p.charsize=1.4
   
   erase & multiplot, [3,1],mxtitsize=1.5,mytitsize=1.5

   
   age=[0.2,1]
   agestring=['0.2','1.0']

	   
    
   ; Data of NE cluster
   ;simklf,klf,0.5
   
   salpeterimf,m1,n1,rm1
   msimf,m2,n2,rm2
   muenchimf,m3,n3,rm3
   modelklf,rm1,klf1,age=0.25;,factor=1.5
   modelklf,rm2,klf2,age=0.25;,factor=1.5
   modelklf,rm3,klf3,age=0.25;,factor=1.5
   
   
   
   neind=where(cat.group eq 1 ,count) 
   print,'NE= ',count
   neh=histogram(cat.cmk[neind],min=mag_min,max=mag_max,bin=bin)
   nexh=(findgen(n_elements(neh))*bin)+mag_min
   ;print, 'NE=',median(mk[ind]),mean(mk[ind]),median(cor.avk[ind])
   ix=where(neh eq 0 and nexh ge -3 and nexh le 2 ,count)
   if count ne 0 then neh[ix]=1
   plot,nexh,alog10(neh),psym=10,yrange=[-0.1,1.6],xrange=[-5,8],$
   xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=2.5,ystyle=1,$
   xthick=5.0, ythick=5.0, thick=5.0,ytitle='Star count (Log N)
   
   xyouts,-4,1.5, 'NE cluster', font=1,charsize=2.0
   xyouts,1.5,1.5, 'Age = 0.25 Myr', font=1,charsize=2.0
   ;xyouts,2,75, 'Age = 0.02 Myr', font=1,charsize=1.5 
   ;xyouts,-4,75, 'NE cluster', font=1,charsize=1.5    
   ;oplot,klf1.xh,alog10(klf1.h)/2.5,color=blue,line=2,thick=5.0
   oplot,klf2.xh,alog10(klf2.h)/3.0,color=blue,thick=5.0
   oplot,klf3.xh,alog10(klf3.h)/3.0,color=blue,line=3,thick=5.0  & multiplot
	 
	 msimf,m2,n2,rm2
   modelklf,rm2,klf2,age=0.5;,factor=1.5
   modelklf,rm3,klf3,age=0.5;,factor=1.5
    ;simklf,klf,0.5
   swind=where(cat.group eq 2 ,count) 
   print,'SW= ',count
   ;print,count 
   swh=histogram(cat.cmk[swind],min=mag_min,max=mag_max,bin=bin)
   swxh=(findgen(n_elements(swh))*bin)+mag_min
   plot,swxh,alog10(swh),psym=10,yrange=[-0.1,1.6],xrange=[-2,6],ystyle=1,$
      xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=2.5,$
      xthick=5.0, ythick=5.0, thick=5.0
   ;oplot,nexh,alog10(neh),psym=10,line=3,thick=5
   
   print,swxh,swh   
   xyouts,2.5,1.5, 'Age = 0.5 Myr', font=1,charsize=2.0
   
   xyouts,-1,1.5, 'SW cluster', font=1,charsize=2.0
   ;oplot,[-0.6,0.5],[1.42,1.42],thick=5
   ;xyouts,-3,1.3, 'NE cluster', font=1,charsize=1.5
   ;oplot,[-0.6,0.5],[1.32,1.32],thick=5,line=3
     
   oplot,klf2.xh,alog10(klf2.h)/3.0,color=blue,thick=5.0 
   oplot,klf3.xh,alog10(klf3.h)/3.0,color=blue,thick=5.0,line=3 & multiplot
   ;oplot,klf.xh3,alog10(klf.h3)/2.5,color=blue,line=3,thick=5.0  & multiplot
	
	; Selecting field stars
	simklf,klf,1.5
	;ind=where((((cat.x-659.0)^2 + (cat.y-369.0)^2) le 10000) $
   ;   or (((cat.x-537.0)^2 + (cat.y-530.0)^2) le 11000), complement=inx)		
   inx=where(cat.group eq 3 ,count)
   print,'FS= ',count
   h=histogram(cat.cmk[inx],min=mag_min,max=mag_max,bin=bin)
   xh=(findgen(n_elements(h))*bin)+mag_min
   plot,xh,alog10(h),psym=10,yrange=[-0.1,1.6],xrange=[-4,6],ystyle=1,$
      xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=2.5,$
      xthick=5.0, ythick=5.0, thick=5.0
   
   modelklf,rm2,klf2,age=1.5;,factor=1.5
   modelklf,rm3,klf3,age=1.5;,factor=1.5

   ;oplot,klf.xh1,alog10(klf.h1)/2,color=blue,line=2,thick=5.0
   oplot,klf2.xh,alog10(klf2.h)/1.8,color=blue,thick=5.0
   oplot,klf3.xh,alog10(klf3.h)/1.8,color=blue,line=3,thick=5.0  
   
   modelklf, rm2, klf2, age=1.5
   ;oplot,klf2.xh,alog10(klf2.h)/2,color=blue,thick=5.0
   xyouts,1.5,1.5, 'Age = 1.5 Myr', font=1,charsize=2.0
   xyouts,-3.5,1.5, 'Distributed stars', font=1,charsize=2.0 & multiplot

 
   multiplot,[1,1],/init
   cleanplot,/silent
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif


END


PRO CLUSTERIMF, cor, PS=ps
   COMMON share,conf
   loadconfig
   
   ;String for $\pm$ in IDL
   pm=string(43B)
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+'clusterimf.eps',$
         /color,xsize=20,ysize=10,xoffset=0.4,yoffset=0,$
         SET_FONT='Helvetica Bold',/TT_FONT,/encapsulated,/ISOLATIN1

         
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
   ;print,cor.avk[ind]
   x=cor.x
   y=cor.y
   
   mass=cor.mass;[ind]

   mass_min=0.05
   mass_max=10.0
   bin=0.2
   erase & multiplot, [2,1]   
   
   
   ; NE cluster
   neind=where(cor.group eq 1 ,count) 
   neh=histogram(mass[neind],min=mass_min,max=mass_max,bin=bin)
   nexh=(findgen(n_elements(neh))*bin)+mass_min
   
   ind=where(alog10(neh) gt 0)
   plot,alog10(nexh[ind]),alog10(neh[ind]),psym=5,ystyle=1,yrange=[0,1.2],xrange=[1,-1.5],$
     ytitle='Star count (Log N)',font=1,charsize=1.5,xthick=3.0,ythick=3.0,thick=3.0,xstyle=1,$
     xtickinterval=1,xticks=2
 
   yy=alog10(neh)
   ind=where(yy gt 0)

   coeff=linfit(alog10(nexh[ind]),yy[ind],yfit=yfit,sigma=sigma)
   xyouts,0.8,1.1,'NE Cluster (!9G!X='$
   	+string(coeff[1],format='(F5.2)')+'!Z(00B1)!X'+string(sigma[1],format='(F4.2)')$
   	+')',font=1,charsize=1.2
   oplot,alog10(nexh[ind]),yfit,thick=2.5,color=red& multiplot
    print,'NE=',coeff[1],' +/-',sigma[1]
     
  ; SW Cluster 
   swind=where(cor.group eq 2 ,count) 
   swh=histogram(mass[swind],min=mass_min,max=mass_max,bin=bin)
   swxh=(findgen(n_elements(swh))*bin)+mass_min
   ind=where(alog10(swh) gt 0)
   plot,alog10(swxh[ind]),alog10(swh[ind]),psym=5,ystyle=1,yrange=[0,1.2],xrange=[1,-1.5],$
     font=1,charsize=1.5,xstyle=1,$
     xthick=3.0,ythick=3.0,thick=3.0,xtickinterval=1,xticks=2
   yy=alog10(swh)
     
   ind=where(yy gt 0)
   coeff=linfit(alog10(swxh[ind]),yy[ind],yfit=yfit,sigma=sigma)
   print, 'SW=',coeff[1],' +/-',sigma[1]
   xyouts,0.8,1.1,'SW Cluster (!9G!X='$
      +string(coeff[1],format='(F5.2)')+'!Z(00B1)!X'+string(sigma[1],format='(F4.2)')$
      +')',font=1,charsize=1.2

   oplot,alog10(swxh[ind]),yfit,thick=2.5,color=red & multiplot
   
   
   
   multiplot,[1,1],/init
   cleanplot,/silent
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif

END


PRO ALLIMF, cor, PS=ps
   COMMON share,conf
   loadconfig
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+'allimf.eps',$
         /color,xsize=20,ysize=10,xoffset=0.4,yoffset=0,$
         SET_FONT='Helvetica Bold',/TT_FONT,/encapsulated,/ISOLATIN1
         
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
   endif else begin
      blue=65535
      red=255
      green=32768    
   endelse

   
   mass=cor.mass;[ind]

   mass_min=0.05
   mass_max=10.0
   bin=0.2
	
	 erase & multiplot, [2,1] 
	
	 ; Selecting cluster stars
	 ind=where(cor.group ne 3, complement=inx)		

	 ch=histogram(mass[ind],min=mass_min,max=mass_max,bin=bin)
   cxh=(findgen(n_elements(ch))*bin)+mass_min
   ind=where(alog10(ch) gt 0 )
   plotsym,0,1.5,/fill
   plot,alog10(cxh[ind]),alog10(ch[ind]),psym=5,ystyle=1,$
     yrange=[0,1.5],xrange=[1,-1.5],xstyle=1,$
     ytitle='Star count (Log N)',font=1,$
     charsize=1.5,xthick=3.0,ythick=3.0,$
     thick=3.0,xtickinterval=1,xticks=2
   
   neind=where(cor.group eq 1)
   neh=histogram(mass[neind],min=mass_min,max=mass_max,bin=bin)
   nexh=(findgen(n_elements(neh))*bin)+mass_min
   ;oplot,alog10(nexh),alog10(neh),psym=2

   swind=where(cor.group eq 2)
   swh=histogram(mass[swind],min=mass_min,max=mass_max,bin=bin)
   swxh=(findgen(n_elements(swh))*bin)+mass_min
   ;oplot,alog10(swxh),alog10(swh),psym=10,color=red
   
   yy=alog10(ch)
   
   ;ii=where()
   yy[where(ch eq 1)]=0.0
   ind=where(yy gt 0)
   coeff=linfit(alog10(cxh[ind]),yy[ind],yfit=yfit,sigma=sigma)
   xyouts,0.8,1.4,'Cluster stars (!9G!X='$
      +string(coeff[1],format='(F5.2)')+'!Z(00B1)!X'+string(sigma[1],format='(F4.2)')$
      +')',font=1,charsize=1.2
	 
	 oplot,alog10(cxh[ind]),yfit,thick=2.5,color=red  & multiplot
   


	 print,coeff[1],'+/-',sigma[1]
	
	 fh=histogram(mass[inx],min=mass_min,max=mass_max,bin=bin)
   fxh=(findgen(n_elements(fh))*bin)+mass_min
   ind=where(alog10(fh) gt 0)
   plot,alog10(fxh[ind]),alog10(fh[ind]),psym=5,ystyle=1,yrange=[0,1.5],xrange=[1,-1.5],xstyle=1,$
     xticks=4,font=1,charsize=1.5,xthick=3.0,ythick=3.0,$
     thick=3.0,xtickinterval=1

   yy=alog10(fh)
   
   ;ii=where()
   
   ind=where(yy gt 0.0)
   
   coeff=linfit(alog10(fxh[ind]),yy[ind],yfit=yfit,sigma=sigma)
   xyouts,0.8,1.4,'Distributed stars (!9G!X='$
   	+string(coeff[1],format='(F5.2)')+'!Z(00B1)!X'+string(sigma[1],format='(F4.2)')$
   	+')',font=1,charsize=1.2
	oplot,alog10(fxh[ind]),yfit,thick=2.5,color=red & multiplot

	print,coeff[1],'+/-',sigma[1]


  ind=where(cor.mass)
   multiplot,[1,1],/init
   cleanplot,/silent
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif

END



