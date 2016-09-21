PRO RUNSEXTRACTOR
   COMMON share,conf 
   loadconfig
  
  cd,conf.wircampath
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'1633-2410_J_coadd.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'check_j.fits -CATALOG_NAME '+conf.catpath+'region2_j.cat -MAG_ZEROPOINT 25.00'$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
    +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '

  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'1633-2410_H_coadd.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'check_h.fits -CATALOG_NAME '+conf.catpath+'region2_h.cat -MAG_ZEROPOINT 25.00'$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
    +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '

  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'1633-2410_Ks_coadd.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'check_k.fits -CATALOG_NAME '+conf.catpath+'region2_k.cat -MAG_ZEROPOINT 25.00'$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
    +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '
   
  cd,'/home/chyan/idl_script/Projects/RhoOph/'
END

PRO RUNSEXTRACTOR_REG2
   COMMON share,conf 
   loadconfig
  
  cd,conf.wircampath
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'1633-2410_J_coadd.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'check_j.fits -CATALOG_NAME '+conf.catpath+'region2_j.cat -MAG_ZEROPOINT 25.00'$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
    +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '

  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'1633-2410_H_coadd.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'check_h.fits -CATALOG_NAME '+conf.catpath+'region2_h.cat -MAG_ZEROPOINT 25.00'$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
    +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '

  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'1633-2410_Ks_coadd.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'check_k.fits -CATALOG_NAME '+conf.catpath+'region2_k.cat -MAG_ZEROPOINT 25.00'$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
    +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '
   
  cd,'~chyan/idl_script/Projects/RhoOph/'
END


PRO RUNSEXTRACTOR_L1689
   COMMON share,conf 
   loadconfig
  
  cd,conf.wircampath
  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1689_remap_J.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'check_j.fits -CATALOG_NAME '+conf.catpath+'L1689_j.cat -MAG_ZEROPOINT 25.00'$
  
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1689_J_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'check_j.fits -CATALOG_NAME '+conf.catpath+'L1689_J_new.cat -MAG_ZEROPOINT 25.00'$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 3.0 '$
    +' -DETECT_THRESH 3.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1689_remap_H.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'check_h.fits -CATALOG_NAME '+conf.catpath+'L1689_h.cat -MAG_ZEROPOINT 25.00'$
  
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1689_H_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'check_h.fits -CATALOG_NAME '+conf.catpath+'L1689_H_new.cat -MAG_ZEROPOINT 25.00'$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 3.0 '$
    +' -DETECT_THRESH 3.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1689_remap_Ks.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'check_k.fits -CATALOG_NAME '+conf.catpath+'L1689_k.cat -MAG_ZEROPOINT 25.00'$

  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1689_Ks_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'check_k.fits -CATALOG_NAME '+conf.catpath+'L1689_Ks_new.cat -MAG_ZEROPOINT 25.00'$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 3.0 '$
    +' -DETECT_THRESH 3.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '
   
  cd,'~chyan/IDLSourceCode/Science/RhoOph/'
END

PRO RUNSEXTRACTOR_L1688
   COMMON share,conf 
   loadconfig
  
  cd,conf.wircampath
  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1688_J_coadd.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1688_J_check.fits -CATALOG_NAME '+conf.catpath+'L1688_j.cat -MAG_ZEROPOINT 25.00'$
  
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1688_J_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1688_J_check.fits -CATALOG_NAME '+conf.catpath+'L1688_J_new.cat -MAG_ZEROPOINT 25.00'$  
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
    +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1688_H_coadd.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1688_H_check.fits -CATALOG_NAME '+conf.catpath+'L1688_h.cat -MAG_ZEROPOINT 25.00'$
 
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1688_H_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1688_H_check.fits -CATALOG_NAME '+conf.catpath+'L1688_H_new.cat -MAG_ZEROPOINT 25.00'$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
    +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1688_Ks_coadd.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1688_Ks_check.fits -CATALOG_NAME '+conf.catpath+'L1688_k.cat -MAG_ZEROPOINT 25.00'$

  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1688_Ks_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1688_Ks_check.fits -CATALOG_NAME '+conf.catpath+'L1688_Ks_new.cat -MAG_ZEROPOINT 25.00'$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
    +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '
   
  cd,'~chyan/IDLSourceCode/Science/RhoOph/'
END


