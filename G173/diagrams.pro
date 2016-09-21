PRO MKCCDIAGRAM, final, ps=ps

	COMMON share,conf
	
	loadconfig
   symsize=1.0

   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+ps,$
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
   
   ctts=intarr(n_elements(final.mk))
   ctts[*]=0
   ; Selecting CTTS stars
   for i=0, n_elements(final.mj)-1 do begin
         ; left boundary
            y1=1.7*(final.mh[i]-final.mk[i])+0.031 
       
         ; right boundary
            y2=1.7*(final.mh[i]-final.mk[i])-0.644
            y3=0.58*(final.mh[i]-final.mk[i])+0.52
      if ((final.mj[i]-final.mh[i]) le y1) and ((final.mj[i]-final.mh[i]) ge y2) $
      and ((final.mj[i]-final.mh[i]) ge y3) then begin
        ctts[i]=1;              
      endif
   endfor

  final.ctts=ctts

   plot,final.mh-final.mk,final.mj-final.mh,$
      xtitle='H - Ks',ytitle='J - H',xrange=[-0.5,2.5],yrange=[0,4],$
      xstyle=1,psym=7,charsize=2.0,symsize=symsize, font=1, xthick=8.0,$
      ythick=8.0,/nodata
   ;polyfill,[0.5,1.0,2.9,3.3],[0.8,1.1,5.0,5.0],color = red;, /DEVICE 
   R=217
   G=216
   B=213 
	polyfill,[0.44,2.94,3.3,1.0],[0.8,5.0,5.0,1.1],color = R+256L*(G+256L*B)  


   
   ; Plot HR diagram
   ; Selecting field stars
   plotsym,0,symsize,thick=3
   inx=where(final.group ne 1 and ctts ne 1,count)
   plot,final.mh[inx]-final.mk[inx],final.mj[inx]-final.mh[inx],$
      xtitle='H - Ks',ytitle='J - H',xrange=[-0.5,2.5],yrange=[0,4.0],$
      xstyle=1,psym=8,charsize=2.0, font=1, xthick=8.0,$
      ythick=8.0,/noerase
   
   plotsym,0,symsize,/fill,thick=3
   inx=where(final.group ne 1  and ctts eq 1,count)
   oplot,final.mh[inx]-final.mk[inx],final.mj[inx]-final.mh[inx],psym=8
     
   
   ; Data of cluster
   plotsym,8,symsize,thick=3
   ind=where(final.group eq 1 and ctts ne 1,count)
   oplot,final.mh[ind]-final.mk[ind],final.mj[ind]-final.mh[ind],psym=8
   
   plotsym,8,1,/fill,thick=3
   ind=where(final.group eq 1 and ctts eq 1,count)
   oplot,final.mh[ind]-final.mk[ind],final.mj[ind]-final.mh[ind],psym=8

	
	; Plot stellar group
	loaddwarfiso,djh,dhk
	oplot,dhk,djh,color=blue,thick=8
	loadgaintiso,gjh,ghk
	oplot,ghk,gjh,color=blue,thick=8
	; Plot CTTS
	aa=(findgen(6)+5)/10
	bb=0.58*aa+0.52
	oplot,aa,bb,line=4,color=blue,thick=5
	
   ;plot extinction vector
 	arrow,0.0,1.5,0.65,2.61,/data,color=red,thick=4
  xyouts,0,2.61,'Av = 10',font=1,charsize=1.8
 	
  ; Plot extcintoin direction
  oplot,[0.37,3.37],[0.66,5.76],line=3,color=red,thick=8
 	oplot,[0.16,3.16],[0.79,5.89],line=3,color=red,thick=8
	oplot,[max(aa),3+max(aa)],[max(bb),5.1+max(bb)],line=3,color=red,thick=8
	
	if keyword_set(PS) then begin
     
      device,/close
      set_plot,'x'
      pdfname=file_basename(ps,'.eps')
      spawn,'ps2pdf '+conf.pspath+ps+' '+conf.pspath+pdfname+'.pdf'
	endif
	

	return 
END

PRO MAKECMD, cat, PS=ps

COMMON share,conf
loadconfig
if keyword_set(PS) then begin

PS_Start, FILENAME=conf.pspath+ps,xsize=8,ysize=7,$
   TT_FONT='Times',/encapsulated
endif 
  
mh=cat.mh+11.27
mk=cat.mk+11.27
 
plot,mh-mk,mk,psym=4,xrange=[-1,5],yrange=[20,6],ystyle=1,$
  font=1,charsize=2.0,xtickinterval=1,xticks=3,xstyle=1,xtitle='H - Ks',$
  ytitle='Ks',/nodata
  
  ind=where(cat.ctts eq 0 ,count3)
  plotsym,0,symsize,thick=thick
  if count3 ne 0 then oplot,mh[ind]-mk[ind],cat.mk[ind],psym=8
  
  ;ind=where(cat.group eq 3 and ctts eq 1,count4)
  ind=where(cat.ctts eq 1,count4)
  plotsym,0,symsize,color=cgCOLOR("Blue"),thick=thick,/fill
  if count4 ne 0 then oplot,mh[ind]-mk[ind],cat.mk[ind],psym=8


