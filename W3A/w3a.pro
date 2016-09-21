@photometry
@calibassoc
@h2mapping
PRO LOADCONFIG
   COMMON share,conf

   if strcmp(!VERSION.OS,'linux') then begin 
     path='/data/disk/chyan/Projects/W3/'
   endif else begin
     path='/Volumes/Data/Projects/W3/'
   endelse
  
   wircampath=path+'WIRCam/'
   fitspath=path+'FITS/'
   pspath=path+'PS/'
   iracpath=path+'IRAC/'
   catpath=path+'Catalog/'
   regpath=path+'Regions/'
   imagepath=path+'Image/'
   confpath=path+'Config/'
   sedpath=path+'SED/'
   conf={path:path,wircampath:wircampath,fitspath:fitspath,pspath:pspath,$
      imagepath:imagepath,iracpath:iracpath,catpath:catpath,regpath:regpath,$
      confpath:confpath,sedpath:sedpath}
   
   
END

PRO RESIZEIMAGE, inname, ra, dec, xsize, ysize, outname
	COMMON share,conf
	
	loadconfig
   
   ;ra=36.489511
   ;dec=62.13785
   
   hd=headfits(conf.wircampath+inname)
   adxy,hd,ra,dec,x,y
   
   xcent=round(x)
   ycent=round(y)
  
   if file_test(conf.fitspath+outname) then spawn, 'rm -rf '+conf.fitspath+outname
   spawn,'imcopy '+"'"+conf.wircampath+inname+'['+strcompress(string(xcent-xsize/2),/remove)+$
      ':'+strcompress(string(xcent+xsize/2),/remove)+','+strcompress(string(ycent-ysize/2),/remove)+':'+$
      strcompress(string(ycent+ysize/2),/remove)+']'+"' "+conf.fitspath+outname

END

PRO TRIMIMAGES
   COMMON share,conf
   
   loadconfig
   resizeimage,'J_coadd.fits',36.489511,62.13785,4000,4000,'W3A_J.fits'
   resizeimage,'H_coadd.fits',36.489511,62.13785,4000,4000,'W3A_H.fits'
   resizeimage,'Ks_coadd.fits',36.489511,62.13785,4000,4000,'W3A_Ks.fits'
   resizeimage,'H2_coadd.fits',36.489511,62.13785,4000,4000,'W3A_H2.fits'
  
   resizeimage,'J_coadd.fits',36.800793,61.832262,4000,4000,'W3OH_J.fits'
   resizeimage,'H_coadd.fits',36.800793,61.832262,4000,4000,'W3OH_H.fits'
   resizeimage,'Ks_coadd.fits',36.800793,61.832262,4000,4000,'W3OH_Ks.fits'
   resizeimage,'H2_coadd.fits',36.800793,61.832262,4000,4000,'W3OH_H2.fits'

END

PRO GO

   trimimages
   mkassoc,36.489511,62.13785,10 
   runsexassoc
   zero=[-0.017,0.19,-0.50,0.14]
   calibassoc,zero,/ps
   
   
   getstar,cat
   find2mass,ref, 36.489511,62.13785,10 

END









