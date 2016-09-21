

PRO FLUXCALIB, catalog, ref, ps=ps, filename=filename
   
   COMMON share,conf
   loadconfig
   
   ; The maximum value of magnitude offset of star
   dlim=0.2
   
   ; File name of the PS file
   if keyword_set(filename) then begin
      psfile=filename
   endif else begin
      psfile='fluxcalib.ps'
   endelse
   
   !p.multi=[0,1,2]
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+psfile,$
         /color,xsize=15,ysize=20,xoffset=1.5,yoffset=0
         
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2   
   endif else begin
      red=255
      green=32768    
   endelse
   
   tagname=tag_names(catalog)
   
   dmag=getseries(10,16,1.0)
   me={dmag:fltarr(n_elements(dmag)),err:fltarr(n_elements(dmag))}
   magerr=replicate(me,3)
   
   ; Go through each filter
   for i=0,2 do begin
      ; Extract the name of the filter
      filter=strlowcase(tagname[i])
 
      ; Matching catalog of each filter
      MATCH_CATALOG,catalog.(i).x, catalog.(i).y, catalog.(i).mag,catalog.(i).magerr,$
         ref.x, ref.y, ref.(i+5),ref.(i+8), match
      
      
      if (strcmp('J',filter,/fold_case)) then m_sat=12.12
      if (strcmp('H',filter,/fold_case)) then m_sat=12.30
      if (strcmp('K',filter,/fold_case)) then m_sat=11.54
      
      
      
      caterr=match.magerr1
      referr=match.magerr2
      catmag=match.fmag1
      refmag=match.fmag2
      
      ind=where(refmag ge m_sat)
      
      s=catmag[ind]-refmag[ind]
      s_weight= 1 / referr[ind]
      s_best= total(s_weight*s)/total(s_weight)

      ;th_image_cont,60-im.(i),/nocont,/nobar,crange=[0,60]
      ;oplot,match.x,match.y,psym=4,color=red
   
      ; Selecting star with big magnotude offset
      ind=where(abs(s) ge dlim, count)
      
     ; if count ne 0 then begin
     ;    oplot,match.x[ind],match.y[ind],PSYM=5,color=green,symsize=2
     ;    getds9region,match.x[ind],match.y[ind],'star_check_'+strlowcase(tagname[i]),color='red'
     ; endif
         
      ;plot,refmag,s,psym=6,yrange=[-2.0,2.0],$
      ;   xtitle='!6Magnitude from 2MASS Catalog',ytitle='Deteced - 2MASS',$
      ;   title='!6'+strupcase(filter)+' Band'
      ind=where(catmag le 50)
      ploterror,refmag[ind],catmag[ind]-refmag[ind],referr[ind],referr[ind],psym=3,$
         xrange=[min(refmag[ind]),max(refmag[ind])+0.5],yrange=[-2.0,2.0],$
         xstyle=1,ystyle=1,$
         xtitle='!6Magnitude from 2MASS Catalog',ytitle='Deteced - 2MASS',$
         title='!6'+strupcase(filter)+' Band',symsize=1,/nohat
          
         
      if count ne 0 then begin
         oplot,[min(refmag),max(refmag)],[-dlim,-dlim],color=red,line=2
         oplot,[min(refmag),max(refmag)],[dlim,dlim],color=red,line=2
      endif
  
      oplot,[min(refmag),max(refmag)],[s_best,s_best]
      oplot,[min(refmag),max(refmag)],[median(s),median(s)],line=3
      ;errplot,refmag,catmag-refmag-err,catmag-refmag+err
      
      print,'Photometric calibation of '+strupcase(filter)+' Band'
      print,'Matched 2MASS stars = '+strcompress(string(n_elements(refmag)),/remove)
      print,'Photometry offset = ',s_best,median(s)
      print,'Photometry error = ',stddev(s) 
      ; Check the error as function of magnitude
      ;dmag=getseries(10,16,1.0)
      ;magerr=fltarr(n_elements(dmag))
      for j=1,n_elements(dmag)-1 do begin
        
        ii=where(refmag ge dmag[j-1] and refmag le dmag[j],count)
        if count ge 3 then begin
       
          magerr[i].err[j]=stddev(s[ii])
          
        endif  
      endfor
      magerr[i].dmag=dmag
      
      
      ploterror,refmag,catmag,referr,caterr,psym=3,/nohat,$
         xtitle='!6Magnitude from 2MASS Catalog',ytitle='!6Observed Magnitude ',$
         title='!6'+strupcase(filter)+' Band'
      ;plot,findgen(100)
      ;plot,dmag,magerr[i].err,psym=4,xtitle='!6Magnitude from 2MASS Catalog'
      ;print,dmag,stddev(s[ii])
   endfor
   
   
   
   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif
   resetplt,/all
   !p.multi=0


END


PRO  PLOTMAGERR, magerr,ps=ps
   COMMON share,setting
   loadconfig
   
   
   ; File name of the PS file   
   !p.multi=0
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=setting.pspath+'magerr.ps',$
         /color,xsize=20,ysize=15,xoffset=1.5,yoffset=2
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2   
   endif else begin
      red=255
      green=32768    
   endelse
   
   
   plot,[10,16],[0,1],/nodata, xtitle='Magnitude', ytitle='Standard Deviation'

   for i=0,2 do begin
      oplot,magerr[i].dmag-0.5,magerr[i].err,psym=4+i
      plots,14.5,0.9-0.05*i,psym=4+i
      
      ;oplot,magerr[i].dmag,magerr[i].err
   endfor
   
   xyouts,14.7,0.9,'J band'
   xyouts,14.7,0.85,'H band'
   xyouts,14.7,0.8,'Ks band'
   if keyword_set(PS) then begin
        device,/close
      set_plot,'x'
   endif
   resetplt,/all
   !p.multi=0

END






