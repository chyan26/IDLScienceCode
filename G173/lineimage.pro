
PRO GENERATE_MASK, mask, im
	
	; detecting point source
	fwhm=2.0
	hmin=50
	sharplim=[0.2,1.0]
	roundlim=[-1.0,1.0]
	find,im,x,y,flux,sharp,round,hmin,fwhm,roundlim,sharplim,/silent
	
	;th_image_cont,im,crange=[0,1000],/nocont
	;oplot,x,y,psym=4,color=255
	; flag unwanted data points
	
	ind=where((x ge 606 and x le 635 and y ge 593 and y lt 605) or $
;			(x ge 600 and x le 660 and y ge 360 and y lt 450) or $
;			(x ge 530 and x le 578 and y ge 618 and y lt 685) or $
;			(x ge 530 and x le 533 and y ge 598 and y lt 600) or $
;			(x ge 562 and x le 573 and y ge 357 and y lt 366) or $
;			(x ge 453 and x le 481 and y ge 230 and y lt 273) or $
;			(x ge 352 and x le 373 and y ge 924 and y lt 959) or $			
;			(x ge 558 and x le 631 and y ge 532 and y lt 604) or $			
;			(x ge 697 and x le 716 and y ge 522 and y lt 531) or $			
;         (x ge 551 and x le 563 and y ge 404 and y lt 424) or $         
;         (x ge 628 and x le 712 and y ge 454 and y lt 590) or $         
			(x ge 384 and x le 479 and y ge 425 and y lt 499),complement=inx)
;	
;   xx=[x[inx],568,489,475,500,577,661]
;   yy=[y[inx],604,533,496,495,617,216]

xx=x[inx]
yy=y[inx] 
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
			clean,im,psf,fix(xx[i]),fix(yy[i]),3,3,imconv
			imst=imst+imconv
	endfor
	
	; imconv is the stars in image.
	imconv=convolve(imst,psf)
	ind=where(imconv gt mean(imconv)+0*stddev(imconv),complement=inx)
	mask[ind]=0
	mask[inx]=1
   

       
END



PRO MASKPOLYREGION, im, x, y
    ind=polyfillv(x,y,1024,1024)
    tim=im[*,*]
    tim[ind]=0
    im[*,*]=tim[*,*]
END

PRO SAVELINEIMG, line, header
   common share,conf
   loadconfig

   writefits,conf.fitspath+'sg_g173_brg_nocont_new.fits',line.brg,header.brg
   writefits,conf.fitspath+'sg_g173_h2_nocont_new.fits',line.h2,header.h2
   ;writefits,conf.fitsepath+'sg_g173_h2.fits',line.mask,header.brg


END


PRO SUBTRACT_CONT, im, line
   common share,conf
   loadconfig
   
   br=im.brg
   h2=im.h2
   cont=im.kcont
   
   
   ;generate_mask,h2mask,h2
   ;generate_mask,brgmask,br
   generate_mask,kcontmask,cont
   
   ; A mask for SW bright star
   nm=fltarr(1024,1024)
   nm[*,*]=1
   spawn,"wircampolyregion "+conf.regpath+'linemask_brigtstars.reg'+" /tmp/region.txt"
   readcol,"/tmp/region.txt",id,ext,x,y
   
   idmax=max(id)
   
   for i=1, idmax do begin
     ind=where(id eq i,count ,complement=inx)
     if count ne 0 then maskpolyregion,nm,x[ind],y[ind]
   endfor
   
   
   th_image_cont,nm*kcontmask,crange=[0,1]
   
   mask=kcontmask*nm
   
   ; Masking bright stars
   nim1=h2*mask
   nim2=br*mask
   nim3=cont*mask
   
  
   ; Replace masked pixel with linear interpolation
   fixbadpix,nim1,kcontmask,xim1
   fixbadpix,nim2,kcontmask,xim2
   fixbadpix,nim3,kcontmask,xim3
   
   
   ; Image subtraction to get H2 image
   line_h2=(xim1-1.3*xim3);*nm
   line_br=(1.2*xim2-xim3);*mask
   ;line_br=(xim2-xim3*1.2);*mask
   
    ; Put white noise to big flagged region
   ind=where(nm eq 0)
   for i=0 ,n_elements(ind)-1 do begin
      line_h2[ind[i]]=randomn(seed)*12.0
   end
   
   

    ;newmask=line_h2
    ;ind=where(line_h2 le 0, complement=inx)
    ;newmask[ind]=0
    ;newmask[inx]=1
    ; fixbadpix,line_h2,newmask,nline_h2
