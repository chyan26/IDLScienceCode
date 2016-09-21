
PRO CMDPLOT, FILE=file, PS=ps, markc2d=markc2d

   COMMON share,conf
   loadconfig

   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+ps,$
         /color,xsize=20,ysize=20,xoffset=0.4,yoffset=0,$
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
   !p.multi=[0,2,2]

   table=mrdfits(file,1)
   
   mj=fltarr(n_elements(table.flux[0]))
   mh=fltarr(n_elements(table.flux[0]))
   mk=fltarr(n_elements(table.flux[0]))
   mi1=fltarr(n_elements(table.flux[0]))
   mi2=fltarr(n_elements(table.flux[0]))
   mi3=fltarr(n_elements(table.flux[0]))
   mi4=fltarr(n_elements(table.flux[0]))
   mm1=fltarr(n_elements(table.flux[0]))
   
   if keyword_set(markc2d) then begin
     c2dflag=where(table.c2d eq 1)
   endif
   
   for i=0,n_elements(table.(0))-1 do begin
        
     
     mj[i]=-2.5*alog10((table[i].flux[0]*1e-3)/1594.0)
     mh[i]=-2.5*alog10((table[i].flux[1]*1e-3)/1024.0)
     mk[i]=-2.5*alog10((table[i].flux[2]*1e-3)/666.7)
     mi1[i]=-2.5*alog10((table[i].flux[3]*1e-3)/280.9)
     mi2[i]=-2.5*alog10((table[i].flux[4]*1e-3)/179.7)
     mi3[i]=-2.5*alog10((table[i].flux[5]*1e-3)/115.0)
     mi4[i]=-2.5*alog10((table[i].flux[6]*1e-3)/64.13)
     mm1[i]=-2.5*alog10((table[i].flux[7]*1e-3)/7.17)
     
   endfor



   plot,mh-mk,mj-mh,$
      xtitle='H - Ks',ytitle='J - H',xrange=[-1,3.5],yrange=[0,4],$
      xstyle=1,psym=7,charsize=1.6,symsize=0.3, font=1, xthick=5.0,$
      ythick=5.0

   plot,mi3-mi4,mi1-mi2,$
      xtitle='[5.8] -[8.0]',ytitle='[3.6] - [4.5]',xrange=[-2,4],yrange=[-0.5,2.5],$
      xstyle=1,psym=7,charsize=1.6,symsize=0.3, font=1, xthick=5.0,$
      ythick=5.0

    plot,mi4-mm1,mi1-mi3,$
      xtitle='[8.0] - [24.0] ',ytitle='[3.6] - [5.8]',xrange=[-0.5,10.5],yrange=[-0.5,5],$
      xstyle=1,psym=7,charsize=1.6,symsize=0.3, font=1, xthick=5.0,$
      ythick=5.0
 

   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif
   resetplt,/all
   !p.multi=0
   

END


