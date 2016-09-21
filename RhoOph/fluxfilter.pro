;  This flux filter is used to filter out some souces that are fitted with very high M1 
;    level (F_m1 > F_max), but not detected in M1 band

PRO FLUXFILTER, FITS=fits, NEWFITS=newfits, REGION=region,NIRLIM=nirlim

   COMMON share,conf
   loadconfig
   
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
   
   ; Converting mJy to erg s-1 cm-2 Hz-1
   factor=1d-23*1e-3


   ; Read information in SED produced FITS files
   tab1=mrdfits(fits,1,mhd,/Silent)
   tab2=mrdfits(fits,2,/Silent)

   flag=intarr(n_elements(tab1.SOURCE_NAME))
   flag[*]=1
   
   spawn,"rm -rf /tmp/ysoname.txt"
   spawn, "ssh chyan@capella findyso "+$
      "--ra="+strcompress(string(mean(tab1.x)),/remove)+$
      " --dec="+strcompress(string(mean(tab1.y)),/remove)+$
      ;" --dra="+strcompress(string(abs(max(tab1.x)-min(tab1.x))/2.0,/remove)+$
      ;" --ddec="+strcompress(string(string(abs(max(tab1.y)-min(tab1.y))/2.0,/remove)+$
      " --rad=100"+$
      " --cat=oph  > /tmp/ysoname.txt"
      
   spawn,'wc -l /tmp/ysoname.txt',result
   if result ne 0 then begin
      readcol,'/tmp/ysoname.txt',format='(f,a,a,f,f,f)',id,sstc2d,c2dnames,ra,dec,slope
      isswire=0
   endif else begin
      isswire=1
   endelse
   
   for ind=0,n_elements(tab1.SOURCE_NAME)-1 do begin
      
      ;if strcmp(strcompress(tab1[ind].source_name,/remove),'SSTc2dJ163252.9-243220') eq 1 then begin
         obs_flux=tab1[ind].flux*phertz2pmicron(v)*factor
         obs_fluxerr=tab1[ind].flux_error*abs(phertz2pmicron(v)*factor)
         
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
                           
         spectrum=tf[4].(0)*extinc*scaling
         photosphere=sed.stellar_flux*scaling*extinc
         
         inx=where(tab1[ind].valid gt 0)
         plot,v[inx],obs_flux[inx],psym=6,xrange=[0.1,100],$
            /xlog,xstyle=1,/ylog,yrange=[min(obs_flux[inx]),max([obs_flux,photosphere])],charsize=2.0,$
            xtitle='Wavelength (' + micron + 'm)',ytitle=lambda+'F!D'+lambda+'!X',$
            thick=3,xthick=3,ythick=3,font=1,title=tab1[ind].source_name
         
         
         oplot,sed.wavelength, photosphere,color=255
         oplot,sed.wavelength, spectrum,color=255
         oplot,v,obs_flux,psym=5,color=255
         
         
         sed_flux_mips=interpol(spectrum,sed.wavelength,24.0)
         sed_flux_jband=interpol(spectrum,sed.wavelength,1.235)
         sed_flux_hband=interpol(spectrum,sed.wavelength,1.662)
         sed_flux_kband=interpol(spectrum,sed.wavelength,2.159)
         stellar_flux_mips=interpol(photosphere,sed.wavelength,24.0)
         
         ; Before doing filtering, make sure this source is not in C2D list
         if isswire eq 0 then begin
            newstring=strmid(tab1[ind].source_name,7,16)
            ysoind=where(strmatch(c2dnames,newstring) eq 1,count)
         endif else begin
            count=0
         endelse
         if count eq 0 then begin 
            
            ; If a source is not detected in 24 micron but SED expects a detection, remove it. 
            ;  M1 flux sensitivity is 0.03 mJy 
            m1_flux_limit=0.03*abs(phertz2pmicron(24.0)*factor)
            if (sed_flux_mips ge m1_flux_limit and tab1[ind].valid[7] eq 0) then begin
               print,tab1[ind].source_name,"Reject: SED expects envelope but not detected."
               print,'M1 flux limit=',string(m1_flux_limit)
               flag[ind]=0
            endif 
            ; If a source is detected in MP1 but does not fit with SED a 24 micron, remove it.
            if (tab1[ind].valid[7] eq 1 and stellar_flux_mips ge obs_flux[7]+4.0*obs_fluxerr[7]) then begin
               print,tab1[ind].source_name,"Reject: MIPS is lower (3-sigma) than YSO and stellar SED."
               flag[ind]=0
            endif
            
            if (tab1[ind].valid[7] eq 1 and abs(sed_flux_mips-obs_flux[7]) ge 6.0*obs_fluxerr[7]) then begin
               ;print,sed_flux_mips-obs_flux[7],3.5*obs_fluxerr[7]
               print,tab1[ind].source_name,"Reject: SED is not well fitted at MIPS band."
               flag[ind]=0
            endif
            
            if keyword_set(nirlim) then begin
               
               if (tab1[ind].valid[0] eq 0 and sed_flux_jband ge nirlim[0]) then begin
                  print,tab1[ind].source_name,"Reject: expected J band should be detectable."
                  flag[ind]=0
               endif
               if (tab1[ind].valid[1] eq 0 and sed_flux_hband ge nirlim[1]) then begin
                  print,tab1[ind].source_name,"Reject: expected H band should be detectable."
                  flag[ind]=0
               endif
               if (tab1[ind].valid[2] eq 0 and sed_flux_kband ge nirlim[2]) then begin
                  print,tab1[ind].source_name,"Reject: expected K band should be detectable."
                  flag[ind]=0
               endif
            
            endif
         endif
   endfor
   ii=where(flag eq 1)
   newtab1=tab1[ii]
   
   k=0
   for i=0,n_elements(newtab1.source_name)-1 do begin
      ind=where(tab2[*].source_id eq newtab1[i].soure_id, count)
      if count ne 0 then begin 
      
         if k eq 0 then begin
            newtab2=tab2[ind]
            k=1      
         endif else begin
            newtab2=[newtab2,tab2[ind]]
         endelse
      endif    
   end

   if file_test(newfits) then spawn,'rm -rf '+newfits
   mwrfits,newtab1, newfits,mhd,/Silent
   mwrfits,newtab2,newfits,/Silent
   
   print,'Total number of sources: ',n_elements(tab1.soure_id)
   print,'Removed source: ', n_elements(tab1.soure_id)-n_elements(newtab1.soure_id)
   print,'Source lefted: ',n_elements(newtab1.soure_id),'ID = ',newtab1.soure_id



END