; 
;    newmask=tbr
;    ind=where(tbr le 0, complement=inx)
;    newmask[ind]=0
;    newmask[inx]=1
;    fixbadpix,tbr,newmask,line_br
   
      
  line={h2:line_h2,brg:line_br}

END

PRO LOADLINE, image, header
   COMMON share,conf
   loadconfig
   
   nim1=readfits(conf.fitspath+'sg_g173_h2_new.fits',nhd1)
   nim2=readfits(conf.fitspath+'sg_g173_brg.fits',nhd2)
   nim3=readfits(conf.fitspath+'sg_g173_k.fits',nhd3)
   
   image={h2:nim1,brg:nim2,kcont:nim3}
   header={h2:nhd1,brg:nhd2,kcont:nhd3}

END

PRO H2CATALOG

   COMMON share,conf
   loadconfig

   readcol,conf.catpath+'h2bowshock.dat',id,x,y,maxflux,xfwhm,yfwhm,r,flux,npix
   
   regfile=conf.regpath+'h2bowshock_id.reg'
   color='red'
   
   openw,fileunit, regfile, /get_lun 
   for i=0, n_elements(x)-1 do begin
     ext=0 
     regstring = 'tile '+strcompress(string(ext),/remove_all)+'; image; Text('+$
                    strcompress(string(x[i]),/remove_all)+','+$
                    strcompress(string(y[i]),/remove_all)+') #text = {'+$
                    strcompress(string(id[i],format='(I2)'),/remove)+'} color ='+color
     printf, fileunit, format='(A)', regstring
   endfor
  
   close, fileunit
   free_lun,fileunit
   
   ; Reading FITS header
   hd=headfits(conf.fitspath+'sub_g173_h2_nocont_new_smooth.fits')
   
   xyad,hd,x,y,ra,dec
   radec, ra, dec, ihr, imin, xsec, ideg, imn, xsc
   rastring=strcompress(string(ihr,format='(I)'),/remove)+':'+$
            strcompress(string(imin,format='(I02)'),/remove)+':'+$
            strcompress(string(xsec,format='(F04.1)'),/remove)

   decstring=strcompress(string(ideg,format='(I)'),/remove)+':'+$
            strcompress(string(imn,format='(I02)'),/remove)+':'+$
            strcompress(string(xsc,format='(F04.1)'),/remove)
   
   mjyflux=flux*4.9e-5*1e2
   
   tabfile=conf.paperpath+'h2catalog.tex'
   
   openw,fileunit, tabfile, /get_lun  
   
   printf, fileunit, format='(A)', '\begin{table*}'
   printf, fileunit, format='(A)', '\begin{center}'
   printf, fileunit, format='(A)', '\begin{tabular}{cccccc}'
   printf, fileunit, format='(A)', '\tableline'
   printf, fileunit, format='(A)', '\tableline'
   printf, fileunit, format='(A)', 'ID & \multicolumn{2}{c}{RA \& Dec(J2000)} & $R$\tablenotemark{a} '
   printf, fileunit, format='(A)', ' & Flux (mJy, $\times 10^{-2}$) & N$_{\rm pixel}$ & Cross ID\\'
   printf, fileunit, format='(A)', '\tableline'
   printf, fileunit, format='(A)', '\tableline'
   
   for i=0, n_elements(id)-1 do begin
     pstring = strcompress(string(id[i],format='(I)'),/remove)+' & '+$
                    rastring[i]+' & '+$
                    decstring[i]+' & '+$
                   strcompress(string(r[i],format='(F5.2)'),/remove)+' & '+$
                    strcompress(string(mjyflux[i],format='(F12.2)'),/remove)+' & '+$
                    strcompress(string(npix[i],format='(I)'),/remove)+'  & \\'
     
     printf, fileunit, format='(A)', pstring
   endfor
   printf, fileunit, format='(A)', '\tableline'
   printf, fileunit, format='(A)', '\end{tabular}'
   printf, fileunit, format='(A)', '$^{\mbox{\tiny{a}}}$ Equivalent circular radius'
   printf, fileunit, format='(A)', '\end{center}'
   
   printf, fileunit, format='(A)', '\end{table*}'


   close, fileunit
   free_lun,fileunit

END





