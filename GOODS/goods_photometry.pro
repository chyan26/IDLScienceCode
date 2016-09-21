PRO RUNSEXTRACTOR
  COMMON share,conf
  loadconfig

  cd,conf.stackpath
  spawn,'sex -c '+conf.confpath+'config_wircam.sex '+conf.stackpath+'CHI_zjhk_detection.fits -CHECKIMAGE_NAME '$
    +conf.stackpath+'check_k.fits -CATALOG_NAME '+conf.catpath+'CHI_zjhk_stacked_k.cat  -MAG_ZEROPOINT 25.00 '$
    +' -WEIGHT_IMAGE '+conf.stackpath+'CHI_norm_detection.weight.fits '$
    +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
    +' -FILTER_NAME '+conf.confpath+'default.conv '$
    +' -STARNNW_NAME '+conf.confpath+'default.nnw '
    

  cd,'~chyan/IDLSourceCode/Science/GOODS/'
END

PRO GETSTAR, catalog, ZERO=zero
  COMMON share,conf
  loadconfig


  readcol,conf.catpath+'CHI_zjhk_stacked_k.cat',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent

  
  index=where(class ge 0.80 and mag le 15)
  ;index=where(id ne 0)
  k={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]-zero,$
    magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
    fwhm:fwhm[index],flag:flag[index],class:class[index]}


  catalog={k:k}
END


PRO FIND2MASS_GOODS, ref
  COMMON share,conf
  loadconfig

  hdr=headfits(conf.stackpath+'CHI_zjhk_detection.fits')
  xsize=sxpar(hdr,'NAXIS1')
  ysize=sxpar(hdr,'NAXIS2')
  cx=xsize/2.0
  cy=ysize/2.0

  xyad,hdr,cx,cy,cra,cdec

  spawn,"rm -rf /tmp/2mass_idl.dat"
  spawn,"ssh capella find2mass -c "+string(cra)+" "+string(cdec)+" -bd 1 -m 20000 -e b > /tmp/2mass_temp.dat"
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

    ind=where(dist eq min(dist) and min(dist) le 15,count)

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
    ;print,i,count,min(dist)

  endfor

  match={id:findgen(n_elements(x)),x:x,y:y,fmag1:fmag1,fmag2:fmag2,$
    magerr1:magerr,magerr2:magerr2}

END
