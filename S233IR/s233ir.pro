@imaging
@photometry
@fluxcalib
@loadavgiso
@cmdclean
@deredden
@diagrams
@count
@stellarmass
;@textable
@iracstar
@iraccolor
@klfimf
@simklf
@cloudmass
;@brgimage
@modelklf
@lineregions
@dust
@h2flux
@tricolor

PRO LOADCONFIG
	COMMON share,conf
	
	;Settings for HOME computer
	;imgpath = '/Volumes/disk1s1/Projects/S233IR/'
	;mappath = '/Volumes/disk1s1/Projects/S233IR/'
	
	;Settings for ASIAA computer
	;path='/data/disk/chyan/Projects/S233IR/'
   
   ;Setting for Mac computer
   if strcmp(!VERSION.OS,'linux') then begin 
     path='/data/disk/chyan/Projects/S233IR/'
   endif else begin
     path='/Volumes/Science/Projects/S233IR/'
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



;
; Get 2MASS catalog from network using FITS header.
;
PRO GET2MASS, ref
   COMMON share,conf
   loadconfig

	spawn,"rm -rf /tmp/2mass_idl.dat"
	spawn,"scat -c tmc 84.8041667 35.765 J2000 -r 250 -n 500 -d> /tmp/2mass_idl.dat"
	readcol,'/tmp/2mass_idl.dat',a,ra,dec,m1,m2,mag
	ind=where(mag le 15)
	
	hdr=headfits(conf.fitspath+'s233ir_j.fits')
	
	adxy,hdr,ra,dec,x,y

	
	ref={id:findgen(n_elements(ra)),ra:ra[ind],dec:dec[ind],x:x[ind],$
		y:y[ind],mj:m1[ind],mh:m2[ind],mk:mag[ind]}
END

;
; Get 2MASS catalog from network using FITS header.
;
PRO GETREF2MASS, ref
   COMMON share,conf
   loadconfig
   
   spawn,"rm -rf /tmp/2mass_idl.dat"
   spawn,"scat -c tmc 84.66706 35.702143 J2000 -r 250 -n 500 -d> /tmp/2mass_idl.dat"
   readcol,'/tmp/2mass_idl.dat',a,ra,dec,m1,m2,mag
   ind=where(mag le 15)
 
   hdr=headfits(conf.fitspath+'s233ir_j_ref.fits')
   
   adxy,hdr,ra,dec,x,y

   
   ref={id:findgen(n_elements(ra)),ra:ra[ind],dec:dec[ind],x:x[ind],$
      y:y[ind],mj:m1[ind],mh:m2[ind],mk:mag[ind]}
END
PRO FIND2MASS, ref
   COMMON share,conf
   loadconfig

   spawn,"rm -rf /tmp/2mass_idl.dat"
   spawn,"find2mass -c 84.8041667 35.765 -r 2.5 -m 3000 -e b > /tmp/2mass_temp.dat"
   spawn,'cat /tmp/2mass_temp.dat |sed -e "s/|/ /g"|sed -e "s/---/-999.9/g"'+$
      '> /tmp/2mass_aclient.dat'
   ;readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
   ; format='f,f,s,f,f,f,f,f,f,s',/silent
   readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
    format='f10.7,f10.7,a,f,f,f,f,f,f,a',/silent
   ;print,strcmp('AAA',flag)
   ind=where((strcmp('AAA',flag) eq 1) and (mjerr ge 0) and (mherr ge 0) and (mkerr ge 0) $
    and (mj ge 10) and (mh ge 10) and (mk ge 10))
   
   hdr=headfits(conf.fitspath+'s233ir_j.fits')
   
   adxy,hdr,ra,dec,x,y
   
   xsize=sxpar(hdr,'NAXIS1')
   ysize=sxpar(hdr,'NAXIS2')
   ;ind=where(x le xsize and y le ysize,count)
   
   ref={id:findgen(n_elements(ra[ind])),ra:ra[ind],dec:dec[ind],x:x[ind],$
      y:y[ind],mj:mj[ind],mh:mh[ind],mk:mk[ind],mjerr:mjerr[ind],mherr:mherr[ind],$
      mkerr:mkerr[ind]}
END



;
; Get Porras catalog from file
;
PRO GETPORRAS, hdr, ref
	COMMON share,conf
	loadconfig
	readcol,conf.catpath+'porras.cat',id,ra,dec,mj,mjerr,mh,mherr,mk,mkerr,av,m
	;ind=where(abs(m2-mag) le 0.9)
	
	adxy,hdr,ra,dec,x,y

   cmj=mj-11.28-0.270*av
   cmh=mh-11.28-0.142*av      
   cmk=mk-11.28-0.081*av

   ;Selecting NE cluster
   neind=where((((x-537.0)^2 + (y-530.0)^2) le 11000) or $
   (x ge 436 and x le 448 and y ge 454 and y le 471),count)
   group=intarr(n_elements(x))   
   group[neind]=1
   
   swind=where(((x-659.0)^2 + (y-369.0)^2) le 10000 ,count) 
   group[swind]=2

   ind=where((((x-659.0)^2 + (y-369.0)^2) le 10000) $
      or (((x-537.0)^2 + (y-530.0)^2) le 11000 or $
      (x ge 436 and x le 448 and y ge 454 and y le 471)), complement=inx)      
   group[inx]=3
	
	ref={id:findgen(n_elements(ra)),ra:ra,dec:dec,x:x,y:y,mj:mj,mh:mh,mk:mk,$
         mjerr:mjerr,mherr:mherr,mkerr:mkerr,cmj:cmj,cmh:cmh,cmk:cmk,av:av,$
         mass:m,group:group}
