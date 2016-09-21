
PRO GENERATE_MASK, mask, im
	
	; detecting point source
	fwhm=2.5
	hmin=50
	sharplim=[0.2,1.0]
	roundlim=[-1.0,1.0]
	find,im,x,y,flux,sharp,round,hmin,fwhm,roundlim,sharplim,/silent
	
	; flag unwanted data points
	
	ind=where((x ge 450 and x le 560 and y ge 450 and y lt 550) or $
			(x ge 600 and x le 660 and y ge 360 and y lt 450) or $
			(x ge 530 and x le 578 and y ge 618 and y lt 685) or $
			(x ge 530 and x le 533 and y ge 598 and y lt 600) or $
			(x ge 562 and x le 573 and y ge 357 and y lt 366) or $
			(x ge 453 and x le 481 and y ge 230 and y lt 273) or $
			(x ge 352 and x le 373 and y ge 924 and y lt 959) or $			
			(x ge 558 and x le 631 and y ge 532 and y lt 604) or $			
			(x ge 697 and x le 716 and y ge 522 and y lt 531) or $			
         (x ge 551 and x le 563 and y ge 404 and y lt 424) or $         
         (x ge 628 and x le 712 and y ge 454 and y lt 590) or $         
			(x ge 610 and x le 618 and y ge 590 and y lt 595),complement=inx)
	
   xx=[x[inx],568,489,475,500,577,661]
   yy=[y[inx],604,533,496,495,617,216]
  
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

PRO MAP_ALL, im, line, PS = ps
   common share,conf
   loadconfig
   
   ks=im.kcont
   h2=line.h2
  
   resetplt,/all  
   clearplt,/all
   !p.multi=0
   
   if keyword_set(PS) then begin
      set_plot,'ps'
      device,filename=mappath+'h2_all.eps',$
         /color,xsize=10,ysize=20,xoffset=0,yoffset=3,$
      SET_FONT='Helvetica Bold',/TT_FONT,/encapsulated
      
     tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
   endif else begin
     blue=65535
      red=255
      green=32768    
   endelse
   !x.title = "RA offset (arcmin)"  & !y.title = "Dec offset (arcmin)"
   !p.charsize = 1.1
   !x.range=[-1,1]
   !p.font=1
   !x.thick=2.0 & !y.thick=2.0
   
  
   ; Plot grey scale
   th_image_cont,200-ks[330:694,*],crange=[0,200],/nocont,/nobar,/inverse
   
   
   ;Plot contour
   resetplt,/x,/y
   levels=median(h2)+10*[5,10,20,30,40]
   tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
   th_image_cont,medsmooth(h2[330:694,*],5),level=levels,/cont,/noerase,c_color=red,$
      xrange=[-1,1],yrange=[-2.56,2.56]
   
  ;th_image_cont,h2,crange=[0,200],/nocont,/nobar,/inverse
   
   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif


END

PRO H2_ALL, line, PS = ps
   common share,conf
   loadconfig
   
   h2=line.h2
   
   resetplt,/all  
   !p.multi=0
   
   if keyword_set(PS) then begin
      set_plot,'ps'
      device,filename=mappath+'h2_image.eps',$
         /color,xsize=10,ysize=20,xoffset=0,yoffset=3,$
      SET_FONT='Helvetica Bold',/TT_FONT,/encapsulated
      
     tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
   endif else begin
     blue=65535
      red=255
      green=32768    
   endelse
   !x.title = "RA offset (arcmin)"  & !y.title = "Dec offset (arcmin)"
   !p.charsize = 1.1
   !x.range=[-1,1]
   !p.font=1
   !x.thick=2.0 & !y.thick=2.0
   
   th_image_cont,400-smooth(h2[330:694,*],5),crange=[100,400],/nocont,/nobar,$
      xrange=[-1,1],yrange=[-2.56,2.56],ct=0
  
   
   
   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif


END

