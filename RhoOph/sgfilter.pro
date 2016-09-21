
PRO RUNSGSEX, FITS=fits, WEIGHT=weight, ASSOC=assoc, SGSOCCAT=sgsoccat
  COMMON share,conf
  loadconfig
  
  if (n_elements(fits) ne 3) then begin
      print, 'FITS keyword is not given properly.'
      return
  endif
  
  filter=['j','h','k']
  
  for i=0,n_elements(fits)-1 do begin
      file=conf.wircampath+fits[i]
      checkname='soc_check_'+filter[i]+'.fits'
      spawn,'sex -c '+conf.confpath+'sex.conf '+file+' -CHECKIMAGE_NAME '$
        +conf.fitspath+checkname+' -CATALOG_NAME '+conf.catpath+sgsoccat[i]$
        +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
        +' -WEIGHT_IMAGE '+conf.wircampath+weight[i]$
        +' -WEIGHT_TYPE MAP_WEIGHT '$
        +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
        +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
        +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+assoc[0]$
        +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
        +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
        +' -ANALYSIS_THRESH 3 -NTHREADS 4'
      
  endfor
  
  
 END

PRO RUNSGSEX_L1689
  COMMON share,conf
  loadconfig
  
  ; Based on the star list, do photometry on these star first
;  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1689_remap_J.fits -CHECKIMAGE_NAME '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1689_J_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'soc_check_j.fits -CATALOG_NAME '+conf.catpath+'L1689_sgfilter_soc_j.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    ;+' -WEIGHT_IMAGE '+conf.wircampath+'L1689_remap_J.weight.fits'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1689_J_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1689_sgfilter_J.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

;  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1689_remap_H.fits -CHECKIMAGE_NAME '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1689_H_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'soc_check_h.fits -CATALOG_NAME '+conf.catpath+'L1689_sgfilter_soc_h.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
;    +' -WEIGHT_IMAGE '+conf.wircampath+'L1689_remap_H.weight.fits'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1689_H_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1689_sgfilter_H.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

;  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1689_remap_Ks.fits -CHECKIMAGE_NAME '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1689_Ks_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'soc_check_k.fits -CATALOG_NAME '+conf.catpath+'L1689_sgfilter_soc_k.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
;    +' -WEIGHT_IMAGE '+conf.wircampath+'L1689_remap_Ks.weight.fits'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1689_Ks_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1689_sgfilter_K.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

END

PRO RUNSGSEX_L1688
  COMMON share,conf
  loadconfig
  
  ; Based on the star list, do photometry on these star first
  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1688_J_coadd.fits -CHECKIMAGE_NAME '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1688_J_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'soc_check_j.fits -CATALOG_NAME '+conf.catpath+'L1688_sgfilter_soc_j.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    ;+' -WEIGHT_IMAGE '+conf.wircampath+'L1688_J_coadd.weight.fits'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1688_J_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1688_sgfilter_J.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1688_H_coadd.fits -CHECKIMAGE_NAME '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1688_H_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'soc_check_h.fits -CATALOG_NAME '+conf.catpath+'L1688_sgfilter_soc_h.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    ;+' -WEIGHT_IMAGE '+conf.wircampath+'L1688_H_coadd.weight.fits'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1688_H_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1688_sgfilter_H.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1688_Ks_coadd.fits -CHECKIMAGE_NAME '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1688_Ks_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'soc_check_k.fits -CATALOG_NAME '+conf.catpath+'L1688_sgfilter_soc_k.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    ;+' -WEIGHT_IMAGE '+conf.wircampath+'L1688_Ks_coadd.weight.fits'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1688_Ks_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1688_sgfilter_K.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

END

PRO RUNSGSEX_L1709
  COMMON share,conf
  loadconfig
  
  ; Based on the star list, do photometry on these star first
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1709_J_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'soc_check_j.fits -CATALOG_NAME '+conf.catpath+'L1709_sgfilter_soc_j.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1709_J_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1709_sgfilter_J.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST -ASSOC_RADIUS 2.0'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1709_H_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'soc_check_h.fits -CATALOG_NAME '+conf.catpath+'L1709_sgfilter_soc_h.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1709_H_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1709_sgfilter_H.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST -ASSOC_RADIUS 2.0'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1709_Ks_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'soc_check_k.fits -CATALOG_NAME '+conf.catpath+'L1709_sgfilter_soc_k.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1709_Ks_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1709_sgfilter_K.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST -ASSOC_RADIUS 2.0'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

