PRO GENERATE_MASK, mask, im
   
   ; detecting point source
   fwhm=2.5
   hmin=50
   sharplim=[0.2,1.0]
   roundlim=[-1.0,1.0]
   find,im,x,y,flux,sharp,round,hmin,fwhm,roundlim,sharplim,/silent
   
   ; flag unwanted data points
   
;   ind=where((x ge 450 and x le 560 and y ge 450 and y lt 550) or $
;         (x ge 600 and x le 660 and y ge 360 and y lt 450) or $
;         (x ge 530 and x le 578 and y ge 618 and y lt 685) or $
;         (x ge 530 and x le 533 and y ge 598 and y lt 600) or $
;         (x ge 562 and x le 573 and y ge 357 and y lt 366) or $
;         (x ge 453 and x le 481 and y ge 230 and y lt 273) or $
;         (x ge 352 and x le 373 and y ge 924 and y lt 959) or $         
;         (x ge 558 and x le 631 and y ge 532 and y lt 604) or $         
;         (x ge 697 and x le 716 and y ge 522 and y lt 531) or $         
;         (x ge 551 and x le 563 and y ge 404 and y lt 424) or $         
;         (x ge 628 and x le 712 and y ge 454 and y lt 590) or $         
;         (x ge 610 and x le 618 and y ge 590 and y lt 595),complement=inx)
   
;   xx=[x[inx],568,489,475,500,577,661]
;   yy=[y[inx],604,533,496,495,617,216]
  
   ;th_image_cont,h2-ks/13,crange=[-5,5],/nocont
   ;oplot,x[inx],y[inx],psym=4,color=255

   ; Building star mask
   imst=fltarr(n_elements(im[*,0]),n_elements(im[0,*]))
   mask=fltarr(n_elements(im[*,0]),n_elements(im[0,*]))
   imst[*,*]=0
   mask[*,*]=0
   
   ; Building deconvole kernel
   psf=psf_gaussian(npixel=10,fwhm=3)
   
   ; Deconvolution using CLEAN algorithm
   for i=0,n_elements(xx)-1 do begin
         clean,im,psf,fix(xx[i]),fix(yy[i]),5,3,imconv
         imst=imst+imconv
   endfor
   
   ; imconv is the stars in image.
   imconv=convolve(imst,psf)
   ind=where(imconv gt mean(imconv)+0*stddev(imconv),complement=inx)
   mask[ind]=0
   mask[inx]=1
   

       
END


function shift_sub, image, x0, y0
;+
; NAME: SHIFT_SUB
; PURPOSE:
;     Shift an image with subpixel accuracies
; CALLING SEQUENCE:
;      Result = shift_sub(image, x0, y0)
;-

    
   if fix(x0)-x0 eq 0. and fix(y0)-y0 eq 0. then return, shift(image, x0, y0)
   
   s =size(image)
   x=findgen(s(1))#replicate(1., s(2))
   y=replicate(1., s(1))#findgen(s(2))
   x1= (x-x0)>0<(s(1)-1.)  
   y1= (y-y0)>0<(s(2)-1.)  
   return, interpolate(image, x1, y1)
end 

PRO SUBTRACT_CONT
   common share,conf
   loadconfig
   
   h2=readfits(conf.fitspath+'W3A_H2.fits')
   cont=readfits(conf.fitspath+'W3A_Ks.fits')
   
   generate_mask,mask,h2
   
   line=h2-shift_sub(cont/2.5,-0.5,1.5)
   
   writefits,conf.fitspath+'h2.fits',line
   generate_mask,mask,h2

   ; A mask for SW bright star
   ;nm=fltarr(1024,1024)
   ;lnm[*,*]=1
   ;spawn,"wircampolyregion "+conf.regpath+'sw_brightstar.reg'+" /tmp/region.txt"
   ;readcol,"/tmp/region.txt",id,ext,x,y
   
   ;ind=where(id eq 1,complement=inx)
   ;maskpolyregion,nm,x[ind],y[ind]
   ;maskpolyregion,nm,x[inx],y[inx]
   
   ;ind=where(nm eq 0)
   ;for i=0 ,n_elements(ind)-1 do begin
   ;   nm[ind[i]]=randomn(seed)*0.02
   ;end
   ; Masking bright stars
   ;nim1=h2*mask
   ;nim2=br*mask
   ;nim3=cont*mask
   
   
   
   ; Replace masked pixel with linear interpolation
   ;fixbadpix,nim1,mask,xim1
   ;fixbadpix,nim2,mask,xim2
   ;fixbadpix,nim3,mask,xim3
   
   ; Image subtraction to get H2 image
   ;line_h2=(xim1-xim3*1.1)*nm
   ;line_br=(xim2-xim3*0.5);*mask
   
;    newmask=th2
;    ind=where(th2 le 0, complement=inx)
;    newmask[ind]=0
;    newmask[inx]=1
;    ;fixbadpix,th2,newmask,line_h2
; 
;    newmask=tbr
;    ind=where(tbr le 0, complement=inx)
;    newmask[ind]=0
;    newmask[inx]=1
;    fixbadpix,tbr,newmask,line_br
   
      
   ;line={mask:mask,h2:line_h2,brg:line_br}

END
