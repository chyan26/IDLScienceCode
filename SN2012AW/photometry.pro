
PRO MKASSOC
   COMMON share,conf 
   loadconfig
   
   ;readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
   ; format='f,f,s,f,f,f,f,f,f,s',/silent
   
   ;tab1=read_ascii(conf.catpath+'hst_05397_1e_wfpc2_f439w_wf_daophot_trm.cat')
   readcol,conf.catpath+'hst_05397_1e_wfpc2_f439w_wf_daophot_trm.cat',x,y,ra,dec,id,m1,merr1,m2,merr2,msky,std,flux,mag,magerr
   
   hdr=headfits(conf.fitspath+'hst_05397_1h_wfpc2_f439w_wf_drz.fits',ext=1)
   adxy,hdr,ra,dec,x,y
   
   close,1
   openw,1,conf.fitspath+'stars_cat_b.assoc'
      for i=0, n_elements(x)-1 do begin
         printf,1,i+1,format='(i,f10.3,f10.3,f8.3,f7.4,f8.3,f7.4,f8.3,f7.4)',x[i],y[i],mag[i],magerr[i]
      endfor
   close,1
   getds9region,x,y,'reg-b-assoc',color='blue',r=0.1




   readcol,conf.catpath+'hst_05397_1e_wfpc2_f555w_wf_daophot_trm.cat',x,y,ra,dec,id,m1,merr1,m2,merr2,msky,std,flux,mag,magerr
   
   hdr=headfits(conf.fitspath+'hlsp_sgal_hst_wfpc2_n3351_f555w_drz.fits')
   adxy,hdr,ra,dec,x,y
   
   close,1
   openw,1,conf.fitspath+'stars_cat_v.assoc'
      for i=0, n_elements(x)-1 do begin
         printf,1,i+1,format='(i,f10.3,f10.3,f8.3,f7.4,f8.3,f7.4,f8.3,f7.4)',x[i],y[i],mag[i],magerr[i]
      endfor
   close,1
   getds9region,x,y,'reg-v-assoc',color='blue',r=0.2





   readcol,conf.catpath+'hst_05397_1e_wfpc2_f814w_wf_daophot_trm.cat',x,y,ra,dec,id,m1,merr1,m2,merr2,msky,std,flux,mag,magerr
   
   hdr=headfits(conf.fitspath+'hlsp_sgal_hst_wfpc2_n3351_f814w_drz.fits')
   adxy,hdr,ra,dec,x,y
   
   close,1
   openw,1,conf.fitspath+'stars_cat_i.assoc'
      for i=0, n_elements(x)-1 do begin
         printf,1,i+1,format='(i,f10.3,f10.3,f8.3,f7.4,f8.3,f7.4,f8.3,f7.4)',x[i],y[i],mag[i],magerr[i]
      endfor
   close,1
   getds9region,x,y,'reg-i-assoc',color='red',r=0.3


END

PRO RUNSEXASSOC
   COMMON share,conf 
   loadconfig
   
   ;cd,setting.fitspath
   ; Based on the star list, do photometry on these star first
   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'hst_05397_1h_wfpc2_f439w_wf_drz.fits -CHECKIMAGE_NAME '$
      +conf.fitspath+'soc_check_b.fits -CATALOG_NAME '+conf.catpath+'soc_b.sex -MAG_ZEROPOINT 22.358'$
      +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc_aper.param'$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw '$      
      +' -FILTER_NAME '+conf.confpath+'default.conv '$
      +' -ASSOC_NAME '+conf.fitspath+'stars_cat_b.assoc -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5'$
      +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 10 -ANALYSIS_THRESH 2.0 '$
      +' -DETECT_THRESH 2.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '

   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'hlsp_sgal_hst_wfpc2_n3351_f555w_drz.fits -CHECKIMAGE_NAME '$
      +conf.fitspath+'soc_check_v.fits -CATALOG_NAME '+conf.catpath+'soc_v.sex -MAG_ZEROPOINT 35.303511 '$
      +' -FILTER_NAME '+conf.confpath+'default.conv '$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
      +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc_aper.param'$
      +' -ASSOC_NAME '+conf.fitspath+'stars_cat_v.assoc -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5'$
      +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 10 -ANALYSIS_THRESH 2.0 '$
      +' -DETECT_THRESH 2.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '

   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'hlsp_sgal_hst_wfpc2_n3351_f814w_drz.fits -CHECKIMAGE_NAME '$
      +conf.fitspath+'soc_check_i.fits -CATALOG_NAME '+conf.catpath+'soc_i.sex -MAG_ZEROPOINT 34.3885 '$
      +' -FILTER_NAME '+conf.confpath+'default.conv '$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
      +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc_aper.param'$
      +' -ASSOC_NAME '+conf.fitspath+'stars_cat_i.assoc -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '$
      +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 10 -ANALYSIS_THRESH 4.0 '$
      +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '
      
   ;cd,'~chyan/idl_script/Projects/S104/'   