loadiso_zams,iso
oplot,iso.mh-iso.mk,iso.mk+11.27,color=red,thick=5

ind=[0,1,2,3,4,5,6,7,9,12,17,19,20]
oplot,iso.mh[ind]-iso.mk[ind],iso.mk[ind]+11.27,psym=7
xyouts,iso.mh[ind]-iso.mk[ind]-0.5,iso.mk[ind]+11.27+0.1,iso.type[ind],charsize=1.5


arrow,0.0,1.5,0.65,2.61,/data,color=red,thick=4
xyouts,0,2.61,'Av = 10',font=1,charsize=1.8

r=2.0
avx=iso.mh[17]-iso.mk[17]
avy=iso.mk[17]+11.27
avx1=(r+1.79*avx)/1.79

xx=[avx,avx1]
yy=[avy,avy+r]
oplot,xx,yy

; Find out how many star below this lin
hk=mh-mk
kk=mk
line_kk = INTERPOL(yy, xx, hk)  
print,kk-line_kk

ind=where(kk-line_kk ge 0 and cat.group eq 1 and cat.ctts eq 1, count1)
ind=where(kk-line_kk ge 0 and cat.group eq 1 and cat.mj le 0 and cat.ctts eq 0, count2)
ind=where(kk-line_kk ge 0 and cat.group eq 1 and cat.av ge 14 and cat.mj le 0 and cat.ctts eq 0, count3)
ind=where(kk-line_kk ge 0 and cat.group eq 1,count0)
ind=where(kk-line_kk ge 0 and cat.group eq 2 and cat.ctts eq 1, count4)
ind=where(kk-line_kk ge 0 and cat.group eq 2 and cat.mj le 0 and cat.ctts eq 0, count5)
ind=where(kk-line_kk ge 0 and cat.group eq 2 and cat.av ge 14 and cat.mj le 0 and cat.ctts eq 0, count6)
print,'In cloud CCTS=',count1
print,'In cloud Non-J =',count2
print,'In cloud High Av =',count3
print,'In cloud total star=',count0
print,'Off cloud CCTS=',count4
print,'Off cloud Non-J =',count5
print,'Off cloud High Av =',count6


ind=where(kk-line_kk ge 0,count)
print,count

;oplot,cat.mh[ind]-cat.mk[ind],cat.mk[ind],psym=8


if keyword_set(PS) then begin
  ps_end,/png
  pdfname=file_basename(ps,'.eps')
  spawn,'ps2pdf '+conf.pspath+ps+' '+conf.pspath+pdfname+'.pdf'
endif




END

PRO GETEXTINCTION, X, Y, R, XX, YY
  
  


END



PRO CHECKHRD, final, ps=ps
   COMMON share,conf
   loadconfig
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+'checkhrd.eps',$
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

   plot,final.mh-final.mk,final.mj-final.mh,$
      xtitle='H - Ks',ytitle='J - H',xrange=[-0.5,4.5],yrange=[0,5],$
      xstyle=1,psym=7,charsize=1.6,symsize=0.3, font=1, xthick=5.0,$
      ythick=5.0,/nodata
   
   ind=where(nonpms eq 2)
   getds9region,final.x[ind],final.y[ind],'checkhrd_overpms',color='red'
   ind=where(nonpms eq 1)
   getds9region,final.x[ind],final.y[ind],'checkhrd_belowpms',color='green'
    
   plotsym,0,symsize
   inx=where(nonpms eq 1 or nonpms eq 2,count)
   plot,final.mh[inx]-final.mk[inx],final.mj[inx]-final.mh[inx],$
      xtitle='H - Ks',ytitle='J - H',xrange=[-0.5,4.5],yrange=[0,5],$
      xstyle=1,psym=8,charsize=1.6, font=1, xthick=5.0,$
      ythick=5.0,/noerase
   
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
   !p.multi=[0,1,3]
   plothist,final.mj[inx],xrange=[9,20]
   plothist,final.mh[inx],xrange=[9,20]
   plothist,final.mk[inx],xrange=[9,20]
   !p.multi=0
   
   if keyword_set(PS) then begin
      device,/close
     set_plot,'x'
   endif

END

