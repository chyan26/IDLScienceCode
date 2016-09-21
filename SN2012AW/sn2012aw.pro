@diagram
@imaging
@photometry
@calibassoc
PRO LOADCONFIG
	COMMON share,conf
	
	;Settings for HOME computer
	;imgpath = '/Volumes/disk1s1/Projects/S233IR/'
	;mappath = '/Volumes/disk1s1/Projects/S233IR/'
	
	;Settings for ASIAA computer
	;path='/data/disk/chyan/Projects/S233IR/'
   
   ;Setting for Mac computer
   if strcmp(!VERSION.OS,'linux') then begin 
     path='/data/disk/chyan/Projects/SN2012aw/'
   endif else begin
     path='/Volumes/Data/Projects/SN2012aw/'
   endelse
  
   wircampath=path+'WIRCam/'
   fitspath=path+'FITS/'
   pspath=path+'PS/'
   iracpath=path+'IRAC/'
   catpath=path+'Catalog/'
   regpath=path+'Region/'
   imagepath=path+'Image/'
   confpath=path+'Config/'
   sedpath=path+'SED/'
   conf={path:path,wircampath:wircampath,fitspath:fitspath,pspath:pspath,$
      imagepath:imagepath,iracpath:iracpath,catpath:catpath,regpath:regpath,$
      confpath:confpath,sedpath:sedpath}
	
; 	color=[[255,0,0],]
; tvlct,255,0,0,1                         ; $$ red
; tvlct,240,0,240,2                       ; $$ magenta
; tvlct,245,133,20,3                      ; $$ orange
; tvlct,255,250,0,4                       ; $$ ellow
; tvlct,0,255,0,5                         ; $$ light green
; tvlct,12,158,22,6                       ; $$ green
; tvlct,0,0,255,7                         ; $$ blue
; tvlct,0,225,255,8                       ; $$ ligth blue
; tvlct,138,37,182,9                      ; $$ purple
; tvlct,0,0,0,10                          ; $$ black
	
END


PRO sn2012aw


	runsextractor
	getstar,cat
    
    getds9region,cat.j.ra,cat.j.dec,'band1',r=0.1,color='blue',/wcs
    getds9region,cat.h.ra,cat.h.dec,'band2',r=0.2,color='green',/wcs
    getds9region,cat.k.ra,cat.k.dec,'band3',r=0.3,color='red',/wcs
    
    mkcatalog,cat,final
 	
 	ind=where(final.mh ge 0 and final.mk ge 0)
 	getds9region,final.ra[ind],final.dec[ind],'viband',r=0.3,color='red'
 	getds9region,final.ra,final.dec,'allband',r=0.3,color='red',/wcs
 	dumptable,final
 	
 	cmdplot,final
 	
 	mkassoc
 	runsexassoc
 	calibassoc,[-0.431200,0.484201,1.28160],/ps
END
