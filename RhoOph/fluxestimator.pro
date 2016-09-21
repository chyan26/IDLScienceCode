; This program is used to make a flux extimation on the given wavelength
PRO FLUXESTIMATOR, FITS=fits, BAND=band, fluxlimit=fluxlimit, PS=ps

   COMMON share,conf
   loadconfig
    
   c0=2.998e8
   
   receiver=[8100,3900,3100,2050,1600,1250,900,700,450,350]
   obs_v=receiver[band-1]
   
   nu=receiver*1e-6
   lam=c0/nu
   
   ; Read extinction law 
   exfile='~/idl_script/Projects/RhoOph/extinction_law.ascii'
   readcol,exfile,wave,kappa,/silent
   k_v=211.4
   
   v=[1.252,1.631,2.146,3.56,4.52,5.73,7.91,24.0]
   
   ; Converting mJy to erg s-1 cm-2 Hz-1
   factor=1d-23*1e-3


   ; Read information in SED produced FITS files
   tab1=mrdfits(fits,1,mhd,/Silent)
   tab2=mrdfits(fits,2,/Silent)
   
   spawn,"rm -rf /tmp/ysoname.txt"
   spawn, "ssh chyan@capella findyso --ra="+strcompress(string(mean(tab1.x)),/remove)+$
      " --dec="+strcompress(string(mean(tab1.y)),/remove)+$
      " --cat=oph  > /tmp/ysoname.txt"
   
   readcol,'/tmp/ysoname.txt',format='(f,a,a,f,f,f)',id,sstc2d,c2dnames,ra,dec,slope
   
   
   ; Reading parameter file to get model parameters.
   parameter_file=strmid(conf.modelpath,0,strlen(conf.modelpath)-5)+'parameters.fits'
   modelparameter=mrdfits(parameter_file,1)
   
   for ind=0,n_elements(tab1.SOURCE_NAME)-1 do begin
   ;for ind=54,54 do begin
      
      ; check if this source is in c2d detection list
      newstring=strmid(tab1[ind].source_name,7,16)
      c2dind=where(strmatch(c2dnames,newstring) eq 1,c2dcount)
      
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
         
      inx=where(tab1[ind].valid gt 0)
      plot,v[inx],obs_flux[inx],psym=6,xrange=[0.1,1000],$
         /xlog,xstyle=1,/ylog,yrange=[1e-14,max([obs_flux,photosphere])],charsize=2.0,$
         xtitle='Wavelength (' + micron + 'm)',ytitle=lambda+'F!D'+lambda+'!X',$
         thick=3,xthick=3,ythick=3,font=1,title=tab1[ind].source_name
      
      
      oplot,sed.wavelength, photosphere,color=255
      oplot,sed.wavelength, spectrum,color=255
      oplot,v,obs_flux,psym=5,color=255
      
      ; Find out the YSO classifications
      find=where(tab1[ind].valid gt 0 and v ge 2.0 and v lt 25)
      coef=linfit(alog10(v[find]),alog10(obs_flux[find]),sigma=sigma,yfit=yfit)
      alpha=coef[1]
      oplot,v[find],10^yfit,color=65535,line=2,thick=3.0
      if alpha ge 0.3 then class="I"
      if alpha ge -0.3 and alpha lt 0.3 then class="F"
      if alpha ge -1.6 and alpha lt -0.3 then class="II"
      if alpha lt -1.6  then class="III"      
      
      ; Extropolate the flux
      sed_flux_alma=interpol(spectrum,sed.wavelength,obs_v)
      
      
      ; If extropolation failed, use 10 - 100 micron SED for extropolation 
      if sed_flux_alma le 0 then begin 
      	exind=where(sed.wavelength ge 30 and sed.wavelength le 100)
      	;oplot,sed[exind].wavelength, spectrum[exind],color=65535,psym=6

      
      
      	coef=linfit(sed[exind].wavelength,alog10(spectrum[exind]),sigma=sigma,yfit=yfit)
      
     
      	sed_flux_alma=10^(coef[1]*obs_v+coef[0])
      	xx=findgen(1000)+30
      	yy=10^(coef[1]*xx+coef[0])
      	;print,coef[1]
      	oplot,xx,yy,color=65535,line=2,thick=3.0
      endif
      if ind eq 0 then begin
         print,'           Source Name            RA           Dec    chi2   Model Name     Flux(mJy)   Ltot  Class'
         print,'---------------------------------------------------------------------------------------------------'
         
      endif 
      
      flux=sed_flux_alma/lam[band-1]/factor
      
      if keyword_set(fluxlimit) and flux ge fluxlimit then begin
      
         if c2dcount ge 1 then begin
            print,strcompress(tab1[ind].source_name,/remove)+'(c2d) '+$
               string(tab1[ind].x,format='(f12.5)')+$
               string(tab1[ind].y,format='(f12.5)')+$
               string(minchi,format='(f9.3)')+'   '+string(strcompress(modelind,/remove),format='(A10)')+$
               string(sed_flux_alma/lam[band-1]/factor,format='(f12.3)')+$
               string(model_para.ltot,format='(f9.3)')+'   '+class
         endif else begin
            print,strcompress(tab1[ind].source_name,/remove)+'(new) '+$
               string(tab1[ind].x,format='(f12.5)')+$
               string(tab1[ind].y,format='(f12.5)')+$
               string(minchi,format='(f9.3)')+'   '+string(strcompress(modelind,/remove),format='(A10)')+$
               string(sed_flux_alma/lam[band-1]/factor,format='(f12.3)')+$
               string(model_para.ltot,format='(f9.3)')+'   '+class
         endelse
      
      endif
      resetplt,/all

   endfor


