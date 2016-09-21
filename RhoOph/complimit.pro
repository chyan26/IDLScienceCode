; This is the IDL script to add artificial stars and test the completeness.


PRO COMPLIMIT,FITS=fits, COMP=comp, NEWSKY=newsky,PSFILE=psfile
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
   mag_min=17.0
   mag_max=25.0
   mag_zp=25.0
   bin=0.1
   
   hd=headfits(fitsfile)
   xsize=sxpar(hd,'NAXIS1')
   ysize=sxpar(hd,'NAXIS2')
   exptime=sxpar(hd,'EXPTIME')
   
   multiplot,/default
   multiplot,[0,1,2,0,0],gap=0.005, mTitSize=2.0,/square
  
   
   list='sky.list'
   
   if keyword_set(newsky) then begin
      spawn,'sky -c '+conf.confpath+'sky.conf -MAG_ZEROPOINT '+strcompress(string(mag_zp),/remove)+' '+$
         '-EXPOSURE_TIME 1.0 '+' -IMAGE_NAME '+tmppath+'sky.fits '+$
         '-IMAGE_SIZE '+strcompress(string(xsize),/remove)+','+strcompress(string(ysize),/remove)+' '+$
         '-PIXEL_SIZE 0.3 -SEEING_FWHM 0.7 '+$
         '-AUREOLE_RADIUS 0 -ARM_THICKNESS 1 '+$
         '-MAG_LIMITS '+strcompress(string(mag_min),/remove)+$
         ','+strcompress(string(mag_max),/remove)+' '+$
         '-STARCOUNT_SLOPE 0.1 -STARCOUNT_ZP 1e4 '+$
         '-GAIN 3.0'
      
      im=readfits(fitsfile,hd)
      sky=readfits(tmppath+'sky.fits',shd)
      
      nim=sky+im
      writefits,tmppath+'final.fits',nim,hd
   
      spawn,'sex -c '+conf.confpath+'sex.conf '+tmppath+'final.fits -MAG_ZEROPOINT '+$
         strcompress(string(mag_zp),/remove)+' '$
         +'-CATALOG_NAME '+tmppath+'test.cat '$
         +' -PARAMETERS_NAME '+conf.confpath+'sex_assoc.param'$
         +' -FILTER_NAME '+conf.confpath+'gauss_2.0_3x3.conv'$
         +' -STARNNW_NAME '+conf.confpath+'default.nnw'$
         +' -ASSOC_NAME '+tmppath+'sky.list -ASSOC_TYPE NEAREST '$
         +' -ASSOC_DATA 1 -CHECKIMAGE_TYPE NONE'
   
   endif 
		   
   readcol,tmppath+list,class,x,y,mag,/silent
   
   h=histogram(mag,min=mag_min,max=mag_max,bin=bin)
   xh=(findgen(n_elements(h))*bin)+mag_min
   plot,xh,h,psym=10,ytitle='Star count (N)',font=1,charsize=1.6,thick=5.0,xthick=5.0,ythick=5.0
   
		   
   readcol,tmppath+'test.cat',id,x,y,flux,ferr,smag,magerr,a,b,i,e,fwhm,flag,class,/silent
   sh=histogram(smag,min=mag_min,max=mag_max,bin=bin)
   sxh=(findgen(n_elements(h))*bin)+mag_min
   oplot,sxh,sh,psym=10,color=red,thick=5.0
   multiplot
   
   lim=fltarr(n_elements(h))
   for i=0,n_elements(h)-1 do begin
      lim[i]=total(sh[0:i])/total(h[0:i])
   endfor
   plot,sxh,lim,yrange=[0,1.2],font=1,charsize=1.6,$
      xtitle='Magnitude',ytitle='Completeness',$
      thick=5.0,xthick=5.0,ythick=5.0
  
   
   ; Looking for 90% completeness
   newlim=reverse(lim)
   newsxh=reverse(sxh)
   finallimitmag=interpol(newsxh,newlim,comp)
   
   oplot,[finallimitmag,finallimitmag],[0,2],color=red,thick=5.0
   xyouts,20,0.9,'M!D'+string(comp*100,format='(I2)')+$
      '% !N = '+strcompress(string(finallimitmag,format='(f5.2)'),/remove),font=1,charsize=1.6
   multiplot
   
   print,"Limiting magnitude is ",strcompress(string(finallimitmag),/remove),' for '+file_basename(fits)  

   if keyword_set(newsky) then spawn,' rm -rf '+tmppath+'sky.fits '+tmppath+'final.fits'
   
   if keyword_set(PSFILE) then begin
     device,/close
     set_plot,'x'
   endif
   resetplt,/all

end