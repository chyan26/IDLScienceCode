
PRO MKASSOC
   COMMON share,conf 
   loadconfig
   
   spawn,"rm -rf /tmp/2mass_idl.dat"
   spawn,"find2mass -c 84.830166 35.725762 -r 10 -m 30000 -e b > /tmp/2mass_temp.dat"
   spawn,'cat /tmp/2mass_temp.dat |sed -e "s/|/ /g"|sed -e "s/---/-999.9/g"'+$
      '> /tmp/2mass_aclient.dat'
   ;readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
   ; format='f,f,s,f,f,f,f,f,f,s',/silent
   readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
    format='f10.7,f10.7,a,f,f,f,f,f,f,a',/silent
   ;print,strcmp('AAA',flag)
 ;  ind=where((mjerr ge 0) and (mherr ge 0) and (mkerr ge 0) $
 ;   and (mj ge 10) and (mh ge 10) and (mk ge 10),count)
   ind=where((mk ge 12),count)
   
   hdr=headfits(conf.fitspath+'g173_j.fits')
   adxy,hdr,ra[ind],dec[ind],x,y
   close,1
   openw,1,conf.catpath+'stars_cat_j.assoc'
      for i=0, count-1 do begin
         printf,1,i+1,format='(i,f10.3,f10.3,f8.3,f7.4,f8.3,f7.4,f8.3,f7.4)',$
         x[i],y[i],mj[ind[i]],mjerr[ind[i]],mh[ind[i]],mherr[ind[i]],mk[ind[i]],mkerr[ind[i]]
      endfor
   close,1
   getds9region,x[ind],y[ind],conf.regpath+'reg-j-assoc',color='blue'
   
   hdr=headfits(conf.fitspath+'g173_j.fits')
   adxy,hdr,ra[ind],dec[ind],x,y
   close,1
   openw,1,conf.catpath+'stars_cat_h.assoc'
      for i=0, count-1 do begin
         printf,1,i+1,format='(i,f10.3,f10.3,f8.3,f7.4,f8.3,f7.4,f8.3,f7.4)',$
            x[i],y[i],mj[ind[i]],mjerr[ind[i]],mh[ind[i]],mherr[ind[i]],mk[ind[i]],mkerr[ind[i]]
      endfor
   close,1
   getds9region,x[ind],y[ind],conf.regpath+'reg-h-assoc',color='green'

   hdr=headfits(conf.fitspath+'g173_j.fits')
   adxy,hdr,ra[ind],dec[ind],x,y
   close,1
   openw,1,conf.catpath+'stars_cat_k.assoc'
      for i=0, count-1 do begin
         printf,1,i+1,format='(i,f10.3,f10.3,f8.3,f7.4,f8.3,f7.4,f8.3,f7.4)',$
            x[i],y[i],mj[ind[i]],mjerr[ind[i]],mh[ind[i]],mherr[ind[i]],mk[ind[i]],mkerr[ind[i]]
      endfor
   close,1
   getds9region,x[ind],y[ind],conf.regpath+'reg-k-assoc',color='red'

END

