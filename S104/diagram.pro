PRO MKCCDIAGRAM, final, ps=ps
	COMMON share,setting	
	loadconfig
  
  symsize=0.6
  
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=setting.pspath+'hrdiagram.eps',$
         /color,xsize=20,ysize=20,xoffset=0.4,yoffset=10,$
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
   
   ; Selecting CTTS stars
   ctts=intarr(n_elements(final.mk))
   ctts[*]=0
   for i=0, n_elements(final.mj)-1 do begin
         ; left boundary
            y1=1.7*(final.mh[i]-final.mk[i])+0.031 
       
         ; right boundary
            y2=1.7*(final.mh[i]-final.mk[i])-0.544
            y3=0.58*(final.mh[i]-final.mk[i])+0.52
      if ((final.mj[i]-final.mh[i]) le y1) and ((final.mj[i]-final.mh[i]) ge y2-0.2) $
      and ((final.mj[i]-final.mh[i]) ge y3) then begin
         ctts[i]=1;              
      endif
   endfor


  ; Plot HR diagram
  inx=where(final.mk ge -100.0, count)

  plot,final.mh[inx]-final.mk[inx],final.mj[inx]-final.mh[inx],$
  	xtitle='H - Ks',ytitle='J - H',xrange=[-0.5,2.5],yrange=[0,3],$
  	xstyle=1,psym=7,charsize=1.6,symsize=0.3, font=1, xthick=5.0,$
  	ythick=5.0,/nodata
   R=217
   G=216
   B=213  
   polyfill,[0.45,1.75,2.1,1.0],[0.8,3.0,3.0,1.1],color = R+256L*(G+256L*B)  
  
  
	; Plot cluster stars
	plotsym,0,symsize
	inx=where(final.group eq 2 and ctts ne 1)
	oplot,final.mh[inx]-final.mk[inx],final.mj[inx]-final.mh[inx],psym=8
	plotsym,0,symsize,/fill
	inx=where(final.group eq 2 and ctts eq 1)
	oplot,final.mh[inx]-final.mk[inx],final.mj[inx]-final.mh[inx],psym=8
	
	plotsym,0,symsize
  inx=where(final.group eq 1  and ctts ne 1)
  ;oplot,final.mh[inx]-final.mk[inx],final.mj[inx]-final.mh[inx],psym=8
  plotsym,0,symsize,/fill
  inx=where(final.group eq 1  and ctts eq 1)
  ;oplot,final.mh[inx]-final.mk[inx],final.mj[inx]-final.mh[inx],psym=8
	
	;plot,final.mh-final.mk,final.mj-final.mh,psym=3,xtitle='!6H-K',$
	;	ytitle='J-H',xrange=[-0.5,4.5],yrange=[0,5],xstyle=1
	
	; Plot stellar group
	loaddwarfiso,djh,dhk
	loadgaintiso,gjh,ghk

	oplot,dhk,djh,color=blue,thick=5
	oplot,ghk,gjh,color=blue,thick=5
	
	aa=(findgen(6)+5)/10
	bb=0.58*aa+0.52
	oplot,aa,bb,line=4,color=blue,thick=5
	;plot extinction
	
 	arrow,0.0,1.5,0.65,2.61,/data,color=red,thick=5
   xyouts,0,2.61,'Av = 10',font=1,charsize=1.5
 	oplot,[0.37,3.37],[0.66,5.76],line=1,color=red,thick=6
 	oplot,[0.16,3.16],[0.79,5.89],line=1,color=red,thick=6
	oplot,[max(aa),3+max(aa)],[max(bb),5.1+max(bb)],line=1,color=red,thick=6
	
   
	if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
	endif
	
	resetplt,/all
	!p.multi=0

	return 
