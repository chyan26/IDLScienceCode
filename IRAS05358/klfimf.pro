

PRO CLUSTERKLF, cor, porcat, PS=ps
   COMMON share,imgpath, mappath 
   loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'clusterklf.eps',$
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
  
   ind=where(cor.cmj ge -99.0)
   ;print,cor.avk[ind]
   x=cor.x[ind]
   y=cor.y[ind]
   
   mk=cor.cmj[ind]
   avk=cor.avk[ind]
   
   mag_min=-5.0
   mag_max=10.0
   bin=0.5
   erase & multiplot, [2,1]

   
   
   ; Points of SW cluster
   swind=where(((x-656.0)^2 + (y-360.0)^2) le 10000 and mk ge -100,count)  
   swh=histogram(mk[swind],min=mag_min,max=mag_max,bin=bin)
   swxh=(findgen(n_elements(swh))*bin)+mag_min
   plot,swxh,swh,psym=10,yrange=[0,15],xrange=[-5,8],ystyle=1,$
   xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=1.5,$
   xthick=3.0, ythick=3.0, thick=3.0, $
   xtitle='Absolute K!IS!N magnitude',ytitle='Star count (N)'
   xyouts,-4,10.5, 'SW cluster', font=1,charsize=1.2 & multiplot
   
      
   ; Data of NE cluster
   neind=where(((x-537.0)^2 + (y-530.0)^2) le 11000 and mk ge -100,count)
   neh=histogram(mk[neind],min=mag_min,max=mag_max,bin=bin)
   nexh=(findgen(n_elements(neh))*bin)+mag_min
   ;print, 'NE=',median(mk[ind]),mean(mk[ind]),median(cor.avk[ind])
   plot,nexh,neh,psym=10,yrange=[0,15],xrange=[-5,8],$
   xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=1.5,ystyle=1,$
   xthick=3.0, ythick=3.0, thick=3.0 ,/nodata
   
   ind=where(((porcat.x-537.0)^2 + (porcat.y-530.0)^2) le 11000 and mk ge -100,count)
   neh=histogram(porcat.cmj[ind],min=mag_min,max=mag_max,bin=bin)
   nexh=(findgen(n_elements(neh))*bin)+mag_min
   oplot,nexh,neh,psym=10
   xyouts,-4,10.5, 'NE cluster', font=1,charsize=1.2 & multiplot

      
   
   multiplot,[1,1],/init
   cleanplot,/silent
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif

    ind=where((((x-659.0)^2 + (y-369.0)^2) le 10000) $
      or (((x-537.0)^2 + (y-530.0)^2) le 11000), complement=inx)        

   format='(A10,5(TR4,f5.2),TR4,I3)'
   print,'Clsuter       med_Mk   avg_Mk   med_Av   avg_Av   std_av    N'
   print,'-------------------------------------------------------------'
   print,format=format, 'SW cluster',median(mk[swind]),mean(mk[swind]),$
   median(avk[swind]),mean(avk[swind]),stddev(avk[swind]),n_elements(swind)
   print,format=format, 'NE cluster',median(mk[neind]),mean(mk[neind]),median(avk[neind]),$
      mean(avk[neind]),stddev(avk[neind]), n_elements(neind)
   print,format=format, 'ALL',median(mk[inx]),mean(mk[inx]),median(avk[inx]),mean(avk[inx]),stddev(avk[inx]), n_elements(mk[inx])

END