PRO MAP_REG, im, line, PS = ps
   common share,conf
   loadconfig
   
   ks=im.kcont
   h2=line.h2
   
   resetplt,/all  
   clearplt,/all
   
   if keyword_set(PS) then begin
      set_plot,'ps'
      device,filename=mappath+'h2_reg.eps',$
         /color,xsize=30,ysize=15,xoffset=0,yoffset=3,$
      SET_FONT='Helvetica Bold',/TT_FONT,/encapsulated
      
     tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
   endif else begin
     blue=65535
      red=255
      green=32768    
   endelse
   erase
   
   erase & multiplot, [4,2]
   levels=median(h2)+20*[5,10,20,30,40]
   
   ;!x.title = "RA offset(arcmin)"  & !y.title = "Dec offset(arcmin)"
   th_image_cont,200-ks,crange=[0,200],/nocont,/nobar
   oplotbox,450,650,550,750,color=blue,linestyle=2,thick=1.5
   oplotbox,535,665,500,630,color=0,linestyle=0,thick=1.3
   oplotbox,510,610,390,490,color=red,linestyle=2,thick=1.3
   oplotbox,560,710,310,460,color=blue,linestyle=0,thick=1.5
   oplotbox,640,740,440,540,color=0,linestyle=0,thick=1.3
   oplotbox,420,520,210,310,color=red,linestyle=2,thick=1.3
   oplotbox,300,400,890,990,color=blue,linestyle=2,thick=1.3
   oplot,[20,120],[40,40],thick=4
   xyouts,125,20,'30"'
   th_image_cont,medsmooth(h2,5),level=10*[5,10,20,30,40],/cont,/noerase,c_color=red & multiplot
; 
   
   ; Plot Region 1
   !p.charsize = 0.8
   th_image_cont,300.0-ks[450:650,550:750],crange=[0,300],/nocont,/nobar
   oplot,[20,30],[10,10],thick=2
   xyouts,30,10,'3"'
   th_image_cont,h2[450:650,550:750],level=levels,/cont,/noerase,c_color=red & multiplot
   ;imcontour,h2[450:650,550:750],hdr,level=levels,/overlay
   
   !p.title = ""
   th_image_cont,300-ks[535:665,500:630],crange=[0,300],/nocont,/nobar,/inverse,/nodata
   oplot,[110,120],[125,125],thick=4
   xyouts,122,123,'3"'
   levels=median(h2)+20*[5,10,20,30,40]
   th_image_cont,h2[535:665,500:630],level=levels,/cont,/noerase,c_color=red & multiplot

   
   th_image_cont,300-ks[510:610,390:490],crange=[0,300],/nocont,/nobar,/inverse
   oplot,[80,90],[95,95],thick=4
   xyouts,92,95,'3"'
   th_image_cont,h2[510:610,390:490],level=levels,/cont,/noerase,c_color=red & multiplot

   th_image_cont,800-ks[560:710,310:460],crange=[0,800],/nocont,/nobar,/inverse
   oplot,[10,20],[10,10],thick=4
   xyouts,20,10,'3"'
   th_image_cont,h2[560:710,310:460],level=levels,/cont,/noerase,c_color=red & multiplot
 
   th_image_cont,150-ks[640:740,440:540],crange=[0,150],/nocont,/nobar,/inverse
   oplot,[10,20],[10,10],thick=4
   xyouts,22,10,'3"'
   th_image_cont,h2[640:740,440:540],level=levels,/cont,/noerase,c_color=red& multiplot

   
   th_image_cont,150-ks[415:525,210:320],crange=[0,150],/nocont,/nobar,/inverse
   oplot,[10,20],[10,10],thick=4
   xyouts,22,10,'3"'
   th_image_cont,h2[415:525,210:320],level=levels,/cont,/noerase,c_color=red& multiplot
 
   th_image_cont,150-ks[300:400,890:990],crange=[0,150],/nocont,/nobar,/inverse
   oplot,[10,20],[10,10],thick=4
   xyouts,22,10,'3"'
   th_image_cont,h2[300:400,890:990],level=levels,/cont,/noerase,c_color=red& multiplot
  

   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif
   !p.multi=0
   resetplt,/all
   
   multiplot,[1,1],/init
   cleanplot,/silent

END

