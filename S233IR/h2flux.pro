

PRO H2SEXTRACTOR
   COMMON share,conf
   loadconfig
   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'s233ir_h2.fits -CHECKIMAGE_NAME '$
      +conf.fitspath+'check_h2.fits -CATALOG_NAME '+conf.catpath+'s233ir_h2.sex -MAG_ZEROPOINT 25.0 '$
      +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
      +' -FILTER_NAME '+conf.confpath+'default.conv '$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 7 -ANALYSIS_THRESH 4.0 '$
      +' -DETECT_THRESH 4.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '$
      +' -ASSOC_NAME '+conf.confpath+'saturated_ref.list '$
      +' -ASSOC_DATA 2,3 -ASSOC_PARAMS 2,3 -ASSOC_TYPE MAX '$
      +' -ASSOC_RADIUS 10.0 -ASSOCSELEC_TYPE -MATCHED'

END

PRO GETH2STAR, catalog
   COMMON share,conf 
   loadconfig

   ; eliminate saturated stars

   readcol,conf.catpath+'s233ir_h2.sex',id,x,y,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
   
   ;index=where(flag eq 0 and class ge 0.85 and mag le 16.2)
   index=where(id ne 0)
   h2={id:id[index],x:x[index],y:y[index],flux:flux[index],mag:mag[index]+0.221900,$
      magerr:magerr[index],a:a[index],b:b[index],i:i[index],e:e[index],$
      fwhm:fwhm[index],flag:flag[index],class:class[index]}
      
   
   catalog={h2:h2}   
END


PRO H2FLUXZP, catalog, ref, ps=ps
   COMMON share,conf 
        
   loadconfig
   
   im=readfits(conf.fitspath+'s233ir_h2.fits')
   
   !p.multi=[0,1,2]
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+'h2fluxzp.ps',$
         /color,xsize=15,ysize=25,xoffset=1.5,yoffset=0
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2   
   endif else begin
      red=255
      green=32768    
   endelse

   MATCH_CATALOG,catalog.h2.x, catalog.h2.y, catalog.h2.mag,catalog.h2.magerr,$
                 ref.x, ref.y, ref.mk, match
   err=match.magerr
        
   catmag=match.fmag1
   refmag=match.fmag2
        
   s=catmag-refmag
   s_weight= 1 / err
   s_best= total(s_weight*s)/total(s_weight)

   th_image_cont,60-im,/nocont,/nobar,crange=[0,60]
   oplot,match.x,match.y,psym=4,color=red
                        
   plot,refmag,s,psym=6,yrange=[-2.0,2.0],$
   xtitle='!6Magnitude from 2MASS Catalog',ytitle='Deteced - 2MASS',$
      title='!6J Band'

   oplot,[min(refmag),max(refmag)],[s_best,s_best]
   errplot,refmag,catmag-refmag-err,catmag-refmag+err
   print,s_best,median(s)

   if keyword_set(PS) then begin
             device,/close
      set_plot,'x'
   endif
   resetplt,/all
   !p.multi=0

END

PRO H2FLUX


   h2sextractor
   geth2star,cat
   find2mass,ref
   h2fluxzp,cat,ref


END


