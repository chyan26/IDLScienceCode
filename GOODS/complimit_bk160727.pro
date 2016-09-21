; This is the IDL script to add artificial stars and test the completeness.


PRO COMPLIMIT,FITS=fits, WEIGHTFITS=weightfits, COMP=comp,PSFILE=psfile, MAGZP=magzp, NOIM=noim, LOOPS=loops
   COMMON share,conf
   loadconfig
   
   fitsfile=fits
   
   if (keyword_set(comp) ne 1) then comp=0.99
   if keyword_set(PSFILE) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+psfile,$
         /color,xsize=15,ysize=20,xoffset=0.4,yoffset=20,$
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
  
   tmppath=conf.wircampath
   mag_min=20.0
   mag_max=25.0
   ;mag_zp=25.0
   bin=0.1
   
   hd=headfits(fitsfile)
   xsize=sxpar(hd,'NAXIS1')
   ysize=sxpar(hd,'NAXIS2')
   exptime=sxpar(hd,'EXPTIME')
   
   multiplot,/default
   multiplot,[0,1,2,0,0],gap=0.005, mTitSize=2.0,/square
  
   
   list='sky.list'
   im=readfits(fitsfile,hd)

   
   spawn,'sky -c '+conf.confpath+'sky.conf '+$
       '-IMAGE_TYPE SKY_NONOISE '+$
       '-MAG_ZEROPOINT '+strcompress(string(magzp),/remove)+' '+$
       '-EXPOSURE_TIME 1.0 '+' -IMAGE_NAME '+tmppath+'sky.fits '+$
       '-BACK_MAG '+strcompress(string(magzp+2),/remove)+' '+$
       '-IMAGE_SIZE '+strcompress(string(xsize),/remove)+','+strcompress(string(ysize),/remove)+' '+$
       '-PIXEL_SIZE 0.3 -SEEING_FWHM 0.6 '+$
       '-AUREOLE_RADIUS 0 -ARM_THICKNESS 1 '+$
       '-MAG_LIMITS '+strcompress(string(mag_min),/remove)+','+strcompress(string(mag_max),/remove)+' '+$
       '-STARCOUNT_SLOPE 0.2 -STARCOUNT_ZP 3e4 '+$
       '-GAIN 2.6 -PSF_MAPSIZE 128 -PSF_OVERSAMP 9'
    
   sky=readfits(tmppath+'sky.fits',shd)
    
   if keyword_set(NOIM) then begin
      nim=sky;+im
      weighttype='NONE'
   endif else begin
      nim=sky+im
      weighttype='MAP_WEIGHT'

   endelse
   
   writefits,tmppath+'final.fits',nim,hd
   
   spawn,'sex -c '+conf.confpath+'config_wircam.sex '+tmppath+'final.fits -MAG_ZEROPOINT '+$
       strcompress(string(magzp),/remove)+' '$
       +'-CATALOG_NAME '+tmppath+'test.cat '$
       +' -WEIGHT_IMAGE '+weightfits+' -WEIGHT_TYPE '+weighttype+' '$
       +' -PARAMETERS_NAME '+conf.confpath+'comp_assoc.param'$
       +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
       +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
       +' -ASSOC_NAME '+tmppath+'sky.list -ASSOC_TYPE NEAREST '$
       +' -ASSOC_DATA 4 -ASSOC_PARAMS 2,3 -ASSOCCOORD_TYPE PIXEL -ASSOC_RADIUS 5.0'$
       +' -ASSOC_TYPE NEAREST -ASSOCSELEC_TYPE MATCHED -CHECKIMAGE_TYPE NONE'

    
 		   
   readcol,tmppath+list,class,x,y,mag,/silent
   
   h=histogram(mag,min=mag_min,max=mag_max,bin=bin)
   xh=(findgen(n_elements(h))*bin)+mag_min
   plot,xh,h,psym=10,ytitle='Star count (N)',font=1,charsize=1.6,thick=5.0,xthick=5.0,ythick=5.0
   
		   
   readcol,tmppath+'test.cat',id,x,y,flux,fluxerr,smag,magerr,fwhm,flag,class,simmag,nassoc,/silent
   ;ind=where(class ge 0.85)
   
   sh=histogram(smag,min=mag_min,max=mag_max,bin=bin)
   sxh=(findgen(n_elements(h))*bin)+mag_min
   oplot,sxh,sh,psym=10,color=red,thick=5.0
   multiplot
   
   lim=fltarr(n_elements(h))
   for i=0,n_elements(h)-1 do begin
      lim[i]=total(sh[0:i])/total(h[0:i])
   endfor
   plot,sxh,lim,yrange=[0.8,max(lim)],font=1,charsize=1.6,$
      xtitle='Magnitude',ytitle='Completeness',$
      thick=5.0,xthick=5.0,ythick=5.0
  
   
   ; Looking for 90% completeness
   newlim=reverse(lim)
   newsxh=reverse(sxh)
   finallimitmag=interpol(newsxh,newlim,comp)

   ;oplot,[finallimitmag,finallimitmag],[0,2],color=red,thick=5.0
   ;xyouts,20,0.9,'M!D'+string(comp*100,format='(I2)')+$
   ;   '% !N = '+strcompress(string(finallimitmag,format='(f5.2)'),/remove),font=1,charsize=1.6
   
   if n_elements (comp) eq 1 then begin
      ;finallimitmag=interpol(newsxh,newlim,comp)

      oplot,[finallimitmag,finallimitmag],[0,2],color=red,thick=5.0
      xyouts,20,0.9,'M!D'+string(comp*100,format='(I2)')+$
        '% !N = '+strcompress(string(finallimitmag,format='(f5.2)'),/remove),font=1,charsize=1.6
      
      multiplot
      print,"Completeness magnitude of "+strcompress(string(comp*100,format='(I2)'),/remove)+$
        "% is ",strcompress(string(finallimitmag),/remove),' for '+file_basename(fits)

   endif else begin
      oplot,[finallimitmag[-1],finallimitmag[-1]],[0,2],color=red,thick=5.0
      xyouts,finallimitmag[-1],0.9,'M!D'+string(comp[-1]*100,format='(I2)')+$
        '% ',font=1,charsize=1.6
      
      for i=0,n_elements(comp)-1 do begin
          
          xyouts,20.5,0.95-i*0.025,'M!D'+string(comp[i]*100,format='(I2)')+$
            '% !N = '+strcompress(string(finallimitmag[i],format='(f5.2)'),/remove),font=1,charsize=1.2

          print,"Completeness magnitude of "+strcompress(string(comp[i]*100,format='(I2)'),/remove)+$
            "% is ",strcompress(string(finallimitmag[i]),/remove),' for '+file_basename(fits)      
      endfor

   endelse
   
 
   ;spawn,' rm -rf '+tmppath+'sky.fits final.fits'
   
   if keyword_set(PSFILE) then begin
     device,/close
     set_plot,'x'
   endif
   
   if keyword_set(PDF) then begin
   endif
   
   resetplt,/all

end










