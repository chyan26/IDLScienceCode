PRO calibassoc,zero,ps=ps
   COMMON share,conf 
   loadconfig

   filter=['b','v','i']
   satmag=[0,0,0]
   
   !p.multi=[0,2,1]
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.path+'calibassoc.ps',$
         /color,xsize=20,ysize=10,xoffset=1.5,yoffset=0;,$
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
      readcol,conf.fitspath+'stars_cat_'+filter[j]+'.assoc',$
         aid,ax,ay,amag,amagerr,/silent
     
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

				refmag=amag[ind]
				refmagerr=amagerr[ind]               
;               refmj=amj[ind]
;               refmh=amh[ind]
;               refmk=amk[ind]
;               refmjerr=amjerr[ind]
;               refmherr=amherr[ind]
;               refmkerr=amkerr[ind]
                
               ;refmag=amag[ind]
               ;referr=amagerr[ind]
               obsmag=mag[i]
               obserr=magerr[i]
               f = 1
            endif else begin
			   refmag=[refmag,amag[ind]]
			   refmagerr=[refmag,amagerr[ind]]               
               
;               refmj=[refmj,amj[ind]]
;               refmh=[refmh,amh[ind]]
;               refmk=[refmk,amk[ind]]
;               refmjerr=[refmjerr,amjerr[ind]]
;               refmherr=[refmherr,amherr[ind]]
;               refmkerr=[refmkerr,amkerr[ind]]
            
               ;refmag=[refmag,amag[ind]]
               ;referr=[referr,amagerr[ind]]
               obsmag=[obsmag,mag[i]]
               obserr=[obserr,magerr[i]]
            endelse
         endif
      endfor
 
      if j eq 0 then refmag=refmag & referr=refmagerr
      if j eq 1 then refmag=refmag & referr=refmagerr
      if j eq 2 then refmag=refmag & referr=refmagerr
          
      plot,refmag,obsmag-refmag,psym=4,yrange=[-2.0,2.0],$
            xrange=[min(refmag),max(refmag)],$
            xtitle='!6Magnitude from 2MASS Catalog',ytitle='Deteced - HLA',$
            title='!6'+strupcase(filter[j])+' Band',font=1,charsize=1.5
            
      inx=where(refmag ge satmag[j])
      s=obsmag-refmag
      off=median(s[inx])
      oplot,[min(refmag),max(refmag)],[off,off],color=red,thick=2
      
      
      h=histogram(s,bin=0.1,min=-1,max=1)
      xh=getseries(-1,1,0.1)
      yfit = GAUSSFIT(xh, h, coeff, NTERMS=3)
      plot,xh,h,psym=10
      oplot,xh,yfit,color=red
      
      
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