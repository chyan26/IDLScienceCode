


FUNCTION GETIMAGE, seeing=seeing, scale=scale, pix=pix,$
   flux=flux,skybg=skybg,readnoise=readnoise,$
   nopsferr=nopsferr,noskyerr=noskyerr
   
   fwhm=seeing/scale
   
   psf_err=fltarr(pix,pix)
   naxis=pix
   psf = psf_gaussian(fwhm=fwhm,npixel=naxis,/normal)*flux
   
   sky_err=RANDOMN(seed,pix,pix,poisson=skybg)
   read_err=randomn(seed,pix,pix,/normal)*readnoise
   
   for i=0,pix-1 do begin
      for j=0,pix-1 do begin
         psf_err[i,j]=randomn(seed)*sqrt(psf[i,j])+psf[i,j]
      endfor
   endfor
   
     
   ;th_image_cont,psf_err+sky_err,/nocont
   
   if keyword_set(nopsferr) then begin
      star=psf
   endif else begin
      star=psf_err
   endelse
   
   if keyword_set(noskyerr) then begin
      im=star
   endif else begin
      im=star+sky_err
   endelse

   ;print,total(im),total(im+read_err)
   return,im+read_err
   
END


PRO mockimage, fitsname=fitsname, xframes=xframes, yframes=yframes,$
   seeing=seeing, scale=scale, pix=pix,flux=flux,skybg=skybg,readnoise=readnoise
   
   seeing=seeing
   scale=scale
   flux=flux
   pix=pix
   skybg=skybg
   readnoise=readnoise
   
   tim=fltarr(xframes*pix, yframes*pix)
   
   for i=0,xframes-1 do begin
      for j=0,yframes-1 do begin
         im=getimage(SEEING=seeing,scale=scale,pix=pix,FLUX=flux,skybg=skybg,readnoise=readnoise)
         tim[(i*pix)+0:(i*pix)+pix-1,(j*pix)+0:(j*pix)+pix-1]=im
      endfor
   endfor
   
   ;print,mean(tim)
   writefits,fitsname,tim
   ;th_image_cont,tim,/nocont
end   
   
   
PRO GETPHOTOMETRY, catname, ps=ps
   
   !p.multi=[0,1,2]
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename='~/TAOS_mock/'+ps,$
         /color,xsize=15,ysize=20,xoffset=0.4,yoffset=10,$
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
   
   readcol,catname,id,x,y,aper,err_aper,auto,err_auto,/silent
   plot,id,aper,psym=4,yrange=[30,200],title=catname,font=1,xthick=5,ythick=5
 
   xyouts,0.1*n_elements(id)+1,175,'Mean Value = '+string(mean(aper),format='(f7.2)')+$
      '  STD = '+string(mean(err_aper),format='(f7.2)'),font=1,charsize=1.4
   xyouts,0.1*n_elements(id)+1,20,'Aperture Photometry',font=1,charsize=1.2
   
   plot,id,auto,psym=5,yrange=[40,220],font=1,xthick=5,ythick=5
   xyouts,0.1*n_elements(id)+1,210,'Mean Value = '+string(mean(auto),format='(f7.2)')+$
      '  STD = '+string(mean(err_auto),format='(f7.2)'),font=1,charsize=1.4
   xyouts,0.1*n_elements(id)+1,20,'Kron Photometry',font=1,charsize=1.2
   
   ;print,mean(aper),stddev(aper),mean(auto),stddev(auto)

   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif

   !p.multi=0
END


PRO GOMOCK,pix=pix, seeing=seeing,scale=scale,skybg=skybg, mag=mag, show=show, fits=fits
   ;seeing=1.2
   ;scale=0.6
   ;skybg=0.5  
   ;mag=17
   
   if mag ge 17 and mag le 19 then begin
      if mag eq 17 then flux=97.6
      if mag eq 18 then flux=39.0
      if mag eq 19 then flux=15.6
   endif else begin
      print,'Magnitude is not in defined range.'
      return   
   endelse   
   
   ;pix=15
   
   path='~/TAOS_mock/'
   filename='mock_s'+strcompress(string(seeing,format='(f4.1)'),/remove)+$
      '_p'+strcompress(string(scale,format='(f4.1)'),/remove)+$
      '_sky'+strcompress(string(skybg,format='(f4.1)'),/remove)+$
      '_R'+strcompress(string(mag,format='(I)'),/remove)+'.fits'
   
   basename=file_basename(filename,'.fits')
   psname=basename+'.ps'
   catname=basename+'.cat'
   
   mockimage,fitsname=path+filename,xframes=20,yframes=20, $
      seeing=seeing,scale=scale,flux=flux,pix=pix,skybg=skybg,readnoise=2.0
   cd,path,current=pwd
   
   spawn,'sex -c sex.conf '+filename+' -CATALOG_NAME '+catname,result
   
   cd,pwd
   
   getphotometry,path+catname,ps=psname
   
   if keyword_set(show) then begin
      spawn,'gv '+path+psname+' &'
   endif
   
   if keyword_set(fits) then begin
      spawn,'ds9 '+path+filename+' &'
   endif
   
      
END

PRO  Main
   
   gomock,pix=16,seeing=1.2,scale=0.6,skybg=0.5,mag=17
   gomock,pix=16,seeing=1.2,scale=0.6,skybg=0.5,mag=18
   gomock,pix=16,seeing=1.2,scale=0.6,skybg=0.5,mag=19
   
   gomock,pix=16,seeing=1.2,scale=0.6,skybg=4.5,mag=17
   gomock,pix=16,seeing=1.2,scale=0.6,skybg=4.5,mag=18
   gomock,pix=16,seeing=1.2,scale=0.6,skybg=4.5,mag=19
   
   gomock,pix=16,seeing=1.2,scale=1.0,skybg=1.4,mag=17
   gomock,pix=16,seeing=1.2,scale=1.0,skybg=1.4,mag=18
   gomock,pix=16,seeing=1.2,scale=1.0,skybg=1.4,mag=19
   
   gomock,pix=16,seeing=1.2,scale=1.0,skybg=12.6,mag=17
   gomock,pix=16,seeing=1.2,scale=1.0,skybg=12.6,mag=18
   gomock,pix=16,seeing=1.2,scale=1.0,skybg=12.6,mag=19
   
END