END



PRO RUNSEXTRACTOR
   COMMON share,conf
   loadconfig
   
   
   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'hlsp_sgal_hst_wfpc2_n3351_f555w_drz.fits'$
   	  +' -CHECKIMAGE_NAME '$
      +conf.fitspath+'check_f555w.fits -CATALOG_NAME '+conf.catpath+'f555w.sex -MAG_ZEROPOINT 35.303511 '$
      +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
      +' -FILTER_NAME '+conf.confpath+'default.conv '$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 10 -ANALYSIS_THRESH 2.0 '$
      +' -DETECT_THRESH 2.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '

   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'hlsp_sgal_hst_wfpc2_n3351_f814w_drz.fits'$
      +' -CHECKIMAGE_NAME '$
      +conf.fitspath+'check_f814w.fits -CATALOG_NAME '+conf.catpath+'f814w.sex -MAG_ZEROPOINT 34.3885 '$
      +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
      +' -FILTER_NAME '+conf.confpath+'default.conv '$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 10 -ANALYSIS_THRESH 4.0 '$
      +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '

   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'hst_05397_1h_wfpc2_f439w_wf_drz.fits'$
      +' -CHECKIMAGE_NAME '$
      +conf.fitspath+'check_f439w.fits -CATALOG_NAME '+conf.catpath+'f439w.sex -MAG_ZEROPOINT 22.358 '$
      +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
      +' -FILTER_NAME '+conf.confpath+'default.conv '$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 10 -ANALYSIS_THRESH 2.0 '$
      +' -DETECT_THRESH 2.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '
 
      
END

PRO GETIMAGEZP,fits
   COMMON share,conf
   loadconfig

   ;fits='hlsp_sgal_hst_wfpc2_n3351_f555w_drz.fits'
   hd=headfits(conf.fitspath+fits)
	
   photflam=sxpar(hd,'PHOTFLAM')   	
   photzpt=sxpar(hd,'PHOTZPT')
   exptime=sxpar(hd,'EXPTIME')   	
   
   if photflam eq 0 then begin
   		hd=headfits(conf.fitspath+fits,exten=1)
	    photflam=sxpar(hd,'PHOTFLAM')   	
	    photzpt=sxpar(hd,'PHOTZPT')
   endif 
   
   print,photflam,photzpt,exptime
   print,-2.5*alog10(photflam)+photzpt+2.5*alog10(exptime)+2.5*alog10(7.0)

END