PRO MKASSOC_LINE
   COMMON share,conf 
   loadconfig
   
   spawn,"rm -rf /tmp/2mass_idl.dat"
   spawn,"find2mass -c 84.830166 35.725762 -r 10 -m 30000 -e b > /tmp/2mass_temp.dat"
   spawn,'cat /tmp/2mass_temp.dat |sed -e "s/|/ /g"|sed -e "s/---/-999.9/g"'+$
      '> /tmp/2mass_aclient.dat'
   ;readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
   ; format='f,f,s,f,f,f,f,f,f,s',/silent
   readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
    format='f10.7,f10.7,a,f,f,f,f,f,f,a',/silent
   ;print,strcmp('AAA',flag)
 ;  ind=where((mjerr ge 0) and (mherr ge 0) and (mkerr ge 0) $
 ;   and (mj ge 10) and (mh ge 10) and (mk ge 10),count)
   ind=where((mk ge 12),count)
   
   hdr=headfits(conf.fitspath+'g173_h2.fits')
   adxy,hdr,ra[ind],dec[ind],x,y
   close,1
   openw,1,conf.catpath+'stars_cat_h2.assoc'
      for i=0, count-1 do begin
         printf,1,i+1,format='(i,f10.3,f10.3,f8.3,f7.4,f8.3,f7.4,f8.3,f7.4)',$
         x[i],y[i],mj[ind[i]],mjerr[ind[i]],mh[ind[i]],mherr[ind[i]],mk[ind[i]],mkerr[ind[i]]
      endfor
   close,1
   getds9region,x[ind],y[ind],conf.regpath+'reg-j-assoc',color='blue'
   
   hdr=headfits(conf.fitspath+'g173_brg.fits')
   adxy,hdr,ra[ind],dec[ind],x,y
   close,1
   openw,1,conf.catpath+'stars_cat_brg.assoc'
      for i=0, count-1 do begin
         printf,1,i+1,format='(i,f10.3,f10.3,f8.3,f7.4,f8.3,f7.4,f8.3,f7.4)',$
            x[i],y[i],mj[ind[i]],mjerr[ind[i]],mh[ind[i]],mherr[ind[i]],mk[ind[i]],mkerr[ind[i]]
      endfor
   close,1
   getds9region,x[ind],y[ind],conf.regpath+'reg-h-assoc',color='green'

   hdr=headfits(conf.fitspath+'g173_kcont.fits')
   adxy,hdr,ra[ind],dec[ind],x,y
   close,1
   openw,1,conf.catpath+'stars_cat_kcont.assoc'
      for i=0, count-1 do begin
         printf,1,i+1,format='(i,f10.3,f10.3,f8.3,f7.4,f8.3,f7.4,f8.3,f7.4)',$
            x[i],y[i],mj[ind[i]],mjerr[ind[i]],mh[ind[i]],mherr[ind[i]],mk[ind[i]],mkerr[ind[i]]
      endfor
   close,1
   getds9region,x[ind],y[ind],conf.regpath+'reg-k-assoc',color='red'

END

PRO RUNSEXASSOC
   COMMON share,conf 
   loadconfig
   
   cd,conf.fitspath
   ; Based on the star list, do photometry on these star first
   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'g173_j.fits -CHECKIMAGE_NAME '$
      +conf.fitspath+'soc_check_j.fits -CATALOG_NAME '+conf.catpath+'soc_j.sex '$
      +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
      +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
      +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'stars_cat_j.assoc'+' -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5'$
      +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
      +' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 0.0,0.0'

   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'g173_h.fits -CHECKIMAGE_NAME '$
      +conf.fitspath+'soc_check_h.fits -CATALOG_NAME '+conf.catpath+'soc_h.sex '$
      +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
      +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
      +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'stars_cat_h.assoc'+' -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5'$
      +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
      +' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 0.0,0.0'

   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'g173_k.fits -CHECKIMAGE_NAME '$
      +conf.fitspath+'soc_check_k.fits -CATALOG_NAME '+conf.catpath+'soc_k.sex '$
      +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
      +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
      +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'stars_cat_k.assoc'+' -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5'$
      +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
      +' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 0.0,0.0'
      
   cd,'~chyan/IDLSourceCode/Science/G173'   

END

PRO RUNSEXASSOC_LINE
   COMMON share,conf 
   loadconfig
   
   cd,conf.fitspath
   ; Based on the star list, do photometry on these star first
   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'g173_h2.fits -CHECKIMAGE_NAME '$
      +conf.fitspath+'soc_check_h2.fits -CATALOG_NAME '+conf.catpath+'soc_h2.sex '$
      +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
      +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
      +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'stars_cat_h2.assoc'+' -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5'$
      +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
      +' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 0.0,0.0'

   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'g173_brg.fits -CHECKIMAGE_NAME '$
      +conf.fitspath+'soc_check_brg.fits -CATALOG_NAME '+conf.catpath+'soc_brg.sex '$
      +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
      +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
      +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'stars_cat_brg.assoc'+' -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5'$
      +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
      +' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 0.0,0.0'

   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'g173_kcont.fits -CHECKIMAGE_NAME '$
      +conf.fitspath+'soc_check_kcont.fits -CATALOG_NAME '+conf.catpath+'soc_kcont.sex '$
      +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
      +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
      +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+'stars_cat_kcont.assoc'+' -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5'$
      +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
      +' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 0.0,0.0'
      
   cd,'~chyan/IDLSourceCode/Science/G173'   

