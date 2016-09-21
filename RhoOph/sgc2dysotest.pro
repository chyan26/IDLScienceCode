PRO SGYSOPLOT, REGION=REGION,title=title, PS=ps
   COMMON share,conf
   loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=ps,$
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
   
   prefix_array=['L1689_','L1688_','L1709_','L1712_','rho_oph_']
   
   if (keyword_set(region) and (strmatch(region,'L1689') eq 1)) then begin
     file_prefix='L1689_'
   endif
   
   if (keyword_set(region) and (strmatch(region,'L1688') eq 1)) then begin
     file_prefix='L1688_'
   endif
   
   if (keyword_set(region) and (strmatch(region,'L1709') eq 1)) then begin
     file_prefix='L1709_'
   endif
   
   if (keyword_set(region) and (strmatch(region,'L1712') eq 1)) then begin
     file_prefix='L1712_'
   endif
   
   if (keyword_set(region) and (strmatch(region,'rho_oph') eq 1)) then begin
     file_prefix='rho_oph_'
   endif
   
   
   
   if (keyword_set(region) and (strmatch(region,'all') eq 1)) then begin
      for ii=0,n_elements(prefix_array)-1 do begin
        if file_test(conf.catpath+prefix_array[ii]+'c2d_ysosgtest_J.cat') then begin
            readcol,conf.catpath+prefix_array[ii]+'c2d_ysosgtest_J.cat',nj,xj,yj,sfj,$
                ferrj,mj,merrj,aj,bj,tj,ej,fwhmj,flagj,classj,vj,nj,/silent
        endif 
        
        if file_test(conf.catpath+prefix_array[ii]+'c2d_ysosgtest_H.cat') then begin
            readcol,conf.catpath+prefix_array[ii]+'c2d_ysosgtest_H.cat',nh,xh,yh,sfh,$
                ferrh,mh,merrh,ah,bh,th,eh,fwhmh,flagh,classh,vh,nh,/silent
        endif
        
        if file_test(conf.catpath+prefix_array[ii]+'c2d_ysosgtest_Ks.cat') then begin
            readcol,conf.catpath+prefix_array[ii]+'c2d_ysosgtest_Ks.cat',nk,xk,yk,sfk,$
                ferrk,mk,merrk,ak,bk,tk,ek,fwhmk,flagk,classk,vk,nk,/silent
        endif

        if ii eq 0 then begin 
            allclassj=classj
            allclassh=classh
            allclassk=classk
        endif else begin
            allclassj=[allclassj,classj]
            allclassh=[allclassh,classh]
            allclassk=[allclassk,classk]
        endelse
      endfor
      classj=allclassj
      classh=allclassh
      classk=allclassk
   
   endif else begin
      readcol,conf.catpath+file_prefix+'c2d_ysosgtest_J.cat',nj,xj,yj,sfj,ferrj,mj,merrj,aj,bj,tj,ej,fwhmj,flagj,classj,vj,nj,/silent
      readcol,conf.catpath+file_prefix+'c2d_ysosgtest_H.cat',nh,xh,yh,sfh,ferrh,mh,merrh,ah,bh,th,eh,fwhmh,flagh,classh,vh,nh,/silent
      readcol,conf.catpath+file_prefix+'c2d_ysosgtest_Ks.cat',nk,xk,yk,sfk,ferrk,mk,merrk,ak,bk,tk,ek,fwhmk,flagk,classk,vk,nk,/silent
      
   endelse
 
   
   
   
   print,classj
   print,min(classj),min(classh),min(classk)
   
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



PRO RUNSGYSOSEX, REGION=REGION
   COMMON share,conf
   loadconfig
   
   file_suffix='_new.fits'
   weight_suffix='_new.weight.fits
 
  
   if (keyword_set(region) and (strmatch(region,'L1689') eq 1)) then begin
      file_prefix='L1689_'
   endif
  
   if (keyword_set(region) and (strmatch(region,'L1688') eq 1)) then begin
      file_prefix='L1688_'
   endif
   
   if (keyword_set(region) and (strmatch(region,'L1709') eq 1)) then begin
      file_prefix='L1709_'
   endif
   
   if (keyword_set(region) and (strmatch(region,'L1712') eq 1)) then begin
      file_prefix='L1712_'
   endif
  
   if (keyword_set(region) and (strmatch(region,'rho_oph') eq 1)) then begin
      file_prefix='rho_oph_'
   endif
  
   filter=['J','H','Ks']
   for i=0,n_elements(filter)-1 do begin
      imname=file_prefix+filter[i]+file_suffix
      catname=file_prefix+'c2d_ysosgtest_'+filter[i]+'.cat'
      assocname=file_prefix+'c2d_yso_'+filter[i]+'.assoc'
      wename=file_prefix+filter[i]+weight_suffix
      command='sex -c '+conf.confpath+'sex.conf '+conf.wircampath+imname +' -CHECKIMAGE_NAME '$
        +conf.fitspath+'soc_check_j.fits -CATALOG_NAME '+conf.catpath+catname+$
        ' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'+$
        ' -WEIGHT_IMAGE '+conf.wircampath+wename+$
        ' -WEIGHT_TYPE MAP_WEIGHT '+$
        ' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'+$
        ' -STARNNW_NAME '+conf.confpath+'default.nnw'+$
        ' -MAG_ZEROPOINT 25.0 -ASSOC_NAME '+conf.catpath+assocname+$
        ' -ASSOC_DATA 1 -ASSOC_PARAMS 2,3 -ASSOC_TYPE NEAREST -ASSOC_RADIUS 2.0'+$
        ' -PHOT_FLUXFRAC 0.5 -PHOT_AUTOPARAMS 0.5,2.5 -DETECT_THRESH 3'+$
        ' -ANALYSIS_THRESH 3  -NTHREADS 4'
      
      print,command
      spawn,command  
   endfor
  
 
