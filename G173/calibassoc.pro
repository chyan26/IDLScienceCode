PRO calibassoc,zero,ps=ps
   COMMON share,conf 
   loadconfig

   filter=['j','h','k']
   filterstring=['J','H','Ks']
   satmag=[0,0,0]
   
   ;!p.multi=[0,3,1]
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+ps,$
         /color,xsize=34,ysize=12,xoffset=1.5,yoffset=0,$
         /encapsulated,SET_FONT='Helvetica',/TT_FONT
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2   
   endif else begin
      red=255
      green=32768    
   endelse
   multiplot,/default
   xtitle=textoidl("m_{2MASS}")
   ytitle=textoidl('m_{obs} - m_{2mass}')
   
   !p.charsize=3.0
   !p.font=1
   erase & multiplot, [0,3,1,0,0], /square,xgap=0.001, mXtitle=xtitle, mYtitle=ytitle,$
    mxTitOffse=1.5
 
   
   for j=0,n_elements(filter)-1 do begin
      readcol,conf.catpath+'soc_'+filter[j]+'.sex',id,x,y,flux,ferr,$
         mag,magerr,a,b,i,e,fwhm,flag,class,va,/silent
      readcol,conf.catpath+'stars_cat_'+filter[j]+'.assoc',$
         aid,ax,xy,amj,amjerr,amh,amherr,amk,amkerr,/silent
     
      mag=mag-zero[j]
      
      f=0
     ; print,amj[0],amh[0]
     ;  if j eq 0 then begin
     ;     amag=amj
     ;     amagerr=amjerr
     ;  endif

      ; if j eq 1 then begin
      ;    amag=amh
      ;    amagerr=amherr
      ; endif
      ; if j eq 2 then begin
      ;    amag=amk
      ;    amagerr=amkerr
      ; endif
      
      for i=0, n_elements(va)-1 do begin
         ind=where(va[i] eq aid,count)
         if count eq 1 then begin
            if f eq 0 then begin
               
               refmj=amj[ind]
               refmh=amh[ind]
               refmk=amk[ind]
               refmjerr=amjerr[ind]
               refmherr=amherr[ind]
               refmkerr=amkerr[ind]
                
               ;refmag=amag[ind]
               ;referr=amagerr[ind]
               obsmag=mag[i]
               obserr=magerr[i]
               f = 1
            endif else begin
               refmj=[refmj,amj[ind]]
               refmh=[refmh,amh[ind]]
               refmk=[refmk,amk[ind]]
               refmjerr=[refmjerr,amjerr[ind]]
               refmherr=[refmherr,amherr[ind]]
               refmkerr=[refmkerr,amkerr[ind]]
            
               ;refmag=[refmag,amag[ind]]
               ;referr=[referr,amagerr[ind]]
               obsmag=[obsmag,mag[i]]
               obserr=[obserr,magerr[i]]
            endelse
         endif
      endfor
 
      if j eq 0 then refmag=refmj & referr=refmjerr
      if j eq 1 then refmag=refmh & referr=refmherr
      if j eq 2 then refmag=refmk & referr=refmkerr
          
     
           
      ploterror,refmag,obsmag-refmag,referr,sqrt(referr^2+obserr^2),psym=3,$
         xrange=[12.5,max(refmag)+0.5],yrange=[-2.0,2.0],$
         xstyle=1,ystyle=1,$
         xthick=5.0,ythick=5.0,symsize=1,/nohat,charsize=1.2,font=1
            
      inx=where(refmag ge satmag[j])
      s=obsmag-refmag
      off=median(s[inx])
      oplot,[min(refmag),max(refmag)+0.3],[off,off],color=red,thick=5
      
      h=histogram(s,bin=0.01,min=-1,max=1)
      xh=getseries(-1,1,0.01)
      yfit = GAUSSFIT(xh, h, coeff, NTERMS=3)
      print,coeff[2]
      
      oplot,[min(refmag),max(refmag)+1.0],[3*coeff[2],3*coeff[2]],line=1,thick=5
      oplot,[min(refmag),max(refmag)+1.0],[-3*coeff[2],-3*coeff[2]],line=1,thick=5
      xyouts,max(refmag),1.6,filterstring[j],charsize=1.5,font=1
      
      
      multiplot
      
      
      print,'Photometric calibation of '+strupcase(filter[j])+' Band'
      print,off,coeff[2]
      
   endfor
   
   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
      pdfname=file_basename(ps,'.eps')
      spawn,'epstopdf '+conf.pspath+ps
      
   endif
   resetplt,/all
   !p.multi=0
   
END