END





PRO RUNSEXTRACTOR
	COMMON share,conf	
	loadconfig
  
  cd,conf.fitspath
  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'sg_g173_j.fits -CHECKIMAGE_NAME '$
      +conf.fitspath+'check_j.fits -CATALOG_NAME '+conf.catpath+'sg_g173_j.sex -MAG_ZEROPOINT 25.0 '$
      +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
      +' -FILTER_NAME '+conf.confpath+'default.conv '$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
      +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '$
      +' -ASSOC_NAME '+conf.confpath+'saturated_ref.list '$
      +' -ASSOC_DATA 2,3 -ASSOC_PARAMS 2,3 -ASSOC_TYPE MAX '$
       +' -ASSOC_RADIUS 10.0 -ASSOCSELEC_TYPE -MATCHED'

  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'sg_g173_h.fits -CHECKIMAGE_NAME '$
      +conf.fitspath+'check_h.fits -CATALOG_NAME '+conf.catpath+'sg_g173_h.sex -MAG_ZEROPOINT 25.0 '$
      +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
      +' -FILTER_NAME '+conf.confpath+'default.conv '$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
      +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '$
      +' -ASSOC_NAME '+conf.confpath+'saturated_ref.list '$
      +' -ASSOC_DATA 2,3 -ASSOC_PARAMS 2,3 -ASSOC_TYPE MAX '$
       +' -ASSOC_RADIUS 10.0 -ASSOCSELEC_TYPE -MATCHED'

  spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'sg_g173_k.fits -CHECKIMAGE_NAME '$
      +conf.fitspath+'check_k.fits -CATALOG_NAME '+conf.catpath+'sg_g173_k.sex -MAG_ZEROPOINT 25.0 '$
      +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
      +' -FILTER_NAME '+conf.confpath+'default.conv '$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
      +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '$
      +' -ASSOC_NAME '+conf.confpath+'saturated_ref.list '$
      +' -ASSOC_DATA 2,3 -ASSOC_PARAMS 2,3 -ASSOC_TYPE MAX '$
       +' -ASSOC_RADIUS 10.0 -ASSOCSELEC_TYPE -MATCHED'
 
	
   cd,'~chyan/IDLSourceCode/Science/G173'   
END


