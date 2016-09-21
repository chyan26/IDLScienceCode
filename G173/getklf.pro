PRO CLUSTERAGE, cat, PS=ps
   COMMON share,conf
   loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+ps,$
         /color,xsize=23,ysize=20,xoffset=0.4,yoffset=0,$
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
   
   mag_min=-5.0
   mag_max=5.0
   bin=0.5
   
   !p.font=1
   !p.charsize=1.4
   
   erase & multiplot, [1,1],mxtitsize=1.5,mytitsize=1.5

   
   age=[0.8,1.0]
   fontsize=3.0
     
    
   ; Data of NE cluster
   ;simklf,klf,0.5
   
   salpeterimf,m1,n1,rm1
   msimf,m2,n2,rm2
   muenchimf,m3,n3,rm3
   modelklf,rm1,klf1,age=age[0];,factor=1.5
   modelklf,rm2,klf2,age=age[0];,factor=1.5
   modelklf,rm3,klf3,age=age[0];,factor=1.5
   
   
   
   neind=where(cat.group eq 1 ,count) 
   print,'G173= ',count
   neh=histogram(cat.cmk[neind],min=mag_min,max=mag_max,bin=bin)
   nexh=(findgen(n_elements(neh))*bin)+mag_min
   ;print, 'NE=',median(mk[ind]),mean(mk[ind]),median(cor.avk[ind])
   ix=where(neh eq 0 and nexh ge -3 and nexh le 2 ,count)
   if count ne 0 then neh[ix]=1
   plot,nexh,alog10(neh),psym=10,yrange=[-0.1,1.6],xrange=[-2,5],$
   xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=2.5,ystyle=1,$
   xthick=10.0, ythick=10.0, thick=10.0,ytitle='Star count (Log N)
   
   print,nexh,neh
   
   xyouts,-1.4,1.5, 'G173.58+2.45 cluster', font=1,charsize=fontsize,color=cgcolor('Black')
   xyouts,-1.4,1.4, 'Age = '+strcompress(string(age[0],format='(f4.1)'),/remove)+' Myr'$
    ,font=1,charsize=fontsize,color=cgcolor('Black')
   ;xyouts,2,75, 'Age = 0.02 Myr', font=1,charsize=1.5 
   ;xyouts,-4,75, 'NE cluster', font=1,charsize=1.5    
   ;oplot,klf1.xh,alog10(klf1.h)/2.5,color=blue,line=2,thick=5.0
   oplot,klf2.xh,alog10(klf2.h)/3.0,color=blue,thick=10.0
   oplot,klf3.xh,alog10(klf3.h)/3.0,color=blue,line=3,thick=10.0  & multiplot
   
   msimf,m2,n2,rm2
   modelklf,rm2,klf2,age=age[1];,factor=1.5
   modelklf,rm3,klf3,age=age[1];,factor=1.5
    ;simklf,klf,0.5
   swind=where(cat.group eq 2 ,count) 
   print,'Distributed Stars= ',count
   ;print,count 
   swh=histogram(cat.cmk[swind],min=mag_min,max=mag_max,bin=bin)
   swxh=(findgen(n_elements(swh))*bin)+mag_min
   ;plot,swxh,alog10(swh),psym=10,yrange=[-0.1,1.6],xrange=[-2,6],ystyle=1,$
   ;   xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=2.5,$
   ;   xthick=8.0, ythick=8.0, thick=5.0
   ;oplot,nexh,alog10(neh),psym=10,line=3,thick=5
      
   ;xyouts,2.5,1.5, 'Age = '+strcompress(string(age[1],format='(f4.1)'),/remove)+' Myr'$
   ; ,font=1.5,charsize=fontsize
   
   ;xyouts,-1,1.5, 'Distributed Stars', font=1.5,charsize=fontsize
   ;oplot,[-0.6,0.5],[1.42,1.42],thick=5
   ;xyouts,-3,1.3, 'NE cluster', font=1,charsize=1.5
   ;oplot,[-0.6,0.5],[1.32,1.32],thick=5,line=3
     
   ;oplot,klf2.xh,alog10(klf2.h)/2.3,color=blue,thick=8.0 
   ;oplot,klf3.xh,alog10(klf3.h)/2.3,color=blue,thick=8.0,line=3 & multiplot
   ;oplot,klf.xh3,alog10(klf.h3)/2.5,color=blue,line=3,thick=5.0  & multiplot
  