PRO CMDFILTERPLOT, FILE=file, PS=ps, MARKC2D=markc2d, dumpnewyso=dumpnewyso, dumpgalaxyzone=dumpgalaxyzone, list=list, sym=sym, sizesym=sizesym

   COMMON share,conf
   loadconfig
   
   if keyword_set(sym) then begin
      sym=sym
   endif else begin
      sym=4
   endelse
   
   if keyword_set(sizesym) then begin
     symsize=sizesym
   endif else begin
     symsize=1.0
   endelse
   
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
	
	if keyword_set(markc2d) then begin
		spawn,'ssh chyan@capella findyso --ra=248.39013 --dec=-24.088804 --dra=10.0 --ddec=1.0 --cat=oph>'$
      	+conf.catpath+'oph_c2d_yso.cat' 
	endif	

   table=mrdfits(file,1)

   mj=fltarr(n_elements(table.flux[0]))
   mh=fltarr(n_elements(table.flux[0]))
   mk=fltarr(n_elements(table.flux[0]))
   mi1=fltarr(n_elements(table.flux[0]))
   mi2=fltarr(n_elements(table.flux[0]))
   mi3=fltarr(n_elements(table.flux[0]))
   mi4=fltarr(n_elements(table.flux[0]))
   mm1=fltarr(n_elements(table.flux[0]))
	if keyword_set(markc2d) then begin
		c2dflag=fltarr(n_elements(table.flux[0]))
	endif
	
   for i=0,n_elements(table.(0))-1 do begin
   
      ; Check if this source are shown in c2d yso
		if keyword_set(markc2d) then begin
			name=strmid(table[i].source_name,7,16)
			spawn,'grep '+name+' '+conf.catpath+'oph_c2d_yso.cat',result,exit_status=status
			if status eq 0 then begin
				c2dflag[i]=1
			endif

		endif
      
      
      mj[i]=-2.5*alog10((table[i].flux[0]*1e-3)/1594.0)
      mh[i]=-2.5*alog10((table[i].flux[1]*1e-3)/1024.0)
      mk[i]=-2.5*alog10((table[i].flux[2]*1e-3)/666.7)
      mi1[i]=-2.5*alog10((table[i].flux[3]*1e-3)/280.9)
      mi2[i]=-2.5*alog10((table[i].flux[4]*1e-3)/179.7)
      mi3[i]=-2.5*alog10((table[i].flux[5]*1e-3)/115.0)
      mi4[i]=-2.5*alog10((table[i].flux[6]*1e-3)/64.13)
      mm1[i]=-2.5*alog10((table[i].flux[7]*1e-3)/7.17)
      
   endfor

	if keyword_set(markc2d) then begin
		inx=where(c2dflag eq 1,count,complement=newyso)
		plot,mi2[inx]-mi4[inx],mi4[inx],psym=sym,xrange=[-1,5],yrange=[15,5],$
	      xstyle=1,ystyle=1,symsize=sizesym,$
	      xtitle='[4.5] - [8.0]',ytitle='[8.0]',charsize=2.0,$
	      xthick=6,ythick=6,font=1,/nodata
	      		
		oplot,mi2[inx]-mi4[inx],mi4[inx],psym=sym,color=red,symsize=1.5,thick=5.0
		oplot,mi2[newyso]-mi4[newyso],mi4[newyso],psym=sym+1,symsize=1.5,thick=5.0
	   
	   oplot,[-1,5],[15,9],line=2,thick=5
     ;oplot,[-1,5],[15,9]-2,line=3,thick=5
	   oplot,[2,2],[0,100],line=2,thick=5

	endif else begin
	
		plot,mi2-mi4,mi4,psym=sym,xrange=[-1,5],yrange=[15,5],$
	      xstyle=1,ystyle=1,symsize=sizesym,$
	      xtitle='[4.5] - [8.0]',ytitle='[8.0]',charsize=2.0,$
	      xthick=8,ythick=8,font=1,thick=5.0
	
	   oplot,[-1,5],[15,9],line=2,thick=5
	   ;oplot,[-1,5],[15,9]-2,line=3,thick=5
	   oplot,[2,2],[0,100],line=2,thick=5
	
	endelse
	
	; selecting new ysos in YSO zone. Note: found YSO will be over plotted as a gree cross.
	if keyword_set(dumpnewyso) then begin
		; Selecting YSO in YSO zone.
		select_ind=where(c2dflag ne 1 and mi2-mi4 le 2.0 and mi2 le 14, complement=gind)
		
		;ysoind=where(c2dflag[gind] ne 1)
		;newysoind=gind[ysoind]
		oplot,mi2[select_ind]-mi4[select_ind],mi4[select_ind],psym=1,color=green
		;oplot,mi2[newysoind]-mi4[newysoind],mi4[newysoind],psym=1,color=green
		
		
		for n=0,n_elements(select_ind)-1 do begin
			print,table[select_ind[n]].source_name
		endfor
	endif

	if keyword_set(dumpgalaxyzone) then begin
		; Selecting YSO in YSO zone.
		mi2mi4=mi2-mi4
		y1=-mi2mi4+14
		y2=-mi2mi4+12
		
		select_ind=where(mi4 le y1 and mi4 ge y2, count)
		
		; Then selecting YSO in galaxy zone
		;ysoind=where(c2dflag[gind] ne 1)
		;newysoind=gind[ysoind]
		oplot,mi2[select_ind]-mi4[select_ind],mi4[select_ind],psym=4,symsize=1.5,color=green,thick=5.0
		for n=0,n_elements(select_ind)-1 do begin
			print,table[select_ind[n]].source_name,table[select_ind[n]].alpha,table[select_ind[n]].class
			
		endfor
		
		print,max(table[select_ind].alpha),min(table[select_ind].alpha), mean(table[select_ind].alpha), median(table[select_ind].alpha)
	endif
	
	xyouts,3.8,6.0,'New YSOs',color=cgcolor('black'),charsize=1.5,font=1
	xyouts,3.8,6.4,'c2D YSOs',color=cgcolor('black'),charsize=1.5,font=1
	
	oplot,[3.6],[5.9],psym=sym+1,symsize=1.5,thick=5.0
	oplot,[3.6],[6.3],psym=sym,symsize=1.5,thick=5.0,color=cgcolor('red')

   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif
   resetplt,/all

	if keyword_set(markc2d) then begin
		spawn,'rm -rf '+conf.catpath+'oph_c2d_yso.cat'
	endif	