PRO GETSTAR, catalog
   COMMON share,conf 
   loadconfig

   ; eliminate saturated stars

   readcol,conf.catpath+'f439w.sex',format='(f,f,f,d,d,f,f,f,f,f,f,f,f,f,f,f)'$
   	  ,id,x,y,ra,dec,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   ;print,xx
   ;1546-1946,3273-3673
   ydec=0.415895*ra-55.2790
   flag=intarr(n_elements(ydec))
   flag[*]=0
   for ii=0,n_elements(ydec)-1 do begin
     if dec[ii] ge ydec[ii] then flag[ii]=1
   endfor
   index=where(flag eq 1 and ra ge 160.97004 and ra le 160.97744 and dec ge 11.66792 and dec le 11.67497)
   ;index=where(ra ne 0)
   ;print,n_elements(index)
   ;index=where(id ne 0)
   j={id:id[index],x:x[index],y:y[index],ra:ra[index],dec:dec[index],flux:flux[index],mag:mag[index],$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   readcol,conf.catpath+'f555w.sex',format='(f,f,f,d,d,f,f,f,f,f,f,f,f,f,f,f)'$
   	  ,id,x,y,ra,dec,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent

   
   ydec=0.415895*ra-55.2791
   flag=intarr(n_elements(ydec))
   flag[*]=0
   for ii=0,n_elements(ydec)-1 do begin
     if dec[ii] ge ydec[ii] then flag[ii]=1
   endfor
   index=where(flag eq 1 and ra ge 160.97004 and ra le 160.97744 and dec ge 11.66792 and dec le 11.67497)
   ;print,zz
   ;index=where(ra ne 0)

   ;index=where(id ne 0)
   h={id:id[index],x:x[index],y:y[index],ra:ra[index],dec:dec[index],flux:flux[index],mag:mag[index],$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   readcol,conf.catpath+'f814w.sex',format='(f,f,f,d,d,f,f,f,f,f,f,f,f,f,f,f)'$
   	  ,id,x,y,ra,dec,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   index=where(ra ge 160.97004 and ra le 160.97744 and dec ge 11.66792 and dec le 11.67497)
   ;index=where(ra ne 0)

   ;index=where(id ne 0)
   k={id:id[index],x:x[index],y:y[index],ra:ra[index],dec:dec[index],flux:flux[index],mag:mag[index],$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
   
   
   catalog={j:j,h:h,k:k}   
END

PRO MKCATALOG, cat, final
   COMMON share,conf
   
   loadconfig
   
   ; The first step is to register the catalog
   
   ; Mininum distance in pixels
   d=0.3
   
   j=0
   ; This is the flag for star registered.
   jflag=intarr(n_elements(cat.j.x))
   kflag=intarr(n_elements(cat.k.x))
   
   
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
      x=cat.h.ra[i]
      y=cat.h.dec[i]
      
      xx[i]=x
      yy[i]=y
      mh[i]=cat.h.mag[i]
      mherr[i]=cat.h.magerr[i]

      ; Looking for k band
      dist1=sqrt(((cat.k.ra-x)^2)+((cat.k.dec-y)^2))*3600.0
      ind1=where(dist1 eq min(dist1) and (min(dist1) le 0.05) and (kflag eq 0), count1)
      if (count1 ne 0) then begin
         mk[i]=cat.k.mag[ind1]
         mkerr[i]=cat.k.magerr[ind1]
         kflag[ind1]=1
      endif else begin
         mk[i]=-999.0
         mkerr[i]=-999.0
      endelse
      
      ; Looking for J band
      dist2=sqrt(((cat.j.ra-x)^2)+((cat.j.dec-y)^2))*3600.0
      ind2=where(dist2 eq min(dist2) and (min(dist2) le d) and (jflag eq 0), count2)
      if (count2 ne 0) then begin
         mj[i]=cat.j.mag[ind2]
         mjerr[i]=cat.j.magerr[ind2]
         jflag[ind2]=1
      endif else begin
         mj[i]=-999.0
         mjerr[i]=-999.0
      endelse
      
      
   endfor
   
   reind=where(kflag eq 0)
   
   print,n_elements(xx)
   for i=0,n_elements(reind)-1 do begin
      xx=[xx,cat.k.ra[reind[i]]] 
      yy=[yy,cat.k.dec[reind[i]]]  
      mj=[mj,-999.0]
      mjerr=[mjerr,-999.0]
      mh=[mh,-999.0]
      mherr=[mherr,-999.0]
      mk=[mk,cat.k.mag[reind[i]]]
      mkerr=[mkerr,cat.k.magerr[reind[i]]] 
   endfor 
	
   print,n_elements(xx)

   reind=where(jflag eq 0)
   for i=0,n_elements(reind)-1 do begin
      xx=[xx,cat.j.ra[reind[i]]] 
      yy=[yy,cat.j.dec[reind[i]]]  
      mj=[mj,cat.j.mag[reind[i]]]
      mjerr=[mjerr,cat.j.magerr[reind[i]]]
      mh=[mh,-999.0]
      mherr=[mherr,-999.0]
      mk=[mk,-999.0]
      mkerr=[mkerr,-999.0] 
   endfor 
	

	   
   ; Set the limiting magnitude of each filter
   mjlim=19.0
   mhlim=18.0
   mklim=18.0

	;print,gg
   ;eliminate stars only detected in K band 
   ;ind=where((mk ge 17.5 and mj eq -999.0 and mh eq -999.0) or (mk ge mklim) $
   ;and (mh or mhlim) and (mj or mjlim), complement=inx)
   inx=where(mk ne 0)
   
   id=indgen(n_elements(inx))
   
   final={id:id,ra:xx[inx],dec:yy[inx],mj:mj[inx],mh:mh[inx],mk:mk[inx],$
       mjerr:mjerr[inx],mherr:mherr[inx],mkerr:mkerr[inx]}

 
END

PRO FINDNOMAD, ref
   COMMON share,conf
   loadconfig

   spawn,"find2mass -c 84.8041667 35.765 -r 2.5 -m 3000 -e b > /tmp/2mass_temp.dat"
   spawn,'cat /tmp/2mass_temp.dat |sed -e "s/|/ /g"|sed -e "s/---/-999.9/g"'+$
      '> /tmp/2mass_aclient.dat'
   ;readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
   ; format='f,f,s,f,f,f,f,f,f,s',/silent
   readcol,conf.catpath+'NOMAD1.txt',ra,dec,vizier,name,ym,ra2000,dec2000,b,pmra,pmdec,pmraerr,pmdecerr,mb,mberr,mv,mverr,$
       mr,mrerr,format='f10.7,f10.7,a,a,a,f,f,a,f,f,f,f,a',/silent
   ;print,strcmp('AAA',flag)
   ind=where((strcmp('AAA',flag) eq 1) and (mjerr ge 0) and (mherr ge 0) and (mkerr ge 0) $
    and (mj ge 10) and (mh ge 10) and (mk ge 10))
   
   hdr=headfits(conf.fitspath+'s233ir_j.fits')
   
   adxy,hdr,ra,dec,x,y
   
   xsize=sxpar(hdr,'NAXIS1')
   ysize=sxpar(hdr,'NAXIS2')
   ;ind=where(x le xsize and y le ysize,count)
   
   ref={id:findgen(n_elements(ra[ind])),ra:ra[ind],dec:dec[ind],x:x[ind],$
      y:y[ind],mj:mj[ind],mh:mh[ind],mk:mk[ind],mjerr:mjerr[ind],mherr:mherr[ind],$
      mkerr:mkerr[ind]}
END



PRO GETDS9REGION, x, y, name,r=r, color=color, wcs=wcs
	COMMON share,conf	
	loadconfig

	regname = name+'.reg'
	regpath = conf.regpath
	regfile = regpath+regname
	
	;x=cat.x
	;y=cat.y
	id=indgen(n_elements(x))
	
	openw,fileunit, regfile, /get_lun	
	index = where(id eq 1)
	
	if keyword_set(wcs) then begin
		printf, fileunit, format='(A)', 'fk5'
	endif
	
	for i=0, n_elements(x)-1 do begin
		ext=0	
		regstring = 'circle('+$
                    strcompress(string(x[i],format='(f13.6)'),/remove_all)+','+$
                    strcompress(string(y[i],format='(f13.6)'),/remove_all)+','+$
                    strcompress(string(r),/remove_all)+'") #color ='+color
		printf, fileunit, format='(A)', regstring
	endfor
	
	close, fileunit
	free_lun,fileunit
END


PRO DUMPTABLE, final
	COMMON share,conf	
	loadconfig

	hdr=headfits(conf.fitspath+'hlsp_sgal_hst_wfpc2_n3351_f555w_drz.fits')
    adxy,hdr,final.ra,final.dec,x,y

	n=n_elements(final.id)
	
	close,1
    openw,1,conf.catpath+'sn2012aw_photometry_120328.txt'

	for i=0,n-1 do begin
		printf,1,format='(i,f13.5,f13.5,f10.3,f10.3,f9.3,f9.3,f9.3,f9.3,f9.3,f9.3)'$
		,final.id[i],final.ra[i],final.dec[i],x[i],y[i],final.mj[i],final.mjerr[i],final.mh[i],final.mherr[i],final.mk[i],final.mkerr[i]
	
	end
	close,1

END

PRO DUMPBANDTABLE, cat
	COMMON share,conf	
	loadconfig

	;hdr=headfits(conf.fitspath+'hlsp_sgal_hst_wfpc2_n3351_f555w_drz.fits')
    ;adxy,hdr,final.ra,final.dec,x,y

	;n=n_elements(final.id)
    
    close,1
    openw,1,conf.catpath+'catalog_2012aw_b.cat'
      for i=0, n_elements(cat.j.x)-1 do begin
         printf,1,format='(i,f13.5,f13.5,f10.3,f10.3,f8.3,f8.3)',i+1,cat.j.ra[i],cat.j.dec[i],cat.j.x[i],cat.j.y[i],cat.j.mag[i],cat.j.magerr[i]
      endfor
    close,1
	
    close,1
    openw,1,conf.catpath+'catalog_2012aw_v.cat'
      for i=0, n_elements(cat.h.x)-1 do begin
         printf,1,i+1,format='(i,f13.5,f13.5,f10.3,f10.3,f8.3,f8.3)',cat.h.ra[i],cat.h.dec[i],cat.h.x[i],cat.h.y[i],cat.h.mag[i],cat.h.magerr[i]
      endfor
    close,1
    
    close,1
    openw,1,conf.catpath+'catalog_2012aw_i.cat'
      for i=0, n_elements(cat.k.x)-1 do begin
         printf,1,i+1,format='(i,f13.5,f13.5,f10.3,f10.3,f8.3,f8.3)',cat.k.ra[i],cat.k.dec[i],cat.k.x[i],cat.k.y[i],cat.k.mag[i],cat.k.magerr[i]
      endfor
    close,1


END