;  ; Selecting field stars
;  simklf,klf,1.5
;  ;ind=where((((cat.x-659.0)^2 + (cat.y-369.0)^2) le 10000) $
;   ;   or (((cat.x-537.0)^2 + (cat.y-530.0)^2) le 11000), complement=inx)   
;   inx=where(cat.group eq 3 ,count)
;   print,'FS= ',count
;   h=histogram(cat.cmk[inx],min=mag_min,max=mag_max,bin=bin)
;   xh=(findgen(n_elements(h))*bin)+mag_min
;   plot,xh,alog10(h),psym=10,yrange=[-0.1,1.6],xrange=[-4,6],ystyle=1,$
;      xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=2.5,$
;      xthick=5.0, ythick=5.0, thick=5.0
;   
;   modelklf,rm2,klf2,age=1.5;,factor=1.5
;   modelklf,rm3,klf3,age=1.5;,factor=1.5
;
;   ;oplot,klf.xh1,alog10(klf.h1)/2,color=blue,line=2,thick=5.0
;   oplot,klf2.xh,alog10(klf2.h)/1.8,color=blue,thick=5.0
;   oplot,klf3.xh,alog10(klf3.h)/1.8,color=blue,line=3,thick=5.0  
;   
;   modelklf, rm2, klf2, age=1.5
;   ;oplot,klf2.xh,alog10(klf2.h)/2,color=blue,thick=5.0
;   xyouts,1.5,1.5, 'Age = 1.5 Myr', font=1,charsize=2.0
;   xyouts,-3.5,1.5, 'Distributed stars', font=1,charsize=2.0 & multiplot

 
   multiplot,[1,1],/init
   cleanplot,/silent
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
     
     pdfname=file_basename(ps,'.eps')
     spawn,'epstopdf '+conf.pspath+ps;+' '+conf.pspath+pdfname+'.pdf'
     
   endif


END






PRO KLFAGEDEMO, PS=ps
   COMMON share,conf
   loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+ps,$
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
   multiplot,/reset
   erase & multiplot, [3,3],mxtitsize=1.2,mytitsize=1.2;,mXtitle='Absolute K magnitude', mYtitle='Normalized star count'

   agearray=[0.1,0.5,0.9,1.0,1.5,3,5,7,9]
   
   for i=0,n_elements(agearray)-1 do begin
   tage=agearray[i]
   
   plot,getseries(-1,10,1),psym=10,yrange=[0,1.2],xrange=[-5,8],ystyle=1,$
      xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=1.5,$
      xthick=3.0, ythick=3.0, thick=5.0,/nodata
     
   
   salpeterimf,m1,n1,rm1
   msimf,m2,n2,rm2
   muenchimf,m3,n3,rm3
 
   modelklf,rm1,klf1,age=tage
   modelklf,rm2,klf2,age=tage
   modelklf,rm3,klf3,age=tage
   
   oplot,klf1.xh,alog10(klf1.h)/max(alog10(klf1.h)),thick=5,line=2
   oplot,klf2.xh,alog10(klf2.h)/max(alog10(klf2.h)),thick=5
   oplot,klf3.xh,alog10(klf3.h)/max(alog10(klf3.h)),thick=5,line=3
 
   ; xyouts,5.3, 1.34,'0.1 Myr',charsize=1.8
   xyouts,-4, 1.0,'T = '+strcompress(string(tage,format='(F4.2)'),/remove)+' Myr',charsize=1.8,font=1
   multiplot
   endfor
   
   resetplt,/all
   multiplot,/reset
  if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
     
     pdfname=file_basename(ps,'.eps')
     spawn,'epstopdf '+conf.pspath+ps;+' '+conf.pspath+pdfname+'.pdf'
     
   endif


END