END



PRO CMDFILTERPLOTBYCLASS, FILE=file, PS=ps, list=list, sym=sym, sizesym=sizesym

  COMMON share,conf
  loadconfig
  
  if keyword_set(sym) then begin
    sym=sym
  endif else begin
    sym=4
  endelse
  
  if keyword_set(sizesym) then begin
    symsize=sizesym
  endif else begin
    symsize=1.0
  endelse
  

  
   
  table=mrdfits(file,1)
  
  mj=fltarr(n_elements(table.flux[0]))
  mh=fltarr(n_elements(table.flux[0]))
  mk=fltarr(n_elements(table.flux[0]))
  mi1=fltarr(n_elements(table.flux[0]))
  mi2=fltarr(n_elements(table.flux[0]))
  mi3=fltarr(n_elements(table.flux[0]))
  mi4=fltarr(n_elements(table.flux[0]))
  mm1=fltarr(n_elements(table.flux[0]))
  
  for i=0,n_elements(table.(0))-1 do begin
        
    mj[i]=-2.5*alog10((table[i].flux[0]*1e-3)/1594.0)
    mh[i]=-2.5*alog10((table[i].flux[1]*1e-3)/1024.0)
    mk[i]=-2.5*alog10((table[i].flux[2]*1e-3)/666.7)
    mi1[i]=-2.5*alog10((table[i].flux[3]*1e-3)/280.9)
    mi2[i]=-2.5*alog10((table[i].flux[4]*1e-3)/179.7)
    mi3[i]=-2.5*alog10((table[i].flux[5]*1e-3)/115.0)
    mi4[i]=-2.5*alog10((table[i].flux[6]*1e-3)/64.13)
    mm1[i]=-2.5*alog10((table[i].flux[7]*1e-3)/7.17)
    
  endfor
  
    inx=where(table.c2d eq 1,count,complement=newyso)
    plot,mi2[inx]-mi4[inx],mi4[inx],psym=sym,xrange=[-1,5],yrange=[15,5],$
      xstyle=1,ystyle=1,symsize=sizesym,$
      xtitle='[4.5] - [8.0] (mag)',ytitle='[8.0] (mag)',charsize=2.0,$
      xthick=6,ythick=6,font=1,/nodata
    
    inx=where(table.c2d eq 1 and strmatch(strcompress(table.class,/remove),'I') eq 1,count)
    oplot,mi2[inx]-mi4[inx],mi4[inx],psym=sym,symsize=1.5,thick=5.0,color=cgcolor('red')
    inx=where(table.c2d eq 1 and strmatch(strcompress(table.class,/remove),'F') eq 1,count)
    oplot,mi2[inx]-mi4[inx],mi4[inx],psym=sym,symsize=1.5,thick=5.0,color=cgcolor('green')
    inx=where(table.c2d eq 1 and strmatch(strcompress(table.class,/remove),'II') eq 1,count)
    oplot,mi2[inx]-mi4[inx],mi4[inx],psym=sym,symsize=1.5,thick=5.0,color=cgcolor('blue')
    inx=where(table.c2d eq 1 and strmatch(strcompress(table.class,/remove),'III') eq 1,count)
    oplot,mi2[inx]-mi4[inx],mi4[inx],psym=sym,symsize=1.5,thick=5.0,color=cgcolor('purple')


    inx=where(table.c2d eq 0 and strmatch(strcompress(table.class,/remove),'I') eq 1,count)
    oplot,mi2[inx]-mi4[inx],mi4[inx],psym=sym+1,symsize=1.5,thick=5.0,color=cgcolor('red')
    inx=where(table.c2d eq 0 and strmatch(strcompress(table.class,/remove),'F') eq 1,count)
    oplot,mi2[inx]-mi4[inx],mi4[inx],psym=sym+1,symsize=1.5,thick=5.0,color=cgcolor('green')
    inx=where(table.c2d eq 0 and strmatch(strcompress(table.class,/remove),'II') eq 1,count)
    oplot,mi2[inx]-mi4[inx],mi4[inx],psym=sym+1,symsize=1.5,thick=5.0,color=cgcolor('blue')
    inx=where(table.c2d eq 0 and strmatch(strcompress(table.class,/remove),'III') eq 1,count)
    oplot,mi2[inx]-mi4[inx],mi4[inx],psym=sym+1,symsize=1.5,thick=5.0,color=cgcolor('purple')
    
    xyouts,4,6,'Class I',color=cgcolor('red'),charsize=1.5,font=1
    xyouts,4,6.4,'Flat',color=cgcolor('green'),charsize=1.5,font=1
    xyouts,4,6.8,'Class II',color=cgcolor('blue'),charsize=1.5,font=1
    xyouts,4,7.2,'Class III',color=cgcolor('purple'),charsize=1.5,font=1
    
    xyouts,3.8,8.0,'New YSOs',color=cgcolor('black'),charsize=1.5,font=1
    xyouts,3.8,8.4,'c2D YSOs',color=cgcolor('black'),charsize=1.5,font=1

    oplot,[3.6],[7.9],psym=sym+1,symsize=1.5,thick=5.0
    oplot,[3.6],[8.3],psym=sym,symsize=1.5,thick=5.0
    
    oplot,[-1,5],[15,9],line=2,thick=5
    oplot,[2,2],[0,100],line=2,thick=5
    

  
  if keyword_set(PS) then begin
     ps_end,/png
     pdfname=file_basename(ps,'.eps')
     spawn,'ps2pdf '+ps+' '+conf.pspath+pdfname+'.pdf'
   endif
   resetplt,/all
   !p.multi=0
  
  