END
PRO CHECKHRD, final, ps=ps
   COMMON share,conf
   loadconfig
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+'checkhrd.eps',$
         /color,xsize=20,ysize=15,xoffset=0.4,yoffset=10,$
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

   
   ; Selecting the stars not in PMS, CTTS locus
   nonpms=intarr(n_elements(final.mk))
   nonpms[*]=0
   for i=0, n_elements(final.mj)-1 do begin
         ; left boundary
            y1=1.7*(final.mh[i]-final.mk[i])+0.6
            
            y2=1.7*(final.mh[i]-final.mk[i])+0.031 
            y3=1.7*(final.mh[i]-final.mk[i])-0.544
            y4=0.58*(final.mh[i]-final.mk[i])+0.52
      if ((final.mj[i]-final.mh[i]) ge y1) then begin
         nonpms[i]=2
      endif
      
      if ((final.mj[i]-final.mh[i]) le y2) then begin
         nonpms[i]=1
      endif
  
      
      if ((final.mj[i]-final.mh[i]) le y2) and ((final.mj[i]-final.mh[i]) ge y3-0.2) $
      and ((final.mj[i]-final.mh[i]) ge y4) then begin
        nonpms[i]=3;              
      endif
      
   endfor

   ;plot,final.mh-final.mk,final.mj-final.mh,$
   ;   xtitle='H - Ks',ytitle='J - H',xrange=[-0.5,4.5],yrange=[0,3],$
   ;   xstyle=1,psym=7,charsize=1.6,symsize=0.3, font=1, xthick=5.0,$
   ;   ythick=5.0,/nodata
   
   ind=where(nonpms eq 2)
   getds9region,final.x[ind],final.y[ind],'checkhrd_overpms',color='red'
   ind=where(nonpms eq 1)
   getds9region,final.x[ind],final.y[ind],'checkhrd_belowpms',color='green'
    
   plotsym,0,symsize
   inx=where(nonpms eq 1 or nonpms eq 2 and final.mk ge -100 ,count)
   plot,final.mh-final.mk,final.mj-final.mh,$
      xtitle='H - Ks',ytitle='J - H',xrange=[-0.5,2.5],yrange=[0,3],$
      xstyle=1,psym=8,charsize=1.6, font=1, xthick=5.0,$
      ythick=5.0
   
   ; Plot stellar group
   loaddwarfiso,djh,dhk
   oplot,dhk,djh,color=blue,thick=5
   loadgaintiso,gjh,ghk
   oplot,ghk,gjh,color=blue,thick=5
   ; Plot CTTS
   aa=(findgen(6)+5)/10
   bb=0.58*aa+0.52
   oplot,aa,bb,line=4,color=blue,thick=5

   ;plot extinction vector
   arrow,0.0,1.5,0.65,2.61,/data,color=red
   xyouts,0,2.61,'Av = 10',font=1,charsize=1.5
   
   ; Plot extcintoin direction
   oplot,[0.37,3.37],[0.66,5.76],line=3,color=red,thick=5
   oplot,[0.16,3.16],[0.79,5.89],line=3,color=red,thick=5
   oplot,[max(aa),3+max(aa)],[max(bb),5.1+max(bb)],line=3,color=red,thick=5
   
   resetplt,/all
   ;!p.multi=[0,1,3]
   ;plothist,final.mj[inx],xrange=[9,20]
   ;plothist,final.mh[inx],xrange=[9,20]
   ;plothist,final.mk[inx],xrange=[9,20]
   ;!p.multi=0
   
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif

END

