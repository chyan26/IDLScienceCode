PRO OBSREGION,ps = ps
  COMMON share,conf
  
  loadconfig
  if keyword_set(PS) then begin 
    set_plot,'ps'
    device,filename=conf.pspath+'obsregion.eps',$
      /color,xsize=20,ysize=15,xoffset=0.4,yoffset=10,$
      SET_FONT='Helvetica',/TT_FONT,/encapsulated
         
      
    tvlct,[0,255,0,0,255],[0,0,255,0,255],[0,0,0,255,0]
    red=1
    green=2
    blue=3
    yellow=4
  endif else begin
    blue=65535
    red=255
    green=32768    
  endelse

  fits=conf.extpath+'OphA_ExtnCambR_F.fits'
  
  im=readfits(fits)
  hd=headfits(fits)
  im=max(im)-im
  hextract, im, hd, newim, newhd, 150, 314, 150, 290, SILENT = silent

  xim=sxpar(newhd,'NAXIS1')
  yim=sxpar(newhd,'NAXIS2')
  xyad,newhd,0,0,a0,d0
  xyad,newhd,xim,yim,a1,d1
  
  !x.range=[a0,a1]
  !y.range=[d0,d1]
  !x.thick=8
  !y.thick=8
  !x.charsize=1.3
  !y.charsize=1.3
  !p.charthick=5.0
  
  !p.font=1
  
  crange=[1,8]
  th_image_cont,newim,/nocont,/nobar,crange=crange
  spawn,'ls '+conf.wircampath+'/*J*coadd.fits',result

  for i=0, n_elements(result)-1 do begin
    shd=headfits(result[i])
    ra=sxpar(shd,'CRVAL1')
    dec=sxpar(shd,'CRVAL2')
    size=sxpar(shd,'NAXIS1')*sxpar(shd,'CD1_1')
    oplotbox,ra-size/2,ra+size/2,dec-size/2,dec+size/2,color=3,thick=4
    xyouts,ra,dec,i+1,color=1,font=1
    print,size^2
  endfor  
  
  
  if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
  endif
  
  resetplt,/all
  

END



PRO GETDS9REGION, x, y,file=file, color=color, size=size
   COMMON share,conf 
   loadconfig
   
   ;readcol,conf.catpath+'/asiaa/home/chyan/test.cat',ra,dec,fj,fh,fk
   ;regname = 'mips.reg'
   ;regpath = conf.regpath
   regfile = conf.regpath+file
   
   ;x=cat.x
   ;y=cat.y
   id=indgen(n_elements(x))
   
   if keyword_set(size) then dsize=strcompress(string(size),/remove) else dsize=3
   
   openw,fileunit, regfile, /get_lun   
   index = where(id eq 1)
   for i=0, n_elements(x)-1 do begin
      ext=0 
      regstring = ' circle('+$
                    strcompress(string(x[i],format='(F13.7)'),/remove_all)+', '+$
                    strcompress(string(y[i],format='(F13.7)'),/remove_all)+','+dsize+') #color ='+color
      printf, fileunit, format='(A)', regstring
   endfor
   
   close, fileunit
   free_lun,fileunit
END


PRO SEDREGION, file=file, reg=regfile, color=color

   COMMON share,conf 
   loadconfig

   table=mrdfits(conf.fitspath+file,1)

   openw,fileunit, conf.regpath+regfile, /get_lun   
   for i=0, n_elements(table[*].x)-1 do begin
      ext=0 
      regstring = 'fk5; circle('+$
                    strcompress(string(table[i].x,format='(F11.7)'),/remove_all)+'d,'+$
                    strcompress(string(table[i].y,format='(F11.7)'),/remove_all)+'d,5") #color = '+$
                    color+' text={'+string(table[i].source_name,format='(A24)')+'}'
      printf, fileunit, format='(A)', regstring
      
   endfor
   
   close, fileunit
   free_lun,fileunit

END