PRO GETSTAR, catalog, zero=zero, limitmag=limitmag
	COMMON share,conf	
	loadconfig
	
	;runsextractor
		
	readcol,conf.catpath+'sg_g173_j.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	;index=where(flag eq 0 and class ge 0.85 and mag le 16.2)
	index=where(mag ge 14.2 and (x le 603 or x ge 646 or y le 349 or y ge 414) and $
	 (x ge 208 or y ge 166) and (x le 208 or x ge 468 or y le 1 or y ge 99) and $
	 (x le 692 or x ge 797 or y le 0 or y ge 61) and (x le 600 or x ge 682 or y ge 66) and $
	 (x le 850 or x ge 896 or y le 121 or y ge 151) and (x le 581 or x ge 596 or y le 124 or y ge 140) and $
	 (x le 851 or x ge 871 or y le 27 or y ge 45) and (x le 585 or x ge 603 or y le 228 or y ge 241) and $
	 (x le 774 or x ge 760 or y le 133 or y ge 146))
	 mag=mag-zero[0]
	j={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index],$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   getds9region,x[index],y[index],conf.regpath+'j-selected',color='green'
   
   spawn,"rm -rf /tmp/2mass_idl.dat"
   spawn,"find2mass -c 84.857847 35.683841 -r 3 -m 30000 -e b > /tmp/2mass_temp.dat"
   spawn,'cat /tmp/2mass_temp.dat |sed -e "s/|/ /g"|sed -e "s/---/-999.9/g"'+$
      '> /tmp/2mass_aclient.dat'
   ;readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
   ; format='f,f,s,f,f,f,f,f,f,s',/silent
   readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,tmcflag,$
    format='f10.7,f10.7,a,f,f,f,f,f,f,a',/silent

   hdr=headfits(conf.fitspath+'sg_g173_j.fits')

   xpix=sxpar(hdr,'NAXIS1')
   ypix=sxpar(hdr,'NAXIS2')
   adxy,hdr,ra,dec,tmcx,tmcy
   ;getds9region,tmcx,tmcy,conf.regpath+'tmc_cat',color='green'
   for ii=0,n_elements(tmcx)-1 do begin
      dist=sqrt((tmcx[ii]-j.x)^2+(tmcy[ii]-j.y)^2)
      if min(dist) ge 5 and min(dist) le 0.25*xpix and tmcx[ii] ge 0 and $
        tmcy[ii] ge 0 and tmcx[ii] le xpix and tmcy[ii] le ypix then begin

        if (strcmp('U',strmid(tmcflag[ii],0,1)) ne 1) then begin       
        ;print,i,min(dist),' USE 2MASS'
        id=[j.id,max(j.id)+1]
        x=[j.x,tmcx[ii]]
        y=[j.y,tmcy[ii]]
        flux=[j.flux,-9999]
        mag=[j.mag,mj[ii]]
        magerr=[j.magerr,mjerr[ii]]
        a=[j.a,-999]
        b=[j.b,-999]
        i=[j.i,-999]
        e=[j.e,-999]
        fwhm=[j.fwhm,-999]
        flag=[j.flag,-999]
        class=[j.class,-999]
        j={id:id,x:x,y:y,flux:flux,mag:mag,$
          magerr:magerr,a:a,b:b,i:i,e:e,$
          fwhm:fwhm,flag:flag,class:class}
          
        endif  
      endif
      
   
   endfor
    
	
  getds9region,j.x,j.y,conf.regpath+'j-selected-2mass',color='blue'
	
	readcol,conf.catpath+'sg_g173_h.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	;index=where(flag eq 0 and class ge 0.85 and mag  le 15.8)
	index=where(mag ge 14.2 and (x le 603 or x ge 646 or y le 349 or y ge 414) and $
   (x ge 208 or y ge 166) and (x le 208 or x ge 468 or y le 1 or y ge 99) and $
   (x le 692 or x ge 797 or y le 0 or y ge 61) and (x le 600 or x ge 682 or y ge 66) and $
   (x le 850 or x ge 896 or y le 121 or y ge 151) and (x le 581 or x ge 596 or y le 124 or y ge 140) and $
   (x le 851 or x ge 871 or y le 27 or y ge 45) and (x le 585 or x ge 603 or y le 228 or y ge 241) and $
   (x le 372 or x ge 387 or y le 628 or y ge 638) and (x le 843 or x ge 862 or y le 747 or y ge 761) and $
   (x le 519 or x ge 548 or y le 537 or y ge 558) and (x le 418 or x ge 449 or y le 105 or y ge 148) and $
   (x le 774 or x ge 760 or y le 133 or y ge 146) and magerr le 0.5)
	mag=mag-zero[1]
	
	h={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index],$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}

  getds9region,x[index],y[index],conf.regpath+'h-selected',color='green'
   
   readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,tmcflag,$
    format='f10.7,f10.7,a,f,f,f,f,f,f,a',/silent

   hdr=headfits(conf.fitspath+'sg_g173_h.fits')

   xpix=sxpar(hdr,'NAXIS1')
   ypix=sxpar(hdr,'NAXIS2')
   adxy,hdr,ra,dec,tmcx,tmcy
   ;getds9region,tmcx,tmcy,conf.regpath+'tmc_cat',color='green'
   for ii=0,n_elements(tmcx)-1 do begin
      dist=sqrt((tmcx[ii]-h.x)^2+(tmcy[ii]-h.y)^2)
      if min(dist) ge 5 and min(dist) le 0.25*xpix and tmcx[ii] ge 0 and $
        tmcy[ii] ge 0 and tmcx[ii] le xpix and tmcy[ii] le ypix then begin
        
        if (strcmp('U',strmid(tmcflag[ii],2,1)) ne 1) then begin       
        
        ;print,i,min(dist),' USE 2MASS'
        id=[h.id,max(h.id)+1]
        x=[h.x,tmcx[ii]]
        y=[h.y,tmcy[ii]]
        flux=[h.flux,-9999]
        mag=[h.mag,mh[ii]]
        magerr=[h.magerr,mherr[ii]]
        a=[h.a,-999]
        b=[h.b,-999]
        i=[h.i,-999]
        e=[h.e,-999]
        fwhm=[h.fwhm,-999]
        flag=[h.flag,-999]
        class=[h.class,-999]
        h={id:id,x:x,y:y,flux:flux,mag:mag,$
          magerr:magerr,a:a,b:b,i:i,e:e,$
          fwhm:fwhm,flag:flag,class:class}
          
        endif  
      endif
         
   endfor

	 getds9region,h.x,h.y,conf.regpath+'h-selected-2mass',color='green'
	 
	 
	 
	 
	readcol,conf.catpath+'sg_g173_k.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	;index=where(flag eq 0 and class ge 0.85 and mag le 15)
	index=where(mag ge 12.5 and (x le 86 or y le 709 or x ge 104 or y ge 729) and $ 
     (x le 844 or y le 739 or x ge 865 or y ge 767) and (x le 872 or y le 763 or x ge 896 or y ge 882) and $
     (x le 930 or y le 502 or x ge 954 or y ge 519) and (x le 619 or y le 370 or x ge 643 or y ge 400) and $
     (x le 567 or y le 700 or x ge 589 or y ge 718) and (x le 260 or y le 615 or x ge 281 or y ge 635) and $
     (x le 370 or y le 625 or x ge 389 or y ge 644) and (x le 532 or y le 537 or x ge 556 or y ge 556) and $
     (x le 447 or y le 500 or x ge 468 or y ge 513) and(x le  14 or y le 389 or x ge  38 or y ge 410) and $
     (x le 987 or y le 429 or x ge 1005 or y ge 442) and (x le 224 or y le 51 or x ge  245 or y ge 64) and $
     (x le 724 or y le 29  or x ge 742 or y ge 45)  and (x le 853 or y le 35 or x ge  871 or y ge 49) and $
     (x le 464 or y le 480 or x ge 472 or y ge 483) and (x le 736 or y le 8 or x ge  766 or y ge 34) and $
	   (x le 921 or y le 718 or x ge 938 or y ge 744) and (x le 909 or y le 637 or x ge 929 or y ge 662))
	mag=mag-zero[2]
	k={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index],$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
  
  getds9region,x[index],y[index],conf.regpath+'k-selected',color='red'
    
   readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,tmcflag,$
    format='f10.7,f10.7,a,f,f,f,f,f,f,a',/silent

   hdr=headfits(conf.fitspath+'sg_g173_k.fits')

   xpix=sxpar(hdr,'NAXIS1')
   ypix=sxpar(hdr,'NAXIS2')
   adxy,hdr,ra,dec,tmcx,tmcy
   ;getds9region,tmcx,tmcy,conf.regpath+'tmc_cat',color='green'
   for ii=0,n_elements(tmcx)-1 do begin
      dist=sqrt((tmcx[ii]-k.x)^2+(tmcy[ii]-k.y)^2)
      if min(dist) ge 3 and min(dist) le 0.25*xpix and tmcx[ii] ge 0 and $
        tmcy[ii] ge 0 and tmcx[ii] le xpix and tmcy[ii] le ypix then begin
        
        if (strcmp('U',strmid(tmcflag[ii],2,1)) ne 1) then begin       
        
        ;print,i,min(dist),' USE 2MASS'
        id=[k.id,max(j.id)+1]
        x=[k.x,tmcx[ii]]
        y=[k.y,tmcy[ii]]
        flux=[k.flux,-9999]
        mag=[k.mag,mk[ii]]
        magerr=[k.magerr,mkerr[ii]]
        a=[k.a,-999]
        b=[k.b,-999]
        i=[k.i,-999]
        e=[k.e,-999]
        fwhm=[k.fwhm,-999]
        flag=[k.flag,-999]
        class=[k.class,-999]
        k={id:id,x:x,y:y,flux:flux,mag:mag,$
          magerr:magerr,a:a,b:b,i:i,e:e,$
          fwhm:fwhm,flag:flag,class:class}
          
        endif
      endif
         
   endfor

   getds9region,k.x,k.y,conf.regpath+'k-selected-2mass',color='red'
   
   
	
	catalog={j:j,h:h,k:k}	
