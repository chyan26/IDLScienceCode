
PRO MKASSOC
   COMMON share,setting 
   loadconfig
   
   spawn,"rm -rf /tmp/2mass_idl.dat"
   spawn,"find2mass -c 304.39415 36.76345 -r 13 -m 30000 -e b > /tmp/2mass_temp.dat"
   spawn,'cat /tmp/2mass_temp.dat |sed -e "s/|/ /g"|sed -e "s/---/-999.9/g"'+$
      '> /tmp/2mass_aclient.dat'
   ;readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
   ; format='f,f,s,f,f,f,f,f,f,s',/silent
   readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
    format='f10.7,f10.7,a,f,f,f,f,f,f,a',/silent
   ;print,strcmp('AAA',flag)
   ind=where((strcmp('AAA',flag) eq 1) and (mjerr ge 0) and (mherr ge 0) and (mkerr ge 0) $
    and (mj ge 10) and (mh ge 10) and (mk ge 10),count)
   
   hdr=headfits(setting.wircampath+'SH2-104_J_coadd.fits')
   adxy,hdr,ra[ind],dec[ind],x,y
   close,1
   openw,1,setting.fitspath+'stars_cat_j.assoc'
      for i=0, count-1 do begin
         printf,1,i+1,format='(i,f10.3,f10.3,f8.3,f7.4,f8.3,f7.4,f8.3,f7.4)',$
         x[i],y[i],mj[ind[i]],mjerr[ind[i]],mh[ind[i]],mherr[ind[i]],mk[ind[i]],mkerr[ind[i]]
      endfor
   close,1
   getds9region,x[ind],y[ind],'reg-j-assoc',color='blue'
   
   hdr=headfits(setting.wircampath+'SH2-104_H_coadd.fits')
   adxy,hdr,ra[ind],dec[ind],x,y
   close,1
   openw,1,setting.fitspath+'stars_cat_h.assoc'
      for i=0, count-1 do begin
         printf,1,i+1,format='(i,f10.3,f10.3,f8.3,f7.4,f8.3,f7.4,f8.3,f7.4)',$
            x[i],y[i],mj[ind[i]],mjerr[ind[i]],mh[ind[i]],mherr[ind[i]],mk[ind[i]],mkerr[ind[i]]
      endfor
   close,1
   getds9region,x[ind],y[ind],'reg-h-assoc',color='green'

   hdr=headfits(setting.wircampath+'SH2-104_KS_coadd.fits')
   adxy,hdr,ra[ind],dec[ind],x,y
   close,1
   openw,1,setting.fitspath+'stars_cat_k.assoc'
      for i=0, count-1 do begin
         printf,1,i+1,format='(i,f10.3,f10.3,f8.3,f7.4,f8.3,f7.4,f8.3,f7.4)',$
            x[i],y[i],mj[ind[i]],mjerr[ind[i]],mh[ind[i]],mherr[ind[i]],mk[ind[i]],mkerr[ind[i]]
      endfor
   close,1
   getds9region,x[ind],y[ind],'reg-k-assoc',color='red'

END

PRO RUNSEXASSOC
   COMMON share,setting 
   loadconfig
   
   cd,setting.fitspath
   ; Based on the star list, do photometry on these star first
   spawn,'sex -c '+setting.fitspath+'sex.conf '+setting.wircampath+'SH2-104_J_coadd.fits -CHECKIMAGE_NAME '$
      +setting.fitspath+'soc_check_j.fits -CATALOG_NAME '+setting.fitspath+'soc_j.sex '$
      +' -PARAMETERS_NAME '+setting.fitspath+'sex_assoc.param'$
      +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME stars_cat_j.assoc -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5'$
      +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
      +' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 0.0,0.0'

   spawn,'sex -c '+setting.fitspath+'sex.conf '+setting.wircampath+'SH2-104_H_coadd.fits -CHECKIMAGE_NAME '$
      +setting.fitspath+'soc_check_h.fits -CATALOG_NAME '+setting.fitspath+'soc_h.sex '$
      +' -PARAMETERS_NAME '+setting.fitspath+'sex_assoc.param'$
      +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME stars_cat_h.assoc -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5'$
      +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
      +' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 0.0,0.0'

   spawn,'sex -c '+setting.fitspath+'sex.conf '+setting.wircampath+'SH2-104_KS_coadd.fits -CHECKIMAGE_NAME '$
      +setting.fitspath+'soc_check_k.fits -CATALOG_NAME '+setting.fitspath+'soc_k.sex '$
      +' -PARAMETERS_NAME '+setting.fitspath+'sex_assoc.param'$
      +' -MAG_ZEROPOINT 25.0 -ASSOC_NAME stars_cat_k.assoc -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '$
      +' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST'$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
      +' -ANALYSIS_THRESH 3 -PHOT_AUTOAPERS 0.0,0.0'
      
   cd,'~chyan/idl_script/Projects/S104/'   