PRO KLF, cor, PS=ps
   COMMON share,imgpath, mappath 
   loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'klf.eps',$
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
   ind=where(cor.cmk ge -99.0)
   ;print,cor.avk[ind]
   x=cor.x[ind]
   y=cor.y[ind]
   
   mk=cor.cmk[ind]
   avk=cor.avk[ind]
   
   mag_min=-5.0
   mag_max=10.0
   bin=0.5
   erase & multiplot, [2,1]
   
   ind=where((x ge 564 and x le 745 and y ge 286 and y le 449) or $
      (((x-476.0)^2 + (y-515.0)^2) le 28000),complement=inx)
   
   ; Cluster region
   clh=histogram(mk[ind],min=mag_min,max=mag_max,bin=bin)
   clxh=(findgen(n_elements(clh))*bin)+mag_min
   plot,clxh,clh,psym=10,yrange=[1,100],xrange=[-5,8],/ylog,$
      xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=1.5,$
      xthick=3.0, ythick=3.0, thick=3.0, xtitle='Absolute K!IS!N magnitude',ytitle='Star count (N)' 
   xyouts,-4,70, 'cluster stars', font=1,charsize=1.2& multiplot

   sth=histogram(mk[inx],min=mag_min,max=mag_max,bin=bin)
   stxh=(findgen(n_elements(sth))*bin)+mag_min
   plot,stxh,sth,psym=10,yrange=[1,100],xrange=[-5,10],/ylog,$
      xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=1.5,$
      xthick=3.0, ythick=3.0, thick=3.0 
   xyouts,-4,70, 'Field stars', font=1,charsize=1.2& multiplot
   
   multiplot,[1,1],/init
   cleanplot,/silent
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif

END


; This function compare the LF based on my method and the result from Porras
PRO KLFCOMP, cat, porcat, PS=ps
   COMMON share,imgpath, mappath 
   loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'klfcomp.eps',$
         /color,xsize=15,ysize=20,xoffset=0.4,yoffset=0,$
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

   erase & multiplot, [2,3]
   
   ; -----------------------------J band--------------------------------
    
   ; Data of NE cluster
   neind=where(cat.group eq 1 ,count) 
   neh=histogram(cat.cmj[neind],min=mag_min,max=mag_max,bin=bin)
   nexh=(findgen(n_elements(neh))*bin)+mag_min
   ;print, 'NE=',median(mk[ind]),mean(mk[ind]),median(cor.avk[ind])
   plot,nexh,neh,psym=10,yrange=[0,8],xrange=[-5,8],$
   xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=1.5,ystyle=1,$
   xthick=3.0, ythick=3.0, thick=3.0 
   
   ind=where(porcat.group eq 1 ,count)
   neh=histogram(porcat.cmj[ind],min=mag_min,max=mag_max,bin=bin)
   nexh=(findgen(n_elements(neh))*bin)+mag_min
   oplot,nexh,neh,psym=10,color=red, thick=3.0

   xyouts,-4,6.5, 'NE cluster (J)', font=1,charsize=1.2 & multiplot
  ; Points of SW cluster
   swind=where(cat.group eq 2 ,count) 
   swh=histogram(cat.cmj[swind],min=mag_min,max=mag_max,bin=bin)
   swxh=(findgen(n_elements(swh))*bin)+mag_min
   plot,swxh,swh,psym=10,yrange=[0,8],xrange=[-5,8],ystyle=1,$
      xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=1.5,$
      xthick=3.0, ythick=3.0, thick=3.0
   swind=where(porcat.group eq 2 ,count)
   swh=histogram(porcat.cmj[swind],min=mag_min,max=mag_max,bin=bin)
   swxh=(findgen(n_elements(swh))*bin)+mag_min
   oplot,swxh,swh,psym=10,color=red, thick=3.0
   xyouts,-4,6.5, 'SW cluster (J)', font=1,charsize=1.2 & multiplot

   ;------------------ H -----------------------------------------------
   
   ; Data of NE cluster
   ;neind=where(((cat.x-537.0)^2 + (cat.y-530.0)^2) le 11000,count)
   neind=where(cat.group eq 1 ,count) 
   neh=histogram(cat.cmh[neind],min=mag_min,max=mag_max,bin=bin)
   nexh=(findgen(n_elements(neh))*bin)+mag_min
   ;print, 'NE=',median(mk[ind]),mean(mk[ind]),median(cor.avk[ind])
   plot,nexh,neh,psym=10,yrange=[0,8],xrange=[-5,8],$
   xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=1.5,ystyle=1,$
   xthick=3.0, ythick=3.0, thick=3.0 

   ind=where(porcat.group eq 1 ,count)
   neh=histogram(porcat.cmh[ind],min=mag_min,max=mag_max,bin=bin)
   nexh=(findgen(n_elements(neh))*bin)+mag_min
   oplot,nexh,neh,psym=10,color=red  , thick=3.0
   xyouts,-4,6.5, 'NE cluster (H)', font=1,charsize=1.2 & multiplot
   
   swind=where(cat.group eq 2 ,count)
   swh=histogram(cat.cmh[swind],min=mag_min,max=mag_max,bin=bin)
   swxh=(findgen(n_elements(swh))*bin)+mag_min
   plot,swxh,swh,psym=10,yrange=[0,8],xrange=[-5,8],ystyle=1,$
      xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=1.5,$
      xthick=3.0, ythick=3.0, thick=3.0
   swind=where(porcat.group eq 2 ,count)

   swh=histogram(porcat.cmh[swind],min=mag_min,max=mag_max,bin=bin)
   swxh=(findgen(n_elements(swh))*bin)+mag_min
   oplot,swxh,swh,psym=10,color=red, thick=3.0
   xyouts,-4,6.5, 'SW cluster (H)', font=1,charsize=1.2 & multiplot
   ;------------------ K band -----------------------------------------------
   
   ; Data of NE cluster
   neind=where(cat.group eq 1 ,count) 
   neh=histogram(cat.cmk[neind],min=mag_min,max=mag_max,bin=bin)
   nexh=(findgen(n_elements(neh))*bin)+mag_min
   ;print, 'NE=',median(mk[ind]),mean(mk[ind]),median(cor.avk[ind])
   plot,nexh,neh,psym=10,yrange=[0,8],xrange=[-5,8],$
   xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=1.5,ystyle=1,$
   xthick=3.0, ythick=3.0, thick=3.0 ,ytitle='Star count (N)', $
   xtitle='Absolute K!IS!N magnitude'
   
   ind=where(porcat.group eq 1 ,count)
   neh=histogram(porcat.cmk[ind],min=mag_min,max=mag_max,bin=bin)
   nexh=(findgen(n_elements(neh))*bin)+mag_min
   oplot,nexh,neh,psym=10,color=red  , thick=3.0
   

   xyouts,-4,6.5, 'NE cluster (Ks)', font=1,charsize=1.2 & multiplot      
   
   swind=where(cat.group eq 2 ,count)
   swh=histogram(cat.cmk[swind],min=mag_min,max=mag_max,bin=bin)
   swxh=(findgen(n_elements(swh))*bin)+mag_min
   plot,swxh,swh,psym=10,yrange=[0,8],xrange=[-5,8],ystyle=1,$
      xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=1.5,$
      xthick=3.0, ythick=3.0, thick=3.0
   swind=where(porcat.group eq 2 ,count)

   swh=histogram(porcat.cmk[swind],min=mag_min,max=mag_max,bin=bin)
   swxh=(findgen(n_elements(swh))*bin)+mag_min
   oplot,swxh,swh,psym=10,color=red, thick=3.0
   xyouts,-4,6.5, 'SW cluster (Ks)', font=1,charsize=1.2 & multiplot

   
   multiplot,[1,1],/init
   
   cleanplot,/silent
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif
  
   
END 