PRO calibassoc_line,zero,ps=ps
   COMMON share,conf 
   loadconfig

   filter=['h2','brg','kcont']
   satmag=[0,0,0]
   
   !p.multi=[0,2,2]
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+'calibassoc_cont.ps',$
         /color,xsize=20,ysize=20,xoffset=1.5,yoffset=0;,$
         ;/encapsulated
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2   
   endif else begin
      red=255
      green=32768    
   endelse
   
   for j=0,n_elements(filter)-1 do begin
      readcol,conf.catpath+'soc_'+filter[j]+'.sex',id,x,y,flux,ferr,$
         mag,magerr,a,b,i,e,fwhm,flag,class,va,/silent
      readcol,conf.catpath+'stars_cat_'+filter[j]+'.assoc',$
         aid,ax,xy,amj,amjerr,amh,amherr,amk,amkerr,/silent
     
      mag=mag-zero[j]
      
      f=0
     ; print,amj[0],amh[0]
     ;  if j eq 0 then begin
     ;     amag=amj
     ;     amagerr=amjerr
     ;  endif

      ; if j eq 1 then begin
      ;    amag=amh
      ;    amagerr=amherr
      ; endif
      ; if j eq 2 then begin
      ;    amag=amk
      ;    amagerr=amkerr
      ; endif
      
      for i=0, n_elements(va)-1 do begin
         ind=where(va[i] eq aid,count)
         if count eq 1 then begin
            if f eq 0 then begin
               
               refmj=amk[ind]
               refmh=amk[ind]
               refmk=amk[ind]
               refmjerr=amkerr[ind]
               refmherr=amkerr[ind]
               refmkerr=amkerr[ind]
                
               ;refmag=amag[ind]
               ;referr=amagerr[ind]
               obsmag=mag[i]
               obserr=magerr[i]
               f = 1
            endif else begin
               refmj=[refmj,amk[ind]]
               refmh=[refmh,amk[ind]]
               refmk=[refmk,amk[ind]]
               refmjerr=[refmjerr,amkerr[ind]]
               refmherr=[refmherr,amkerr[ind]]
               refmkerr=[refmkerr,amkerr[ind]]
            
               ;refmag=[refmag,amag[ind]]
               ;referr=[referr,amagerr[ind]]
               obsmag=[obsmag,mag[i]]
               obserr=[obserr,magerr[i]]
            endelse
         endif
      endfor
 
      if j eq 0 then refmag=refmj & referr=refmjerr
      if j eq 1 then refmag=refmh & referr=refmherr
      if j eq 2 then refmag=refmk & referr=refmkerr
          
      plot,refmag,obsmag-refmag,psym=6,yrange=[-2.0,2.0],$
            xrange=[min(refmag),max(refmag)],$
            xtitle='!6Magnitude from 2MASS Catalog',ytitle='Deteced - 2MASS',$
            title='!6'+strupcase(filter[j])+' Band',font=1,charsize=1.2,symsize=0.6
            
      inx=where(refmag ge satmag[j])
      s=obsmag-refmag
      off=median(s[inx])
      oplot,[min(refmag),max(refmag)],[off,off],color=red,thick=2
      
      
      h=histogram(s,bin=0.01,min=-1,max=1)
      xh=getseries(-1,1,0.01)
      yfit = GAUSSFIT(xh, h, coeff, NTERMS=3)
      plot,xh,h,psym=10,font=1,charsize=1.2
      oplot,xh,yfit,color=red
      
      if j eq 0 then begin
         ind=where(obsmag ge 12.5 and refmj le 20)
         plot,refmj[ind]-refmh[ind],obsmag[ind]-refmag[ind],psym=3,xtitle='J - H',$
            ytitle='j(obs) - J',font=1,charsize=1.2
         plot,refmh[ind]-refmk[ind],obsmag[ind]-refmag[ind],psym=3,xtitle='H - K',$
            ytitle='j(obs) - J',font=1,charsize=1.2
      endif
      
      if j eq 1 then begin
         ind=where(obsmag ge 12.5 and refmh le 20)
         plot,refmh[ind]-refmk[ind],obsmag[ind]-refmag[ind],psym=3,xtitle='H - K',$
            ytitle='h(obs) - H',font=1,charsize=1.2
         plot,refmj[ind]-refmh[ind],obsmag[ind]-refmag[ind],psym=3,xtitle='J - H',$
            ytitle='h(obs) - H' ,font=1,charsize=1.2   
      endif

      if j eq 2 then begin
         ind=where(obsmag ge 12.5 and refmk le 20)
         plot,refmh[ind]-refmk[ind],obsmag[ind]-refmag[ind],psym=3,xtitle='H - K',$
            ytitle='k(obs) - K',font=1,charsize=1.2
         plot,refmj[ind]-refmk[ind],obsmag[ind]-refmag[ind],psym=3,xtitle='J - H',$
            ytitle='k(obs) - K',font=1,charsize=1.2    
      endif
      
      print,'Photometric calibation of '+strupcase(filter[j])+' Band'
      print,off,coeff[2]
      
   endfor
   
   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif
   resetplt,/all
   !p.multi=0
   
END