END



PRO GETDS9TEXT, text,x, y, name, color=color
  COMMON share,conf 
  loadconfig

  regname = name+'.reg'
  regpath = mappath
  regfile = regpath+regname
  
  ;x=cat.x
  ;y=cat.y
  id=indgen(n_elements(x))
  
  openw,fileunit, regfile, /get_lun 
  index = where(id eq 1)
  ;printf, fileunit, 'global color=green dashlist=8 3 width=1 font="helvetica 10 normal" select=1 high lite=1 dash=0 fixed=0 edit=1 move=1 delete=1 include=1 source=1 physical'
  for i=0, n_elements(x)-1 do begin
    print,x[i],i
    ext=0 
    regstring = '# text('+$
                    strcompress(string(x[i]),/remove_all)+','+$
                    strcompress(string(y[i]),/remove_all)+') width=2 '+$
                    ' text= {'+strcompress(string(text[i]),/remove_all)+'}'
    printf, fileunit, format='(A)', regstring
  endfor
  
  close, fileunit
  free_lun,fileunit


END

PRO GETDS9REGION, x, y, name, color=color
	COMMON share,conf	
	loadconfig

	regname = name+'.reg'
	regpath = conf.regpath
	regfile = regpath+regname
	
	;x=cat.x
	;y=cat.y
	id=indgen(n_elements(x))
	
	openw,fileunit, regfile, /get_lun	
	index = where(id eq 1)
	for i=0, n_elements(x)-1 do begin
		ext=0	
		regstring = 'tile '+strcompress(string(ext),/remove_all)+'; image; circle('+$
                    strcompress(string(x[i]),/remove_all)+','+$
                    strcompress(string(y[i]),/remove_all)+',10) #color ='+color
		printf, fileunit, format='(A)', regstring
	endfor
	
	close, fileunit
	free_lun,fileunit
END

PRO AVGEXT, cat
  
  id=where(cat.group eq 1 and cat.av ge 0, count)
  print,mean(cat.av[id]),median(cat.av[id]),stddev(cat.av[id]),count
  
  id=where(cat.group eq 2 and cat.av ge 0, count)
  print,mean(cat.av[id]),median(cat.av[id]),stddev(cat.av[id]),count
  
  id=where(cat.group eq 3 and cat.av ge 0, count)
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
  
  daophot,cat  
  ; Make catalog and group stars
  mkcatalog,cat,tmp
  groupstar,tmp,final
       
   
  ; Load reference field
  getrefstar,rcat
  mkcatalog,rcat,rtab
   
  mkccdiagram,final,/ps
   
  ; Use reference field to clean the CMD
  cmdclean,final,rtab,ctab,/ps
 
   
  ; Absolite magnitude
  absmag=absmag(ctab,1800.0)
     
  ; Correcting extinction
  newderedden, absmag, corrcat
         
  ; Age estimation 
  getageplot,corrcat,/ps
  
  ; Calculate the mass based on MLR
  stellarmass,corrcat, all 
   
  ; Plot IMFs of clusters
  clusterimf,all
  allimf,all
   
  ysoregion, corrcat
   
  sfeprofile,all,/ps 
  	
END


PRO H2REGION
  loads233ir,im,hd
  subtract_cont,im,line
END

PRO S233IR
	resizeimage,im,hd
	
	loads233ir,im,hd
   daophot,cat
	get2mass, ref
	
	fluxcalib,im,cat,ref,magerr,/ps,filename='fluxcalib.ps'
	
	plotmagerr,magerr,/ps
	
	; Make catalog and group stars
	mkcatalog,cat,tmp
  groupstar,tmp,final
    
  ; Star count and compare with Porras 2000   
  getporras,hd.j,porrascat
  norstarcount,cat  
  ;clustercount,final,porrascat
   
   
  ; Load reference field
  loadref,refim,refhd
  getref2mass,rfield
  runsextractor
  getrefstar,rcat
  fluxcalib,refim,rcat,rfield,/ps,filename='fluxcalib_ref.ps'
  mkcatalog,rcat,rtab
   
  mkccdiagram,final,/ps
   
   ; Use reference field to clean the CMD
   cmdclean,final,rtab,ctab,/ps
 
   
   ; Absolite magnitude
   absmag=absmag(ctab,1800.0)
   porabs=absmag(porrascat,1800.0)
     
   ; Correcting extinction
   newderedden, absmag, corrcat
   newderedden, porabs, porcor

   ; Compare KLF
   klfcomp,corrcat,porrascat,/ps
   fieldklfcomp,corrcat,porrascat
   		   
   ; Age estimation 
   getageplot,corrcat,/ps
  
   ; Calculate the mass based on MLR
   stellarmass,corrcat, all 
   
	; Plot IMFs of clusters
   clusterimf,all
   allimf,all
   
   ysoregion, ctab
   
   dustmap,corrcat 
   clusterklf,all,porrascat
   klf,all
   
   
   iraccatalog,irac
   mergecat,all,irac,merge
   mksed,merge
   
   textable,merge
   
   subtract_cont,im,line
   savelineimg,line,hd
END