PRO FIELDKLFCOMP, cat, porcat, PS=ps
   COMMON share,imgpath, mappath 
   loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'fieldklfcomp.eps',$
         /color,xsize=15,ysize=20,xoffset=0,yoffset=0,$
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


	; Selecting field stars
	obinx=where(cat.group eq 3 ,count)	

	poind=where(porcat.group eq 3 ,pocount)
	!p.font=1
   
	erase & multiplot, [1,3], myTitle='Star count (N)', myTitSize=1.3
	   ; -----------------------------J band--------------------------------

   jobh=histogram(cat.cmj[obinx],min=mag_min,max=mag_max,bin=bin)
   jobxh=(findgen(n_elements(jobh))*bin)+mag_min
	
	jpoh=histogram(porcat.cmj[poind],min=mag_min,max=mag_max,bin=bin)
	jpoxh=(findgen(n_elements(jpoh))*bin)+mag_min

   plot,jobxh,jobh,psym=10,yrange=[0,70],xrange=[-5,6],$
   xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=1.3,ystyle=1,$
   xthick=3.0, ythick=3.0, thick=4.0,ytickinterval=15,yticks=5
   
   oplot,jpoxh,jpoh,psym=10,color=red,thick=4
	xyouts,-4,50, 'Field stars (J)', font=1,charsize=1.2 & multiplot
   ; -----------------------------H band--------------------------------

   jobh=histogram(cat.cmh[obinx],min=mag_min,max=mag_max,bin=bin)
   jobxh=(findgen(n_elements(jobh))*bin)+mag_min
	
	jpoh=histogram(porcat.cmh[poind],min=mag_min,max=mag_max,bin=bin)
	jpoxh=(findgen(n_elements(jpoh))*bin)+mag_min

   plot,jobxh,jobh,psym=10,yrange=[0,70],xrange=[-5,6],$
   xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=1.3,ystyle=1,$
   xthick=3.0, ythick=3.0, thick=4.0,ytickinterval=15,yticks=5
	oplot,jpoxh,jpoh,psym=10,color=red,thick=4
	xyouts,-4,50, 'Field stars (H)', font=1,charsize=1.2 & multiplot
   
   ; -----------------------------K band--------------------------------

   jobh=histogram(cat.cmk[obinx],min=mag_min,max=mag_max,bin=bin)
   jobxh=(findgen(n_elements(jobh))*bin)+mag_min
	
	jpoh=histogram(porcat.cmk[poind],min=mag_min,max=mag_max,bin=bin)
	jpoxh=(findgen(n_elements(jpoh))*bin)+mag_min

   plot,jobxh,jobh,psym=10,yrange=[0,70],xrange=[-5,6],xtitle='Magnitude',$
   xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=1.3,ystyle=1,$
   xthick=3.0, ythick=3.0, thick=4.0,ytickinterval=15,yticks=5
	oplot,jpoxh,jpoh,psym=10,color=red,thick=4
	xyouts,-4,50, 'Field stars (Ks)', font=1,charsize=1.2 & multiplot



   multiplot,[1,1],/init   
   cleanplot,/silent
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif
  
 
END