PRO CTTSISO
	COMMON share,conf
	loadconfig
    
    blue=65535
    red=255
    green=32768    

	plot,[-0.5,4.5],[0,5],$
	xtitle='H - Ks',ytitle='J - H',xrange=[-0.5,1.5],yrange=[0,2],$
	xstyle=1,psym=7,charsize=1.6,symsize=0.3, font=1, xthick=5.0,$
	ythick=5.0,/nodata

	loaddwarfiso,djh,dhk
	loadgaintiso,gjh,ghk
	oplot,dhk,djh,color=blue
	oplot,ghk,gjh,color=blue
	
	aa=(findgen(6)+4.5)/10
	bb=0.58*aa+0.52
	oplot,aa,bb,line=4,color=blue

 	oplot,[0.37,3.37],[0.66,5.76],line=3,color=red
 	oplot,[0.16,3.16],[0.79,5.89],line=3,color=red
	oplot,[max(aa),3+max(aa)],[max(bb),5.1+max(bb)],line=3,color=red

	x=findgen(15)
	y=1.7*x+0.031
	oplot,x,y
	y=1.7*x-0.544
	oplot,x,y
	
	hk=(findgen(51)+45)/100
	
	jh=0.58*hk+0.52
	
	h=findgen(51)/10
	print,h
	k=h-hk
	j=jh+h
	oplot,h-k,j-h,psym=4
END


PRO MKCMD, final, ps=ps

	COMMON share,conf
	loadconfig
  symsize=0.7
	!p.multi=0
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+'cmd.eps',$
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
         ;av[i]=(y2-(mj[i]-mh[i]))     
         
         ;av[i]=abs(y2-((mj[i]-mh[i])))/0.107
         ctts[i]=1;              
      endif
   endfor

	;----------------------------------
	;  H-Ks vs Ks
	;----------------------------------
  
  ; first of all, load isochrone to get average H-K 
   age=[1,2,3,5,7,10]
   for i=0,5 do begin
      loadiso_dm98,iso,av=0,age=age[i]
      if i eq 0 then begin
         mh=reform(iso.mh)
         mk=reform(iso.mk)
      endif else begin
         mh=[mh,reform(iso.mh)]
         mk=[mk,reform(iso.mk)]
      endelse
   endfor
	
   ix=sort(mk)
   
   amk=mk[ix]
   amh=mh[ix]
   
   ; Selecting field stars   
	inx=where(final.group eq 1 and ctts eq 0,count)
   plotsym,0,symsize
	plot,final.mh[inx]-final.mk[inx],final.mk[inx],psym=8, $
		yrange=[13,-5],ystyle=1,xrange=[-1,5], $
		xstyle=1, xtitle='H - Ks',ytitle='Ks',charsize=2,font=1,$
		xthick=5.0,ythick=5.0
   
   inx=where(final.group eq 1 and ctts eq 1,count)
   plotsym,0,symsize,color=blue,/fill
   oplot,final.mh[inx]-final.mk[inx],final.mk[inx],psym=8
	
	; Points of SW cluster
   plotsym,4,symsize
   ind=where(final.group eq 2 and ctts eq 0 ,count)
   oplot,final.mh[ind]-final.mk[ind],final.mk[ind],psym=8	
	
   plotsym,4,symsize,color=blue,/fill
   ind=where(final.group eq 2 and ctts eq 1,count)
   oplot,final.mh[ind]-final.mk[ind],final.mk[ind],psym=8   
	; Make the region for SW member
	;getds9region,final.x[ind],final.y[ind],'sw.reg',color='green'
	
	
	; Data of NE cluster
	plotsym,8,symsize
   ind=where(final.group eq 1 and ctts eq 0,count)
   oplot,final.mh[ind]-final.mk[ind],final.mk[ind],psym=8	
	
   plotsym,8,symsize,color=blue,/fill
   ind=where(final.group eq 1 and ctts eq 1,count)
   oplot,final.mh[ind]-final.mk[ind],final.mk[ind],psym=8   
 
    ; Make the region for SW member
    getds9region,final.x[ind],final.y[ind],'ne',color='red'
   
	; Select stars in the left hand side of the ISO
	ii=where(final.mh-final.mk le 0.3 and final.mh-final.mk ge -1  and final.mk ge 5)
	
   ;oplot,final.mh[ii]-final.mk[ii],final.mk[ii],psym=6,color=red
	; Make region files for non-member
	getds9region,final.x[ii],final.y[ii],'hk',color='red'
	
	; Print the information of non-member stars
	;for k=0,n_elements(ii)-1 do begin
	;	print,final.mj[ii[k]],final.mh[ii[k]],final.mk[ii[k]],final.mh[ii[k]]-final.mk[ii[k]]
	;endfor
	
   ;loadavgiso,iso
   tage=2.0
   loadiso_sdf,age=tage,iso1
   print,tage
   loadiso_dm98,age=tage,iso2,av=4
   loadiso_dm98,age=tage,iso2,av=0
   
   oplot,iso1.mh-iso1.mk,iso1.mk,color=blue,thick=2
   oplot,iso2.mh-iso2.mk,iso2.mk,color=red,thick=2
   ;print,max(amh-amk),min(amh-amk)
   
   arrow,2.0,-3.5,2.61,-2.38,/data,color=red
   xyouts,2.0,-3.5,'Av = 10',font=1,charsize=1.5

	if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
	endif
	
	resetplt,/all
	!p.multi=0

	return 
END
