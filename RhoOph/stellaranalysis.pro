PRO GETMIPSEXCESS, FITS=fits, NEWFITS=newfits, SIGMA=sigma, PS=ps
    COMMON share,conf 
    loadconfig
   
    if strcmp(!VERSION.OS,'linux') then begin 
        modelpath='/data/local/chyan/Models/models_kurucz/seds/'
    endif else begin
        modelpath='/Volumes/Science/Models/models_kurucz/seds/'
    endelse
     
    if keyword_set(PS) then begin 
        set_plot,'ps'
        psfile=ps  
        
        tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
        red=1
        green=2
        blue=3
    endif else begin
        blue=65535
        red=255
        green=32768    
    endelse
   
   
   
    v=[1.252,1.631,2.146,3.56,4.52,5.73,7.91,24.0]
    factor=1d-23*1e-3


   
	  ; Read catalog in FITS format
    table=mrdfits(fits,1,/Silent)
    modeltab=mrdfits(fits,2,/Silent)

    ;ind=where(table.source_name eq 17)
  	
    flag=intarr(n_elements(table.source_name))
   
  	for ind=0,n_elements(table.source_name)-1 do begin
   ;for ind=0,100 do begin     
      ; Loading sellar SED
      ;if strcmp(strcompress(table[ind].source_name,/remove),'SSTc2dJ163224.8-244933') eq 1 then begin
      modelname=modelpath+strcompress(modeltab[ind].model_name,/remove)+'_sed.fits'
      sed=mrdfits(modelname,1,/silent)
      
      ; Read extinction law 
      exfile='~/IDLSourceCode/Science/RhoOph/extinction_law.ascii'
      readcol,exfile,wave,kappa,/silent
      k_v=211.4
	   
	   k_lambda=interpol(kappa,wave,sed.wavelength)
	   a_lambda=modeltab[ind].av*(k_lambda/k_v) 
      
     scale=10^(-0.4*a_lambda)/(10^(modeltab[ind].scale))^2
     sed_flux=sed.frequency*sed.stellar_flux*factor*scale   
      
      
     obs_flux=table[ind].flux*phertz2pmicron(v)*factor
     obs_fluxerr=table[ind].flux_error*abs(phertz2pmicron(v)*factor)
      
      
      
	   sed_flux_mips=interpol(sed_flux,sed.wavelength,24.0)
      
     chi=modeltab[ind].chi2
      
	   inx=where(v eq 24.0,count)
	   if count ne 0 then begin 
         obs_flux_mips=obs_flux[inx]
         obs_fluxerr_mips=obs_fluxerr[inx]
         if (obs_flux_mips ge 0) and (obs_flux_mips-2.5*obs_fluxerr_mips ge sed_flux_mips) then begin
            ;print,'obs=',obs_flux_mips-2.5*obs_fluxerr_mips
            ;print,'sed=',sed_flux_mips
            
            flag[ind]=1
            sourcename=strcompress(string(table[ind].source_name),/remove)
            
            filename='/tmp/'+sourcename+'.eps'
            
            if keyword_set(PS) then begin 
               device,filename=filename,$
               /color,xsize=20,ysize=15,xoffset=0.4,yoffset=10,$
               SET_FONT='Helvetica',/TT_FONT,/encapsulated
   
               micron = '!9' + String("155B) + '!X'
               lambda=  '!9' + String("154B) + '!X' 
               plot,sed.wavelength,sed_flux,xrange=[0.1,100],$
                     /xlog,xstyle=1,/ylog,yrange=[min(abs(obs_flux))*1e-1,max(sed_flux)*10],charsize=1.6,$
                     xtitle='Wavelength (' + micron + 'm)',ytitle=lambda+'F!D'+lambda+'!X',$
                     title=sourcename+' '+strcompress(modeltab[ind].model_name,/remove),$
                     thick=3,xthick=3,ythick=3,font=1
               
               oplot,v,obs_flux,psym=6
               oploterror,v,obs_flux,obs_fluxerr,psym=3
            endif
            
            if keyword_set(PS) then device,/close    
            
	      endif
	   endif
     ;endif  
	endfor
   
   
   
   iid=where(flag eq 1, COMPLEMENT=inx, count)
   if count ge 1 then begin
      newtab1=table[iid]
      
      for i=0,n_elements(iid)-1 do begin
         print,table[iid[i]].source_name,"Selected: MIPS flux is larger than stellar SED."
      endfor
   
      k=0
      for i=0,n_elements(newtab1.source_name)-1 do begin
         ind=where(modeltab[*].source_id eq newtab1[i].soure_id, count)
         if count ne 0 then begin 
          
            if k eq 0 then begin
               newtab2=modeltab[ind]
               k=1      
            endif else begin
               newtab2=[newtab2,modeltab[ind]]
            endelse
         endif    
      end
      if file_test(newfits) then spawn,'rm -rf '+newfits
      mwrfits,newtab1, newfits,mhd,/Silent
      mwrfits,newtab2,newfits,/Silent
     if keyword_set(PS) then begin
        device,/close
        set_plot,'x'
        spawn,'epsmerge -o '+conf.pspath+psfile+' -cs 0 -par 1 -p A4 -x 1 -y 1 --postscript /tmp/*.eps'
        spawn,'rm -rf /tmp/*.eps'
     endif
      
   endif else begin
   
      print,"No MIPS excess detected."
   
     if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
     endif
   
   endelse
   
       
  
   resetplt,/all
	
	
END

















