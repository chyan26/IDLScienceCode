
;
; This program is used to pick up YSO candidates that are not identified by C2D project.  Also, this 
;   program will produce SED plot for both c2d detected and new detected YSOs.
;
PRO EXAMYSOCANDIDATE, fits=fits, pos=pos, dpos=dpos, SEDPATH=sedpath, NOPS=nops
   COMMON share,conf
   loadconfig
   
   if keyword_set(SEDPATH) then begin
      plotpath=sedpath+'/plots_yso_good/'
   endif else begin
      plotpath='/data/local/chyan/SEDProject/L1688YSO/plots_yso_good/'
   endelse
   
   ; Read information in SED produced FITS files
   tab1=mrdfits(fits,1,mhd,/silent)
   tab2=mrdfits(fits,2,mhd,/silent)
   
   cra=mean(tab1.x)
   cdec=mean(tab1.y)
   dra=abs((max(tab1.x)-min(tab1.x)))/2
   ddec=abs((max(tab1.y)-min(tab1.y)))/2
   
   spawn,"rm -rf /tmp/ysoname.txt"

   print, "ssh chyan@capella findyso --ra="+strcompress(string(pos[0],format='(f10.5)'),/remove)+$
      " --dec="+strcompress(string(pos[1],format='(f10.5)'),/remove)+$
      " --dra="+strcompress(string(dpos[0]),/remove)+$
      " --ddec="+strcompress(string(dpos[1]),/remove)+$
      " --cat=oph  > /tmp/ysoname.txt"
   spawn, "ssh chyan@capella findyso --ra="+strcompress(string(pos[0],format='(f10.5)'),/remove)+$
      " --dec="+strcompress(string(pos[1],format='(f10.5)'),/remove)+$
      " --dra="+strcompress(string(dpos[0]),/remove)+$
      " --ddec="+strcompress(string(dpos[1]),/remove)+$
      " --cat=oph  > /tmp/ysoname.txt"
   
   readcol,'/tmp/ysoname.txt',format='(f,a,a,f,f,f)',id,sstc2d,c2dnames,ra,dec,slope
   
   
   spawn, "ssh chyan@capella findmir --ra="+strcompress(string(mean(pos[0])),/remove)+$
      " --dec="+strcompress(string(pos[1]),/remove)+$
      " --dra="+strcompress(string(dpos[0]),/remove)+$
      " --ddec="+strcompress(string(dpos[1]),/remove)+$
      "> /tmp/c2dsource.txt"
      ;" --rad=0.6 > /tmp/c2dsource.txt"
   
   readcol,'/tmp/c2dsource.txt',format='(f,a,a,f,f,f,f,f,f,f,f,f)',c_id,c_sstc2d,c_c2dnames,$
      c_ra,c_dec,c_mj_flux,c_mj_err,c_mh_flux,c_mh_err,c_mk_flux,c_mk_err
   
   no_detection=0
   c2d_detection=0
   new_detection=0
   wircam_detection=0
   
   c2dflags=intarr(n_elements(c2dnames))
   c2dflags[*]=0
   
   c2d_list=''
   new_list=''
   
   for i=0,n_elements(tab1.source_name)-1 do begin
      newstring=strmid(tab1[i].source_name,7,16)
      
      ;print,newstring
      ind=where(strmatch(c2dnames,newstring) eq 1,count)
      if count ne 0 then begin
         c2d_detection++
         c2d_list=c2d_list+' '+plotpath+'SSTc2d_'+newstring+'.eps'
         c2dflags[ind]=1
      endif else begin
         ;print,newstring
         iix=where(c_c2dnames eq newstring and c_mk_flux le 0, c)
         if c ne 0 then begin
            wircam_detection++
            print,newstring
         endif
         new_detection++
         new_list=new_list+' '+plotpath+'SSTc2d_'+newstring+'.eps'
      endelse
   endfor
   
   
   inx=where(c2dflags eq 0, count)
   if count ne 0 then begin
      for i=0,count-1 do begin
         spawn,'find '+sedpath+' |grep '+c2dnames[inx[i]],exit_status=status,result
         no_detection=no_detection+1;
         ;print,result
         if status eq 1 then begin
             print,'c2d YSO: SSTc2d '+c2dnames[inx[i]]+' missing. Reason: Not in catalog.'
         endif else begin 
             if n_elements(result) le 2 then begin
                 rstring=result[0]
             endif else begin
                 rsting=result
             endelse
             if stregex(rstring,"stellar") ge 0 then begin
                 print,'c2d YSO: SSTc2d '+c2dnames[inx[i]]+' missing. Reason: fitted with star.'
             endif
             if stregex(rstring,"yso_bad") ge 0 then begin             
                 print,'c2d YSO: SSTc2d '+c2dnames[inx[i]]+' missing. Reason: in bad yso.'
             endif
             if stregex(rstring,"yso_good") ge 0 then begin
                 print,'c2d YSO: SSTc2d '+c2dnames[inx[i]]+' missing. Reason: filtered out.'
             endif
             
             
             ;print,'c2d YSO: SSTc2d '+c2dnames[inx[i]]+' is not detected.'
         endelse
      endfor
   end
   print,'Number of c2d YSO missing in searching:',no_detection
   print,'Number of YSOs also detected by c2d:',c2d_detection
   print,'Number of YSOs newly detected:',new_detection
   print,'       Due to WIRCam data:',wircam_detection
   
   ;cd, '/data/capella/chyan/SEDProject/RhoReg2/plots_yso_good', CURRENT=old_dir  
   
   if keyword_set(nops) eq 0 then begin
   print,'GO ps'
   spawn,'epsmerge -o '+conf.pspath+'c2d_detection.ps -cs 0 -prs 1 -p A4 -O landscape -x 1 -y 1 '+c2d_list 
   spawn,'epsmerge -o '+conf.pspath+'new_detection.ps -cs 0 -prs 1 -p A4 -O landscape -x 1 -y 1 '+new_list 
   endif
   
   ;spawn,'rm -rf /tmp/ysoname.txt /tmp/c2dsource.txt'
   ;print,c2d_list
END


PRO YSO_PARAMETER, fits=fits,final
   COMMON share,conf
   loadconfig
   file=fits
   d=150.0
   dr=100.0
   
    ulim=alog10((d+dr)/1000.0)
    llim=alog10((d-dr)/1000.0)
   ;ulim=alog10(0.1)
   ;llim=alog10(0.3)
   
   if strcmp(!VERSION.OS,'linux') then begin 
      modelname='/data/local/chyan/Models/models_r06/parameters.fits'
   endif else begin
      modelname='/Volumes/Science/Models/models_r06/parameters.fits'
   endelse
  
   
  ; file='output_yso_good.fits'
   table=mrdfits(file,1)
   fit=mrdfits(file,2)
   model=mrdfits(modelname,1)
   
   ; Go through each fitting result and selecting
   for i=0,n_elements(table[*].soure_id)-1 do begin
         ind=where(fit.chi2 eq min(fit.chi2),count)    
         inx=where(strcmp(model.MODEL_NAME,fit[ind].model_name) eq 1, count)
         ;print,count
         if i eq 0 then begin
            final=model[inx]
         endif else begin
            final=[final,model[inx]]
         endelse
   endfor