PRO RUNSEXTRACTOR_L1709
   COMMON share,conf 
   loadconfig
  
  cd,conf.wircampath
  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1709_remap_J.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1709_J_check.fits -CATALOG_NAME '+conf.catpath+'L1709_j.cat -MAG_ZEROPOINT 25.00'$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1709_J_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1709_J_check.fits -CATALOG_NAME '+conf.catpath+'L1709_J_new.cat -MAG_ZEROPOINT 25.00'$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 5.0 '$
    +' -DETECT_THRESH 5.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 -NTHREADS 4'

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1709_remap_H.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1709_H_check.fits -CATALOG_NAME '+conf.catpath+'L1709_h.cat -MAG_ZEROPOINT 25.00'$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1709_H_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1709_H_check.fits -CATALOG_NAME '+conf.catpath+'L1709_H_new.cat -MAG_ZEROPOINT 25.00'$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 5.0 '$
    +' -DETECT_THRESH 5.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 -NTHREADS 4'

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1709_remap_Ks.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1709_Ks_check.fits -CATALOG_NAME '+conf.catpath+'L1709_k.cat -MAG_ZEROPOINT 25.00'$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1709_Ks_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1709_Ks_check.fits -CATALOG_NAME '+conf.catpath+'L1709_Ks_new.cat -MAG_ZEROPOINT 25.00'$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 5.0 '$
    +' -DETECT_THRESH 5.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 -NTHREADS 4'
   
  cd,'~chyan/IDLSourceCode/Science/RhoOph/'
END

PRO RUNSEXTRACTOR_L1712
   COMMON share,conf 
   loadconfig
  
  cd,conf.wircampath
  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_remap_J.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1712_J_check.fits -CATALOG_NAME '+conf.catpath+'L1712_j.cat -MAG_ZEROPOINT 25.00'$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_J_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1712_J_check.fits -CATALOG_NAME '+conf.catpath+'L1712_J_new.cat -MAG_ZEROPOINT 25.00'$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 5.0 '$
    +' -DETECT_THRESH 5.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 -NTHREADS 4'

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_remap_H.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1712_H_check.fits -CATALOG_NAME '+conf.catpath+'L1712_h.cat -MAG_ZEROPOINT 25.00'$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_H_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1712_H_check.fits -CATALOG_NAME '+conf.catpath+'L1712_H_new.cat -MAG_ZEROPOINT 25.00'$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 5.0 '$
    +' -DETECT_THRESH 5.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 -NTHREADS 4'

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_remap_Ks.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1712_Ks_check.fits -CATALOG_NAME '+conf.catpath+'L1712_k.cat -MAG_ZEROPOINT 25.00'$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_Ks_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1712_Ks_check.fits -CATALOG_NAME '+conf.catpath+'L1712_Ks_new.cat -MAG_ZEROPOINT 25.00'$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 5.0 '$
    +' -DETECT_THRESH 5.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 -NTHREADS 4'
   
  cd,'~chyan/IDLSourceCode/Science/RhoOph/'
END


PRO RUNSEXTRACTOR_RHO_OPH
   COMMON share,conf 
   loadconfig
  
  cd,conf.wircampath
  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_remap_J.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1712_J_check.fits -CATALOG_NAME '+conf.catpath+'L1712_j.cat -MAG_ZEROPOINT 25.00'$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'rho_oph_J_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'rho_oph_J_check.fits -CATALOG_NAME '+conf.catpath+'rho_oph_J_new.cat -MAG_ZEROPOINT 25.00'$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 5.0 '$
    +' -DETECT_THRESH 5.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 -NTHREADS 4'

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_remap_H.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1712_H_check.fits -CATALOG_NAME '+conf.catpath+'L1712_h.cat -MAG_ZEROPOINT 25.00'$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'rho_oph_H_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'rho_oph_H_check.fits -CATALOG_NAME '+conf.catpath+'rho_oph_H_new.cat -MAG_ZEROPOINT 25.00'$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 5.0 '$
    +' -DETECT_THRESH 5.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 -NTHREADS 4'

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_remap_Ks.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1712_Ks_check.fits -CATALOG_NAME '+conf.catpath+'L1712_k.cat -MAG_ZEROPOINT 25.00'$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'rho_oph_Ks_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'rho_oph_Ks_check.fits -CATALOG_NAME '+conf.catpath+'rho_oph_Ks_new.cat -MAG_ZEROPOINT 25.00'$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 5.0 '$
    +' -DETECT_THRESH 5.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 -NTHREADS 4'
   
  cd,'~chyan/IDLSourceCode/Science/RhoOph/'
END


