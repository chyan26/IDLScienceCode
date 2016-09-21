PRO IMGEXTRACT, cra, cdec, imsize, oim, ohd, nim, nhd
  Compile_opt idl2
  On_error,2

  npar = N_params()

  if ( npar EQ 0 ) then begin
        print,'Syntax - IMGEXTRACT, cra, cdec, oim, ohd, nim, nhd'
        print,'CRA and CDEC must be in decimal DEGREES'
        return
  endif                                                                  
  
  adxy,ohd,cra,cdec,x,y
  rad=fix(imsize/2.0)  
  hextract,oim,ohd,nim,nhd,fix(x-rad+1),fix(x+rad),fix(y-rad+1), fix(y+rad)
  
  return 
END

PRO RESIZEIMAGE_S233G173
	COMMON share,conf
	loadconfig
	
	im1=readfits(conf.wircampath+'S233IR_J_coadd.fits',hd1)
	im2=readfits(conf.wircampath+'S233IR_H_coadd.fits',hd2)
	im3=readfits(conf.wircampath+'S233IR_Ks_coadd.fits',hd3)
	im4=readfits(conf.wircampath+'S233IR_H2_coadd.fits',hd4)
	im5=readfits(conf.wircampath+'S233IR_BrG_coadd.fits',hd5)
	im6=readfits(conf.wircampath+'S233IR_Kcont_coadd.fits',hd6)
	
	
	imgextract, 84.83044, 35.726082, 2048, im1, hd1, nim1, nhd1
	imgextract, 84.83044, 35.726082, 2048, im2, hd2, nim2, nhd2
	imgextract, 84.83044, 35.726082, 2048, im3, hd3, nim3, nhd3
	imgextract, 84.83044, 35.726082, 2048, im4, hd4, nim4, nhd4
	imgextract, 84.83044, 35.726082, 2048, im5, hd5, nim5, nhd5
	imgextract, 84.83044, 35.726082, 2048, im6, hd6, nim6, nhd6
	
	writefits,conf.fitspath+'g173_j.fits',nim1,nhd1
	writefits,conf.fitspath+'g173_h.fits',nim2,nhd3
	writefits,conf.fitspath+'g173_k.fits',nim3,nhd3
	writefits,conf.fitspath+'g173_h2.fits',nim4,nhd4
	writefits,conf.fitspath+'g173_brg.fits',nim5,nhd5
	writefits,conf.fitspath+'g173_kcont.fits',nim6,nhd6
	
	return

END




PRO RESIZEIMAGE_G173
	COMMON share,conf
	loadconfig
	
	im1=readfits(conf.wircampath+'S233IR_J_coadd.fits',hd1)
	im2=readfits(conf.wircampath+'S233IR_H_coadd.fits',hd2)
	im3=readfits(conf.wircampath+'S233IR_Ks_coadd.fits',hd3)
	im4=readfits(conf.wircampath+'S233IR_H2_coadd.fits',hd4)
	im5=readfits(conf.wircampath+'S233IR_BrG_coadd.fits',hd5)
	im6=readfits(conf.wircampath+'S233IR_Kcont_coadd.fits',hd6)
	
	
	imgextract, 84.858039, 35.683819, 1024, im1, hd1, nim1, nhd1
	imgextract, 84.858039, 35.683819, 1024, im2, hd2, nim2, nhd2
	imgextract, 84.858039, 35.683819, 1024, im3, hd3, nim3, nhd3
	imgextract, 84.858039, 35.683819, 1024, im4, hd4, nim4, nhd4
	imgextract, 84.858039, 35.683819, 1024, im5, hd5, nim5, nhd5
	imgextract, 84.858039, 35.683819, 1024, im6, hd6, nim6, nhd6
	
	writefits,conf.fitspath+'sg_g173_j.fits',nim1,nhd1
	writefits,conf.fitspath+'sg_g173_h.fits',nim2,nhd3
	writefits,conf.fitspath+'sg_g173_k.fits',nim3,nhd3
	writefits,conf.fitspath+'sg_g173_h2.fits',nim4,nhd4
	writefits,conf.fitspath+'sg_g173_brg.fits',nim5,nhd5
	writefits,conf.fitspath+'sg_g173_kcont.fits',nim6,nhd6
	
	return

END

