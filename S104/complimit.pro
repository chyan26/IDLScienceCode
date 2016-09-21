; This is the IDL script to add artificial stars and test the completeness.


Pro COMPLIMIT
  COMMON share,setting
  loadconfig
  
  fitsfile=setting.fitspath+'s104_j.fits'
  limit=0.99
  
  tmppath='/Volumes/data/Projects/S104/Completeness/'
  mag_min=17.0
  mag_max=25.0
  mag_zp=25.0
  bin=0.1

  hd=headfits(fitsfile)
  xsize=sxpar(hd,'NAXIS1')
  exptime=sxpar(hd,'EXPTIME')
  
  !p.multi=[0,1,2]
  list='sky.list'
  cd, tmppath
  spawn,'sky -c sky.conf -MAG_ZEROPOINT '+strcompress(string(mag_zp),/remove)+' '+$
  		'-EXPOSURE_TIME 1.0 -IMAGE_HEADER '+fitsfile+' '+$
  		'-IMAGE_SIZE '+strcompress(string(xsize),/remove)+' '+$
  		'-PIXEL_SIZE 0.3 -SEEING_FWHM 0.7 '+$
  		'-AUREOLE_RADIUS 0 -ARM_THICKNESS 1 '+$
  		'-MAG_LIMITS '+strcompress(string(mag_min),/remove)+$
  		','+strcompress(string(mag_max),/remove)+' '+$
  		'-STARCOUNT_SLOPE 0.2 -STARCOUNT_ZP 1e5 '+$
  		'-GAIN 3.0'
     
  im=readfits(fitsfile,hd)
  sky=readfits(tmppath+'sky.fits',shd)

  nim=sky;+im
  writefits,tmppath+'final.fits',nim,hd

		
  readcol,tmppath+list,class,x,y,mag



  h=histogram(mag,min=mag_min,max=mag_max,bin=bin)
  xh=(findgen(n_elements(h))*bin)+mag_min
  plot,xh,h,psym=10

  spawn,'sex -c sex.conf final.fits -MAG_ZEROPOINT '+$
  		strcompress(string(mag_zp),/remove)+' '+$
  		'-ASSOC_NAME sky.list -ASSOC_TYPE NEAREST '+$
  		'-ASSOC_DATA 1 '
		
  readcol,tmppath+'test.cat',id,sx,sy,smag
  sh=histogram(smag,min=mag_min,max=mag_max,bin=bin)
  sxh=(findgen(n_elements(h))*bin)+mag_min
  oplot,sxh,sh,psym=10,color=255


  lim=fltarr(n_elements(h))
  for i=0,n_elements(h)-1 do begin
  	lim[i]=total(sh[0:i])/total(h[0:i])
  endfor
  plot,sxh,lim,yrange=[0,2]
  
  ind=where(lim le limit and sxh ge 18)
  oplot,[sxh[ind[0]],sxh[ind[0]]],[0,100]
  
  ;print,sxh[ind[0]]
  
  cd, '/Users/chyan/idl_script/Projects/S104/'
  !p.multi=0
end