PRO GETSTAR, catalog, ZERO=zero
	COMMON share,conf	
	loadconfig
	
	;runsextractor
		
	readcol,conf.catpath+'region2_j.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	index=where(flag eq 0 and class ge 0.80)
	j={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-zero[0],$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
	
	readcol,conf.catpath+'region2_h.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	index=where(flag eq 0 and class ge 0.80)
	;index=where(id ne 0)
	h={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-zero[1],$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
	
	readcol,conf.catpath+'region2_k.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	index=where(flag eq 0 and class ge 0.80)
	;index=where(id ne 0)
	k={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-zero[2],$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
	
	
	catalog={j:j,h:h,k:k}	
END

PRO GETSTAR_L1689, catalog, ZERO=zero
   COMMON share,conf 
   loadconfig
   
   ;runsextractor
      
   ;readcol,conf.catpath+'L1689_j.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   readcol,conf.catpath+'L1689_J_new.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   index=where(flag eq 0 and class ge 0.90)
   j={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-zero[0],$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   ;readcol,conf.catpath+'L1689_h.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   readcol,conf.catpath+'L1689_H_new.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent

   index=where(flag eq 0 and class ge 0.90)
   ;index=where(id ne 0)
   h={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-zero[1],$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   ;readcol,conf.catpath+'L1689_k.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   readcol,conf.catpath+'L1689_Ks_new.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   index=where(flag eq 0 and class ge 0.90)
   ;index=where(id ne 0)
   k={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-zero[2],$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   
   catalog={j:j,h:h,k:k}   
END

PRO GETSTAR_L1688, catalog, ZERO=zero
   COMMON share,conf 
   loadconfig
   
   ;runsextractor
      
   ;readcol,conf.catpath+'L1688_j.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   readcol,conf.catpath+'L1688_J_new.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   index=where(flag eq 0 and class ge 0.90)
   j={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-zero[0],$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   ;readcol,conf.catpath+'L1688_h.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   readcol,conf.catpath+'L1688_H_new.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   index=where(flag eq 0 and class ge 0.90)
   ;index=where(id ne 0)
   h={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-zero[1],$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   ;readcol,conf.catpath+'L1688_k.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   readcol,conf.catpath+'L1688_Ks_new.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   index=where(flag eq 0 and class ge 0.90)
   ;index=where(id ne 0)
   k={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-zero[2],$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   
   catalog={j:j,h:h,k:k}   
END

PRO GETSTAR_L1709, catalog, ZERO=zero
   COMMON share,conf 
   loadconfig
   
   ;runsextractor
      
   ;readcol,conf.catpath+'L1709_j.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   readcol,conf.catpath+'L1709_J_new.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   index=where(flag eq 0 and class ge 0.80)
   j={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-zero[0],$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   ;readcol,conf.catpath+'L1709_h.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   readcol,conf.catpath+'L1709_H_new.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   index=where(flag eq 0 and class ge 0.80)
   ;index=where(id ne 0)
   h={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-zero[1],$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   ;readcol,conf.catpath+'L1709_k.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   readcol,conf.catpath+'L1709_Ks_new.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   index=where(flag eq 0 and class ge 0.80)
   ;index=where(id ne 0)
   k={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-zero[2],$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   
   catalog={j:j,h:h,k:k}   
END


PRO GETSTAR_L1712, catalog, ZERO=zero
   COMMON share,conf 
   loadconfig
   
   ;runsextractor
      
   readcol,conf.catpath+'L1712_J_new.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   index=where(flag eq 0 and class ge 0.90)
   j={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-zero[0],$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   readcol,conf.catpath+'L1712_H_new.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   index=where(flag eq 0 and class ge 0.90)
   ;index=where(id ne 0)
   h={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-zero[1],$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   readcol,conf.catpath+'L1712_Ks_new.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   index=where(flag eq 0 and class ge 0.90)
   ;index=where(id ne 0)
   k={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-zero[2],$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   
   catalog={j:j,h:h,k:k}   
END

PRO GETSTAR_RHO_OPH, catalog, ZERO=zero
   COMMON share,conf 
   loadconfig
   
   ;runsextractor
      
   readcol,conf.catpath+'rho_oph_J_new.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   index=where(flag eq 0 and class ge 0.80)
   j={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-zero[0],$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   readcol,conf.catpath+'rho_oph_H_new.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   index=where(flag eq 0 and class ge 0.80)
   ;index=where(id ne 0)
   h={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-zero[1],$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   readcol,conf.catpath+'rho_oph_Ks_new.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   index=where(flag eq 0 and class ge 0.80)
   ;index=where(id ne 0)
   k={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-zero[2],$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   
   catalog={j:j,h:h,k:k}   
END


PRO GETREFSTAR, catalog
  COMMON share,setting  
  loadconfig
  
  ;runsextractor
    
  readcol,setting.fitspath+'j_ref.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
  
  ;index=where(flag eq 0 and class ge 0.85 and mag le 16.2)
  index=where(id ne 0)
  j={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.183400,$
    magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
    fwhm:fwhm[index],flag:flag[index],class:class[index]}
  
  readcol,setting.fitspath+'h_ref.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
  
  ;index=where(flag eq 0 and class ge 0.85 and mag  le 15.8)
  index=where(id ne 0)
  h={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.145599,$
    magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
    fwhm:fwhm[index],flag:flag[index],class:class[index]}
  
  readcol,setting.fitspath+'k_ref.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
  
  ;index=where(flag eq 0 and class ge 0.85 and mag le 15)
  index=where(id ne 0)
  k={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.187599,$
    magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
    fwhm:fwhm[index],flag:flag[index],class:class[index]}
  
  
  catalog={j:j,h:h,k:k} 
END

;
; This function takes two sets of catalogue and do a matching
;    to register star detected by any routine
;
PRO MATCH_CATALOG,x1,y1,mag1,merr1,x2,y2,mag2,merr2,match
  ; x1  : vector of X positions of field star (by FIND)
  ; y1  : vector of Y positions of field star(by FIND)
  ; mag1  : vector of Ks band magnitudes of field star (by APER)
  ; merr1  : vector of magnitudes error of star (by APER) 
  ; x2  : vector of X positions of catalog star (2MASS)
  ; y2  : vector of Y positions of catalog star (2MASS)
  ; mag2  : vector of Ks band magnitudes of catalog star
  ; match : structure that stores the matched catalog
  ; .x  :  vector of X positions of matched stars
  ; .y  :  vector of Y positions of matched stars
  ; .fmag1:  vector of instrumental magnitude
  ; .fmag2:  vector of magnitude of catalog stars (2MASS) 
  flag=intarr(n_elements(x2))
  flag[*]=0
  x=0
  y=0
  fmag1=0
  fmag2=0

  n=0
  for i=0L,n_elements(x1)-1 do begin
    dist=sqrt((x1[i]-x2)^2+(y1[i]-y2)^2)
   
    ind=where(dist eq min(dist) and min(dist) le 5,count)
    
    if (count ne 0) then begin
      if flag[ind] eq 0 then begin
        if n eq 0 then begin
          x=x1[i]
          y=y1[i]
          fmag1=mag1[i]
          fmag2=mag2[ind]
          magerr=merr1[i]
          magerr2=merr2[ind]
        endif else begin
          x=[x,x1[i]]
          y=[y,y1[i]]
          fmag1=[fmag1,mag1[i]]
          fmag2=[fmag2,mag2[ind]]
          magerr=[magerr,merr1[i]]
          magerr2=[magerr2,merr2[ind]]
        endelse       
        
        n=n+1
        flag[ind]=1 
      endif
    endif
  endfor
  
  match={id:findgen(n_elements(x)),x:x,y:y,fmag1:fmag1,fmag2:fmag2,$
    magerr1:magerr,magerr2:magerr2}
  
END



PRO MKCATALOG, cat, final
	COMMON share,setting	
	loadconfig
	
	; The first step is to register the catalog
	
	; Mininum distance in pixels
	d=3.0
	
	j=0
	; This is the flag for star registered.
	jflag=intarr(n_elements(cat.j.x))
	hflag=intarr(n_elements(cat.h.x))
	
	
	; Initialize the arrays
	xx=fltarr(n_elements(cat.h.x))
	yy=fltarr(n_elements(cat.h.x))
	mj=fltarr(n_elements(cat.h.x))
	mh=fltarr(n_elements(cat.h.x))
	mk=fltarr(n_elements(cat.h.x))
	mjerr=fltarr(n_elements(cat.h.x))
	mherr=fltarr(n_elements(cat.h.x))
	mkerr=fltarr(n_elements(cat.h.x))
	
	; Beginning of the loop
	for i=0,n_elements(cat.h.x)-1 do begin
		x=cat.k.x[i]
		y=cat.k.y[i]
		
		xx[i]=x
		yy[i]=y
		mk[i]=cat.k.mag[i]
		mkerr[i]=cat.k.magerr[i]

		; Looking for H band
		dist1=sqrt(((cat.h.x-x)^2)+((cat.h.y-y)^2))
		ind1=where(dist1 eq min(dist1) and (min(dist1) le d) and (hflag eq 0), count1)
		if (count1 ne 0) then begin
			mh[i]=cat.h.mag[ind1]
			mherr[i]=cat.h.magerr[ind1]
			hflag[ind1]=1
		endif else begin
			mh[i]=-999.0
			mherr[i]=-999.0
		endelse
		
		; Looking for J band
		dist2=sqrt(((cat.j.x-x)^2)+((cat.j.y-y)^2))
		ind2=where(dist2 eq min(dist2) and min(dist2) le 3 and (jflag eq 0), count2)
		if (count2 ne 0) then begin
			mj[i]=cat.j.mag[ind2]
			mjerr[i]=cat.j.magerr[ind2]
			jflag[ind2]=1
		endif else begin
			mj[i]=-999.0
			mjerr[i]=-999.0
		endelse
		
		
	endfor

  ;Group stars for HCN related and continuum related
  ; Selecting star within the HCN contour
  group=intarr(n_elements(xx))
  dist=sqrt(((xx-547)^2)+((yy-532)^2))
  i1=where(dist le 250)
	group[i1]=1
	
	; Selecting star within the continuum contour
  dist=sqrt(((xx-569)^2)+((yy-600)^2))
  i2=where(dist le 80)
  group[i2]=2
	
	
  ; Set the limiting magnitude of each filter
   mjlim=20.0
   mhlim=19.5
   mklim=19.0

   mjlim2=0
   mhlim2=0
   mklim2=0
   
  
   ;eliminate stars only detected in K band 
   ind=where((mk ge 17.5 and mj eq -999.0 and mh eq -999.0) or (mk ge mklim) $
   or (mh ge mhlim) or (mj ge mjlim) or (mj le mjlim2) or (mh le mhlim2) $
   or (mk le mklim2),complement=inx)
   id=indgen(n_elements(inx))
   
   final={id:id,x:xx[inx],y:yy[inx],mj:mj[inx],mh:mh[inx],mk:mk[inx],$
       mjerr:mjerr[inx],mherr:mherr[inx],mkerr:mkerr[inx]}
  
  ;Group stars for HCN related and continuum related
   
	final={x:xx[inx],y:yy[inx],mj:mj[inx],mh:mh[inx],mk:mk[inx],$
			mjerr:mjerr[inx],mherr:mherr[inx],mkerr:mkerr[inx],group:group[inx]}


END



PRO FIND2MASS, ref
   COMMON share,conf
   loadconfig
   
   hdr=headfits(conf.wircampath+'1633-2410_H_coadd.fits')
   xsize=sxpar(hdr,'NAXIS1')
   ysize=sxpar(hdr,'NAXIS2')
   cx=xsize/2.0
   cy=ysize/2.0
   
   xyad,hdr,cx,cy,cra,cdec

   spawn,"rm -rf /tmp/2mass_idl.dat"
   spawn,"find2mass -c "+string(cra)+" "+string(cdec)+" -bd 1 -m 20000 -e b > /tmp/2mass_temp.dat"
   spawn,'cat /tmp/2mass_temp.dat |sed -e "s/|/ /g"|sed -e "s/---/-999.9/g"'+$
      '> /tmp/2mass_aclient.dat'
   ;readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
   ; format='f,f,s,f,f,f,f,f,f,s',/silent
   readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
    format='f10.7,f10.7,a,f,f,f,f,f,f,a',/silent
   ;print,strcmp('AAA',flag)
   ind=where((strcmp('AAA',flag) eq 1) and (mjerr ge 0) and (mherr ge 0) and (mkerr ge 0))
   
   adxy,hdr,ra,dec,x,y
   
  ;ind=where(x le xsize and y le ysize,count)
   
   ref={id:findgen(n_elements(ra[ind])),ra:ra[ind],dec:dec[ind],x:x[ind],$
      y:y[ind],mj:mj[ind],mh:mh[ind],mk:mk[ind],mjerr:mjerr[ind],mherr:mherr[ind],$
      mkerr:mkerr[ind]}
END

PRO FIND2MASS_L1689, ref
   COMMON share,conf
   loadconfig
   
   ;hdr=headfits(conf.wircampath+'L1689_remap_Ks.fits')
   hdr=headfits(conf.wircampath+'L1689_Ks_new.fits')
   xsize=sxpar(hdr,'NAXIS1')
   ysize=sxpar(hdr,'NAXIS2')
   cx=xsize/2.0
   cy=ysize/2.0
   
   xyad,hdr,cx,cy,cra,cdec

   spawn,"rm -rf /tmp/2mass_idl.dat"
   spawn,"find2mass -c "+string(cra)+" "+string(cdec)+" -bd 1 -m 20000 -e b > /tmp/2mass_temp.dat"
   spawn,'cat /tmp/2mass_temp.dat |sed -e "s/|/ /g"|sed -e "s/---/-999.9/g"'+$
      '> /tmp/2mass_aclient.dat'
   ;readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
   ; format='f,f,s,f,f,f,f,f,f,s',/silent
   readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
    format='f10.7,f10.7,a,f,f,f,f,f,f,a',/silent
   ;print,strcmp('AAA',flag)
   ind=where((strcmp('AAA',flag) eq 1) and (mjerr ge 0) and (mherr ge 0) and (mkerr ge 0))
   
   adxy,hdr,ra,dec,x,y
   
  ;ind=where(x le xsize and y le ysize,count)
   
   ref={id:findgen(n_elements(ra[ind])),ra:ra[ind],dec:dec[ind],x:x[ind],$
      y:y[ind],mj:mj[ind],mh:mh[ind],mk:mk[ind],mjerr:mjerr[ind],mherr:mherr[ind],$
      mkerr:mkerr[ind]}
END

PRO FIND2MASS_L1688, ref
   COMMON share,conf
   loadconfig
   
   ;hdr=headfits(conf.wircampath+'L1688_Ks_coadd.fits')
   hdr=headfits(conf.wircampath+'L1688_Ks_new.fits')
   xsize=sxpar(hdr,'NAXIS1')
   ysize=sxpar(hdr,'NAXIS2')
   cx=xsize/2.0
   cy=ysize/2.0
   
   xyad,hdr,cx,cy,cra,cdec

   spawn,"rm -rf /tmp/2mass_idl.dat"
   spawn,"find2mass -c "+string(cra)+" "+string(cdec)+" -bd 1 -m 20000 -e b > /tmp/2mass_temp.dat"
   spawn,'cat /tmp/2mass_temp.dat |sed -e "s/|/ /g"|sed -e "s/---/-999.9/g"'+$
      '> /tmp/2mass_aclient.dat'
   ;readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
   ; format='f,f,s,f,f,f,f,f,f,s',/silent
   readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
    format='f10.7,f10.7,a,f,f,f,f,f,f,a',/silent
   ;print,strcmp('AAA',flag)
   ind=where((strcmp('AAA',flag) eq 1) and (mjerr ge 0) and (mherr ge 0) and (mkerr ge 0))
   
   adxy,hdr,ra,dec,x,y
   
  ;ind=where(x le xsize and y le ysize,count)
   
   ref={id:findgen(n_elements(ra[ind])),ra:ra[ind],dec:dec[ind],x:x[ind],$
      y:y[ind],mj:mj[ind],mh:mh[ind],mk:mk[ind],mjerr:mjerr[ind],mherr:mherr[ind],$
      mkerr:mkerr[ind]}
END

PRO FIND2MASS_L1709, ref
   COMMON share,conf
   loadconfig
   
   hdr=headfits(conf.wircampath+'L1709_Ks_new.fits')
   xsize=sxpar(hdr,'NAXIS1')
   ysize=sxpar(hdr,'NAXIS2')
   cx=xsize/2.0
   cy=ysize/2.0
   
   xyad,hdr,cx,cy,cra,cdec

   spawn,"rm -rf /tmp/2mass_idl.dat"
   spawn,"find2mass -c "+string(cra)+" "+string(cdec)+" -bd 1 -m 20000 -e b > /tmp/2mass_temp.dat"
   spawn,'cat /tmp/2mass_temp.dat |sed -e "s/|/ /g"|sed -e "s/---/-999.9/g"'+$
      '> /tmp/2mass_aclient.dat'
   ;readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
   ; format='f,f,s,f,f,f,f,f,f,s',/silent
   readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
    format='f10.7,f10.7,a,f,f,f,f,f,f,a',/silent
   ;print,strcmp('AAA',flag)
   ind=where((strcmp('AAA',flag) eq 1) and (mjerr ge 0) and (mherr ge 0) and (mkerr ge 0))
   
   adxy,hdr,ra,dec,x,y
   
  ;ind=where(x le xsize and y le ysize,count)
   
   ref={id:findgen(n_elements(ra[ind])),ra:ra[ind],dec:dec[ind],x:x[ind],$
      y:y[ind],mj:mj[ind],mh:mh[ind],mk:mk[ind],mjerr:mjerr[ind],mherr:mherr[ind],$
      mkerr:mkerr[ind]}
END

PRO FIND2MASS_L1712, ref
   COMMON share,conf
   loadconfig
   
   hdr=headfits(conf.wircampath+'L1712_Ks_new.fits')
   xsize=sxpar(hdr,'NAXIS1')
   ysize=sxpar(hdr,'NAXIS2')
   cx=xsize/2.0
   cy=ysize/2.0
   
   xyad,hdr,cx,cy,cra,cdec

   spawn,"rm -rf /tmp/2mass_idl.dat"
   spawn,"find2mass -c "+string(cra)+" "+string(cdec)+" -bd 1 -m 20000 -e b > /tmp/2mass_temp.dat"
   spawn,'cat /tmp/2mass_temp.dat |sed -e "s/|/ /g"|sed -e "s/---/-999.9/g"'+$
      '> /tmp/2mass_aclient.dat'
   ;readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
   ; format='f,f,s,f,f,f,f,f,f,s',/silent
   readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
    format='f10.7,f10.7,a,f,f,f,f,f,f,a',/silent
   ;print,strcmp('AAA',flag)
   ind=where((strcmp('AAA',flag) eq 1) and (mjerr ge 0) and (mherr ge 0) and (mkerr ge 0))
   
   adxy,hdr,ra,dec,x,y
   
  ;ind=where(x le xsize and y le ysize,count)
   
   ref={id:findgen(n_elements(ra[ind])),ra:ra[ind],dec:dec[ind],x:x[ind],$
      y:y[ind],mj:mj[ind],mh:mh[ind],mk:mk[ind],mjerr:mjerr[ind],mherr:mherr[ind],$
      mkerr:mkerr[ind]}
END


PRO FIND2MASS_RHO_OPH, ref
   COMMON share,conf
   loadconfig
   
   hdr=headfits(conf.wircampath+'rho_oph_Ks_new.fits')
   xsize=sxpar(hdr,'NAXIS1')
   ysize=sxpar(hdr,'NAXIS2')
   cx=xsize/2.0
   cy=ysize/2.0
   
   xyad,hdr,cx,cy,cra,cdec

   spawn,"rm -rf /tmp/2mass_idl.dat"
   spawn,"find2mass -c "+string(cra)+" "+string(cdec)+" -bd 1 -m 20000 -e b > /tmp/2mass_temp.dat"
   spawn,'cat /tmp/2mass_temp.dat |sed -e "s/|/ /g"|sed -e "s/---/-999.9/g"'+$
      '> /tmp/2mass_aclient.dat'
   ;readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
   ; format='f,f,s,f,f,f,f,f,f,s',/silent
   readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
    format='f10.7,f10.7,a,f,f,f,f,f,f,a',/silent
   ;print,strcmp('AAA',flag)
   ind=where((strcmp('AAA',flag) eq 1) and (mjerr ge 0) and (mherr ge 0) and (mkerr ge 0))
   
   adxy,hdr,ra,dec,x,y
   
  ;ind=where(x le xsize and y le ysize,count)
   
   ref={id:findgen(n_elements(ra[ind])),ra:ra[ind],dec:dec[ind],x:x[ind],$
      y:y[ind],mj:mj[ind],mh:mh[ind],mk:mk[ind],mjerr:mjerr[ind],mherr:mherr[ind],$
      mkerr:mkerr[ind]}
END


PRO RUNSEXASSOC_REG2
  COMMON share,conf
  loadconfig
  
  ; Based on the star list, do photometry on these star first
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'1633-2410_J_coadd.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'soc_check_j.fits -CATALOG_NAME '+conf.catpath+'soc_j.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'1633-2410_J_coadd.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'mips_select_J.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3'

  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'1633-2410_H_coadd.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'soc_check_h.fits -CATALOG_NAME '+conf.catpath+'soc_h.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'1633-2410_H_coadd.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'mips_select_H.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 '

  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'1633-2410_Ks_coadd.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'soc_check_k.fits -CATALOG_NAME '+conf.catpath+'soc_k.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'1633-2410_Ks_coadd.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'mips_select_K.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3'

END

PRO RUNSEXASSOC_L1689
  COMMON share,conf
  loadconfig
  
  ; Based on the star list, do photometry on these star first
  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1689_remap_J.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1689_soc_check_j.fits -CATALOG_NAME '+conf.catpath+'L1689_soc_j.cat '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1689_J_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1689_J_new_soc_check.fits -CATALOG_NAME '+conf.catpath+'L1689_J_new_soc.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    ;+' -WEIGHT_IMAGE '+conf.wircampath+'L1689_remap_J.weight.fits'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1689_J_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1689_mips_select_J.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3'

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1689_remap_H.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1689_soc_check_h.fits -CATALOG_NAME '+conf.catpath+'L1689_soc_h.cat '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1689_H_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1689_H_new_soc_check.fits -CATALOG_NAME '+conf.catpath+'L1689_H_new_soc.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    ;+' -WEIGHT_IMAGE '+conf.wircampath+'L1689_remap_H.weight.fits'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1689_H_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1689_mips_select_H.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 '

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1689_remap_Ks.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1689_soc_check_k.fits -CATALOG_NAME '+conf.catpath+'L1689_soc_k.cat '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1689_Ks_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1689_Ks_new_soc_check.fits -CATALOG_NAME '+conf.catpath+'L1689_Ks_new_soc.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    ;+' -WEIGHT_IMAGE '+conf.wircampath+'L1689_remap_Ks.weight.fits'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1689_Ks_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1689_mips_select_K.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3'

END

PRO RUNSEXASSOC_L1688
  COMMON share,conf
  loadconfig
  
  ; Based on the star list, do photometry on these star first
  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1688_J_coadd.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1688_soc_check_j.fits -CATALOG_NAME '+conf.catpath+'L1688_soc_j.cat '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1688_J_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1689_J_new_soc_check.fits -CATALOG_NAME '+conf.catpath+'L1688_J_new_soc.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1688_J_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1689_mips_select_J.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1688_H_coadd.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1688_soc_check_h.fits -CATALOG_NAME '+conf.catpath+'L1688_soc_h.cat '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1688_H_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1689_H_new_soc_check.fits -CATALOG_NAME '+conf.catpath+'L1688_H_new_soc.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1688_H_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1688_mips_select_H.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1688_Ks_coadd.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1688_soc_check_k.fits -CATALOG_NAME '+conf.catpath+'L1688_soc_k.cat '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1688_Ks_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1689_Ks_new_soc_check.fits -CATALOG_NAME '+conf.catpath+'L1688_Ks_new_soc.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1688_Ks_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1688_mips_select_K.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

END


PRO RUNSEXASSOC_L1709
  COMMON share,conf
  loadconfig
  
  ; Based on the star list, do photometry on these star first
  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1709_remap_J.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1709_soc_check_j.fits -CATALOG_NAME '+conf.catpath+'L1709_soc_j.cat '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1709_J_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1709_soc_check_j.fits -CATALOG_NAME '+conf.catpath+'L1709_J_new_soc.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1709_J_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1709_mips_select_J.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1709_remap_H.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1709_soc_check_h.fits -CATALOG_NAME '+conf.catpath+'L1709_soc_h.cat '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1709_H_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1709_soc_check_h.fits -CATALOG_NAME '+conf.catpath+'L1709_H_new_soc.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1709_H_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1709_mips_select_H.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1709_remap_Ks.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1709_soc_check_k.fits -CATALOG_NAME '+conf.catpath+'L1709_soc_k.cat '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1709_Ks_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1709_soc_check_k.fits -CATALOG_NAME '+conf.catpath+'L1709_Ks_new_soc.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1709_Ks_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1709_mips_select_K.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

END

PRO RUNSEXASSOC_L1712
  COMMON share,conf
  loadconfig
  
  ; Based on the star list, do photometry on these star first
  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_remap_J.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1712_soc_check_j.fits -CATALOG_NAME '+conf.catpath+'L1712_soc_j.cat '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_J_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1712_soc_check_j.fits -CATALOG_NAME '+conf.catpath+'L1712_J_new_soc.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1712_J_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1712_mips_select_J.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_remap_H.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1709_soc_check_h.fits -CATALOG_NAME '+conf.catpath+'L1712_soc_h.cat '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_H_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1712_soc_check_h.fits -CATALOG_NAME '+conf.catpath+'L1712_H_new_soc.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1712_H_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1712_mips_select_H.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_remap_Ks.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1712_soc_check_k.fits -CATALOG_NAME '+conf.catpath+'L1712_soc_k.cat '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_Ks_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'L1712_soc_check_k.fits -CATALOG_NAME '+conf.catpath+'L1712_Ks_new_soc.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'L1712_Ks_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'L1712_mips_select_K.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

END


PRO RUNSEXASSOC_RHO_OPH
  COMMON share,conf
  loadconfig
  
  ; Based on the star list, do photometry on these star first
  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_remap_J.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1712_soc_check_j.fits -CATALOG_NAME '+conf.catpath+'L1712_soc_j.cat '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'rho_oph_J_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'rho_oph_soc_check_j.fits -CATALOG_NAME '+conf.catpath+'rho_oph_J_new_soc.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'rho_oph_J_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'rho_oph_mips_select_J.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_remap_H.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1709_soc_check_h.fits -CATALOG_NAME '+conf.catpath+'L1712_soc_h.cat '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'rho_oph_H_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'rho_oph_soc_check_h.fits -CATALOG_NAME '+conf.catpath+'rho_oph_H_new_soc.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'rho_oph_H_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'rho_oph_mips_select_H.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

  ;spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'L1712_remap_Ks.fits -CHECKIMAGE_NAME '$
  ;  +conf.fitspath+'L1712_soc_check_k.fits -CATALOG_NAME '+conf.catpath+'L1712_soc_k.cat '$
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.wircampath+'rho_oph_Ks_new.fits -CHECKIMAGE_NAME '$
    +conf.fitspath+'rho_oph_soc_check_k.fits -CATALOG_NAME '+conf.catpath+'rho_oph_Ks_new_soc.cat '$
    +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
    +' -WEIGHT_IMAGE '+conf.wircampath+'rho_oph_Ks_new.weight.fits'$
    +' -WEIGHT_TYPE MAP_WEIGHT '$
    +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
    +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'rho_oph_mips_select_K.assoc'$
    +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
    +' -ANALYSIS_THRESH 3 -NTHREADS 4'

END

