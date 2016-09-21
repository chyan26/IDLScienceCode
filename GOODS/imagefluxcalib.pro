


;PRO IMAGEFLUXCALIB

    ;COMMON share,conf
    loadconfig
    
    image=conf.stackpath+'CHI_zjhk_detection.fits
    weight_image=conf.stackpath+'CHI_norm_detection.weight.fits
    filter='K'
    
    set_plot,'ps'
    device,filename=conf.pspath+'CHI.eps',$
      /color,xsize=15,ysize=15,xoffset=1.5,yoffset=0,$
      SET_FONT='Times',/TT_FONT,/encapsulated

    tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
    red=1
    green=2

    ;
    ;  Preparing the 2MASS Catalog
    ;
    hdr=headfits(image)
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
  
  
    socfile=conf.catpath+'2mass_cat.assoc'
    
    openw,fileunit, socfile, /get_lun
    for i=0, n_elements(ref.id)-1 do begin
      regstring =   strcompress(string(ref.id[i],format='(I)'),/remove_all)+' '+$
        strcompress(string(ref.x[i]),/remove_all)+' '+$
        strcompress(string(ref.y[i]),/remove_all)+' '+$
        strcompress(string(ref.mk[i]),/remove_all)+' '+$
        strcompress(string(ref.mkerr[i]),/remove_all)
      printf, fileunit, format='(A)', regstring
    endfor
  
    close, fileunit
    free_lun,fileunit
  
  
    spawn,'sex -c '+conf.confpath+'default.sex '+image+' -CHECKIMAGE_NAME '$
      +conf.fitspath+'check_k.fits -CATALOG_NAME '+conf.catpath+'assoc_goods.cat '$
      +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
      +' -WEIGHT_IMAGE '+weight_image+' -WEIGHT_TYPE MAP_WEIGHT '$
      +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
      +' -MAG_ZEROPOINT 28.135 -ASSOC_NAME '+conf.catpath+'2mass_cat.assoc'$
      +' -ASSOC_DATA 1,4,5 -ASSOC_PARAMS 2,3 -ASSOCCOORD_TYPE PIXEL -ASSOC_RADIUS 10.0'$
      +' -ASSOC_TYPE NEAREST -ASSOCSELEC_TYPE MATCHED'$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'$
      +' -ANALYSIS_THRESH 3 '

     
    readcol,conf.catpath+'assoc_goods.cat',id,x,y,catmag,caterr,fwhm,flag,class,asocid,refmag,referr,nassoc,$
          format='(I,F,F,F,F,f,f,I,f,f,I)',/silent
    
    
    
    if (strcmp('J',filter,/fold_case)) then m_sat=12.12
    if (strcmp('H',filter,/fold_case)) then m_sat=12.30
    if (strcmp('K',filter,/fold_case)) then m_sat=11.54

    
    ind=where(refmag ge m_sat) 
       
    s=catmag[ind]-refmag[ind]
    s_weight= 1 / referr[ind]
    s_best= total(s_weight*s)/total(s_weight)

    h=histogram(s,bin=0.01,min=-1,max=1)
    xh=getseries(-1,1,0.01)
    yfit = GAUSSFIT(xh, h, coeff, NTERMS=3)

    ;
    ;  Setting the symbol based on the data number
    ;
    if n_elements()
    ind=where(catmag le 50)
    ploterror,refmag[ind],catmag[ind]-refmag[ind],referr[ind],sqrt(referr[ind]^2+caterr[ind]^2),psym=4,$
      xrange=[min(refmag[ind]),max(refmag[ind])+0.5],yrange=[-5.0,5.0],$
      xstyle=1,ystyle=1,$
      xthick=6.0,ythick=6.0,symsize=2,/nohat,charsize=1.2,font=1



    oplot,[min(refmag),max(refmag)+1.0],[3*coeff[2],3*coeff[2]],line=1,thick=5
    oplot,[min(refmag),max(refmag)+1.0],[-3*coeff[2],-3*coeff[2]],line=1,thick=5

    oplot,[min(refmag),max(refmag)+1.0],[s_best,s_best],color=red,thick=5
    ;oplot,[min(refmag),max(refmag)],[median(s),median(s)],line=3
    
    print,'Number of 2MASS stars = ',n_elements(id)
    print,'Photometry offset = ',s_best,median(s)
    print,'Photometry error = ',coeff[2]

    
    device,/close    
    set_plot,'x'
    
    
END