END


PRO GETC2DYSORADEC, LIST=list

  COMMON share,conf
  loadconfig
  

  pos=[248.39013,-24.088804]
  dpos=[6.0,6.0]
  spawn,"rm -rf /tmp/ysoname.txt"
  spawn, "ssh chyan@capella findyso --ra="+strcompress(string(pos[0],format='(f10.5)'),/remove)+$
    " --dec="+strcompress(string(pos[1],format='(f10.5)'),/remove)+$
    " --dra="+strcompress(string(dpos[0]),/remove)+$
    " --ddec="+strcompress(string(dpos[1]),/remove)+$
    " --cat=oph  > /tmp/ysoname.txt"
    
  readcol,'/tmp/ysoname.txt',format='(f,a,a,f,f,f)',c2did,sstc2d,c2dnames,c2dra,c2ddec,c2dslope

   
  
  for xx=0,n_elements(list)-1 do begin
    newstring=strmid(list[xx],7,16)
    c2dind=where(strmatch(c2dnames,newstring) eq 1,xcount)
    
    
    ;print,list[xx]
    
    ;ind=where(strmatch(strcompress(tab1[*].source_name,/remove),strcompress(list[xx],/remove)) eq 1,xcount)
    
    if xcount ne 0 then begin
      ra=c2dra[xx]
      dec=c2ddec[xx]
      
      radec, ra, dec, ihr, imin, xsec, ideg, imn, xsc
      rastring=strcompress(string(ihr,format='(I)'),/remove)+':'+$
        strcompress(string(imin,format='(I02)'),/remove)+':'+$
        strcompress(string(xsec,format='(F04.1)'),/remove)
        
      decstring=strcompress(string(ideg,format='(I)'),/remove)+':'+$
        strcompress(string(imn,format='(I02)'),/remove)+':'+$
        strcompress(string(xsc,format='(F04.1)'),/remove)

      print,xx+1,' & ',list[xx] ,' & '+rastring+'  &  '+decstring+' &  & \\'
    endif
  endfor
  
END