PRO MKHKCMD, final, ps=ps, ZAMS=ZAMS

	COMMON share,setting	
	loadconfig

	!p.multi=0
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=setting.pspath+'hkcmd.eps',$
         /color,xsize=20,ysize=20,xoffset=0.4,yoffset=10,$
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

		
	;----------------------------------
	;  H-Ks vs Ks
	;----------------------------------
  
   ctts=intarr(n_elements(final.mk))
   ctts[*]=0
   ; Selecting CTTS stars
   for i=0, n_elements(final.mj)-1 do begin
         ; left boundary
            y1=1.7*(final.mh[i]-final.mk[i])+0.031 
       
         ; right boundary
            y2=1.7*(final.mh[i]-final.mk[i])-0.544
            y3=0.58*(final.mh[i]-final.mk[i])+0.52
      if ((final.mj[i]-final.mh[i]) le y1) and ((final.mj[i]-final.mh[i]) ge y2-0.2) $
      and ((final.mj[i]-final.mh[i]) ge y3) then begin
          ctts[i]=1;              
      endif
   endfor
	
	print,'Numner of  CTTS = ',n_elements(where(ctts ne 0))
   ; Selecting field stars   
   plot,final.mh-final.mk,final.mk,psym=8, $
    yrange=[20,7.5],ystyle=1,xrange=[-1,3], $
    xstyle=1, xtitle='H - Ks',ytitle='Ks',charsize=2,font=1,$
    xthick=5.0,ythick=5.0,/nodata
    
   ;oplot, 
    
   inx=where(final.group eq 1 and ctts eq 0,count1)
   ;plotsym,0,symsize
   ;oplot,final.mh[inx]-final.mk[inx],final.mk[inx],psym=8
   
   inx=where(final.group eq 1 and ctts eq 1,count2)
   ;plotsym,0,symsize,color=blue,/fill
   ;oplot,final.mh[inx]-final.mk[inx],final.mk[inx],psym=8
  
   ;plotsym,4,symsize
   ind=where(final.group eq 2 and ctts eq 0 ,count3)
   plotsym,0,symsize
   oplot,final.mh[ind]-final.mk[ind],final.mk[ind],psym=8 
  
   ind=where(final.group eq 2 and ctts eq 1,count4)
   plotsym,0,symsize,color=blue,/fill
   oplot,final.mh[ind]-final.mk[ind],final.mk[ind],psym=8   
   
   ind=where(final.group eq 1 and final.mj le -10.0,count)
   print,'IR exc. HCN group = ',count2,count,count1
   
   ind=where(final.group eq 2 and final.mj le -10.0,count)
   print,'IR exc. Continuum = ',count4,count,count3

	; Select stars in the left hand side of the ISO
	;ii=where(final.mh-final.mk le 0.3 and final.mh-final.mk ge -1  and final.mk ge 5)
	
 	
	; Print the information of non-member stars
	;for k=0,n_elements(ii)-1 do begin
	;	print,final.mj[ii[k]],final.mh[ii[k]],final.mk[ii[k]],final.mh[ii[k]]-final.mk[ii[k]]
	;endfor
	   
   if keyword_set(ZAMS) then begin
      d=4000
      factor=5.0*alog10(d)-5.0
      loadiso_zams,iso
      oplot,iso.mh-iso.mk,iso.mk+factor,color=red,thick=5
      ix=where(iso.type eq 'F0')
      avvector,reform(iso.mh[ix]-iso.mk[ix]),reform(iso.mk[ix]+factor),3.0,line=3
      
      ix=where(iso.type eq 'O5')
      avvector,reform(iso.mh[ix]-iso.mk[ix]),reform(iso.mk[ix]+factor),3.0,line=3
      
      for i=0,n_elements(iso.type)-1,3 do begin
         oplot,[-0.7,iso.mh[i]-iso.mk[i]],[iso.mk[i]+factor,iso.mk[i]+factor],line=1
         xyouts,-0.8,iso.mk[i]+factor,iso.type[i],font=1,charsize=1.5
      endfor
      
   endif 
   
   if keyword_set(PMS) then begin   
      d=4000
      factor=5.0*alog10(d)-5.0
      ;loadavgiso,iso,/sdf
      loadiso_sdf,age=5.0,iso
      ;loadiso_zams,iso,d=4000.0
      oplot,iso.mh-iso.mk,iso.mk+factor,color=red,thick=5
      
      ix=where(iso.mass eq max(iso.mass))
      avvector,reform(iso.mh[ix]-iso.mk[ix]),reform(iso.mk[ix]+factor),3.0,line=3
      
      ix=where(iso.mass eq min(iso.mass))
      avvector,reform(iso.mh[ix]-iso.mk[ix]),reform(iso.mk[ix]+factor),3.0,line=3
   
      ; Plot T Tau star mass limit
      ix=where(abs(iso.mass-3.0) eq min(abs(iso.mass-3.0)))
      avvector,reform(iso.mh[ix]-iso.mk[ix]),reform(iso.mk[ix]+factor),3.0,line=3
      
      arrow,2.0,10.0,2.61,11.12,/data,color=red
      xyouts,2.0,9.0,'Av = 10',font=1,charsize=1.5
      
      
      for i=0,n_elements(iso.mass)-1,7 do begin
         mass=iso.mass[i]*10.0
         mass=round(mass)/10.0
         oplot,[-0.3,iso.mh[i]-iso.mk[i]],[iso.mk[i]+factor,iso.mk[i]+factor],line=1
         xyouts,-0.5,iso.mk[i]+factor,string(mass,format='(F4.1)'),font=1,charsize=1.5
      endfor
      
      d=4000
      factor=5.0*alog10(d)-5.0
      oplot,iso.mh-iso.mk,iso.mk+factor,color=red,thick=5,line=4
   
   endif

	if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
	endif
	
	resetplt,/all
	!p.multi=0

	return 
END


PRO plotmaglim,hk
   
   lmk=19.0
   lmh=19.5
   lmj=20.0


END


PRO AVVECTOR,x,y,length,line=line,color=color,thick=thick
  
  b=1.78*x-y
  xx=fltarr(100)
  yy=fltarr(100)
  
  for i=0,n_elements(xx)-1 do begin
    xx[i]=x+0.1*i
    yy[i]=1.78*xx[i]-b
  endfor
  
  ;print,xx
  ;yy=1.78*xx-b
  oplot,xx,yy,line=line,color=color,thick=thick
  
 
  
END