END




PRO CMDAGBCHECK, FITS=fits, PS=ps

  COMMON share,conf
  loadconfig

  if keyword_set(PS) then begin
    PS_Start, FILENAME=ps,/encapsulated
    device,/color,xsize=20,ysize=20,xoffset=0.4,yoffset=0,$
      SET_FONT='Helvetica',/TT_FONT;,/encapsulated
      
  endif
  
  c0=2.998e8
  
  obs_v=[12,25,60]
  
  ;nu=receiver*1e-6
  ;lam=c0/nu
  
  readcol,'postagb-data.txt',f1,f2,f3,f4
  agbm12=-2.5*alog10(f1/43.148)
  agbm25=-2.5*alog10(f2/10.088)
  agbm60=-2.5*alog10(f3/1.581)
  
  ; Read extinction law
  exfile='~/IDLSourceCode/Science/RhoOph/extinction_law.ascii'
  readcol,exfile,wave,kappa,/silent
  k_v=211.4
  
  v=[1.252,1.631,2.146,3.56,4.52,5.73,7.91,24.0]
  
  ; Converting mJy to erg s-1 cm-2 Hz-1
  factor=1d-23*1e-3
  
  
  ; Read information in SED produced FITS files
  tab1=mrdfits(fits,1,mhd,/Silent)
  tab2=mrdfits(fits,2,/Silent)
  
  
  
  ; Reading parameter file to get model parameters.
  parameter_file=strmid(conf.modelpath,0,strlen(conf.modelpath)-5)+'parameters.fits'
  modelparameter=mrdfits(parameter_file,1)
  
  m12=fltarr(n_elements(tab1.flux[0]))
  m25=fltarr(n_elements(tab1.flux[0]))
  m60=fltarr(n_elements(tab1.flux[0]))
  
  for ind=0,n_elements(tab1.SOURCE_NAME)-1 do begin
  
    obs_flux=tab1[ind].flux*phertz2pmicron(v)*factor
    obs_fluxerr=tab1[ind].flux_error*abs(phertz2pmicron(v)*factor)
    
    k_lambda=interpol(kappa,wave,v)
    
    micron = '!9' + String("155B) + '!X'
    lambda=  '!9' + String("154B) + '!X'
    
    index=where(tab2.source_id eq tab1[ind].soure_id, count)
    
    minchi=9999.0
    if count ne 0 then begin
      for i=0, n_elements(index)-1 do begin
        ; looking for SED with smallest chi2
        if minchi ge tab2[index[i]].chi2 then begin
          minchi=tab2[index[i]].chi2
          
          subdir=strmid(strcompress(tab2[index[i]].model_name,/remove),0,5)+'/'
          modelname=conf.modelpath+subdir+strcompress(tab2[index[i]].model_name,/remove)+'_sed.fits.gz'
          modelind=tab2[index[i]].model_name
          
          inx=where(strcmp(modelparameter.MODEL_NAME,tab2[index[i]].model_name) eq 1, count)
          
          if count ne 0 then model_para=modelparameter[inx]
          
          sed=mrdfits(modelname,1,/silent)
          tf=mrdfits(modelname,3,/silent)
          
          k_lambda=interpol(kappa,wave,sed.wavelength)
          a_lambda=tab2[index[i]].av*(k_lambda/k_v)
          extinc=10^(-0.4*a_lambda)
          scaling=(10^(-tab2[index[i]].scale))^2
          
          spectrum=tf[4].(0)*extinc*scaling
          photosphere=sed.stellar_flux*scaling*extinc
        endif
      endfor
      
    endif
    
    iras_flux=interpol(spectrum/sed.frequency,sed.wavelength,obs_v)
    ;print,iras_flux
    ; Convert erg/cm2/s/Hz to Jy
    m12[ind]=-2.5*alog10((iras_flux[0]*1e23)/43.148)
    m25[ind]=-2.5*alog10((iras_flux[1]*1e23)/10.088)
    m60[ind]=-2.5*alog10((iras_flux[2]*1e23)/1.581)
    
    ;print,m12[ind],m25[ind],m60[ind]
       
  endfor

;print,m12
  ind=where(tab1.c2d eq 0 and strmatch(strcompress(tab1.class,/remove),'I') eq 1)
  plotsym,4,1,/fill
  cgplot,m12[ind]-m25[ind],m25[ind]-m60[ind],psym=8,xrange=[-1,5],yrange=[0,4],$
    xstyle=1,ystyle=1,symsize=1.4,$
    xtitle='[12] - [25] (mag)',ytitle='[25] - [60] (mag)',charsize=2.0,$
    xthick=6,ythick=6,font=1,color=cgcolor('red')
    
  oplot,[1.55,1.55],[-10,10],line=1,thick=5
  ;oplot,[1.0,1.0],[-10,10],line=1,thick=5
  oplot,[-10,10],[1,1],line=1 ,thick=5 
  ;oplot,[-10,10],[0.2,0.2],line=1 ,thick=5
  polyfill,[-1,-1,1.55,1.55],[0,1,1,0],color = cgcolor('blk3')
  
  plotsym,0,1,/fill
  oplot,agbm12-agbm25,agbm25-agbm60,psym=8
  
  if keyword_set(PS) then begin
    ps_end,/png
    pdfname=file_basename(ps,'.eps')
    spawn,'ps2pdf '+ps+' '+conf.pspath+pdfname+'.pdf'
  endif
  resetplt,/all
  !p.multi=0
  
END