END

PRO RUNSGSEX_L1712
  COMMON share,conf
  loadconfig
  
  ; Based on the star list, do photometry on these star first
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_J_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'soc_check_j.fits -CATALOG_NAME '+conf.catpath+'L1712_sgfilter_soc_j.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1712_J_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1712_sgfilter_J.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST -ASSOC_RADIUS 2.0'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_H_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'soc_check_h.fits -CATALOG_NAME '+conf.catpath+'L1712_sgfilter_soc_h.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1712_H_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1712_sgfilter_H.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST -ASSOC_RADIUS 2.0'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_Ks_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'soc_check_k.fits -CATALOG_NAME '+conf.catpath+'L1712_sgfilter_soc_k.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1712_Ks_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1712_sgfilter_K.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST -ASSOC_RADIUS 2.0'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

END

PRO RUNSGSEX_RHO_OPH
  COMMON share,conf
  loadconfig
  
  ; Based on the star list, do photometry on these star first
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'rho_oph_J_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'soc_check_j.fits -CATALOG_NAME '+conf.catpath+'rho_oph_sgfilter_soc_j.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'rho_oph_J_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'rho_oph_sgfilter_J.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST -ASSOC_RADIUS 2.0'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'rho_oph_H_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'soc_check_h.fits -CATALOG_NAME '+conf.catpath+'rho_oph_sgfilter_soc_h.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'rho_oph_H_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'rho_oph_sgfilter_H.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST -ASSOC_RADIUS 2.0'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'rho_oph_Ks_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'soc_check_k.fits -CATALOG_NAME '+conf.catpath+'rho_oph_sgfilter_soc_k.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'rho_oph_Ks_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'rho_oph_sgfilter_K.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST -ASSOC_RADIUS 2.0'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

END