PRO COMBINE11AB03
  COMMON share,conf
  loadconfig

  imlist=['11AB03_G173_H2_coadd.fits',$
          '11AB03_G173_H2_coadd.weight.fits',$
          '11AB03_G173_Kcont_coadd.fits',$
          '11AB03_G173_Kcont_coadd.weight.fits']
  
  newimlist=['sg_11ab03_g173_h2.fits',$
             'sg_11ab03_g173_h2.weight.fits',$
             'sg_11ab03_g173_kcont.fits',$
             'sg_11ab03_g173_kcont.weight.fits']
  
  for i=0,n_elements(imlist)-1 do begin
     im=readfits(conf.wircampath+imlist[i],hd) 
     imgextract, 84.858039, 35.683819, 1024, im, hd, nim, nhd
     writefits,conf.fitspath+newimlist[i],nim,nhd
  endfor
  
  imlist=[conf.fitspath+'sg_11ab03_g173_h2.fits',$
    conf.fitspath+'sg_g173_h2.fits']
  combineimage,imlist=imlist,coaddname=conf.fitspath+'sg_g173_h2_new.fits'
  
  imlist=[conf.fitspath+'sg_11ab03_g173_kcont.fits',$
    conf.fitspath+'sg_g173_kcont.fits']
  combineimage,imlist=imlist,coaddname=conf.fitspath+'sg_g173_kcont_new.fits'
  
    
END



PRO COMBINEIMAGE, IMLIST=imlist, COADDNAME=coaddname
  path='/tmp/'
  spawn,'mkdir '+path+'Temp '+path+'Projdir '+path+'Diffdir '+path+'Corrdir'
  
  for i=0,n_elements(imlist)-1 do begin
    spawn,'cp '+imlist[i]+' /tmp/Temp/'
  endfor
  
  spawn,'mImgtbl '+path+'Temp images-rawdir.tbl'
  ;spawn,'mMakeHdr images-rawdir.tbl template.hdr
  spawn,'mProjExec -p '+path+'Temp images-rawdir.tbl template.hdr '+path+'Projdir stats.tbl'
  spawn,'mImgtbl '+path+'Projdir images.tbl'
  spawn,'mOverlaps images.tbl diffs.tbl'
  spawn,'mDiffExec -p '+path+'Projdir diffs.tbl template.hdr '+path+'Diffdir'
  spawn,'mFitExec diffs.tbl fits.tbl '+path+'Diffdir'
  spawn,'mBgModel images.tbl fits.tbl corrections.tbl'
  spawn,'mBgExec -p projdir images.tbl corrections.tbl '+path+'Corrdir'
  spawn,'mAdd -p '+path+'Corrdir images.tbl template.hdr '+coaddname
  
  spawn,'rm -rf *.tbl '+path+'Temp '+path+'Projdir '+path+'Diffdir '+path+'Corrdir'
 

END

PRO RESIZEIMAGE_CO32, fits=fits, outfits=outfits, imagesize=imagesize

	COMMON share,conf
	loadconfig
	
	spawn,'swarp -c '+conf.aropath+$
		'swarp.conf -CENTER 05:39:19.4,+35:43:36.6 -CENTER_TYPE MANUAL '+$
		fits+' -IMAGE_SIZE '+strcompress(string(imagesize),/remove)+' -IMAGEOUT_NAME '+$
		outfits
	
	return

END

PRO RESIZEIMAGE_G173_RADIO, fits=fits, outfits=outfits, imagesize=imagesize
	COMMON share,conf
	loadconfig

	spawn,'swarp -c '+conf.aropath+$
		'swarp.conf -CENTER 5:39:29.9,+35:40:56.1 -CENTER_TYPE MANUAL '+$
		fits+' -IMAGE_SIZE '+strcompress(string(imagesize),/remove)+' -IMAGEOUT_NAME '+$
		outfits

	return
END


PRO TRICOLOR
   COMMON share,setting
   loadconfig
	im1=readfits(conf.wircampath+'SH2-104_J_coadd.fits',hd1)
	im2=readfits(conf.wircampath+'SH2-104_H_coadd.fits',hd2)
	im3=readfits(conf.wircampath+'SH2-104_KS_coadd.fits',hd3)
	im4=readfits(conf.path+'COORD_MINH.FITS',hd4)

	;
	; scale image to the same dimension
	hastrom, im2,hd2,tim2,thd2,hd1
	hastrom, im3,hd3,tim3,thd3,hd1
	hastrom, im4,hd4,tim4,thd4,hd1

	ind=where(tim4 le 0.0003)
	tim4[ind]=0
	
	writefits,conf.wircampath+'j.fits',im1,hd1
	writefits,conf.wircampath+'h.fits',tim2,thd2
	writefits,conf.wircampath+'k.fits',tim3,thd3
	writefits,conf.wircampath+'cs.fits',tim4,thd4
	
	cd,conf.wircampath
	spawn, 'stiff -c stiff.conf k.fits '$
		+'h.fits j.fits '$
		+'-GAMMA 1.5 -COLOUR_SAT 1.1 -MIN_LEVEL 0.01'

	spawn, 'rm -rf j.fits h.fits k.fits '
END


PRO LOADG173, image, header
	COMMON share,setting
	loadconfig
	
	nim1=readfits(conf.fitspath+'s104_j.fits',nhd1)
	nim2=readfits(conf.fitspath+'s104_h.fits',nhd2)
	nim3=readfits(conf.fitspath+'s104_k.fits',nhd3)
	
	image={j:nim1,h:nim2,k:nim3}
	header={j:nhd1,h:nhd2,k:nhd3}

END
