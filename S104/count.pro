
; Normalized star count
PRO NORSTARCOUNT, cat, refcat, Ps=ps
   COMMON share,setting  
   loadconfig
  
   mag_min=8.0
   mag_max=22.0
   bin=0.5
   
   jlim=21
   hlim=20
   klim=19
   !p.multi=[0,3,1]
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=setting.pspath+'norstarcount.eps',$
         /color,xsize=35,ysize=12,xoffset=0.4,yoffset=10,$
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
   erase & multiplot, [3,1]
   
   h=histogram(cat.j.mag,min=mag_min,max=mag_max,bin=bin)
   xh=(findgen(n_elements(h))*bin)+mag_min
   plot,xh,h/25.0,psym=10,yrange=[0,70],ystyle=1,xstyle=1,thick=3,charsize=2.0,$
      xthick=5.0,ythick=5.0,font=1,$
      ytitle='N (per square arcmin)',xtitle='Magnitude',xticks=6,$
      xtickinterval=3
   h1=histogram(refcat.j.mag,min=mag_min,max=mag_max,bin=bin)
   oplot, xh,h1/13.0,psym=10,thick=10.0,line=2
   ;oplot,[18.5,18.5],[0,1000],line=2,thick=5.0  
   ;oplot,[jlim,jlim],[0,1000],thick=10.0,line=1
   xyouts,9,60,'J',charsize=2.0,font=1 & multiplot
   
   h=histogram(cat.h.mag,min=mag_min,max=mag_max,bin=bin)
   xh=(findgen(n_elements(h))*bin)+mag_min
   plot,xh,h/25.0,psym=10,yrange=[0,70],ystyle=1,xstyle=3,thick=3,charsize=2.0,$
      xthick=5.0,ythick=5.0,font=1,xticks=6,xtickinterval=3
   h1=histogram(refcat.h.mag,min=mag_min,max=mag_max,bin=bin)
   oplot, xh,h1/13.0,psym=10,thick=10.0,line=2
   ;oplot,[17.0,17],[0,1000],line=2,thick=5.0  
   ;oplot,[hlim,hlim],[0,1000],thick=10.0,line=1
   xyouts,9,60,'H',charsize=2.0,font=1 & multiplot
   ;
   h=histogram(cat.k.mag,min=mag_min,max=mag_max,bin=bin)

   xh=(findgen(n_elements(h))*bin)+mag_min
   plot,xh,h/25.0,psym=10,yrange=[0,70],ystyle=1,xstyle=1,thick=3,charsize=2.0,$
      xthick=5.0,ythick=5.0,font=1,xticks=6,xtickinterval=3 
   h1=histogram(refcat.k.mag,min=mag_min,max=mag_max,bin=bin)
    oplot, xh,h1/13.0,psym=10,thick=10.0,line=2
  ;oplot,[16.5,16.5],[0,1000],line=2,thick=5.0  
   ;oplot,[klim,klim],[0,1000],thick=10.0,line=1
   xyouts,9,60,'Ks',charsize=2.0,font=1 & multiplot
   

   multiplot,[1,1],/init
   cleanplot,/silent
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif
	
	;plot,h/25.0,psym=10
  ; !p.multi=0
END