PRO MAP_CENTRAL, line, im, hd, PS = ps
   common share,conf
   loadconfig
   
   ks=im.kcont
   h2=line.h2
   hdr=hd.h2
   
   resetplt,/all  
  ; clearplt,/all
   if keyword_set(PS) then begin
      set_plot,'ps'
      device,filename=mappath+'iras_central.eps',$
         /color,xsize=20,ysize=20,xoffset=0,yoffset=3,$
      SET_FONT='Helvetica Bold',/TT_FONT,/encapsulated
           
   endif 
   
   ; Extracting central area
   hextract,ks, hdr, nks, hks, 461, 561, 461, 561 
   
   ;!p.title = "!6 IRAS 05358+3543"
   !x.title = "RA offset (arcsec)"  & !y.title = "Dec offset (arcsec)"
   !p.charsize = 1.3 & !p.font=1
     !x.thick=2.0 & !y.thick=2.0

   th_image_cont,1500-nks,crange=[0,1500],/nocont,$   
      ct=0,/nobar,xrange=[15,-15],yrange=[-15,15]
   
   if keyword_set(PS) then begin 
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
   endif else begin
      red=255
      green=32768
      blue=16711680  
   endelse
   
   ;Add star points as IR objects

   
   ; Over plot contours
   hextract,h2, hdr, nh2, hh2, 461, 561, 461, 561 
   levels=median(h2)+8*[8,10,15,20,30,40,50]
   th_image_cont,medsmooth(nh2,5),level=levels,/cont,/noerase,$
      c_color=red,xrange=[15,-15],yrange=[-15,15]
   
   
   
   ;Add filled triangle as water maser
   plotsym2,4,2,/fill
   plots,[1.7,-2.3,0.5,-0.3],[-2.3,-3,-5,-4],psym=8,color=3 
   ;Add filled circle as deep embedded source
   plotsym2,0,2,/fill
   plots,[1.2],[-4.2],psym=8,color=1
   
   ; Over plot CO contour
   redcont=readfits(mappath+'co-cont-red-high.fits',hd1)
   bluecont=readfits(mappath+'co-cont-blue-high.fits',hd2)
   
   hastrom,redcont,hd1,rco,rhd,hh2
   hastrom,bluecont,hd2,bco,bhd,hh2
   
   rstd=stddev(rco)
   th_image_cont,rco,/cont,/noerase,levels=rstd*[3,4,5,6],c_color=blue,$
      c_linestyle=2,c_thick=1.5
   
   rstd=stddev(bco)
   th_image_cont,bco,/cont,/noerase,levels=rstd*[3,4,5,6],c_color=blue,$
      c_linestyle=0,c_thick=1.5
   
   ; Over plot 3mm contour
;    cont=readfits(mappath+'cont.fits',hd3)  
;    hastrom,cont,hd3,ncnt,nchd,hh2 
;    rstd=stddev(cont)
;    th_image_cont,ncnt,/cont,/noerase,levels=rstd*[3,4,5,6,7,8],c_color=green,$
;       c_linestyle=0,c_thick=1.5
   
   sma=readfits(mappath+'sma.fits',hd4)  
   hastrom,sma,hd4,nsma,nhd4,hh2
   std=stddev(sma)
   th_image_cont,nsma,/cont,/noerase,levels=std*[3,5,7,9],c_color=green,$
      c_linestyle=0,c_thick=1.5
         
   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif
   resetplt,/all
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

   writefits,conf.fitspath+'s233ir_brg_nocont.fits',line.brg,header.brg
   writefits,conf.fitspath+'s233ir_h2_nocont.fits',line.h2,header.h2
   writefits,conf.fitsepath+'s233ir_mask_nocont.fits',line.mask,header.brg


END

PRO SAVESUBREGION, hdr, im, x1, x2, y1, y2, im_name
   common share,conf
   loadconfig
   hextract, im, hdr, nim,nhdr,x1,x2,y1,y2
   writefits,conf.imgpath+im_name,nim,nhdr
   
END

PRO CLUMPTABLE
   common share,conf
   loadconfig
   
   table=['clump_central','clump_reg1','clump_reg2',$
         'clump_reg3','clump_reg4','clump_reg5',$
         'clump_reg6','clump_reg7','clump_reg8',$
         'clump_reg9']
   fits=['h2_central','h2_reg1','h2_reg2',$
         'h2_reg3','h2_reg4','h2_reg5',$
         'h2_reg6','h2_reg7','h2_reg8',$
         'h2_reg9']
   nid=1
   for k=0,n_elements(table)-1 do begin
      readcol,conf.imgpath+table[k]+'.txt',id,x,y,fmax,sizex,sizey,r,flux,npix,/silent
      hd=headfits(conf.imgpath+fits[k]+'.fits')
      xyad,hd,x,y,ra,dec
      for i=0,n_elements(x)-1 do begin
         sid=string(nid,format='(I2)')
         radec=adstring(ra[i],dec[i])
         strput,radec,':',3
         strput,radec,':',6
         strput,radec,':',16
         strput,radec,':',19
         strput,radec,' & ',11
         
         imax=string((fmax[i]-33.42)/100.2,format='(f5.2)')
         itotal=string((flux[i]-33.42)/100.2,format='(f7.2)')
         s=sid+' & '+radec+"  & "+imax+' & '+itotal+' &&\\'
         print,s;,radec,(fmax[i]-33.42)/100.2,(flux[i]-33.42)/100.2,npix[i]
         nid=nid+1
      endfor
   endfor

