PRO MKASSOC, ra, dec, radius
   COMMON share,conf
   loadconfig
   
   
   spawn,"rm -rf /tmp/2mass_idl.dat"
   spawn,"find2mass -c "+strcompress(string(ra),/remove)+" "+strcompress(string(dec),/remove)+$
      " -r "+strcompress(string(radius),/remove)+" -m 30000 -e b > /tmp/2mass_temp.dat"
   spawn,'cat /tmp/2mass_temp.dat |sed -e "s/|/ /g"|sed -e "s/---/-999.9/g"'+$
      '> /tmp/2mass_aclient.dat'
   ;readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
   ; format='f,f,s,f,f,f,f,f,f,s',/silent
   readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
    format='f10.7,f10.7,a,f,f,f,f,f,f,a',/silent
   ;print,strcmp('AAA',flag)
   ind=where((strcmp('AAA',flag) eq 1) and (mjerr ge 0) and (mherr ge 0) and (mkerr ge 0) $
    and (mj ge 10) and (mh ge 10) and (mk ge 10),count)
   
   hdr=headfits(conf.fitspath+'W3A_J.fits')
   adxy,hdr,ra[ind],dec[ind],x,y
   close,1
   openw,1,conf.fitspath+'stars_cat_j.assoc'
      for i=0, count-1 do begin
         printf,1,i+1,format='(i,f12.3,f12.3,f8.3,f7.4,f8.3,f7.4,f8.3,f7.4)',$
         x[i],y[i],mj[ind[i]],mjerr[ind[i]],mh[ind[i]],mherr[ind[i]],mk[ind[i]],mkerr[ind[i]]
      endfor
   close,1
   getds9region,x[ind],y[ind],'reg-j-assoc',color='blue'
   
   hdr=headfits(conf.fitspath+'W3A_H.fits')
   adxy,hdr,ra[ind],dec[ind],x,y
   close,1
   openw,1,conf.fitspath+'stars_cat_h.assoc'
      for i=0, count-1 do begin
         printf,1,i+1,format='(i,f12.3,f12.3,f8.3,f7.4,f8.3,f7.4,f8.3,f7.4)',$
            x[i],y[i],mj[ind[i]],mjerr[ind[i]],mh[ind[i]],mherr[ind[i]],mk[ind[i]],mkerr[ind[i]]
      endfor
   close,1
   getds9region,x[ind],y[ind],'reg-h-assoc',color='green'

   hdr=headfits(conf.fitspath+'W3A_Ks.fits')
   adxy,hdr,ra[ind],dec[ind],x,y
   close,1
   openw,1,conf.fitspath+'stars_cat_k.assoc'
      for i=0, count-1 do begin
         printf,1,i+1,format='(i,f12.3,f12.3,f8.3,f7.4,f8.3,f7.4,f8.3,f7.4)',$
            x[i],y[i],mj[ind[i]],mjerr[ind[i]],mh[ind[i]],mherr[ind[i]],mk[ind[i]],mkerr[ind[i]]
      endfor
   close,1
   getds9region,x[ind],y[ind],'reg-k-assoc',color='red'

   
   hdr=headfits(conf.fitspath+'W3A_H2.fits')
   adxy,hdr,ra[ind],dec[ind],x,y
   close,1
   openw,1,conf.fitspath+'stars_cat_h2.assoc'
      for i=0, count-1 do begin
         printf,1,i+1,format='(i,f12.3,f12.3,f8.3,f7.4,f8.3,f7.4,f8.3,f7.4)',$
            x[i],y[i],mj[ind[i]],mjerr[ind[i]],mh[ind[i]],mherr[ind[i]],mk[ind[i]],mkerr[ind[i]]
      endfor
   close,1
   getds9region,x[ind],y[ind],'reg-h2-assoc',color='white'


END