;
; This is the fnction used to return the YSO classifications by using
;  SED slope.  It is a traditional way to compare with previous result
;
PRO YSO_CLASSIFY, file=file, PS=ps, ALPHA=alpha, WITHC2D=withc2d, MBIN=mbin, MARKCLASS=markclass
   COMMON share,conf
   loadconfig
   
   ; Set magnitude bin
   if keyword_set(mbin) then begin
      mbin=mbin
   endif else begin
      mbin=0.1
   endelse
   
   
   table=mrdfits(file,1)
   
   ; Check how many flux points are loaded
   ndata=n_elements(table[0].flux)
   nu=fltarr(ndata)
   
   ; Go through the header to get the flux 
   mhd=headfits(file,ext=1)
   for i=0,ndata-1 do begin
      string='WAV'+strcompress(string(i+1),/remove)
      nu[i]=sxpar(mhd,string)
   endfor
   nu=[1.252,1.631,2.146,3.56,4.52,5.73,7.91,24.0]
   
   a=fltarr(n_elements(table.x))
   a[*]=!Values.F_NAN
   
   ra=247.97944
   dec=-24.52919 
   
    
   for i=0, n_elements(table.x)-1 do begin
      
      nu_fnu=table[i].flux*1e-26*phertz2pmicron(nu)
      error=table[i].flux_error*1e-26*phertz2pmicron(nu)
      
        ind=where(table[i].flux ge 0 and nu ge 2.0 and nu lt 25)
        ;print,ind 
        bands=nu[ind]
        fluxdensity=nu_fnu[ind]
        ;sigma=error[ind]
        
        ;print,fluxdensity
        ;print,sigma
        coef=linfit(alog10(bands),alog10(fluxdensity),sigma=sigma,yfit=yfit)
  ;       
         ;plot,bands,fluxdensity,/xlog,/ylog,psym=4
  ;       oplot,bands,10^yfit,color=255  
         ;print,yfit
  ;    
         
         a[i]=coef[1]
         print,'------------------'
  ;       ;print,table[i].flux
  ;       ;print,table[i].flux[ind]*1e-26*phertz2pmicron(v[ind])
  ;       print,nu,nu_fnu
  
       ;print,ysoid[i],ysoalpha[i]  
         print,strcompress(string(table[i].source_name),/remove),coef[1]
         ;wait,1
   endfor
   ;a=ysoalpha
   c1=where(a ge 0.3,count1)
   c2=where(a ge -0.3 and a lt 0.3,count2)
   c3=where(a ge -1.6 and a lt -0.3,count3)
   c4=where(a lt -1.6,count4)
   
   print,'Class I   = ',count1
   print,'Flat      = ',count2
   print,'Class II  = ',count3
   print,'Class III = ',count4
   
   getds9region,table[c1].x,table[c1].y,file='class_1.reg',color='red',size=30
   getds9region,table[c2].x,table[c2].y,file='class_f.reg',color='green',size=30
   getds9region,table[c3].x,table[c3].y,file='class_2.reg',color='blue',size=30
   getds9region,table[c4].x,table[c4].y,file='class_3.reg',color='magenta',size=30
   
   
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=ps,$
         /color,xsize=20,ysize=15,xoffset=0,yoffset=0,$
         SET_FONT='Times',/TT_FONT;,/encapsulated
         
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
   endif else begin
      blue=65535
      red=255
      green=32768    
   endelse

   
   if keyword_set(withc2d) then begin
      spawn,"rm -rf /tmp/ysoname.txt"
      spawn,'ssh chyan@capella findyso --ra=247.97944 --dec=-24.52919 --rad=100 --cat=oph > /tmp/ysoname.txt '
      readcol,'/tmp/ysoname.txt',format='(f,a,a,f,f,f)',c2did,sstc2d,c2dnames,c2dra,c2ddec,c2dslope
      c2dhisto=histogram(c2dslope,min=-2.0,max=2.0,bin=mbin)
      spawn,"rm -rf /tmp/ysoname.txt"
   endif
   
   histo=histogram(a,min=-2.0,max=2.0,bin=mbin)
   xh=getseries(-2.0,2.0,mbin)
   
   plot,xh,histo,psym=10,thick=6.0,xthick=5.0,ythick=5.0,charsize=2.0,$
      yrange=[0,60],$
      font=1,ytitle='Number of YSOs',xtitle='SED slope (!9' + String("141B) + '!X)'
   
   if keyword_set(withc2d) then begin
      oplot,xh,c2dhisto,psym=10,line=2,thick=6.0,color=red
   endif
   
   if keyword_set(markclass) then begin
      xyouts,1,55,'I',font=1,charsize=2.0
      xyouts,0,55,'F',font=1,charsize=2.0
      xyouts,-1,55,'II',font=1,charsize=2.0
      xyouts,-1.85,55,'III',font=1,charsize=2.0
      
   endif
   
   
   if keyword_set(alpha) then begin
	   for i=0, n_elements(alpha)-1 do begin
	   	oplot,[alpha[i],alpha[i]],[0,200],line=2,thick=5.0
	   endfor
	   
;	   oplot,[-0.3,-0.3],[0,100],line=2,thick=5.0
;	   oplot,[-1.6,-1.6],[0,100],line=2,thick=5.0
;;	   oplot,[0.3,0.3],[0,100],line=2,thick=5.0
;;	   oplot,[-0.3,-0.3],[0,100],line=2,thick=5.0
;;	   oplot,[-1.6,-1.6],[0,100],line=2,thick=5.0
   endif 
   
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
     pdfname=file_basename(ps,'.eps')
     spawn,'ps2pdf '+ps+' '+conf.pspath+pdfname+'.pdf'
   endif
   resetplt,/all
   !p.multi=0

END




PRO YSOLF, FITS=fits, mbin=mbin, PS=ps
   COMMON share,conf
   loadconfig
   
   ; Set magnitude bin
   if keyword_set(mbin) then begin
     mbin=mbin
   endif else begin
     mbin=0.1
   endelse
   

   
   if keyword_set(PS) then begin
     PS_Start, FILENAME=ps,/encapsulated
     device,/color,xsize=20,ysize=17,xoffset=0.4,yoffset=0,$
       SET_FONT='Helvetica',/TT_FONT;,/encapsulated

   endif
      
   
   ; Read information in SED produced FITS files
   tab1=mrdfits(fits,1,mhd,/Silent)
   tab2=mrdfits(fits,2,/Silent)
  
   logl=alog10(tab1.ltot)
   
   histo=histogram(logl,min=-2.5,max=2.5,bin=mbin)
   xh=getseries(-2.5,2.5,mbin)
   
   cgplot,xh,histo,psym=10,thick=6.0,xthick=5.0,ythick=5.0,charsize=2.0,$
     font=1,ytitle='Number counts',xtitle='Luminosity (log L$\sun$ )'
   
   ind=where(tab1.c2d eq 1)
   histo_c2d=histogram(logl[ind],min=-2.5,max=2.5,bin=mbin)
   
   
   ind=where(tab1.c2d eq 0)
   histo_new=histogram(logl[ind],min=-2.5,max=2.5,bin=mbin)

   oplot,xh,histo_c2d,psym=10,thick=6.0,color=cgcolor('red');,line=1
   oplot,xh,histo_new,psym=10,thick=6.0,color=cgcolor('blue');,line=1  
   
   xyouts,1.8, 55, 'All YSOs',charsize=1.5,font=1
   xyouts,1.8, 52, 'c2D YSOs',color=cgcolor('red'),charsize=1.5,font=1
   xyouts,1.8, 49, 'New YSOs',color=cgcolor('blue'),charsize=1.5,font=1
    
   if keyword_set(PS) then begin
     ps_end,/png
     pdfname=file_basename(ps,'.eps')
     spawn,'ps2pdf '+ps+' '+conf.pspath+pdfname+'.pdf'
   endif
   resetplt,/all
   !p.multi=0



END





PRO YSO_ANALYSIS, final, ps=ps
   COMMON share,conf
   loadconfig
   !p.multi=0
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+'yso_analysis.eps',$
         /color,xsize=20,ysize=20,xoffset=0.4,yoffset=10,$
         SET_FONT='Helvetica',/TT_FONT;,/encapsulated
         
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
   endif else begin
      blue=65535
      red=255
      green=32768    
   endelse
   
   ; Plot mass distribution
   mh=histogram(final.massc,bin=0.1,min=0,max=4)
   xh=getseries(0,4,0.1)
   plot,xh,mh,psym=10,yrange=[0.8,100],font=1,/ylog,ystyle=1,$
      thick=5.0,xthick=4.0,ythick=4.0,charsize=1.2
   
   rh=histogram(final.rmaxd,bin=10,min=20,max=1000)
   xh=getseries(20,1000,10)
   plot,xh,rh,psym=10,/xlog,xrange=[20,1000],xstyle=1,$
      font=1,thick=5.0,xthick=4.0,ythick=4.0,charsize=1.2
   
   plot,final.time,final.mdisk,psym=4,/ylog,font=1,$
      thick=5.0,xthick=4.0,ythick=4.0,charsize=1.2
   
   plot,final.time,final.mdisk/final.massc,psym=4,/ylog,font=1,$
      thick=5.0,xthick=4.0,ythick=4.0,charsize=1.2
 
   
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif
   resetplt,/all
   !p.multi=0
   
END




PRO WRITEINFOTOFITS,fits=fits,newfits=newfits
  
  pos=[248.39013,-24.088804]
  dpos=[6.0,6.0]
  spawn,"rm -rf /tmp/ysoname.txt"
  spawn, "ssh chyan@capella findyso --ra="+strcompress(string(pos[0],format='(f10.5)'),/remove)+$
    " --dec="+strcompress(string(pos[1],format='(f10.5)'),/remove)+$
    " --dra="+strcompress(string(dpos[0]),/remove)+$
    " --ddec="+strcompress(string(dpos[1]),/remove)+$
    " --cat=oph  > /tmp/ysoname.txt"
    
  readcol,'/tmp/ysoname.txt',format='(f,a,a,f,f,f)',c2did,sstc2d,c2dnames,c2dra,c2ddec,c2dslope
  
  if strcmp(!VERSION.OS,'linux') then begin
    modelpath='/data/capella/chyan/Models/models_r06/seds/'
  endif else begin
    modelpath='/Volumes/Science/Models/models_r06/seds/'
  endelse
  
  ; Read extinction law
  exfile='~/IDLSourceCode/Science/RhoOph/extinction_law.ascii'
  readcol,exfile,wave,kappa,/silent
  k_v=211.4
  
  v=[1.252,1.631,2.146,3.56,4.52,5.73,7.91,24.0]
  nu=v
  hz=2.8e8/(v*1e-6)
  ; Converting mJy to erg s-1 cm-2 Hz-1
  factor=1d-23*1e-3
   
   
  data=mrdfits(fits,1)
  data2=mrdfits(fits,2)
  
  ; Check how many flux points are loaded
  ndata=n_elements(data[0].flux)
  ;nu=fltarr(ndata)
  
  ; Go through the header to get the flux
  ;mhd=headfits(fits,ext=1)
  ;for i=0,ndata-1 do begin
  ;  string='WAV'+strcompress(string(i+1),/remove)
  ;  nu[i]=sxpar(mhd,string)
  ;endfor
  
  
  if strcmp(!VERSION.OS,'linux') then begin
    modelname='/data/local/chyan/Models/models_r06/parameters.fits'
  endif else begin
    modelname='/Volumes/Science/Models/models_r06/parameters.fits'
  endelse
  model=mrdfits(modelname,1)
 
  
  
  A = {SOURCE_NAME:'', X:0.0, Y:30., SOURE_ID:40., FIRST_ROW:0L,NUMBER_FITS: 0L,VALID: fltarr(8), $
    FLUX:  fltarr(8),FLUX_ERROR:  fltarr(8), LOG10FLUX:  fltarr(8), LOG10FLUX_ERROR:  fltarr(8), ALPHA:0.0, $
    LTOT: 0.0, TSTAR: 0.0, AV:0.0 , MSTAR:0.0, C2D:0, C2DALPHA: 0.0, TBB:0.0, CLASS:'', TBOLOBS:0.0, TBOLSED:0.0, TBOLSEDAVC:0.0}
    
  newdata = REPLICATE(A, n_elements(data.(0)))
  
  for i=0,n_elements(data.(0))-1 do begin
  ;for i=0,2 do begin
  
    newstring=strmid(data[i].source_name,7,16)
    c2dind=where(strmatch(c2dnames,newstring) eq 1,count)
    if count ne 0 then begin
      newdata[i].c2d=1
      newdata[i].c2dalpha=c2dslope[c2dind]
    endif else begin
      newdata[i].c2d=0
      newdata[i].c2dalpha=-999.0
    endelse
    
    for j=0,n_tags(data)-1 do begin
      newdata[i].(j)=data[i].(j)
    endfor
    
    nu_fnu=data[i].flux*1e-26*phertz2pmicron(v)
    error=data[i].flux_error*1e-26*phertz2pmicron(v)
    ind=where(data[i].flux ge 0 and nu ge 2.0 and nu lt 25)
    bands=nu[ind]
    fluxdensity=nu_fnu[ind]
    
    coef=linfit(alog10(bands),alog10(fluxdensity),sigma=sigma,yfit=yfit)
    if coef[1] ge 0.3 then newdata[i].class='I'
    if coef[1] ge -0.3 and coef[1] lt 0.3 then newdata[i].class='F'
    if coef[1] ge -1.6 and coef[1] lt -0.3 then newdata[i].class='II'
    if coef[1] lt -1.6 then newdata[i].class='III'
    
    newdata[i].ALPHA=coef[1]
 
     
    ; Start to extracting Ltot, Tstar et al.
    ind1=where(data[i].SOURE_ID eq data2.source_id)
    ind2=where(data2[ind1].chi2 eq min(data2[ind1].chi2),count)
    
    subdir=strmid(strcompress(data2[ind1[ind2]].model_name,/remove),0,5)+'/'
    modelname=modelpath+subdir+strcompress(data2[ind1[ind2]].model_name,/remove)+'_sed.fits.gz'

    sed=mrdfits(modelname,1,/silent)
    tf=mrdfits(modelname,3,/silent)

    k_lambda=interpol(kappa,wave,sed.wavelength)
    a_lambda=data2[ind1[ind2]].av*(k_lambda/k_v)
    extinc=10^(-0.4*a_lambda)
    scaling=(10^(-data2[ind1[ind2]].scale))^2
    
    rered_spec=tf[4].(0)*scaling
    spectrum=tf[4].(0)*extinc*scaling
    photosphere=sed.stellar_flux*scaling*extinc

    newdata[i].av = data2[ind1[ind2]].av
    inx=where(strcmp(model.MODEL_NAME,data2[ind1[ind2]].model_name) eq 1, count)
    newdata[i].ltot = model[inx].ltot
    newdata[i].tstar=model[inx].tstar
    newdata[i].mstar=model[inx].massc
    
    ;  Start to looking for Tbol using Black body
    Tbol=getseries(10,6000,10)
    inx=where(data[i].valid gt 0)
    newdata[i].tbolobs=1.25e-11*total(data[i].flux[inx]*hz[inx])/total(data[i].flux[inx])
    ;print,' ---',newdata[i].tbol
    
    int=where(sed.wavelength ge 0.1 and sed.wavelength le 100)
    
    newdata[i].tbolsed=1.25e-11*total(spectrum[int])/total(spectrum[int]/sed[int].frequency)
    newdata[i].tbolsedavc=1.25e-11*total(rered_spec[int])/total(rered_spec[int]/sed[int].frequency)

    
    
    ;print,newdata[i].tbolsed
    
    for tt=0,n_elements(tbol)-1 do begin
      bbflux = planck(wave*1e4,tbol[tt])*wave*1e4*extinc
      ss=max(bbflux)/max(spectrum)
      bb=bbflux/ss
      
      ; find out the BB flux of obsered wavelength
      bb_obs=interpol(bb,wave*1e4,v[inx]*1e4)
      chi2=total((bb_obs-nu_fnu[inx])^2)
      if tt eq 0 then begin
        bestindex=tt
        minch2=chi2
      endif else begin
        if chi2 lt minch2 then begin
          minch2=chi2
          bestindex=tt
        endif
      endelse
      
    endfor
    newdata[i].tbb=tbol[bestindex]

  endfor
  
  
  if file_test(newfits) then spawn,'rm -rf '+newfits
  mwrfits,newdata, newfits,mhd,/Silent
  mwrfits,data2,newfits,/Silent
  
end


PRO MAKELATEXTABLE, fits=fits
  
  data=mrdfits(fits,1)
  
  tabfile='~/Documents/Paper/Thesis/Latex/Chapters/rhoysotable.tex'
  
  ra=data[*].x
  dec=data[*].y
  
  radec, ra, dec, ihr, imin, xsec, ideg, imn, xsc
  rastring=strcompress(string(ihr,format='(I)'),/remove)+':'+$
    strcompress(string(imin,format='(I02)'),/remove)+':'+$
    strcompress(string(xsec,format='(F04.1)'),/remove)
    
  decstring=strcompress(string(ideg,format='(I)'),/remove)+':'+$
    strcompress(string(imn,format='(I02)'),/remove)+':'+$
    strcompress(string(xsc,format='(F04.1)'),/remove)
    

  
  openw,fileunit, tabfile, /get_lun
  
  
  
  for i=0,n_elements(data.(0))-1 do begin
  ;for i=0,2 do begin
      fluxstring=''
      pstring = strcompress(string(data[i].SOURCE_NAME,format='(A)'),/remove)+' & '+$
      rastring[i]+' & '+decstring[i]+' & '
     ;+strcompress(string(data[i].ALPHA,format='(F5.2)'),/remove)
      
     ;if data[i].ALPHA ge 0.3 then pstring=pstring+' & '+ ' I '+' & '
     ;if data[i].ALPHA ge -0.3 and data[i].ALPHA lt 0.3 then pstring=pstring+' & '+ ' F '+' & '
     ;if data[i].ALPHA ge -1.6 and data[i].ALPHA lt -0.3 then pstring=pstring+' & '+ ' II '+' & '
     ;if data[i].ALPHA lt -1.6 then pstring=pstring+' & '+ ' III '+' & '

    ;c2=where(a ge -0.3 and a lt 0.3,count2)
    ;c3=where(a ge -1.6 and a lt -0.3,count3)
    ;c4=where(a lt -1.6,count4)

      
      for j=0,n_elements(data[0].flux)-1 do begin
          fluxstring=fluxstring+strcompress(string(data[i].flux[j],format='(F8.2)'),/remove)+'$\pm$'+$
                  strcompress(string(data[i].flux_error[j],format='(F8.3)'),/remove);+' & '   
          if j eq n_elements(data[0].flux)-1 then fluxstring=fluxstring+' \\ ' else fluxstring=fluxstring+' & '
                  
      endfor
      
      pstring=pstring+fluxstring
      printf,fileunit, pstring
      
  
  
  endfor
  
  close, fileunit
  free_lun,fileunit



END

PRO MAKEPARAMETERTABLE, fits=fits


  data=mrdfits(fits,1)
  
  tabfile='~/Documents/Paper/Thesis/Latex/Chapters/rhoysoparameter.tex'
  
  ra=data[*].x
  dec=data[*].y
  
  radec, ra, dec, ihr, imin, xsec, ideg, imn, xsc
  rastring=strcompress(string(ihr,format='(I)'),/remove)+':'+$
    strcompress(string(imin,format='(I02)'),/remove)+':'+$
    strcompress(string(xsec,format='(F04.1)'),/remove)
    
  decstring=strcompress(string(ideg,format='(I)'),/remove)+':'+$
    strcompress(string(imn,format='(I02)'),/remove)+':'+$
    strcompress(string(xsc,format='(F04.1)'),/remove)
    
    
    
  openw,fileunit, tabfile, /get_lun



  for i=0,n_elements(data.(0))-1 do begin
    
    if data[i].ALPHA ge 0.3 then class='I'
    if data[i].ALPHA ge -0.3 and data[i].ALPHA lt 0.3 then class='F'
    if data[i].ALPHA ge -1.6 and data[i].ALPHA lt -0.3 then class='II'
    if data[i].ALPHA lt -1.6 then class='III'

    pstring = strcompress(string(i+1,format='(I)'),/remove)+' & '+$
    strcompress(string(data[i].SOURCE_NAME,format='(A)'),/remove)+' & '+$
    strcompress(string(data[i].ALPHA,format='(F5.2)'),/remove)+' & '+$
    class+' & '+$
    strcompress(string(data[i].av,format='(F5.2)'),/remove)+' & '+$
    strcompress(string(data[i].tbb,format='(I5)'),/remove)+' & '+$
    strcompress(string(data[i].tbolsed,format='(I5)'),/remove)
    
    if data[i].c2d eq 1 then pstring=pstring+' & c2D YSO \\' else  pstring=pstring+' & new YSO \\'


    printf,fileunit, pstring
  endfor


  close, fileunit
  free_lun,fileunit


END



PRO SELECTVELLO, FITS=fits, TABLE=table, IMGSED=imgsed, c2dflag=c2dflag

  COMMON share,conf
  loadconfig
  
  
  tabfile='~/Documents/Paper/Thesis/Latex/Chapters/'+table
  openw,fileunit, tabfile, /get_lun

  
  c0=2.998e8  
  obs_v=70
    
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
  
  vellolist=''
  n=1
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
    
    sed_flux_70u=interpol(spectrum,sed.wavelength,obs_v)
    radec, tab1[ind].x, tab1[ind].y, ihr, imin, xsec, ideg, imn, xsc
    rastring=strcompress(string(ihr,format='(I)'),/remove)+':'+$
      strcompress(string(imin,format='(I02)'),/remove)+':'+$
      strcompress(string(xsec,format='(F04.1)'),/remove)
      
    decstring=strcompress(string(ideg,format='(I)'),/remove)+':'+$
      strcompress(string(imn,format='(I02)'),/remove)+':'+$
      strcompress(string(xsc,format='(F04.1)'),/remove)

  
    if (tab1[ind].alpha ge 0.3 and sed_flux_70u*3.3e8 le 0.1 and $
      obs_flux[7] ge obs_flux[6] and sed_flux_70u ge obs_flux[7] and tab1[ind].c2d eq c2dflag)  then begin
        ;print,tab1[ind].SOURCE_NAME,sed_flux_70u*3.3e8, tab1[ind].ltot, ' ',tab1[ind].c2d,tab1[ind].tbolsed
        
        pstring=strcompress(string(n,format='(I)'),/remove)+' & ' +tab1[ind].SOURCE_NAME+' & '+$
            rastring+' & '+decstring+' & '+strcompress(string(sed_flux_70u*3.3e8*1e2,format='(f6.2)'),/remove)+' & '+$
            strcompress(string(tab1[ind].ltot,format='(f6.2)'),/remove)+' & '+$
          strcompress(string(tab1[ind].tbolsed,format='(I4)'),/remove)+' \\ '
        
        print,pstring
        printf,fileunit,pstring
        
        vellolist=[vellolist,'SSTc2d '+strmid(tab1[ind].SOURCE_NAME,7,16)]
        n=n+1
    endif 
        
  endfor
  
  close, fileunit
  free_lun,fileunit
  
  if keyword_set(imgsed) then begin
    getysosedimage,fits=fits, list=vellolist,path=conf.path+'ImageSED/VeLLO/'
  endif
    
END



PRO GETYSOTBOL
  COMMON share,conf
  loadconfig

  
   fits=conf.fitspath+'rho_new_yso_final_130515.fits'

   if strcmp(!VERSION.OS,'linux') then begin 
      modelpath='/data/capella/chyan/Models/models_r06/seds/'
   endif else begin
      modelpath='/Volumes/Science/Models/models_r06/seds/'
   endelse
   
   ; Read extinction law 
   exfile='~/IDLSourceCode/Science/RhoOph/extinction_law.ascii'
   readcol,exfile,wave,kappa,/silent
   k_v=211.4
   
   v=[1.252,1.631,2.146,3.56,4.52,5.73,7.91,24.0]
   hz=2.8e8/(v*1e-6)
   
   
   
   ; Converting mJy to erg s-1 cm-2 Hz-1
   factor=1d-23*1e-3


   ; Read information in SED produced FITS files
   tab1=mrdfits(fits,1,mhd,/Silent)
   tab2=mrdfits(fits,2,/Silent)

   ;for ind=0,n_elements(tab1.SOURCE_NAME)-1 do begin
     ;for ind=0,2 do begin
   ind=12
      
      print,1.25e-11*total(tab1[ind].flux*hz)/total(tab1[ind].flux)
      
      ;if strcmp(strcompress(tab1[ind].source_name,/remove),'SSTc2dJ163252.9-243220') eq 1 then begin
         ;obs_flux=tab1[ind].flux*phertz2pmicron(v)*factor/extinc
         ;obs_fluxerr=tab1[ind].flux_error*abs(phertz2pmicron(v)*factor)
         
         k_lambda=interpol(kappa,wave,v)
        
            micron = '!9' + String("155B) + '!X'
            lambda=  '!9' + String("154B) + '!X' 
         
      
         index=where(tab2.source_id eq tab1[ind].soure_id, count)
         
         minchi=9999.0
         
         ; Looking for best fit SED using chi2 value
         bestsed=where(tab2[index].chi2 eq min(tab2[index].chi2),count)
         subdir=strmid(strcompress(tab2[index[bestsed]].model_name,/remove),0,5)+'/'
         modelname=modelpath+subdir+strcompress(tab2[index[bestsed]].model_name,/remove)+'_sed.fits.gz'
         
         sed=mrdfits(modelname,1,/silent)
         tf=mrdfits(modelname,3,/silent)
         
         k_lambda=interpol(kappa,wave,sed.wavelength)
         a_lambda=tab2[index[bestsed]].av*(k_lambda/k_v) 
         extinc=10^(-0.4*a_lambda)
         scaling=(10^(-tab2[index[bestsed]].scale))^2


         obs_flux=tab1[ind].flux*phertz2pmicron(v)*factor;/extinc/scaling
         obs_fluxerr=tab1[ind].flux_error*abs(phertz2pmicron(v)*factor)

         rered_spec=tf[4].(0)*scaling*extinc               
         spectrum=tf[4].(0)*scaling*extinc
         photosphere=sed.stellar_flux*scaling*extinc
         
         inx=where(tab1[ind].valid gt 0)
         plot,v[inx],obs_flux[inx],psym=6,xrange=[0.1,100],$
            /xlog,xstyle=1,/ylog,yrange=[min(obs_flux[inx]),max([obs_flux,photosphere])],charsize=2.0,$
            xtitle='Wavelength (' + micron + 'm)',ytitle=lambda+'F!D'+lambda+'!X',$
            thick=3,xthick=3,ythick=3,font=1,title=tab1[ind].source_name
         
         
         oplot,sed.wavelength, photosphere,color=255
         oplot,sed.wavelength, spectrum,color=255
         oplot,v,obs_flux,psym=5,color=255
         
         int=where(sed.wavelength ge 0.1 and sed.wavelength le 100)

          print,1.25e-11*total(rered_spec[int])/total(rered_spec[int]/sed[int].frequency)
         
         ;print,sed[0].wavelength,sed[1].wavelength,sed[2].wavelength
         
         
         ;  Start to looking for Tbol using Black body
         Tbol=getseries(10,6000,10)
        
         for tt=0,n_elements(tbol)-1 do begin
             bbflux = planck(wave*1e4,tbol[tt])*wave*1e4*extinc
             ss=max(bbflux)/max(spectrum)
             bb=bbflux/ss
             
             
             ; find out the BB flux of obsered wavelength
             bb_obs=interpol(bb,wave*1e4,v[inx]*1e4)
              chi2=total((bb_obs-obs_flux[inx])^2)
              if tt eq 0 then begin
                  bestindex=tt 
                  minch2=chi2
              endif else begin
                  if chi2 lt minch2 then begin
                      minch2=chi2
                      bestindex=tt
                  endif
              endelse
         endfor
         
         ;wave = 2000 + findgen(10)*100
         bbflux = planck(wave*1e4,Tbol[bestindex])*wave*1e4;*extinc
         ss=max(bbflux)/max(spectrum)
         bb=bbflux/ss
         bb_obs=interpol(bb,wave*1e4,v*1e4)
         
         print,Tbol[bestindex]
         ;print,extinc
         ;print,scaling
         oplot,wave,bb,color=65535;,xrange=[0.1,100],/xlog
         oplot,v,bb_obs,psym=5,color=65535
         ;print,wave*1e4
   ;endfor



END 






PRO MAKEYSOREGION, FITS=fits
    COMMON share,conf
    loadconfig
    
    
    table=mrdfits(fits,1)

    c1=where(table.c2d eq 1 and strmatch(strcompress(table.class,/remove),'I') eq 1)
    getds9region,table[c1].x,table[c1].y,file='c2d_class_1.reg',color='red',size=30
    
    c2=where(table.c2d eq 1 and strmatch(strcompress(table.class,/remove),'F') eq 1)
    getds9region,table[c2].x,table[c2].y,file='c2d_class_f.reg',color='green',size=30
    
    c3=where(table.c2d eq 1 and strmatch(strcompress(table.class,/remove),'II') eq 1)
    getds9region,table[c3].x,table[c3].y,file='c2d_class_2.reg',color='blue',size=30
    
    c4=where(table.c2d eq 1 and strmatch(strcompress(table.class,/remove),'III') eq 1)
    getds9region,table[c4].x,table[c4].y,file='c2d_class_3.reg',color='magenta',size=30



    c1=where(table.c2d eq 0 and strmatch(strcompress(table.class,/remove),'I') eq 1)
    getds9region,table[c1].x,table[c1].y,file='new_class_1.reg',color='red',size=30
    
    c2=where(table.c2d eq 0 and strmatch(strcompress(table.class,/remove),'F') eq 1)
    getds9region,table[c2].x,table[c2].y,file='new_class_f.reg',color='green',size=30
    
    c3=where(table.c2d eq 0 and strmatch(strcompress(table.class,/remove),'II') eq 1)
    getds9region,table[c3].x,table[c3].y,file='new_class_2.reg',color='blue',size=30
    
    c4=where(table.c2d eq 0 and strmatch(strcompress(table.class,/remove),'III') eq 1)
    getds9region,table[c4].x,table[c4].y,file='new_class_3.reg',color='magenta',size=30
    
  
END



PRO MODELCMD
    COMMON share,conf
    loadconfig
    
    ;endif else begin
    ;  blue=65535
    ;  red=255
    ;  green=32768
    ;endelse
    
      fits='/Volumes/Science/Models/models_r06/parameters.fits'
      modelpath='/Volumes/Science/Models/models_r06/seds/'
      
      v=[1.252,1.631,2.146,3.56,4.52,5.73,7.91,24.0]
      hz=2.8e8/(v*1e-6)
      
      table=mrdfits(fits,1)
      
      mj=fltarr(n_elements(table.model_name))
      mh=fltarr(n_elements(table.model_name))
      mk=fltarr(n_elements(table.model_name))
      mi1=fltarr(n_elements(table.model_name))
      mi2=fltarr(n_elements(table.model_name))
      mi3=fltarr(n_elements(table.model_name))
      mi4=fltarr(n_elements(table.model_name))
      mm1=fltarr(n_elements(table.model_name))
    
      
      for i=0,n_elements(table.model_name)-1 do begin
        ;for i=0,20000 do begin
      ;i=0
      
          subdir=strmid(strcompress(table[i].model_name,/remove),0,5)+'/'
          modelname=modelpath+subdir+strcompress(table[i].model_name,/remove)+'_sed.fits.gz'
        
          sed=mrdfits(modelname,1,/silent)
          tf=mrdfits(modelname,3,/silent)
          spectrum=tf[4].(0)
          wave=sed.wavelength
          
          sedflux=interpol(spectrum/sed.frequency,sed.wavelength,v)*10e23
          
          mj[i]=-2.5*alog10((sedflux[0])/1594.0)
          mh[i]=-2.5*alog10((sedflux[1])/1024.0)
          mk[i]=-2.5*alog10((sedflux[2])/666.7)
          mi1[i]=-2.5*alog10((sedflux[3])/280.9)
          mi2[i]=-2.5*alog10((sedflux[4])/179.7)
          mi3[i]=-2.5*alog10((sedflux[5])/115.0)
          mi4[i]=-2.5*alog10((sedflux[6])/64.13)
          mm1[i]=-2.5*alog10((sedflux[7])/7.17)
    
          
          ;print,sedflux
        
        
      endfor
    
      ;print,mi4[0:19],mi2[0:19],mi2[0:19]-mi4[0:19]
      plot,mi2-mi4,mi4,psym=3,xrange=[-1,5],yrange=[15,0],$
        xstyle=1,ystyle=1,symsize=1.0,$
        xtitle='[4.5] - [8.0]',ytitle='[8.0]',charsize=2.0,$
        xthick=6,ythick=6,font=1;,/nodata
    
    
      oplot,[-1,5],[15,9],line=2,thick=5
      oplot,[-1,5],[15,9]-2,line=3,thick=5
      oplot,[2,2],[0,100],line=2,thick=5
    
      device,/close
      set_plot,'x'

END




PRO PLOTAVGSED, FITS=fits, PS=ps, CLASS=class
    COMMON share,conf
    loadconfig

  
    if keyword_set(PS) then begin
      set_plot,'ps'
      device,filename=ps,$
        /color,xsize=25,ysize=20,xoffset=0.4,yoffset=10,$
        SET_FONT='Times',/TT_FONT,/encapsulated
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
    endif else begin
      blue=65535
      red=255
      green=32768
    endelse
  
        
    if strcmp(!VERSION.OS,'linux') then begin
      modelpath='/data/capella/chyan/Models/models_r06/seds/'
    endif else begin
      modelpath='/Volumes/Science/Models/models_r06/seds/'
    endelse
    
    ; Read extinction law
    exfile='~/IDLSourceCode/Science/RhoOph/extinction_law.ascii'
    readcol,exfile,wave,kappa,/silent
    k_v=211.4
    
    v=[1.252,1.631,2.146,3.56,4.52,5.73,7.91,24.0]
    hz=2.8e8/(v*1e-6)
    
    avgflux=fltarr(n_elements(v))
    avgflux[*]=0.0
    
    
    ; Converting mJy to erg s-1 cm-2 Hz-1
    factor=1d-23*1e-3
    
    
    ; Read information in SED produced FITS files
    tab1=mrdfits(fits,1,mhd,/Silent)
    tab2=mrdfits(fits,2,/Silent)
    micron = '!9' + String("155B) + '!X'
    lambda=  '!9' + String("154B) + '!X'
    
    plot,v,[1e-10,1e-10,1e-10,1e-10,1e-10,1e-10,1e-10,1e-10],psym=6,xrange=[0.1,100],$
      /xlog,xstyle=1,/ylog,yrange=[1e-16,1e-11],charsize=2.0,$
      xtitle='Wavelength (' + micron + 'm)',ytitle=lambda+'F!D'+lambda+'!N!X'+' (ergs cm!E-2!N!Xs!E-1!N!X)',$
      thick=3,xthick=3,ythick=3,font=1,/nodata
    n=0
    for ind=0,n_elements(tab1.SOURCE_NAME)-1 do begin
    ;for ind=0,2 do begin
    ;ind=12
   
    if tab1[ind].c2d eq 0 and strmatch(strcompress(tab1[ind].class,/remove),class) eq 1 then begin
        print,  tab1[ind].SOURCE_NAME
        k_lambda=interpol(kappa,wave,v)
        
        micron = '!9' + String("155B) + '!X'
        lambda=  '!9' + String("154B) + '!X'
        
        
        index=where(tab2.source_id eq tab1[ind].soure_id, count)
        
        minchi=9999.0
        
        ; Looking for best fit SED using chi2 value
        bestsed=where(tab2[index].chi2 eq min(tab2[index].chi2),count)
        subdir=strmid(strcompress(tab2[index[bestsed]].model_name,/remove),0,5)+'/'
        modelname=modelpath+subdir+strcompress(tab2[index[bestsed]].model_name,/remove)+'_sed.fits.gz'
        
        sed=mrdfits(modelname,1,/silent)
        tf=mrdfits(modelname,3,/silent)
        
        k_lambda=interpol(kappa,wave,sed.wavelength)
        a_lambda=tab2[index[bestsed]].av*(k_lambda/k_v)
        extinc=10^(-0.4*a_lambda)
        scaling=(10^(-tab2[index[bestsed]].scale))^2
        
        
        obs_flux=tab1[ind].flux*phertz2pmicron(v)*factor;/extinc/scaling
        obs_fluxerr=tab1[ind].flux_error*abs(phertz2pmicron(v)*factor)
        
        spectrum=tf[4].(0)*scaling*extinc
        photosphere=sed.stellar_flux*scaling*extinc
        
        inx=where(tab1[ind].valid gt 0)
        
        ;endif  
        oplot,v[inx],obs_flux[inx],psym=6,thick=3.0
        
        avgflux[inx]=avgflux[inx]+obs_flux[inx]
        if n eq 0 then avgsed=spectrum else avgsed=avgsed+spectrum
        ;oplot,sed.wavelength, photosphere,color=255
        oplot,sed.wavelength, spectrum,color=cgcolor('Gray')
        ;oplot,v,obs_flux,psym=5,color=255
        n=n+1
    endif

    endfor

    oplot,v,avgflux/n,psym=6,color=red,thick=5.0,symsize=1.5
    oplot,sed.wavelength,avgsed/n,color=red, thick=5.0

    if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
      pdfname=file_basename(ps,'.eps')
      spawn,'ps2pdf '+ps+' '+conf.pspath+pdfname+'.pdf'
      
    endif

END


PRO PLOTALPHATBOL, fits=fits, ps=ps
    COMMON share,conf
    loadconfig

    if keyword_set(PS) then begin
      PS_Start, FILENAME=ps,/encapsulated
      device,/color,xsize=20,ysize=20,xoffset=0.4,yoffset=0,$
        SET_FONT='Times',/TT_FONT;,/encapsulated        
    endif
    
    ; Read information in SED produced FITS files
    tab1=mrdfits(fits,1,mhd,/Silent)
    tab2=mrdfits(fits,2,/Silent)
    
    plotsym,0,1,/fill
    cgplot,tab1.tbolsed,tab1.alpha,psym=8,xrange=[30,6000],/xlog,xstyle=1,/nodata,$
    thick=6.0,xthick=5.0,ythick=5.0,charsize=2.0,$
      font=1,xtitle='T!Ibol!X!N (K)',ytitle='SED slope (!9' + String("141B) + '!X)'
    
    inx=where(tab1.c2d ne 2 and strmatch(strcompress(tab1.class,/remove),'I') eq 1,count)
    cgoplot,tab1[inx].tbolsed,tab1[inx].alpha,psym=8,color=cgcolor('red')
    inx=where(tab1.c2d ne 2 and strmatch(strcompress(tab1.class,/remove),'F') eq 1,count)
    cgoplot,tab1[inx].tbolsed,tab1[inx].alpha,psym=8,color=cgcolor('green')
    inx=where(tab1.c2d ne 2 and strmatch(strcompress(tab1.class,/remove),'II') eq 1,count)
    cgoplot,tab1[inx].tbolsed,tab1[inx].alpha,psym=8,color=cgcolor('blue')
    inx=where(tab1.c2d ne 2 and strmatch(strcompress(tab1.class,/remove),'III') eq 1,count)
    cgoplot,tab1[inx].tbolsed,tab1[inx].alpha,psym=8,color=cgcolor('purple')
        
    cgoplot,[70,70],[-10,10],line=1,thick=2
    cgoplot,[650,650],[-10,10],line=1,thick=2
    cgoplot,[2800,2800],[-10,10],line=1,thick=2
    
    cgoplot,[0.1,1e5],[0.3,0.3],line=1,thick=2
    cgoplot,[0.1,1e5],[-0.3,-0.3],line=1,thick=2
    cgoplot,[0.1,1e5],[-1.6,-1.6],line=1,thick=2
    
    cgtext, 40,1.8,'Class 0',font=1,charsize=1.5
    cgtext, 110,1.8,'Class I',font=1,charsize=1.5
    cgtext, 1000,1.8,'Class II',font=1,charsize=1.5
    cgtext, 3000,1.8,'Class II',font=1,charsize=1.5
    
    cgtext, 33,0.35,'Class I',font=1,charsize=1.5
    cgtext, 33,-0.25,'Flat',font=1,charsize=1.5
    cgtext, 33,-1.55,'Class II',font=1,charsize=1.5
    cgtext, 33,-2.55,'Class III',font=1,charsize=1.5

    if keyword_set(PS) then begin
      ps_end,/png
      pdfname=file_basename(ps,'.eps')
      spawn,'ps2pdf '+ps+' '+conf.pspath+pdfname+'.pdf'
    endif
    resetplt,/all
    !p.multi=0


END

PRO PLOTLTOTTBOL, fits=fits, ps=ps
  COMMON share,conf
  loadconfig
  
  if keyword_set(PS) then begin
    PS_Start, FILENAME=ps,/encapsulated
    device,/color,xsize=20,ysize=20,xoffset=0.4,yoffset=0,$
      SET_FONT='Times',/TT_FONT;,/encapsulated
  endif
  
  isopath='~/IDLSourceCode/Library/chy_idl/MSIso/'
  file='z019.dat'
   ; Read the isochrone
  readcol,isopath+file,zage,zmi,zma,zlo,zlte
  zte=10^zlte
  lo=10^zlo
  
  loadiso_dm,age=0.02,iso  
  ; Read information in SED produced FITS files
  tab1=mrdfits(fits,1,mhd,/Silent)
  tab2=mrdfits(fits,2,/Silent)
  
  plotsym,0,1,/fill
  cgplot,tab1.tbolsed,tab1.ltot,psym=8,xrange=[1e4,10],/xlog,xstyle=1,/nodata,$
    thick=6.0,xthick=5.0,ythick=5.0,charsize=2.0,/ylog,$
    font=1,xtitle='T!Ibol!X!N (K)',ytitle='SED slope (!9' + String("141B) + '!X)'
  
  
    
  inx=where(strmatch(strcompress(tab1.class,/remove),'I') eq 1,count)
  cgoplot,tab1[inx].tbolsed,tab1[inx].ltot,psym=8,color=cgcolor('red')
  inx=where(strmatch(strcompress(tab1.class,/remove),'F') eq 1,count)
  cgoplot,tab1[inx].tbolsed,tab1[inx].ltot,psym=8,color=cgcolor('green')
  inx=where(strmatch(strcompress(tab1.class,/remove),'II') eq 1,count)
  cgoplot,tab1[inx].tbolsed,tab1[inx].ltot,psym=8,color=cgcolor('blue')
  inx=where(strmatch(strcompress(tab1.class,/remove),'III') eq 1,count)
  cgoplot,tab1[inx].tbolsed,tab1[inx].ltot,psym=8,color=cgcolor('purple')
  
  cgoplot,zte,lo,line=3
  cgoplot,iso.teff,iso.lo
  
;  cgoplot,[70,70],[-10,10],line=1,thick=2
;  cgoplot,[650,650],[-10,10],line=1,thick=2
;  cgoplot,[2800,2800],[-10,10],line=1,thick=2
;  
;  cgoplot,[0.1,1e5],[0.3,0.3],line=1,thick=2
;  cgoplot,[0.1,1e5],[-0.3,-0.3],line=1,thick=2
;  cgoplot,[0.1,1e5],[-1.6,-1.6],line=1,thick=2
;  
;  cgtext, 40,1.8,'Class 0',font=1,charsize=1.5
;  cgtext, 110,1.8,'Class I',font=1,charsize=1.5
;  cgtext, 1000,1.8,'Class II',font=1,charsize=1.5
;  cgtext, 3000,1.8,'Class II',font=1,charsize=1.5
;  
;  cgtext, 33,0.35,'Class I',font=1,charsize=1.5
;  cgtext, 33,-0.25,'Flat',font=1,charsize=1.5
;  cgtext, 33,-1.55,'Class II',font=1,charsize=1.5
;  cgtext, 33,-2.55,'Class III',font=1,charsize=1.5
  
  if keyword_set(PS) then begin
    ps_end,/png
    pdfname=file_basename(ps,'.eps')
    spawn,'ps2pdf '+ps+' '+conf.pspath+pdfname+'.pdf'
  endif
  resetplt,/all
  !p.multi=0
  
  
END