END

PRO PLOTH2, line, hd
   common share, conf
   loadconfig
   readcol,'~/yan_h2.txt',ra,dec,flux,npix
   resetplt,/all
   x=fltarr(n_elements(ra))
   y=fltarr(n_elements(ra))
   ;for i=0,n_elements(ra)-1 do begin
      adxy,hd.h2,ra,dec,x,y
    ;  print,ra[i],dec[i],x[i],y[i]
   ;endfor
   print,x,y
   th_image_cont,line.h2,/nocont,/nobar,crange=[0,50]
   ;adxy,hd.h2,ra,dex,x,y
   oplot,x,y,psym=4,color=255
   
   
END

PRO SUBTRACT_CONT, im, line
   common share,conf
   loadconfig
   
   br=im.brg
   h2=im.h2
   cont=im.kcont
   
   
   generate_mask,mask,h2

   ; A mask for SW bright star
   nm=fltarr(1024,1024)
   nm[*,*]=1
   spawn,"wircampolyregion "+conf.regpath+'sw_brightstar.reg'+" /tmp/region.txt"
   readcol,"/tmp/region.txt",id,ext,x,y
   
   ind=where(id eq 1,complement=inx)
   maskpolyregion,nm,x[ind],y[ind]
   maskpolyregion,nm,x[inx],y[inx]
   
   ind=where(nm eq 0)
   for i=0 ,n_elements(ind)-1 do begin
      nm[ind[i]]=randomn(seed)*0.02
   end
   ; Masking bright stars
   nim1=h2*mask
   nim2=br*mask
   nim3=cont*mask
   
   
   
   ; Replace masked pixel with linear interpolation
   fixbadpix,nim1,mask,xim1
   fixbadpix,nim2,mask,xim2
   fixbadpix,nim3,mask,xim3
   
   ; Image subtraction to get H2 image
   line_h2=(xim1-xim3*1.1)*nm
   line_br=(xim2-xim3*0.5);*mask
	
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
   
      
	line={mask:mask,h2:line_h2,brg:line_br}

END

PRO LOADLINE, image, header
   COMMON share,conf
   loadconfig
   
   nim1=readfits(conf.fitspath+'s233ir_brg_nocont.fits',nhd1)
   nim2=readfits(conf.fitspath+'s233ir_h2_nocont.fits',nhd2)
   nim3=readfits(conf.fitspath+'s233ir_mask_nocont.fits',nhd3)
   
   image={h2:nim1,brg:nim2,mask:nim3}
   header={h2:nhd1,brg:nhd2,mask:nhd3}

END

PRO CUTREGION, im, hd
   common share,conf
   loadconfig
   
   savesubregion,hd.h2,im.h2,461,561,461,561,conf.imagepath+'h2_central.fits'
   savesubregion,hd.h2,im.h2,450,650,550,750,conf.imagepath+'h2_reg1.fits'
   savesubregion,hd.h2,im.h2,535,665,500,630,conf.imagepath+'h2_reg2.fits'
   savesubregion,hd.h2,im.h2,510,610,390,490,conf.imagepath+'h2_reg3.fits'
   savesubregion,hd.h2,im.h2,560,710,310,460,conf.imagepath+'h2_reg4.fits'
   savesubregion,hd.h2,im.h2,640,740,440,540,conf.imagepath+'h2_reg5.fits'
   savesubregion,hd.h2,im.h2,415,525,210,320,conf.imagepath+'h2_reg6.fits'
   savesubregion,hd.h2,im.h2,300,400,890,990,conf.imagepath+'h2_reg7.fits'
   savesubregion,hd.h2,im.h2,500,600,160,260,conf.imagepath+'h2_reg8.fits'   
   savesubregion,hd.h2,im.h2,630,760,670,800,conf.imagepath+'h2_reg9.fits'


END