END



PRO PLOTSEDFORALMA, FITS=fits, BAND=band,SOURCELIST=sourcelist, PS=ps

   COMMON share,conf
   loadconfig
   
   if keyword_set(PS) then begin 
      ;set_plot,'ps'
      
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
   endif else begin
      blue=65535
      red=255
      green=32768    
   endelse
    
   c0=2.998e8
   
   receiver=[8100,3900,3100,2050,1600,1250,900,700,450,350]
   obs_v=receiver[band-1]
   
   nu=receiver*1e-6
   lam=c0/nu
   
   ; Read extinction law 
   exfile='~/idl_script/Projects/RhoOph/extinction_law.ascii'
   readcol,exfile,wave,kappa,/silent
   k_v=211.4
   
   v=[1.252,1.631,2.146,3.56,4.52,5.73,7.91,24.0]
   
   ; Converting mJy to erg s-1 cm-2 Hz-1
   factor=1d-23*1e-3


   ; Read information in SED produced FITS files
   tab1=mrdfits(fits,1,mhd,/Silent)
   tab2=mrdfits(fits,2,/Silent)
   
   spawn,"rm -rf /tmp/ysoname.txt"
   spawn, "ssh chyan@capella findyso --ra="+strcompress(string(mean(tab1.x)),/remove)+$
      " --dec="+strcompress(string(mean(tab1.y)),/remove)+$
      " --cat=oph  > /tmp/ysoname.txt"
   
   readcol,'/tmp/ysoname.txt',format='(f,a,a,f,f,f)',id,sstc2d,c2dnames,ra,dec,slope
   
   
   ; Reading parameter file to get model parameters.
   parameter_file=strmid(conf.modelpath,0,strlen(conf.modelpath)-5)+'parameters.fits'
   modelparameter=mrdfits(parameter_file,1)
   for nn=0,n_elements(sourcelist)-1 do begin
      for ind=0,n_elements(tab1.SOURCE_NAME)-1 do begin
         if strcmp(strcompress(tab1[ind].source_name,/remove),sourcelist[nn]) eq 1 then begin
         
         if keyword_set(PS) then begin
            set_plot,'ps'
      

            basename=string(tab1[ind].source_name,format='(A23)')
            pos = STREGEX(basename, ' ', length=len) 
            strput,basename,'_',pos
      
            ;filename='/tmp/'+basename+'_'+strcompress(string(j),/remove)+'.eps'
            filename='/tmp/'+basename+'.eps'
            
            device,filename=filename,$
            /color,xsize=20,ysize=15,yoffset=20,/encapsulated,$
            SET_FONT='Helvetica',/TT_FONT
                        
            tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
            red=1
            green=2
            blue=3

         endif
         
         ;for ind=54,54 do begin
         
         ; check if this source is in c2d detection list
         newstring=strmid(tab1[ind].source_name,7,16)
         c2dind=where(strmatch(c2dnames,newstring) eq 1,c2dcount)
         
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
            
         inx=where(tab1[ind].valid gt 0)
         plot,v[inx],obs_flux[inx],psym=6,xrange=[0.1,1000],$
            /xlog,xstyle=1,/ylog,yrange=[1e-14,max([obs_flux,photosphere,spectrum])],charsize=2.0,$
            xtitle='Wavelength (' + micron + 'm)',ytitle=lambda+'F!D'+lambda+'!X!N (erg/cm!U-2!N/s)',$
            thick=3,xthick=5,ythick=5,font=1,title=tab1[ind].source_name
         oploterror, v[inx],obs_flux[inx],  obs_fluxerr[inx],psym=6,thick=5
         
         oplot,sed.wavelength, photosphere,thick=5,line=2
         oplot,sed.wavelength, spectrum,color=red,thick=5
         ;oplot,v,obs_flux,psym=5,color=red
         
         oplot,[receiver[band-1],receiver[band-1]],[1e-14,1.0],thick=5
         resetplt,/all
         if keyword_set(PS) then begin
            device,/close
            set_plot,'x'
         endif

      endif
   
      endfor
   endfor
   
   if keyword_set(PS) then begin
      spawn,'epsmerge -o '+ps+' -O Lanscape -cs 0 -prs 1 -p A4 -x 3 -y 3 /tmp/*.eps' 
      spawn,'rm -rf /tmp/*.eps'

   endif

END









