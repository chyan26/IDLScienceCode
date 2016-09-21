;
;  This is a collection of radio related packages.

PRO GETVAL,header,keys,values

  keyword = strtrim(strmid(header, 0, 8), 2)
  space = strpos( header, ' ', 10) + 1
  slash = strpos( header, '/', 10)  > space

  N = N_elements(header)
  len = (slash -10) > 20
  len = reform(len,1,N)
  lvalue = strtrim(strmid(header, 10, len),2)

  nkey = n_elements(keys)
  values = dblarr(nkey)
  for i=0,nkey-1 do values[i] = lvalue[where(keyword eq keys[i])]
  if nkey eq 1 then values=values[0]
  
END



function degls, hd
;+
; NAME:
;   DEGLS
; PURPOSE:
;   Replace GLS astrometry with SFL
; CALLING SEQUENCE:
;   DEGLS, hdr
;
; INPUTS:
;   HDR -- A FITS header
;
; OUTPUTS:
;   HDR is cleaned up in place
;
; MODIFICATION HISTORY:
;
;       Fri Dec 18 01:34:47 2009, Erik <eros@orthanc.local>
;
;   Docd.
;
;-

  hdout = hd
  naxis = sxpar(hd, 'NAXIS')
  s = strcompress(string(indgen(naxis)+1), /rem)
  for k = 1, naxis do begin
    type = sxpar(hdout, 'CTYPE'+s[k-1])
    glshit = stregex(type, 'GLS')
    if glshit ge 0 then begin
      type = strmid(type, 0, glshit)+'SFL'
      sxaddpar, hdout, 'CTYPE'+s[k-1], type
    endif 
  endfor


  return, hdout
end

; This program plots 12CO and C18O data in the same plot.

PRO PLOTCOSPEC, PS=ps

  COMMON share,conf
  loadconfig
  
  if keyword_set(ps) then begin
  
    ps_start,ps
  end
  
  
  cgerase
  multiplot,/default
  multiplot, [0,5,5,0,0], /square, gap=0.01
  vel_range=[-30,-5]

  fits=conf.sraopath+'c18oj21.fits'
  
  c18o=readfits(fits,hd)
  
 
  xpix=sxpar(hd,'NAXIS1')
  ypix=sxpar(hd,'NAXIS2')
  
  del_v=sxpar(hd,'CDELT3')/1000.0
  ref_v=sxpar(hd,'CRVAL3')/1000.0
  ref_c=sxpar(hd,'CRPIX3')


  ; 0.61 is the beam efficiency of SRAO
  c18o=(c18o)/0.61
  
  v0=(ref_v-ref_c*del_v)
  
  channel=sxpar(hd,'NAXIS3')
  
  array_vel=findgen(channel)*del_v+(ref_v-ref_c*del_v)
  
  ; Convert velocity to km s-1
  ch_v=findgen(channel)*del_v+(ref_v-ref_c*del_v)
  
  
  ; Convert from velocity range to channel range
  ; chl_range=[16,31]
  chl_range=round((vel_range-v0)/del_v)-1

  for j=ypix-1,0,-1 do begin
    for i=xpix-1,0,-1 do begin
      xtm=[-25,-5]
      if (i eq xpix-1) and (j eq 0) then begin
      cgplot,ch_v[chl_range[0]:chl_range[1]],smooth(c18o[i,j,chl_range[0]:chl_range[1]],1),psym=10,$
        yrange=[-0.5,2.5],xstyle=1,xticks=2,xrange=vel_range,charsize=0.7,$
        ystyle=1,thick=3.0,yticks=2,ytickname=['-0.5','1.0','2.5'],xtickname=['-30','-20','-5'],xtitle='Velocity',$
        ytitle='T!LMB'
        aString = '\times5'
       cgtext,-13,0.5,TeXtoIDL(aString),Charsize=0.7,color=cgcolor('red')
      endif else begin
       cgplot,ch_v[chl_range[0]:chl_range[1]],smooth(c18o[i,j,chl_range[0]:chl_range[1]],5),psym=10,$
        yrange=[-0.5,2.5],xstyle=1,yticks=0,xrange=vel_range,charsize=0.7,xticks=n_elements(xtm),$
        ystyle=1,ytickname=[' ',' ',' ',' ',' ',' ',' '],xtickname=[' ',' ',' '],thick=3.0
           
      endelse
        
      cgoplot,[-17,-17],[-20,20],line=2,color=cgcolor('purple'),thick=3.0
      newhd=degls(hd)
      xyad,newhd,i,j,ra,dec
      
      ; Extract the CO spectrum at the same position.
      extractspec,fits=conf.aropath+'CO_g173_otf.fits',spec,vel,ra,dec,vel_range
      
      ; Overplot the spectrum with the correction of beam efficiency
      cgoplot,vel,spec/0.65/5.0,psym=10,color=cgcolor('red'),thick=3.0
      
      ; Plot the number on each panel
      if 25-(j*ypix+i) le 9 then begin
        xyouts,-11,2.0,'('+strcompress(string(25-(j*ypix+i),format='(I2)'),/remove)+')',/data,charsize=0.8
      endif else begin 
        xyouts,-13,2.0,'('+strcompress(string(25-(j*ypix+i),format='(I2)'),/remove)+')',/data,charsize=0.8
      endelse
      
      multiplot
    endfor
  endfor
  
  multiplot,/reset
  if keyword_set(ps) then begin
  ps_end
  cgPS2PDF, ps
  
  endif
END