PRO SGASSOC, targetfits=targetfits, assoc=assoc, FLUXUPLIM=fluxuplim, FILE=file
   COMMON share,conf
   loadconfig

   if n_elements(fluxuplim) eq 0 then fluxuplim=[99999.0,99999.0,99999.0]

   table=mrdfits(conf.fitspath+file,1)

   ra=table[*].x
   dec=table[*].y
   flux=table[*].flux
   
   id=indgen(n_elements(ra))+1
   hdr=headfits(targetfits)
   adxy,hdr,ra,dec,x,y
   
   

   socfile=conf.catpath+assoc[0]
   openw,fileunit, socfile, /get_lun
   
   jind=where(flux[0,*] le fluxuplim[0], count)
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[jind[i]]),/remove_all)+' '+$
                    strcompress(string(x[jind[i]]),/remove_all)+' '+$
                    strcompress(string(y[jind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit


   socfile=conf.catpath+assoc[1]
   openw,fileunit, socfile, /get_lun
   
   hind=where(flux[1,*] le fluxuplim[1], count)
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[hind[i]]),/remove_all)+' '+$
                    strcompress(string(x[hind[i]]),/remove_all)+' '+$
                    strcompress(string(y[hind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit

   socfile=conf.catpath+assoc[2]
   openw,fileunit, socfile, /get_lun
   
   kind=where(flux[2,*] le fluxuplim[2], count)
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[kind[i]]),/remove_all)+' '+$
                    strcompress(string(x[kind[i]]),/remove_all)+' '+$
                    strcompress(string(y[kind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit

   
END



; This subroutine generates the histogram plot of SG class
PRO SGCLASSPLOT, SGASSOC=sgassoc,title=title, file=file, PS=ps
   COMMON share,conf
   loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+file,$
         /color,xsize=26,ysize=10,$
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
   
   bmin=-0.1
   bmax=1.0
   bbin=0.02
   
   readcol,conf.catpath+sgassoc[0],nj,xj,yj,sfj,ferrj,mj,merrj,aj,bj,tj,ej,fwhmj,flagj,classj,vj,nj,/silent
   readcol,conf.catpath+sgassoc[1],nh,xh,yh,sfh,ferrh,mh,merrh,ah,bh,th,eh,fwhmh,flagh,classh,vh,nh,/silent
   readcol,conf.catpath+sgassoc[2],nk,xk,yk,sfk,ferrk,mk,merrk,ak,bk,tk,ek,fwhmk,flagk,classk,vk,nk,/silent
   
   
   multiplot,/default
   !p.font=1
   !p.charsize=1.3
   erase & multiplot, [3,1], xgap=0.02, mXtitle='SG Class', mYtitle='Number Counts',$
   mxTitSize=1.5, myTitSize=1.5,mxTitOffset=0.6,mTitle=title,/square

   jhisto=histogram(classj,bin=bbin,min=bmin,max=nmax)
   jx=getseries(bmin,bmax,bbin)+bbin*0.5

   hhisto=histogram(classh,bin=bbin,min=bmin,max=nmax)
   hx=getseries(bmin,bmax,bbin)+bbin*0.5

   khisto=histogram(classk,bin=bbin,min=bmin,max=nmax)
   kx=getseries(bmin,bmax,bbin)+bbin*0.5
   
   ymax=max([jhisto,hhisto,khisto])
   
   plot,jx,jhisto,yrange=[0,ymax],psym=10,font=1,thick=5,$
      xthick=4,ythick=4,xstyle=1 & multiplot
   plot,hx,hhisto,yrange=[0,ymax],psym=10,font=1,thick=5,$
      xthick=4,ythick=4,xstyle=1 & multiplot
   plot,kx,khisto,yrange=[0,ymax],psym=10,font=1,thick=5,$
      xthick=4,ythick=4,xstyle=1 & multiplot

   if keyword_set(PS) then begin
   
     device,/close
     set_plot,'x'
   endif

   multiplot,/default


END


PRO SGCLASSREGION, file=file, threshold=threshold, reg=regfile, color=color

   COMMON share,conf 
   loadconfig
   
   readcol,file,nj,xj,yj,sfj,ferrj,mj,merrj,aj,bj,tj,ej,fwhmj,flagj,classj,vj,nj,/silent

   ind=where(classj gt threshold, COMPLEMENT=inx, count)
   
   openw,fileunit, conf.regpath+regfile, /get_lun   
   for i=0, n_elements(inx)-1 do begin
      regstring = 'box('+$
                    strcompress(string(xj[inx[i]],format='(F11.3)'),/remove_all)+','+$
                    strcompress(string(yj[inx[i]],format='(F11.3)'),/remove_all)+',50,50,0) #color = '+$
                    color+' text={'+'} width = 2'
      printf, fileunit, format='(A)', regstring
      
   endfor
   
   close, fileunit
   free_lun,fileunit
 END


PRO REMOVETARGET, FITS=fits, CATALOG=catalog, SGTHRES=sgthres, NEWFITS=newfits, REGION=region
   COMMON share,conf
   loadconfig
   
   ; Read information in SED produced FITS files
   tab1=mrdfits(fits,1,mhd,/Silent)
   tab2=mrdfits(fits,2,/Silent)

   id=indgen(n_elements(tab1[*].x))+1
   flag=intarr(n_elements(tab1[*].x))
   
   ; Read catalog file with SG class parameter
   readcol,catalog[0],nj,xj,yj,sfj,ferrj,mj,merrj,aj,bj,tj,ej,fwhmj,flagj,classj,vj,nj,/silent
   readcol,catalog[1],nh,xh,yh,sfh,ferrh,mh,merrh,ah,bh,th,eh,fwhmh,flagh,classh,vh,nh,/silent
   readcol,catalog[2],nk,xk,yk,sfk,ferrk,mk,merrk,ak,bk,tk,ek,fwhmk,flagk,classk,vk,nk,/silent
   
   
   ; Pick up sources SG classes that are higher than threshold
    ind=where(classj gt sgthres[0],COMPLEMENT=inx, count)
    if count ge 1 then begin
       index=vj[inx]
       flag[index-1]=1+flag[index-1]
    endif else begin
       print,'No source found with J band threshold or this filter is not used.'
    endelse
    ind=where(classh gt sgthres[1],COMPLEMENT=inx, count)
    if count ge 1 then begin
       index=vh[inx]
       flag[index-1]=2+flag[index-1]
    endif else begin
       print,'No source found with H band threshold or this filter is not used.'
    endelse
    ind=where(classk gt sgthres[2],COMPLEMENT=inx, count)
    if count ge 1 then begin
       index=vk[inx]
       flag[index-1]=4+flag[index-1]
    endif else begin
       print,'No source found with Ks band threshold or this filter is not used.'
    endelse
   
    iid=where(flag eq 0, COMPLEMENT=inx, count)
    if count ge 1 then begin
       newtab1=tab1[iid]
    end
    for i=0,n_elements(inx)-1 do begin
      print,tab1[inx[i]].source_name,"Reject: SG flag is "+$
         strcompress(string(flag[inx[i]],format="(I1)"),/remove)+"."   
    endfor
    print,'1: J band, 2: H band, 4: Ks band'
   if keyword_set(region) then begin
      openw,fileunit, conf.regpath+region, /get_lun   
      for i=0, n_elements(inx)-1 do begin
         regstring = 'fk5;circle('+$
                     strcompress(string(tab1[inx[i]].x,format='(F12.7)'),/remove_all)+'d,'+$
                     strcompress(string(tab1[inx[i]].y,format='(F12.7)'),/remove_all)+'d,5") #color = red'+$
                     ' text={'+'} width = 2'
         printf, fileunit, format='(A)', regstring
         
      endfor
      
      close, fileunit
      free_lun,fileunit
      
   endif
   
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
   print,'Source lefted: ',n_elements(newtab1.soure_id)

END


PRO SGFILTER_C2DTEST_L1688
   COMMON share,conf
   loadconfig

   sgassoc,targetfits=conf.wircampath+'L1688_Ks_coadd.fits',$
       file='yso_c2d_nowircam.fits',assoc=['c2d_yso_sgfilter_soc_j.cat',$
       'c2d_yso_sgfilter_soc_h.cat','c2d_yso_sgfilter_soc_k.cat'],$
       fluxuplim=[10.1,6.46,4.21]
       
   runsgsex,fits=['L1688_J_coadd.fits','L1688_H_coadd.fits','L1688_Ks_coadd.fits'], $
       weight=['L1688_J_coadd.weight.fits','L1688_H_coadd.weight.fits','L1688_Ks_coadd.weight.fits'], $
       assoc=['c2d_yso_sgfilter_soc_j.cat','c2d_yso_sgfilter_soc_h.cat','c2d_yso_sgfilter_soc_k.cat'], $
       sgsoccat=['sgfilter_soc_j.cat','sgfilter_soc_h.cat','sgfilter_soc_k.cat']
   
   sgclassplot,sgassoc=['sgfilter_soc_j.cat','sgfilter_soc_h.cat','sgfilter_soc_k.cat'],$
       title='Target Sources',file='sgclassplot_reg2.eps',/ps
   
   sgclassregion,file=conf.catpath+'sgfilter_soc_k.cat',threshold=0.02,reg='sg_galaxy_k.reg',color='yellow'
   sgclassregion,file=conf.catpath+'sgfilter_soc_h.cat',threshold=0.02,reg='sg_galaxy_h.reg',color='white'
   sgclassregion,file=conf.catpath+'sgfilter_soc_j.cat',threshold=0.02,reg='sg_galaxy_j.reg',color='red'
   
   removetarget, fits=conf.fitspath+'yso_c2d_nowircam.fits',catalog=conf.catpath+['sgfilter_soc_j.cat',$
      'sgfilter_soc_h.cat','sgfilter_soc_k.cat'],$
      sgthres=[0.02,0.02,0.02],newfits=conf.fitspath+'yso_c2d_nowircam_sgfilter.fits',$
       region='no_wircam_sgregion.reg'


END


PRO SGFILTER_RG2YSO
   COMMON share,conf
   loadconfig

   sgassoc,file='c2d_cat_yso_good.fits',fluxuplim=[90.0,90.0,90.0]
   runsgsex
   sgclassplot,title='c2D YSO Sources',file='sgclassplot_c2dyso.eps',/ps
END



PRO SGFILTER, FITS=fits, newfits=newfits, RUNSEX=runsex, NOREG=noreg
   COMMON share,conf
   loadconfig

   if keyword_set(RUNSEX) then begin
      sgassoc,file=fits,fluxuplim=[10.1,6.46,4.21]
      runsgsex
   endif
   
   sgclassplot,title='Target Sources',file='sgclassplot_reg2.eps',/ps
   
   if keyword_set(NOREG) then begin
      removetarget, fits=conf.fitspath+'yso_reg2_good.fits',catalog=conf.catpath+['sgfilter_soc_j.cat',$
      'sgfilter_soc_h.cat','sgfilter_soc_k.cat'],$
      sgthres=[0.03,0.03,0.03],newfits=conf.fitspath+newfits, region='sgregion.reg' 
   endif else begin
     removetarget, fits=conf.fitspath+'yso_reg2_good.fits',catalog=conf.catpath+['sgfilter_soc_j.cat',$
      'sgfilter_soc_h.cat','sgfilter_soc_k.cat'],$
      sgthres=[0.03,0.03,0.03],newfits=conf.fitspath+newfits, region='sgregion.reg' 
      sgclassregion,file=conf.catpath+'sgfilter_soc_k.cat',threshold=0.02,reg='sg_galaxy_k.reg',color='yellow'
      sgclassregion,file=conf.catpath+'sgfilter_soc_h.cat',threshold=0.02,reg='sg_galaxy_h.reg',color='white'
      sgclassregion,file=conf.catpath+'sgfilter_soc_j.cat',threshold=0.02,reg='sg_galaxy_j.reg',color='red'
   endelse
   
END



PRO SGFILTER_L1689, FITS=fits, newfits=newfits, RUNSEX=runsex, NOREG=noreg
   COMMON share,conf
   loadconfig

   if keyword_set(RUNSEX) then begin
      ;sgassoc_l1689,file=fits,fluxuplim=[10.1,6.46,4.21]
	  sgassoc,targetfits=conf.wircampath+'L1689_Ks_new.fits',$
	     file=fits,assoc=['L1689_sgfilter_J.assoc','L1689_sgfilter_H.assoc',$
         'L1689_sgfilter_K.assoc'],fluxuplim=[10.1,6.46,4.21]
         
      runsgsex_l1689
   endif
   
   sgclassplot,sgassoc=['sgfilter_soc_j.cat','sgfilter_soc_h.cat','sgfilter_soc_k.cat'],$
       title='Target Sources',file='sgclassplot_L1689.eps',/ps
    
   if keyword_set(NOREG) then begin
      removetarget, fits=conf.fitspath+fits,catalog=conf.catpath+['L1689_sgfilter_soc_j.cat',$
      'L1689_sgfilter_soc_h.cat','L1689_sgfilter_soc_k.cat'],$
      sgthres=[0.029,0.029,0.029],newfits=conf.fitspath+newfits, region='sgregion.reg' 
   endif else begin
      removetarget, fits=conf.fitspath+fits,catalog=conf.catpath+['L1689_sgfilter_soc_j.cat',$
      'L1689_sgfilter_soc_h.cat','L1689_sgfilter_soc_k.cat'],$
      sgthres=[0.029,0.029,0.029],newfits=conf.fitspath+newfits, region='sgregion.reg' 
      sgclassregion,file=conf.catpath+'L1689_sgfilter_soc_k.cat',threshold=0.02,reg='L1689_sg_galaxy_k.reg',color='yellow'
      sgclassregion,file=conf.catpath+'L1689_sgfilter_soc_h.cat',threshold=0.02,reg='L1689_sg_galaxy_h.reg',color='white'
      sgclassregion,file=conf.catpath+'L1689_sgfilter_soc_j.cat',threshold=0.02,reg='L1689_sg_galaxy_j.reg',color='red'
   endelse
   
END



PRO SGFILTER_L1688, FITS=fits, newfits=newfits, RUNSEX=runsex, NOREG=noreg
   COMMON share,conf
   loadconfig

   if keyword_set(RUNSEX) then begin
       sgassoc,targetfits=conf.wircampath+'L1688_Ks_new.fits',$
       file=fits,assoc=['L1688_sgfilter_J.assoc',$
       'L1688_sgfilter_H.assoc','L1688_sgfilter_K.assoc'],$
       fluxuplim=[10.1,6.46,4.21]
      
      
       runsgsex_l1688
   endif
   
    sgclassplot,sgassoc=['sgfilter_soc_j.cat','sgfilter_soc_h.cat','sgfilter_soc_k.cat'],$
       title='Target Sources',file='sgclassplot_L1688.eps',/ps
       
   ; Note: the threshold is minimum, source with SG class smaller than this value will be ejected.
   ;  To ingnore a certain filter, set threshold to 9.9
   if keyword_set(NOREG) then begin
      removetarget, fits=conf.fitspath+fits,catalog=conf.catpath+['L1688_sgfilter_soc_j.cat',$
      'L1688_sgfilter_soc_h.cat','L1688_sgfilter_soc_k.cat'],$
      sgthres=[9.9,9.0,0.029],newfits=conf.fitspath+newfits, region='sgregion.reg' 
   endif else begin
      removetarget, fits=conf.fitspath+fits,catalog=conf.catpath+['L1688_sgfilter_soc_j.cat',$
      'L1688_sgfilter_soc_h.cat','L1688_sgfilter_soc_k.cat'],$
      sgthres=[9.0,9.0,0.029],newfits=conf.fitspath+newfits, region='sgregion.reg' 
      sgclassregion,file=conf.catpath+'L1688_sgfilter_soc_k.cat',threshold=0.029,reg='L1688_sg_galaxy_k.reg',color='yellow'
      ;sgclassregion,file=conf.catpath+'L1688_sgfilter_soc_h.cat',threshold=0.02,reg='L1688_sg_galaxy_h.reg',color='white'
      ;sgclassregion,file=conf.catpath+'L1688_sgfilter_soc_j.cat',threshold=0.02,reg='L1688_sg_galaxy_j.reg',color='red'
   endelse
   
END


PRO SGFILTER_L1709, FITS=fits, newfits=newfits, RUNSEX=runsex, NOREG=noreg
   COMMON share,conf
   loadconfig

   if keyword_set(RUNSEX) then begin
       sgassoc,targetfits=conf.wircampath+'L1709_Ks_new.fits',$
       file=fits,assoc=['L1709_sgfilter_J.assoc',$
       'L1709_sgfilter_H.assoc','L1709_sgfilter_K.assoc'],$
       fluxuplim=[10.1,6.46,4.21]
      
      
       runsgsex_l1709
   endif
   
    sgclassplot,sgassoc=['sgfilter_soc_j.cat','sgfilter_soc_h.cat','sgfilter_soc_k.cat'],$
       title='Target Sources',file='sgclassplot_L1688.eps',/ps
   
   if keyword_set(NOREG) then begin
      removetarget, fits=conf.fitspath+fits,catalog=conf.catpath+['L1709_sgfilter_soc_j.cat',$
      'L1709_sgfilter_soc_h.cat','L1709_sgfilter_soc_k.cat'],$
      sgthres=[0.80,0.11,0.029],newfits=conf.fitspath+newfits, region='sgregion.reg' 
   endif else begin
      removetarget, fits=conf.fitspath+fits,catalog=conf.catpath+['L1709_sgfilter_soc_j.cat',$
      'L1709_sgfilter_soc_h.cat','L1709_sgfilter_soc_k.cat'],$
      sgthres=[0.80,0.11,0.029],newfits=conf.fitspath+newfits, region='sgregion.reg' 
      sgclassregion,file=conf.catpath+'L1709_sgfilter_soc_k.cat',threshold=0.029,reg='L1709_sg_galaxy_k.reg',color='yellow'
      sgclassregion,file=conf.catpath+'L1709_sgfilter_soc_h.cat',threshold=0.029,reg='L1709_sg_galaxy_h.reg',color='white'
      sgclassregion,file=conf.catpath+'L1709_sgfilter_soc_j.cat',threshold=0.029,reg='L1709_sg_galaxy_j.reg',color='red'
   endelse
   
END


PRO SGFILTER_L1712, FITS=fits, newfits=newfits, RUNSEX=runsex, NOREG=noreg
   COMMON share,conf
   loadconfig

   if keyword_set(RUNSEX) then begin
       sgassoc,targetfits=conf.wircampath+'L1712_Ks_new.fits',$
       file=fits,assoc=['L1712_sgfilter_J.assoc',$
       'L1712_sgfilter_H.assoc','L1712_sgfilter_K.assoc'],$
       fluxuplim=[10.1,6.46,4.21]
      
      
       runsgsex_l1712
   endif
   
    sgclassplot,sgassoc=['sgfilter_soc_j.cat','sgfilter_soc_h.cat','sgfilter_soc_k.cat'],$
       title='Target Sources',file='sgclassplot_L1712.eps',/ps
   
   if keyword_set(NOREG) then begin
      removetarget, fits=conf.fitspath+fits,catalog=conf.catpath+['L1712_sgfilter_soc_j.cat',$
      'L1712_sgfilter_soc_h.cat','L1712_sgfilter_soc_k.cat'],$
      sgthres=[0.029,0.029,0.029],newfits=conf.fitspath+newfits, region='sgregion.reg' 
   endif else begin
      removetarget, fits=conf.fitspath+fits,catalog=conf.catpath+['L1712_sgfilter_soc_j.cat',$
      'L1712_sgfilter_soc_h.cat','L1712_sgfilter_soc_k.cat'],$
      sgthres=[0.029,0.029,0.029],newfits=conf.fitspath+newfits, region='sgregion.reg' 
      sgclassregion,file=conf.catpath+'L1712_sgfilter_soc_k.cat',threshold=0.029,reg='L1712_sg_galaxy_k.reg',color='yellow'
      sgclassregion,file=conf.catpath+'L1712_sgfilter_soc_h.cat',threshold=0.029,reg='L1712_sg_galaxy_h.reg',color='white'
      sgclassregion,file=conf.catpath+'L1712_sgfilter_soc_j.cat',threshold=0.029,reg='L1712_sg_galaxy_j.reg',color='red'
   endelse
   
END


PRO SGFILTER_RHO_OPH, FITS=fits, newfits=newfits, RUNSEX=runsex, NOREG=noreg
   COMMON share,conf
   loadconfig

   if keyword_set(RUNSEX) then begin
       sgassoc,targetfits=conf.wircampath+'rho_oph_Ks_new.fits',$
       file=fits,assoc=['rho_oph_sgfilter_J.assoc',$
       'rho_oph_sgfilter_H.assoc','rho_oph_sgfilter_K.assoc'],$
       fluxuplim=[10.1,6.46,4.21]
      
      
       runsgsex_rho_oph
   endif
   
    sgclassplot,sgassoc=['sgfilter_soc_j.cat','sgfilter_soc_h.cat','sgfilter_soc_k.cat'],$
       title='Target Sources',file='sgclassplot_L1712.eps',/ps
   
   if keyword_set(NOREG) then begin
      removetarget, fits=conf.fitspath+fits,catalog=conf.catpath+['rho_oph_sgfilter_soc_j.cat',$
      'rho_oph_sgfilter_soc_h.cat','rho_oph_sgfilter_soc_k.cat'],$
      sgthres=[0.049,0.079,0.729],newfits=conf.fitspath+newfits, region='sgregion.reg' 
   endif else begin
      removetarget, fits=conf.fitspath+fits,catalog=conf.catpath+['rho_oph_sgfilter_soc_j.cat',$
      'rho_oph_sgfilter_soc_h.cat','rho_oph_sgfilter_soc_k.cat'],$
      sgthres=[0.049,0.079,0.729],newfits=conf.fitspath+newfits, region='sgregion.reg' 
      sgclassregion,file=conf.catpath+'rho_oph_sgfilter_soc_k.cat',threshold=0.049,reg='rho_oph_sg_galaxy_k.reg',color='yellow'
      sgclassregion,file=conf.catpath+'rho_oph_sgfilter_soc_h.cat',threshold=0.079,reg='rho_oph_sg_galaxy_h.reg',color='white'
      sgclassregion,file=conf.catpath+'rho_oph_sgfilter_soc_j.cat',threshold=0.729,reg='rho_oph_sg_galaxy_j.reg',color='red'
   endelse
   
END