; this subroutine plot all age estimation together
PRO GETAGEPLOT, cat, PS=ps
   COMMON share,imgpath, mappath 
   loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'allage.eps',$
         /color,xsize=30,ysize=15,xoffset=0.4,yoffset=0,$
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
   
   erase & multiplot, [3,1],mytitle='Star count (N)',mxtitsize=1.5,mytitsize=1.5

   
   age=[0.2,1]
   agestring=['0.2','1.0']

	   
    
   ; Data of NE cluster
   simklf,klf,0.3
   neind=where(cat.group eq 1 ,count) 

   neh=histogram(cat.cmk[neind],min=mag_min,max=mag_max,bin=bin)
   nexh=(findgen(n_elements(neh))*bin)+mag_min
   ;print, 'NE=',median(mk[ind]),mean(mk[ind]),median(cor.avk[ind])
   plot,nexh,neh,psym=10,yrange=[1,100],xrange=[-5,8],$
   xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=1.5,ystyle=1,$
   xthick=5.0, ythick=5.0, thick=5.0 ,/ylog
   

   xyouts,3,75, 'Age = 0.3 Myr', font=1,charsize=1.5 
   xyouts,-4,75, 'NE cluster', font=1,charsize=1.5    
   oplot,klf.xh1,max(neh+2)*klf.h1/max(klf.h1),color=blue,line=2,thick=5.0
   oplot,klf.xh2,max(neh+2)*klf.h2/max(klf.h2-1),color=blue,thick=5.0
   oplot,klf.xh3,max(neh+2)*klf.h3/max(klf.h3),color=blue,line=3,thick=5.0  & multiplot
	
  simklf,klf,1.0
   swind=where(cat.group eq 2 ,count) 
   
   ;print,count 
   swh=histogram(cat.cmk[swind],min=mag_min,max=mag_max,bin=bin)
   swxh=(findgen(n_elements(swh))*bin)+mag_min
   plot,swxh,swh,psym=10,yrange=[1,100],xrange=[-5,8],ystyle=1,$
      xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=1.5,$
      xthick=5.0, ythick=5.0, thick=5.0,/ylog,xtitle='Absolute Ks magnitude'
      
   xyouts,3,75, 'Age = 1 Myr', font=1,charsize=1.5 
   xyouts,-4,75, 'SW cluster', font=1,charsize=1.5 
   oplot,klf.xh1,max(swh)*klf.h1/max(klf.h1),color=blue,line=2,thick=5.0
   oplot,klf.xh2,max(swh)*klf.h2/max(klf.h2),color=blue,thick=5.0
   oplot,klf.xh3,max(swh)*klf.h3/max(klf.h3),color=blue,line=3,thick=5.0  & multiplot
	
	; Selecting field stars
	simklf,klf,7.0
	;ind=where((((cat.x-659.0)^2 + (cat.y-369.0)^2) le 10000) $
   ;   or (((cat.x-537.0)^2 + (cat.y-530.0)^2) le 11000), complement=inx)		
   inx=where(cat.group eq 3 ,count)
   
   h=histogram(cat.cmk[inx],min=mag_min,max=mag_max,bin=bin)
   xh=(findgen(n_elements(h))*bin)+mag_min
   plot,xh,h,psym=10,yrange=[1,100],xrange=[-5,8],ystyle=1,/ylog,$
      xstyle=1,xtickinterval=5,xticks=3,font=1,charsize=1.5,$
      xthick=5.0, ythick=5.0, thick=5.0
   

   oplot,klf.xh1,max(h)*klf.h1/max(klf.h1),color=blue,line=2,thick=5.0
   oplot,klf.xh2,max(h)*klf.h2/max(klf.h2-1),color=blue,thick=5.0
   oplot,klf.xh3,max(h)*klf.h3/max(klf.h3),color=blue,line=3,thick=5.0  
    xyouts,3,75, 'Age = 7 Myr', font=1,charsize=1.5 
   xyouts,-4,75, 'Field stars', font=1,charsize=1.5 & multiplot

 
   multiplot,[1,1],/init
   cleanplot,/silent
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif


END


PRO CLUSTERIMF, cor, PS=ps
   COMMON share,imgpath, mappath 
   loadconfig
   
   ;String for $\pm$ in IDL
   pm=string(43B)
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'clusterimf.eps',$
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
   mass_max=20.0
   bin=0.5
   erase & multiplot, [2,1]   
   
   
   ; NE cluster
   neind=where(cor.group eq 1 ,count) 
   neh=histogram(mass[neind],min=mass_min,max=mass_max,bin=bin)
   nexh=(findgen(n_elements(neh))*bin)+mass_min
   plot,nexh,neh,psym=10,/ylog,ystyle=1,/xlog,yrange=[0.5,40],xrange=[30,0.1],$
     ytitle='Star count (N)',font=1,charsize=1.5,xthick=3.0,ythick=3.0,thick=3.0,xstyle=1,$
     xtickinterval=10,xticks=2
   err=alog10([neh])
   err[where(neh eq 1)]=1.0
   ;errplot,nexh,neh-err,neh+err
   yy=alog10(neh)
   yy[where(neh eq 1)]=0.0
   ind=where(yy ne -!VALUES.F_INFINITY and nexh le 10.0 and nexh ge 0.5)
   coeff=linfit(alog10(nexh[ind]),yy[ind],yfit=yfit,sigma=sigma)
   xyouts,8,20,'NE Cluster (!9G!X='$
   	+string(coeff[1],format='(F5.2)')+'!Z(00B1)!X'+string(sigma[1],format='(F4.2)')$
   	+')',font=1,charsize=1.2
   oplot,nexh[ind],10^yfit,thick=2.5,color=red& multiplot
    print,'NE=',coeff[1],' +/-',sigma[1]
     
  ; SW Cluster 
   swind=where(cor.group eq 2 ,count) 
   swh=histogram(mass[swind],min=mass_min,max=mass_max,bin=bin)
   swxh=(findgen(n_elements(swh))*bin)+mass_min
   plot,swxh,swh,psym=10,/ylog,ystyle=1,/xlog,yrange=[0.5,40],xrange=[30,0.1],$
     xtitle='Mass',font=1,charsize=1.5,xstyle=1,$
     xthick=3.0,ythick=3.0,thick=3.0,xtickinterval=10,xticks=2
   err=alog10([swh])
   ;err[where(swh eq 1)]=1.0
   ;errplot,swxh,swh-err,swh+err,symsize=2.0
   yy=alog10(swh)
   
   ;ii=where()
   ;yy[where(swh eq 1)]=0.0
    ind=where(yy ne -!VALUES.F_INFINITY and swxh lt 10.0 and swxh ge 0.0)
   ;ind=where(swxh lt 10.0 )
   coeff=linfit(alog10(swxh[ind]),yy[ind],yfit=yfit,sigma=sigma)
   print, 'SW=',coeff[1],' +/-',sigma[1]
   xyouts,8,20,'SW Cluster (!9G!X='$
      +string(coeff[1],format='(F5.2)')+'!Z(00B1)!X'+string(sigma[1],format='(F4.2)')$
      +')',font=1,charsize=1.2
   oplot,swxh[ind],10^yfit,thick=2.5,color=red & multiplot
   
   
   
   multiplot,[1,1],/init
   cleanplot,/silent
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif

END


PRO ALLIMF, cor, PS=ps
   COMMON share,imgpath, mappath 
   loadconfig
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'allimf.eps',$
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
   mass_max=20.0
   bin=0.5
	
	erase & multiplot, [2,1] 
	
	; Selecting field stars
	ind=where((((cor.x-659.0)^2 + (cor.y-369.0)^2) le 10000) $
      or (((cor.x-537.0)^2 + (cor.y-530.0)^2) le 11000), complement=inx)		

	ch=histogram(mass[ind],min=mass_min,max=mass_max,bin=bin)
   cxh=(findgen(n_elements(ch))*bin)+mass_min
   plot,cxh,ch,psym=10,/ylog,ystyle=1,/xlog,yrange=[0.5,400],xrange=[10,0.1],xstyle=1,$
     xticks=2,ytitle='Star count (N)',xtitle='Mass',font=1,charsize=1.5,xthick=3.0,ythick=3.0,$
     thick=3.0
	
	err=alog10([ch])
   err[where(ch eq 1)]=1.0
   ;errplot,cxh,ch-err,ch+err,symsize=2.0
   yy=alog10(ch)
   
   ;ii=where()
   yy[where(ch eq 1)]=0.0
   ind=where(yy ne -!VALUES.F_INFINITY )
   coeff=linfit(alog10(cxh[ind]),yy[ind],yfit=yfit,sigma=sigma)
   xyouts,8,200,'Cluster stars (!9G!X='$
   	+string(coeff[1],format='(F5.2)')+'!Z(00B1)!X'+string(sigma[1],format='(F4.2)')$
   	+')',font=1,charsize=1.2
	oplot,cxh[ind],10^yfit,thick=2.5,color=red  & multiplot

	print,coeff[1],'+/-',sigma[1]
	
	fh=histogram(mass[inx],min=mass_min,max=mass_max,bin=bin)
   fxh=(findgen(n_elements(fh))*bin)+mass_min
   plot,fxh,fh,psym=10,/ylog,ystyle=1,/xlog,yrange=[0.5,400],xrange=[30,0.1],xstyle=1,$
     xticks=4,xtickinterval=10,font=1,charsize=1.5,xthick=3.0,ythick=3.0,$
     thick=3.0

	err=alog10([fh])
   err[where(fh eq 1)]=1.0
   ;errplot,fxh,fh-err,fh+err,symsize=2.0
   yy=alog10(fh)
   
   ;ii=where()
   yy[where(fh eq 1)]=0.0
   ind=where(yy ne -!VALUES.F_INFINITY and fxh ge 0.0)
   coeff=linfit(alog10(fxh[ind]),yy[ind],yfit=yfit,sigma=sigma)
   xyouts,8,200,'Field stars (!9G!X='$
   	+string(coeff[1],format='(F5.2)')+'!Z(00B1)!X'+string(sigma[1],format='(F4.2)')$
   	+')',font=1,charsize=1.2
	oplot,cxh[ind],10^yfit,thick=2.5,color=red & multiplot

	print,coeff[1],'+/-',sigma[1]

   multiplot,[1,1],/init
   cleanplot,/silent
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif

END



