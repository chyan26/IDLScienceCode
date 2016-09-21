@imaging
@photometry
@diagram
@extinction
@getklf
@stellarmass
@makefitmap
@count
@complimit
@loadavgiso
@simklf
@modelklf
@fluxcalib
@cmdclean
@calibassoc
@catalog
PRO LOADCONFIG
   COMMON share,setting
   
   ;cubepath='/arrays/cfht_3/chyan/guidecube/'
   ;cubepath='/h/archive/current/instrument/wircam/'
   ;calibpath='/data/ula/wircam/calib/'
   ;datapath='/data/wena/wircam/chyan/gcube/'
   
   ;path='/Volumes/Data/Projects/S104/'
   ;path='/data/disk/chyan/Projects/S104/'
   if strcmp(!VERSION.OS,'linux') then begin 
     path='/data/disk/chyan/Projects/S104/'
   endif else begin
     path='/Volumes/Data/Projects/S104/'
   endelse
   
   wircampath=path+'WIRCam/'
   msxpath=path+'MSX/'
   fitspath=path+'FITS/'
   pspath=path+'PS/'
   
   setting={path:path,wircampath:wircampath,msxpath:msxpath,fitspath:fitspath,pspath:pspath}
END

;
; Get 2MASS catalog from network using FITS header.
;
PRO GET2MASS, ref
   COMMON share,setting
   loadconfig

   spawn,"rm -rf /tmp/2mass_idl.dat"
   spawn,"scat -c tmc 304.493 36.75 -r 600 -n 2500 -d> /tmp/2mass_idl.dat"
   readcol,'/tmp/2mass_idl.dat',a,ra,dec,m1,m2,mag,/silent
   ;ind=where(mag ne 0)
   
   hdr=headfits(setting.fitspath+'s104_j.fits')
   
   adxy,hdr,ra,dec,x,y
   
   xsize=sxpar(hdr,'NAXIS1')
   ysize=sxpar(hdr,'NAXIS2')
   ind=where(x le xsize and y le ysize,count)
   
   ref={id:findgen(n_elements(ra[ind])),ra:ra[ind],dec:dec[ind],x:x[ind],$
      y:y[ind],mj:m1[ind],mh:m2[ind],mk:mag[ind]}
END


PRO FIND2MASS, ref
   COMMON share,setting
   loadconfig

   spawn,"rm -rf /tmp/2mass_idl.dat"
   spawn,"find2mass -c 304.493 36.75 -r 2.5 -m 3000 -e b > /tmp/2mass_temp.dat"
   spawn,'cat /tmp/2mass_temp.dat |sed -e "s/|/ /g"|sed -e "s/---/-999.9/g"'+$
      '> /tmp/2mass_aclient.dat'
   ;readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
   ; format='f,f,s,f,f,f,f,f,f,s',/silent
   readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
    format='f10.7,f10.7,a,f,f,f,f,f,f,a',/silent
   ;print,strcmp('AAA',flag)
   ind=where((strcmp('AAA',flag) eq 1) and (mjerr ge 0) and (mherr ge 0) and (mkerr ge 0) $
    and (mj ge 10) and (mh ge 10) and (mk ge 10))
   
   hdr=headfits(setting.fitspath+'s104_j.fits')
   
   adxy,hdr,ra,dec,x,y
   
   xsize=sxpar(hdr,'NAXIS1')
   ysize=sxpar(hdr,'NAXIS2')
   ;ind=where(x le xsize and y le ysize,count)
   
   ref={id:findgen(n_elements(ra[ind])),ra:ra[ind],dec:dec[ind],x:x[ind],$
      y:y[ind],mj:mj[ind],mh:mh[ind],mk:mk[ind],mjerr:mjerr[ind],mherr:mherr[ind],$
      mkerr:mkerr[ind]}
END



;
; Get 2MASS catalog from network using FITS header.
;
PRO GETREF2MASS, ref
   COMMON share,setting
   loadconfig

   spawn,"rm -rf /tmp/2mass_idl.dat"
   spawn,"scat -c tmc 304.52016 36.831121 J2000 -r 600 -n 2500 -d> /tmp/2mass_idl.dat"
   readcol,'/tmp/2mass_idl.dat',a,ra,dec,m1,m2,mag,/silent
   ;ind=where(mag ne 0)
   
   hdr=headfits(setting.fitspath+'s104_j_ref.fits')
   
   adxy,hdr,ra,dec,x,y
   
   xsize=sxpar(hdr,'NAXIS1')
   ysize=sxpar(hdr,'NAXIS2')
   ind=where(x le xsize and y le ysize,count)
   
   ref={id:findgen(n_elements(ra[ind])),ra:ra[ind],dec:dec[ind],x:x[ind],$
      y:y[ind],mj:m1[ind],mh:m2[ind],mk:mag[ind]}
