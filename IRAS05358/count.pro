; Note: inpu the raw catalog here!!
PRO STARCOUNT, cat, Ps=ps
   COMMON share,imgpath, mappath 
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
      device,filename=mappath+'starcount.eps',$
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
   
   ;load catalog of Porras, 2000
   readcol,imgpath+'porras.cat',id,ra,dec,mj,mjerr,mh,mherr,mk,mkerr

   h=histogram(cat.j.mag,min=mag_min,max=mag_max,bin=bin)
   xh=(findgen(n_elements(h))*bin)+mag_min
   plot,xh,h,psym=10,yrange=[0,110],ystyle=1,xstyle=1,thick=3,charsize=2.0,$
      xthick=5.0,ythick=5.0,font=1,ytitle='N',xtitle='Magnitude',xticks=6,$
      xtickinterval=3
   h1=histogram(mj,min=mag_min,max=mag_max,bin=bin)
   oplot, xh,h1,psym=10,thick=10.0,line=2
   oplot,[18.5,18.5],[0,1000],line=2,thick=5.0  
   oplot,[jlim,jlim],[0,1000],thick=10.0,line=1
   xyouts,9,100,'J',charsize=2.0,font=1 & multiplot
   
   h=histogram(cat.h.mag,min=mag_min,max=mag_max,bin=bin)
   xh=(findgen(n_elements(h))*bin)+mag_min
   plot,xh,h,psym=10,yrange=[0,110],ystyle=1,xstyle=3,thick=3,charsize=2.0,$
      xthick=5.0,ythick=5.0,font=1,xticks=6,xtickinterval=3
   h1=histogram(mh,min=mag_min,max=mag_max,bin=bin)
   oplot, xh,h1,psym=10,thick=10.0,line=2
   oplot,[17.0,17],[0,1000],line=2,thick=5.0  
   oplot,[hlim,hlim],[0,1000],thick=10.0,line=1
   xyouts,9,100,'H',charsize=2.0,font=1 & multiplot
   ;
   h=histogram(cat.k.mag,min=mag_min,max=mag_max,bin=bin)
   xh=(findgen(n_elements(h))*bin)+mag_min
   plot,xh,h,psym=10,yrange=[0,110],ystyle=1,xstyle=1,thick=3,charsize=2.0,$
      xthick=5.0,ythick=5.0,font=1,xticks=6,xtickinterval=3 
   h1=histogram(mk,min=mag_min,max=mag_max,bin=bin)
    oplot, xh,h1,psym=10,thick=10.0,line=2
  oplot,[16.5,16.5],[0,1000],line=2,thick=5.0  
   oplot,[klim,klim],[0,1000],thick=10.0,line=1
   xyouts,9,100,'Ks',charsize=2.0,font=1 & multiplot
   
   
   

   multiplot,[1,1],/init
   cleanplot,/silent
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif

   !p.multi=0
END

; Normalized star count
PRO NORSTARCOUNT, cat, Ps=ps
   COMMON share,imgpath, mappath 
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
      device,filename=mappath+'norstarcount.eps',$
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
   
   ;load catalog of Porras, 2000
   readcol,imgpath+'porras.cat',id,ra,dec,mj,mjerr,mh,mherr,mk,mkerr

   h=histogram(cat.j.mag,min=mag_min,max=mag_max,bin=bin)
   xh=(findgen(n_elements(h))*bin)+mag_min
   plot,xh,h/25.0,psym=10,yrange=[0,5],ystyle=1,xstyle=1,thick=3,charsize=2.0,$
      xthick=5.0,ythick=5.0,font=1,$
      ytitle='N (per square arcmin)',xtitle='Magnitude',xticks=6,$
      xtickinterval=3
   h1=histogram(mj,min=mag_min,max=mag_max,bin=bin)
   oplot, xh,h1/13.0,psym=10,thick=10.0,line=2
   oplot,[18.5,18.5],[0,1000],line=2,thick=5.0  
   oplot,[jlim,jlim],[0,1000],thick=10.0,line=1
   xyouts,9,4.5,'J',charsize=2.0,font=1 & multiplot
   
   h=histogram(cat.h.mag,min=mag_min,max=mag_max,bin=bin)
   xh=(findgen(n_elements(h))*bin)+mag_min
   plot,xh,h/25.0,psym=10,yrange=[0,5],ystyle=1,xstyle=3,thick=3,charsize=2.0,$
      xthick=5.0,ythick=5.0,font=1,xticks=6,xtickinterval=3
   h1=histogram(mh,min=mag_min,max=mag_max,bin=bin)
   oplot, xh,h1/13.0,psym=10,thick=10.0,line=2
   oplot,[17.0,17],[0,1000],line=2,thick=5.0  
   oplot,[hlim,hlim],[0,1000],thick=10.0,line=1
   xyouts,9,4.5,'H',charsize=2.0,font=1 & multiplot
   ;
   h=histogram(cat.k.mag,min=mag_min,max=mag_max,bin=bin)

   xh=(findgen(n_elements(h))*bin)+mag_min
   plot,xh,h/25.0,psym=10,yrange=[0,5],ystyle=1,xstyle=1,thick=3,charsize=2.0,$
      xthick=5.0,ythick=5.0,font=1,xticks=6,xtickinterval=3 
   h1=histogram(mk,min=mag_min,max=mag_max,bin=bin)
    oplot, xh,h1/13.0,psym=10,thick=10.0,line=2
  oplot,[16.5,16.5],[0,1000],line=2,thick=5.0  
   oplot,[klim,klim],[0,1000],thick=10.0,line=1
   xyouts,9,4.5,'Ks',charsize=2.0,font=1 & multiplot
   

   multiplot,[1,1],/init
   cleanplot,/silent
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif
	
	plot,h/25.0,psym=10
   !p.multi=0