END

PRO MKYSOASSOC, REGION=REGION
   COMMON share,conf
   loadconfig

   spawn,"rm -rf /tmp/ysoname.txt"
   

   if (keyword_set(region) and (strmatch(region,'L1689') eq 1)) then begin
      ;spawn, "ssh chyan@capella findyso --ra=248.056453 --dec=-24.683862 --dra=0.46 --ddec=0.70 "+$
      spawn, "ssh chyan@capella findyso --ra=248.056453 --dec=-24.683862 --dra=0.46 --ddec=0.70 "+$
      " --cat=oph  > /tmp/ysoname.txt"
       
       hdr=headfits(conf.wircampath+'L1689_Ks_new.fits')
       file_prefix='L1689_'
   endif
   
   if (keyword_set(region) and (strmatch(region,'L1688') eq 1)) then begin
      ;spawn, "ssh chyan@capella findyso  --ra=246.321350 --dec=-24.443980 --dra=1.075 --ddec=0.56 "+$
      spawn, "ssh chyan@capella findyso  --ra=246.31989 --dec=-24.446552 --dra=1.24 --ddec=0.618  "+$
      " --cat=oph  > /tmp/ysoname.txt"
       hdr=headfits(conf.wircampath+'L1688_Ks_new.fits')
       file_prefix='L1688_'       
   endif
   
   if (keyword_set(region) and (strmatch(region,'L1709') eq 1)) then begin
      spawn, "ssh chyan@capella findyso --ra=248.139466 --dec=-23.648925 --dra=0.9 --ddec=0.3 "+$
      " --cat=oph  > /tmp/ysoname.txt"
       
       hdr=headfits(conf.wircampath+'L1709_Ks_new.fits')
       file_prefix='L1709_'

   endif
   
   if (keyword_set(region) and (strmatch(region,'L1712') eq 1)) then begin
      spawn, "ssh chyan@capella findyso --ra=250.000445 --dec=-24.292101 --dra=1.45 --ddec=0.5 "+$
      " --cat=oph  > /tmp/ysoname.txt"
       
       hdr=headfits(conf.wircampath+'L1712_Ks_new.fits')
       file_prefix='L1712_'

   endif
   
   if (keyword_set(region) and (strmatch(region,'rho_oph') eq 1)) then begin
      spawn, "ssh chyan@capella findyso --ra=245.86154 --dec=-23.191563 --dra=0.8 --ddec=0.6 "+$
      " --cat=oph  > /tmp/ysoname.txt"
       
       hdr=headfits(conf.wircampath+'rho_oph_Ks_new.fits')
       file_prefix='rho_oph_'

   endif
   
   readcol,'/tmp/ysoname.txt',format='(f,a,a,f,f,f)',id,sstc2d,c2dnames,ra,dec,slope
   
   adxy,hdr,ra,dec,x,y

   ; Building the ASSOC file in defferent bands
   ; J band, selecting source without 2MASS dectection
   jind=where(x ge 0, count)
   
   socfile=conf.catpath+file_prefix+'c2d_yso_J.assoc'
   openw,fileunit, socfile, /get_lun
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[jind[i]]),/remove_all)+' '+$
                    strcompress(string(x[jind[i]]),/remove_all)+' '+$
                    strcompress(string(y[jind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit


   ; H band, selecting source without 2MASS dectection
   hind=where(x ge 0, count)
   
   socfile=conf.catpath+file_prefix+'c2d_yso_H.assoc'
   openw,fileunit, socfile, /get_lun
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[hind[i]]),/remove_all)+' '+$
                    strcompress(string(x[hind[i]]),/remove_all)+' '+$
                    strcompress(string(y[hind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit


   ; Ks band, selecting source without 2MASS dectection
   kind=where(x ge 0, count)
   
   socfile=conf.catpath+file_prefix+'c2d_yso_Ks.assoc'
   openw,fileunit, socfile, /get_lun
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[kind[i]]),/remove_all)+' '+$
                    strcompress(string(x[kind[i]]),/remove_all)+' '+$
                    strcompress(string(y[kind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit


END

PRO SGC2DYSOTEST
    COMMON share,conf
    loadconfig

    mkysoassoc,region='L1689'
    runsgysosex,region='L1689'
    sgysoplot,title='L1689 All Sources',file='L1689_ysosgtest.eps',/ps
    
    
    mkysoassoc,region='L1688'
    runsgysosex,region='L1688'
    sgysoplot,title='L1688 All Sources',file='L1689_ysosgtest.eps',/ps

END