END





PRO RUNSEXTRACTOR
	COMMON share,setting	
	loadconfig
  
  cd,setting.fitspath
  spawn,'sex -c '+setting.fitspath+'sex.conf '+setting.fitspath+'s104_j.fits -CHECKIMAGE_NAME '$
    +setting.fitspath+'check_j.fits -CATALOG_NAME '+setting.fitspath+'j.sex -MAG_ZEROPOINT 25'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
    +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '

  spawn,'sex -c '+setting.fitspath+'sex.conf '+setting.fitspath+'s104_h.fits -CHECKIMAGE_NAME '$
    +setting.fitspath+'check_h.fits -CATALOG_NAME '+setting.fitspath+'h.sex -MAG_ZEROPOINT 25'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
    +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '

  spawn,'sex -c '+setting.fitspath+'sex.conf '+setting.fitspath+'s104_k.fits -CHECKIMAGE_NAME '$
    +setting.fitspath+'check_k.fits -CATALOG_NAME '+setting.fitspath+'k.sex -MAG_ZEROPOINT 25'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
    +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '
 
  spawn,'sex -c '+setting.fitspath+'sex.conf '+setting.fitspath+'s104_j_ref.fits -CHECKIMAGE_NAME '$
    +setting.fitspath+'check_j_ref.fits -CATALOG_NAME '+setting.fitspath+'j_ref.sex -MAG_ZEROPOINT 25'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
    +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '

  spawn,'sex -c '+setting.fitspath+'sex.conf '+setting.fitspath+'s104_h_ref.fits -CHECKIMAGE_NAME '$
    +setting.fitspath+'check_h_ref.fits -CATALOG_NAME '+setting.fitspath+'h_ref.sex -MAG_ZEROPOINT 25'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
    +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '

  spawn,'sex -c '+setting.fitspath+'sex.conf '+setting.fitspath+'s104_k_ref.fits -CHECKIMAGE_NAME '$
    +setting.fitspath+'check_k_ref.fits -CATALOG_NAME '+setting.fitspath+'k_ref.sex -MAG_ZEROPOINT 25'$
    +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
    +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '
	
  cd,'~/idl_script/Projects/S104/'
END


PRO GETSTAR, catalog
	COMMON share,setting	
	loadconfig
	
	;runsextractor
		
	readcol,setting.fitspath+'j.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	;index=where(flag eq 0 and class ge 0.85 and mag le 16.2)
	index=where(id ne 0)
	j={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.131,$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
	
	readcol,setting.fitspath+'h.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	;index=where(flag eq 0 and class ge 0.85 and mag  le 15.8)
	index=where(id ne 0)
	h={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.129,$
		magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
		fwhm:fwhm[index],flag:flag[index],class:class[index]}
	
	readcol,setting.fitspath+'k.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
	
	;index=where(flag eq 0 and class ge 0.85 and mag le 15)
	index=where(id ne 0)
	k={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.140,$
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
  j={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.131,$
    magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
    fwhm:fwhm[index],flag:flag[index],class:class[index]}
  
  readcol,setting.fitspath+'h_ref.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
  
  ;index=where(flag eq 0 and class ge 0.85 and mag  le 15.8)
  index=where(id ne 0)
  h={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.129,$
    magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
    fwhm:fwhm[index],flag:flag[index],class:class[index]}
  
  readcol,setting.fitspath+'k_ref.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
  
  ;index=where(flag eq 0 and class ge 0.85 and mag le 15)
  index=where(id ne 0)
  k={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-0.140,$
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





PRO GETDS9REGION, x, y, name, color=color
  COMMON share,setting
  loadconfig

  regname = name+'.reg'
  regpath = setting.fitspath
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