END

PRO GETREFSTAR, catalog
   COMMON share,conf 
   loadconfig

   ; eliminate saturated stars

   readcol,conf.catpath+'s233ir_j_ref.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   ;index=where(flag eq 0 and class ge 0.85 and mag le 16.2)
   index=where(id ne 0)
   j={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.0470991,$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   
   
   readcol,conf.catpath+'s233ir_h_ref.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   ;index=where(flag eq 0 and class ge 0.85 and mag  le 15.8)
   index=where(id ne 0)
   h={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.0766993,$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
 
   readcol,conf.catpath+'s233ir_k_ref.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   ;index=where(flag eq 0 and class ge 0.85 and mag le 15)
   index=where(id ne 0)
   k={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.207300,$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}

   
   catalog={j:j,h:h,k:k}   
END

;
; This function takes two sets of catalogue and do a matching
;    to register star detected by any routine
;
PRO MATCH_CATALOG,x1,y1,mag1,merr1,x2,y2,mag2,merr2,match
	; x1	: vector of X positions of field star (by FIND)
	; y1	: vector of Y positions of field star(by FIND)
	; mag1	: vector of Ks band magnitudes of field star (by APER)
	; merr1  : vector of magnitudes error of star (by APER)	
	; x2	: vector of X positions of catalog star (2MASS)
	; y2	: vector of Y positions of catalog star (2MASS)
	; mag2	: vector of Ks band magnitudes of catalog star
	; match : structure that stores the matched catalog
	; .x	:  vector of X positions of matched stars
	; .y	:  vector of Y positions of matched stars
	; .fmag1:  vector of instrumental magnitude
	; .fmag2:  vector of magnitude of catalog stars (2MASS) 
	flag=intarr(n_elements(x2))
	flag[*]=0
	x=0
	y=0
	fmag1=0
	fmag2=0

	n=0
	for i=0,n_elements(x1)-1 do begin
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


PRO GROUPSTAR, cat,final
 COMMON share,conf
  loadconfig
  
   xx=cat.x
   yy=cat.y
   
   ;Selecting stars in the cluster
   ;cind=where((xx ge 314 and xx le 680 and yy ge 360 and yy le 738) or $
   ;   (xx ge 226 and xx le 362 and yy ge 332 and yy le 664) or $
   ;   (xx ge 689 and xx le 761 and yy ge 505 and yy le 681) or $
   ;   (xx ge  98 and xx le 237 and yy ge 409 and yy le 567), complement=inx,count)
   
   ; Selecting new star member for new region
   cind=where((xx ge 209 and xx le 692 and yy ge 344 and yy le 609) or $
      (xx ge 158 and xx le 209 and yy ge 393 and yy le 572) or $
      (xx ge 695 and xx le 759 and yy ge 512 and yy le 600) or $
      (xx ge 122 and xx le 151 and yy ge 450 and yy le 513) or $
      (xx ge 262 and xx le 501 and yy ge 289 and yy le 375) or $
      (xx ge 359 and xx le 530 and yy ge 599 and yy le 656) or $
      (xx ge 263 and xx le 691 and yy ge 598 and yy le 643), complement=inx,count)
   
   group=intarr(n_elements(xx))   
   group[cind]=1
   
   group[inx]=2
   
   ; Preparing for the matrix for CTTS
   ctts=intarr(n_elements(xx))  
   ctts[*]=0
   
   getds9region,xx[cind],yy[cind],conf.regpath+'cluster-member',color='red'
    final={id:cat.id,x:cat.x,y:cat.y,mj:cat.mj,mh:cat.mh,mk:cat.mk,$
            mjerr:cat.mjerr,mherr:cat.mherr,mkerr:cat.mkerr,group:group,ctts:ctts}
            
END




PRO GETDS9REGION, x, y, name, color=color
  COMMON share,conf
  loadconfig

  regname = name+'.reg'
  regfile = regname
  
  ;x=cat.x
  ;y=cat.y
  id=indgen(n_elements(x))
  
  openw,fileunit, regfile, /get_lun 
  index = where(id eq 1)
  for i=0, n_elements(x)-1 do begin
    ext=0 
    regstring = 'tile '+strcompress(string(ext),/remove_all)+'; image; circle('+$
                    strcompress(string(x[i]),/remove_all)+','+$
                    strcompress(string(y[i]),/remove_all)+',10) #color ='+color
    printf, fileunit, format='(A)', regstring
  endfor
  
  close, fileunit
  free_lun,fileunit
END