PRO RUNSEXASSOC
   COMMON share,conf 
   loadconfig
   
   cd,conf.fitspath
   ; Based on the star list, do photometry on these star first
   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'W3A_J.fits -CHECKIMAGE_NAME '$
      +conf.fitspath+'soc_check_j.fits -CATALOG_NAME '+conf.fitspath+'soc_j.sex '$
      +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
      +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
      +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME stars_cat_j.assoc -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5'$
      +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
      +' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 0.0,0.0'

   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'W3A_H.fits -CHECKIMAGE_NAME '$
      +conf.fitspath+'soc_check_h.fits -CATALOG_NAME '+conf.fitspath+'soc_h.sex '$
      +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
      +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
      +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME stars_cat_h.assoc -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5'$
      +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
      +' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 0.0,0.0'

   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'W3A_Ks.fits -CHECKIMAGE_NAME '$
      +conf.fitspath+'soc_check_k.fits -CATALOG_NAME '+conf.fitspath+'soc_k.sex '$
      +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
      +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
      +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME stars_cat_k.assoc -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '$
      +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
      +' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 0.0,0.0'

   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'W3A_H2.fits -CHECKIMAGE_NAME '$
      +conf.fitspath+'soc_check_h2.fits -CATALOG_NAME '+conf.fitspath+'soc_h2.sex '$
      +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
      +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
      +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME stars_cat_h2.assoc -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '$
      +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
      +' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 0.0,0.0'

      
  cd,'~/idl_script/Projects/W3A/'

END


PRO FIND2MASS, ref, ra,dec, radius
   COMMON share,conf
   loadconfig

   spawn,"rm -rf /tmp/2mass_idl.dat"
   spawn,"find2mass -c "+strcompress(string(ra),/remove)+" "+strcompress(string(ra),/remove)+$
      " -r "+strcompress(string(radius),/remove)+" -m 30000 -e b > /tmp/2mass_temp.dat"
   spawn,'cat /tmp/2mass_temp.dat |sed -e "s/|/ /g"|sed -e "s/---/-999.9/g"'+$
      '> /tmp/2mass_aclient.dat'
   ;readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
   ; format='f,f,s,f,f,f,f,f,f,s',/silent
   readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
    format='f10.7,f10.7,a,f,f,f,f,f,f,a',/silent
   ;print,strcmp('AAA',flag)
   ind=where((strcmp('AAA',flag) eq 1) and (mjerr ge 0) and (mherr ge 0) and (mkerr ge 0) $
    and (mj ge 10) and (mh ge 10) and (mk ge 10))
   
   hdr=headfits(conf.fitspath+'W3A_J.fits')
   
   adxy,hdr,ra,dec,x,y
   
   xsize=sxpar(hdr,'NAXIS1')
   ysize=sxpar(hdr,'NAXIS2')
   ;ind=where(x le xsize and y le ysize,count)
   
   ref={id:findgen(n_elements(ra[ind])),ra:ra[ind],dec:dec[ind],x:x[ind],$
      y:y[ind],mj:mj[ind],mh:mh[ind],mk:mk[ind],mjerr:mjerr[ind],mherr:mherr[ind],$
      mkerr:mkerr[ind]}
END

PRO GETSTAR, catalog
   COMMON share,conf 
   loadconfig
   
   ;runsextractor
      
   readcol,conf.fitspath+'soc_j.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   ;index=where(flag eq 0 and class ge 0.85 and mag le 16.2)
   index=where(id ne 0)
   j={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.131,$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   readcol,conf.fitspath+'soc_h.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   ;index=where(flag eq 0 and class ge 0.85 and mag  le 15.8)
   index=where(id ne 0)
   h={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.129,$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   readcol,conf.fitspath+'soc_k.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   ;index=where(flag eq 0 and class ge 0.85 and mag le 15)
   index=where(id ne 0)
   k={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.140,$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}

   readcol,conf.fitspath+'soc_h2.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   ;index=where(flag eq 0 and class ge 0.85 and mag le 15)
   index=where(id ne 0)
   k={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.140,$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   
   catalog={j:j,h:h,k:k,h2:h2}   
END


PRO GETDS9REGION, x, y, name, color=color
  COMMON share,conf
  loadconfig

  regname = name+'.reg'
  regpath = conf.fitspath
  regfile = regpath+regname
  
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