;cgerase & multiplot, [4,3], /square, gap=0.1, mXtitle='R', mYtitle='F(R)'
;       for i=0,4*3-1 do begin
;           cgplot, struct[i].x, struct[i].y, psym=4
;           multiplot
;       endfor
;       multiplot,/reset


PRO EXTRACTSPEC, FITS=FITS, SPEC, VELOCITY, RA, DEC, VEL_RANGE 
  COMMON share,conf
  loadconfig
  
  ;ra=84.909208
  ;dec=35.714159
  
  ;vel_range=[-30,-5]

  ;image=conf.aropath+'CO_g173_otf.fits'
  image=fits
  im=readfits(image,hd,/silent)

  
  xpix=sxpar(hd,'NAXIS1')
  ypix=sxpar(hd,'NAXIS2')
  
  del_v=sxpar(hd,'CDELT3')/1000.0
  ref_v=sxpar(hd,'CRVAL3')/1000.0
  ref_c=sxpar(hd,'CRPIX3')
  
  v0=(ref_v-ref_c*del_v)
  
  channel=sxpar(hd,'NAXIS3')
  
  array_vel=findgen(channel)*del_v+(ref_v-ref_c*del_v)
  
  ; Convert velocity to km s-1
  ch_v=findgen(channel)*del_v+(ref_v-ref_c*del_v)
  chl_range=round((vel_range-v0)/del_v)-1
 
  adxy,hd,ra,dec,x,y
  spec=im[floor(x),floor(y),chl_range[0]:chl_range[1]]
   velocity=ch_v[chl_range[0]:chl_range[1]]
  
END


PRO MAKECHANNELMAP
	COMMON share,conf
	loadconfig

	for i=4,24,2 do begin
		vel_range=[-30+i,-30+(i+2)]
		
		integrate_map,fits=conf.aropath+'CO_s233ir_otf_allbackend_130222.fits',$
			vel_range=vel_range,eta=0.65,outfits=conf.aropath+'chan.fits'
		
		; Trim CO moment 0 map to S233IR and G173 region
		resizeimage_co32,fits=conf.aropath+'chan.fits',$
			outfits=conf.aropath+'g173-chan.fits',imagesize=207


		confile='channel_'+strcompress(string(vel_range[0]),/remove)+'_'+$
			strcompress(string(vel_range[1]),/remove)+'.con'

		;print,file
		spawn,'ds9 '+conf.aropath+'g173-chan.fits -smooth yes -smooth radius 7 -contour yes -contour limits 4 40 '+$
			'-contour smooth 1 -contour nlevels 19 -contour save '+conf.ds9path+confile+' '
		
		regfile='channel_'+strcompress(string(vel_range[0]),/remove)+'_'+$
			strcompress(string(vel_range[1]),/remove)+'.reg'
		
		openw,lun,conf.ds9path+regfile,/get_lun
		printf,lun,'# text(1506.2935,115.85819) textangle=3.2918047e-09 font="times 14 bold roman" text={'+$
			strcompress(string(vel_range[0]),/remove)+' ~ '+strcompress(string(vel_range[1]),/remove)+' km/s}'
		close,lun
		free_lun,lun
	endfor

END

PRO MAKEOVROCHANNELMAP, PS=ps
  COMMON share,conf
  loadconfig
  
  
  vel_range=[-26,-12]
  hd=headfits(conf.bimapath+'g173cube.fits')
  
  del_v=sxpar(hd,'CDELT3')/1000.0
  ref_v=sxpar(hd,'CRVAL3')/1000.0
  ref_c=sxpar(hd,'CRPIX3')
  
  v0=(ref_v-ref_c*del_v)
  
  channel=sxpar(hd,'NAXIS3')
  
  array_vel=findgen(channel)*del_v+(ref_v-ref_c*del_v)
  ; Convert velocity to km s-1
  ch_v=findgen(channel)*del_v+(ref_v-ref_c*del_v)
  
  
  ; Convert from velocity range to channel range
  chl_range=round((vel_range-v0)/del_v)-1
  
  ; If the velocity range is inverse sequence, the step should be -1!  
  if chl_range[1] ge chl_range[0] then step=1 else step=-1
  
  allstring=''
  ; Integrate the velocity range
  for i=chl_range[0],chl_range[1],step do begin
      regfile='bima_channel_'+strcompress(string(i),/remove)+'.reg'
      openw,lun,conf.ds9path+regfile,/get_lun
      printf,lun,'# text(265,135) textangle=0.0 font="times 12 bold roman" text={'+$
        strcompress(string(ch_v[i],format='(f5.1)'),/remove)+' km/s}'
      close,lun
      free_lun,lun
      
      ;print,ch_v[i]
      index=strcompress(string(i,format='(I)'),/remove)
      string=conf.bimapath+'g173cube.fits[82:300,33:149,'+index+':'+index+'] -scale limits 0 6 -zoom to fit -cmap Heat '+$
      '-cmap value 1.63112 0.3375 '+$
      '-contour load '+conf.ds9path+'sub_g173_h2_nocont_ovro_20131023.con'+$
      ' wcs fk5 blue 1 -regions load '+conf.regpath+'g173_core_star.reg '+$
      ' -regions load '+conf.ds9path+regfile
      allstring=allstring+' '+string
  endfor
  
  spawn,'ds9 '+allstring+' -regions load '+conf.regpath+'half_pc_bar.reg '+$
  ' -match frame wcs -colorbar no -geometry 1600x1000 '+$
  '-psprint filename '+conf.pspath+ps+' '+$
  '-psprint destination file -psprint'
  
  pdfname=file_basename(ps,'.ps')
  spawn,'ps2pdf '+conf.pspath+ps+' '+conf.pspath+pdfname+'.pdf'
  
END