END

; NOTE:  input MATCHED catalog here!!
PRO CLUSTERCOUNT, cat, porrascat, Ps=ps
   COMMON share,imgpath, mappath 
   loadconfig
   mag_min=8
   mag_max=20.0
   bin=0.25 
   
   klim=19
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'clustercount.eps',$
         /color,xsize=24,ysize=12,xoffset=0.4,yoffset=10,$
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
   erase & multiplot, [2,1]


   ; Data of NE cluster
   ;ind=where(((cat.x-537.0)^2 + (cat.y-530.0)^2) le 11000,count)
   ;inx=where(((porrascat.x-537.0)^2 + (porrascat.y-530.0)^2) le 11000,number)
   ind=where(cat.group eq 1,count)
   inx=where(porrascat.group eq 1, number)
;    if (count ne 0) then begin
;       oplot,cat.x[ind],cat.y[ind],psym=5,color=255
;       oplot,porrascat.x[inx],porrascat.y[inx],psym=2,color=255
      print,count,number
;    endif
   kmag1=cat.mk[ind]
   kmag2=porrascat.mk[inx]
   h1=histogram(kmag1,min=mag_min,max=mag_max,bin=bin)
   h2=histogram(kmag2,min=mag_min,max=mag_max,bin=bin)
   xh=(findgen(n_elements(h1))*bin)+mag_min
   plot,xh,h1,psym=10,yrange=[0,6],ystyle=1,xstyle=1,thick=3,charsize=2.0,$
      xthick=5.0,ythick=5.0,font=1,ytitle='N',xtitle='Magnitude',xticks=6,$
      xtickinterval=3
   oplot,xh,h2,psym=10,thick=10.0,line=2
   xyouts,16,5,'NE cluster',charsize=2.0,font=1 & multiplot   
   
   
   ; Points of SW cluster
   
   ;ind=where((((cat.x-656.0)^2 + (cat.y-360.0)^2) le 10000) and cat.mk ge 0,count)
   ;inx=where(((porrascat.x-656.0)^2 + (porrascat.y-360.0)^2) le 11000,number)
   ind=where(cat.group eq 2,count)
   inx=where(porrascat.group eq 2, number)
   kmag1=cat.mk[ind]
   kmag2=porrascat.mk[inx]
   h1=histogram(kmag1,min=mag_min,max=mag_max,bin=bin)
   h2=histogram(kmag2,min=mag_min,max=mag_max,bin=bin)
   xh=(findgen(n_elements(h1))*bin)+mag_min
   plot,xh,h1,psym=10,yrange=[0,6],ystyle=1,xstyle=1,thick=3,charsize=2.0,$
      xthick=5.0,ythick=5.0,font=1,xticks=6,$
      xtickinterval=3
   oplot,xh,h2,psym=10,thick=10.0,line=2 
   xyouts,16,5,'SW cluster',charsize=2.0,font=1 & multiplot   

;   if (count ne 0) then begin
;       oplot,cat.x[ind],cat.y[ind],psym=5,color=32768
;       oplot,porrascat.x[inx],porrascat.y[inx],psym=2,color=255
       print,count,number
;   endif 
   multiplot,[1,1],/init
   cleanplot,/silent
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif

   !p.multi=0
  
  
   
END