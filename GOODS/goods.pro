@goods_photometry
@fluxcalib
@obsregion
@complimit

PRO LOADCONFIG
   COMMON share,conf
   
   !path=!path+':'+'~chyan/IDLSourceCode/Library/textoidl/'
   
   if strcmp(!VERSION.OS,'linux') then begin 
     path='/data/disk/chyan/Projects/GOODSN/'
   endif else begin
     path='/Volumes/Science/Projects/GOODSN/'
   endelse
  
   wircampath=path+'WIRCam/'
   fitspath=path+'FITS/'
   pspath=path+'PS/'
   stackpath=path+'Stacked/'
   catpath=path+'Catalog/'
   regpath=path+'Regions/'
   imagepath=path+'Image/'
   confpath=path+'Config/'
   ds9path=path+'DS9/'
   sraopath=path+'SRAO/'
   bimapath=path+'BIMA/'
   conf={path:path,wircampath:wircampath,fitspath:fitspath,pspath:pspath,$
      imagepath:imagepath,stackpath:stackpath,catpath:catpath,regpath:regpath,$
      confpath:confpath,ds9path:ds9path,sraopath:sraopath,bimapath:bimapath}
END


PRO RESIZEIMAGE, image, header
	COMMON share,conf
	
	loadconfig
	; Load images
	path=imgpath
	
	im1=readfits(path+'HDF.I.fits',hd1)
	im2=readfits(path+'goodsn_j_071130_rsb.fits',hd2)
	im3=readfits(path+'goodsn_k_071210_rsb.fits',hd3)
	
	;
	; scale image to the same dimension
	hastrom, im2,hd2,tim2,thd2,hd1
	
	;
	; Generate a header with center at 05:39:13.0 35:45:54.0
	shd=hd1
	sxaddpar,shd,'CRVAL1',189.228621
	sxaddpar,shd,'CRVAL2',62.238661
	sxaddpar,shd,'CRPIX1',3065.5
	sxaddpar,shd,'CRPIX2',3079
	
	;
	; scale image to the same dimension
	hastrom, im1,hd1,tim1,thd1,shd
	hastrom, im2,hd2,tim2,thd2,shd
	hastrom, im3,hd3,tim3,thd3,shd
	
	;
	; cut interesting area
	
	hextract, tim1, thd1, nim1,nhd1,700,5600,552,5530
	hextract, tim2, thd2, nim2,nhd2,700,5600,552,5530
	hextract, tim3, thd3, nim3,nhd3,700,5600,552,5530

	; Operate on images
	nim1=nim1/200.0
	
	ind=where(nim2 le 0)
	nim2[ind]=0
	
	ind=where(nim3 le 0)
	nim3[ind]=0
	
	image={i:nim1,j:nim2,k:nim3}
	header={i:nhd1,j:nhd2,k:nhd3}
	
	return

END

PRO SAVEFITS, image, header
  COMMON share,conf
	loadconfig
	
	writefits,imgpath+'goodsn_i.fits',image.i,header.i
	writefits,imgpath+'goodsn_j.fits',image.j,header.j
	writefits,imgpath+'goodsn_k.fits',image.k,header.k
END


PRO RUNSTIFF
  COMMON share,conf
	
	loadconfig
	
	cd, imgpath
	spawn,'stiff -c stiff.conf goodsn_k.fits goodsn_j.fits goodsn_i.fits'+$
		' -GAMMA 0.9 -COLOUR_SAT 1.5'
END

PRO GOODSCOMP
  COMMON share,conf
  loadconfig

 
  complimit,fits=conf.wircampath+'goodsn_J_120614_WDX.fits',weightfits=conf.wircampath+'goodsn_J_120614_WDX.weight.fits',$
    comp=[0.80,0.85,0.90,0.95],psfile='goodsn_J_120614_WDX.eps',magzp=24.034,loops=5
 
  complimit,fits=conf.wircampath+'goodsn_H_160208_WDX.fits',weightfits=conf.wircampath+'goodsn_H_160208_WDX.weight.fits',$
    comp=[0.80,0.85,0.90,0.95],psfile='goodsn_H_160208_WDX.eps',magzp=23.897,loops=5;,dmag=0.8

  complimit,fits=conf.wircampath+'goodsn_K_120607_WDX.fits',weightfits=conf.wircampath+'goodsn_K_120607_WDX.weight.fits',$
    comp=[0.80,0.85,0.90,0.95],psfile='goodsn_K_120607_WDX.eps',magzp=23.917,loops=5,dmag=0.5
  


END


PRO GOODS
  COMMON share,conf
  loadconfig

  resizeimage,im,hd
  savefits,im,hd
  runstiff
  
  
  runsextractor
  getstar,cat,zero=-2.97118
  getds9region,cat.k.x,cat.k.y,file='star.reg',color='green',size=30
 
  find2mass_goods,ref
  getds9region,ref.x,ref.y,file='ref_2mass.reg',color='red',size=20

 
  fluxcalib,cat, ref, ps='CHI.eps', region='GOODS'
  
   
END

