END





PRO AVGEXT, cat
  
  id=where(cat.group eq 1 and cat.av ge 0, count)
  print,mean(cat.av[id]),median(cat.av[id]),stddev(cat.av[id]),count
  
  id=where(cat.group eq 2 and cat.av ge 0, count)
  print,mean(cat.av[id]),median(cat.av[id]),stddev(cat.av[id]),count
    
  id=where(cat.group ne 0 and cat.av ge 0, count)
  print,mean(cat.av[id]),median(cat.av[id]),stddev(cat.av[id]),count
END

FUNCTION ABSMAG, final, dist
	amag=final
	amag.mj=final.mj-5*(alog10(dist)-1)
	amag.mh=final.mh-5*(alog10(dist)-1)
	amag.mk=final.mk-5*(alog10(dist)-1)
	return,amag
END

PRO QUICKRUN
   getstar,cat
   getrefstar,rcat
   mkcatalog,cat,tab
   mkcatalog,rcat,rtab
   
   mkccdiagram,tab 
   
   cmdclean,tab,rtab,ctab,av=0.0,/ps
   
   absmag=absmag(ctab,4000.0)
   newderedden,absmag,final
   avgklf,mklf
   allage,final,mklf
   
   ; Case 1 d=2.0 kpc and age=0.4 M
   absmag=absmag(ctab,2500.0)
   newderedden,absmag,final
   stellarmass,final,all,age=0.1
   
END

PRO S104NOCMDSUB
   getstar,cat
   getrefstar,rcat
   
   mkcatalog,cat,tab,/select
   mkcatalog,rcat,rtab

	mkccdiagram,tab 

; 1. Plot CMD without CMD clean   
	mkhkcmd,tab,/ps,/zams   
   absmag=absmag(tab,4000.0)
	newderedden,absmag,final
	allage,final,/ps

; 2. Plot CMD with CMD clean using reference field	
	cmdclean,tab,rtab,ctab,av=0.0,/ps
	mkhkcmd,ctab,/ps,/zams
   absmag=absmag(ctab,4000.0)
   newderedden,absmag,final
   allage,final,/ps


END

PRO S104NEW
   
   ; First of all, make a ASSOC file for all regions.
   mkassoc
   
   ; Then, use sextractor to measure the flux of 2Mass stars
   runsexassoc
   
   ; Read catalog
   zero=[0.131,0.129,0.140]
   calibassoc,zero,/ps
   
   ; Run SExtractor on all images
   runsextractor
   
   loads104,image,header
   getstar,cat
   find2mass,ref

   loadref,refim,refhd
   getref2mass,rfield
   getrefstar,rcat
  
   fluxcalib,image,cat,ref,err,/ps,filename='fluxcalib.ps'
   
   mkcatalog,cat,tab
   mkcatalog,rcat,rtab
   
   mkccdiagram,tab 
   
   cmdclean,tab,rtab,ctab,av=0.0
   
   mkhkcmd,ctab,/ps
   
   absmag=absmag(ctab,8000.0)
   newderedden,absmag,final
   allage,final,/ps
   
   absmag=absmag(ctab,2000.0)
   newderedden,absmag,final
   
   avgisomass,ctab,tmpmass
   ind=where(tmpmass.ctts eq 1 and tmpmass.mass gt 0)
   print,tmpmass.mass[ind],mean(tmpmass.mass[ind])
   
   avgklf,mklf
   klfage,final,mklf
   stellarmass,final,all,age=0.1
END


PRO S104
   
   ; Extracting target image and reference images
   resizeimage
   
   loads104,image,header
   
   runsextractor
   
   getstar,cat
   find2mass,ref
   get2mass,ref
   

   fluxcalib,image,cat,ref,err,/ps,filename='fluxcalib.ps'
   PLOTMAGERR, magerr,/ps
   
   ; Photometry of reference field
   loadref,refim,refhd
   getref2mass,rfield
   getrefstar,rcat
   
   fluxzp_j,refim,rcat,rfield
   fluxzp_h,refim,rcat,rfield
   fluxzp_k,refim,rcat,rfield
    
   norstarcount,cat,rcat,/ps
   
   mkcatalog,cat,tab
   mkcatalog,rcat,rtab
   
   mkccdiagram,tab 
   
   cmdclean,tab,rtab,ctab,av=0.0,/ps
   mkccdiagram,ctab,/ps
   
   absmag=absmag(ctab,4000.0)
   newderedden,absmag,final
   
   avgext,final
   
   clusterage,final
   stellarmass,final,all
   
   clusterimf,all
   th_image_cont,im,crange=[0,300],/nocont,/nobar
   oplot,ref.x,ref.y,psym=4,color=255
   ;mkccdiagram,ref
   ;absmag=absmag(ref,350.0)
   ;mkcmd,absmag
END