PRO KLFCOMP, PS=ps
    COMMON share,conf
    loadconfig
    
    if keyword_set(PS) then begin
      set_plot,'ps'
      device,filename=conf.pspath+ps,$
        /color,xsize=20,ysize=25,xoffset=0.4,yoffset=0,$
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
    
    fontzise=20.0
    
    salpeterimf,m1,n1,rm1
    msimf,m2,n2,rm2
    muenchimf,m3,n3,rm3
    
    mass=getseries(-5,5,0.5)
    g173  =[0,1,0,0,1,1,1,1,1,3,3,2,4,4,5,3,5,2,1,5,0]
    s233sw=[0,0,0,0,1,0,0,0,1,1,1,3,2,4,5,2,3,3,2,5,0]
    
    erase & multiplot, [1,3],mxtitsize=2.0,mytitsize=2.0,xgap=0,ygap=0.01,$
      mxTitOffse=1.5
    
    plot,mass,alog10(g173+s233sw),psym=10,yrange=[0,1.2],xrange=[-2,4.5],ystyle=1,$
      xstyle=1,xtickinterval=1,xticks=5,font=1,charsize=1.5,$
       xthick=10.0, ythick=10.0, thick=10.0
    
    tage=0.5
    modelklf,rm1,klf1,age=tage
    modelklf,rm2,klf2,age=tage
    modelklf,rm3,klf3,age=tage
    oplot,klf2.xh,alog10(klf2.h)/2.3,thick=10,color=blue
    oplot,klf3.xh,alog10(klf3.h)/2.3,thick=10,line=3,color=blue


    
    xyouts,-1.5,1.1, 'S233IR & G173.58+2.45', font=1,charsize=fontsize,color=cgcolor('Black')

      
    multiplot

    plot,mass,alog10(s233SW),psym=10,yrange=[0,1.2],xrange=[-2,4.5],ystyle=1,$
      xstyle=1,xtickinterval=1,xticks=5,font=1,charsize=1.5,$
       xthick=10.0, ythick=10.0, thick=10.0

    tage=0.5
    modelklf,rm1,klf1,age=tage
    modelklf,rm2,klf2,age=tage
    modelklf,rm3,klf3,age=tage
    
    ;oplot,klf1.xh,alog10(klf1.h)/max(alog10(klf1.h)),thick=5,line=2,color=blue
    oplot,klf2.xh,alog10(klf2.h)/3.0,thick=10,color=blue
    oplot,klf3.xh,alog10(klf3.h)/3.0,thick=10,line=3,color=blue
    ;xyouts,-1.5,1.1, 'S233IR', font=1,charsize=fontsize,color=cgcolor('Black')
    ;xyouts,-1.5,1.0, 'Age = '+strcompress(string(tage,format='(f4.1)'),/remove)+' Myr'$
    ;  ,font=1,charsize=fontsize,color=cgcolor('Black')
    
    multiplot

    
    plot,mass,alog10(g173),psym=10,yrange=[0,1.2],xrange=[-2,4.5],ystyle=1,$
      xstyle=1,xtickinterval=1,xticks=5,font=1,charsize=1.5,$
       xthick=10.0, ythick=10.0, thick=10.0

    tage=0.8
    modelklf,rm1,klf1,age=tage
    modelklf,rm2,klf2,age=tage
    modelklf,rm3,klf3,age=tage
    
    ;oplot,klf1.xh,alog10(klf1.h)/3.0,thick=5,line=2,color=blue
    oplot,klf2.xh,alog10(klf2.h)/3.0,thick=10,color=blue
    oplot,klf3.xh,alog10(klf3.h)/3.0,thick=10,line=3,color=blue
    
    ;xyouts,-1.5,1.1, 'G173.58+2.45', font=1,charsize=fontsize,color=cgcolor('Black')
    ;xyouts,-1.5,1.0, 'Age = '+strcompress(string(tage,format='(f4.1)'),/remove)+' Myr'$
    ;  ,font=1,charsize=fontsize,color=cgcolor('Black')
      
    multiplot
    
    if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
      
      pdfname=file_basename(ps,'.eps')
      spawn,'epstopdf '+conf.pspath+ps;+' '+conf.pspath+pdfname+'.pdf'
      
    endif
   
    multiplot,/reset
    clearplt,/all
    resetplt,/all
    !p.multi=0

END












