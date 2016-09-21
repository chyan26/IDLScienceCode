
; This function read irac catalog into IDL and transform the RA DEC to X Y.
PRO IRACCATALOG, cat
   COMMON share,imgpath, mappath 
   loadconfig

   hd=headfits(imgpath+'s233ir_h2.fits')
   
   factor=0.033846
   
   RESTORE,imgpath+'irac_i1_080509.db'
   ;[ra,dec,rnd,shp,aper,insky,outsky,mag,magerr,sky,skyerr,user_status]
   id=indgen(n_elements(pv_dat[0,*]))
   ra=reform(pv_dat[0,*])
   dec=reform(pv_dat[1,*])
   flux=factor*1.049*10^((25.0-reform(pv_dat[7,*]))/2.5)
   ; factor 0.338 is the factor transform MJy/sr to mJy/pixel
   mag=-2.5*alog10((flux)/280900.0)
   magerr=reform(pv_dat[8,*])
   
   f1=factor*1.049*10^((25-(reform(pv_dat[7,*])-magerr))/2.5)
   f2=factor*1.049*10^((25-(reform(pv_dat[7,*])+magerr))/2.5)
   fluxerr=f1-f2
   
   adxy,hd,ra,dec,x,y
   
   ind=where(x ge 0 and x le 1024 and y ge 0 and y le 1024)
   i1={id:id[ind],x:x[ind],y:y[ind],flux:flux[ind],fluxerr:fluxerr[ind],$
      mag:mag[ind],magerr:magerr[ind]}

   RESTORE,imgpath+'irac_i2_080509.db'
   ;[ra,dec,rnd,shp,aper,insky,outsky,mag,magerr,sky,skyerr,user_status]
   id=indgen(n_elements(pv_dat[0,*]))
   ra=reform(pv_dat[0,*])
   dec=reform(pv_dat[1,*])
   flux=factor*1.050*10^((25.0-reform(pv_dat[7,*]))/2.5)
   fluxerr=10^((25.0-reform(pv_dat[8,*]))/2.5)
   mag=-2.5*alog10((flux)/179700.0)
   magerr=reform(pv_dat[8,*])
   f1=factor*1.050*10^((25-(reform(pv_dat[7,*])-magerr))/2.5)
   f2=factor*1.050*10^((25-(reform(pv_dat[7,*])+magerr))/2.5)
   fluxerr=f1-f2
  
   adxy,hd,ra,dec,x,y
   
   ind=where(x ge 0 and x le 1024 and y ge 0 and y le 1024)
   i2={id:id[ind],x:x[ind],y:y[ind],flux:flux[ind],fluxerr:fluxerr[ind],$
      mag:mag[ind],magerr:magerr[ind]}
   
   RESTORE,imgpath+'irac_i3_080509.db'
   ;[ra,dec,rnd,shp,aper,insky,outsky,mag,magerr,sky,skyerr,user_status]
   id=indgen(n_elements(pv_dat[0,*]))
   ra=reform(pv_dat[0,*])
   dec=reform(pv_dat[1,*])
   flux=factor*1.058*10^((25.0-reform(pv_dat[7,*]))/2.5)
   mag=-2.5*alog10((flux)/115000.0)
   magerr=reform(pv_dat[8,*])
   
   f1=factor*1.058*10^((25-(reform(pv_dat[7,*])-magerr))/2.5)
   f2=factor*1.058*10^((25-(reform(pv_dat[7,*])+magerr))/2.5)
   fluxerr=f1-f2
   adxy,hd,ra,dec,x,y
   
   ind=where(x ge 0 and x le 1024 and y ge 0 and y le 1024)
   i3={id:id[ind],x:x[ind],y:y[ind],flux:flux[ind],fluxerr:fluxerr[ind],$
      mag:mag[ind],magerr:magerr[ind]}

   RESTORE,imgpath+'irac_i4_080509.db'
   ;[ra,dec,rnd,shp,aper,insky,outsky,mag,magerr,sky,skyerr,user_status]
   id=indgen(n_elements(pv_dat[0,*]))
   ra=reform(pv_dat[0,*])
   dec=reform(pv_dat[1,*])
   flux=factor*1.068*10^((25.0-reform(pv_dat[7,*]))/2.5)
   mag=-2.5*alog10((flux)/64130.0)
   magerr=reform(pv_dat[8,*])
   f1=factor*1.068*10^((25-(reform(pv_dat[7,*])-magerr))/2.5)
   f2=factor*1.068*10^((25-(reform(pv_dat[7,*])+magerr))/2.5)
   fluxerr=f1-f2
   
   adxy,hd,ra,dec,x,y
   
   ind=where(x ge 0 and x le 1024 and y ge 0 and y le 1024)
   i4={id:id[ind],x:x[ind],y:y[ind],flux:flux[ind],fluxerr:fluxerr[ind],$
      mag:mag[ind],magerr:magerr[ind]}
   
   cat={i1:i1,i2:i2,i3:i3,i4:i4}     
END

PRO LOADIRAC, cat
   COMMON share,imgpath, mappath 
   loadconfig
   
   readcol,imgpath+'spitzer_i1.txt',id,x,y,flux,mag,err
   i1={id:id,x:x,y:y,flux:flux}
   readcol,imgpath+'spitzer_i2.txt',id,x,y,flux,mag,err
   i2={id:id,x:x,y:y,flux:flux}
   readcol,imgpath+'spitzer_i3.txt',id,x,y,flux,mag,err
   i3={id:id,x:x,y:y,flux:flux}
   readcol,imgpath+'spitzer_i4.txt',id,x,y,flux,mag,err
   i4={id:id,x:x,y:y,flux:flux}


END



; This program is used to 
PRO MERGECAT, wircam, irac, merge
   COMMON share,imgpath, mappath 
   loadconfig
   j=0
   
   ; Transform magnitude to observers' frame

   mj=wircam.cmj+5*(alog10(1800.0)-1)
   mh=wircam.cmh+5*(alog10(1800.0)-1)
   mk=wircam.cmk+5*(alog10(1800.0)-1)

   i1flag=intarr(n_elements(irac.i1.x))
   i2flag=intarr(n_elements(irac.i2.x))
   i3flag=intarr(n_elements(irac.i3.x))
   i4flag=intarr(n_elements(irac.i4.x))
   
   i1flux=fltarr(n_elements(wircam.y))
   i2flux=fltarr(n_elements(wircam.y))
   i3flux=fltarr(n_elements(wircam.y))
   i4flux=fltarr(n_elements(wircam.y))
   
   i1mag=fltarr(n_elements(wircam.y))
   i2mag=fltarr(n_elements(wircam.y))
   i3mag=fltarr(n_elements(wircam.y))
   i4mag=fltarr(n_elements(wircam.y))
   
   i1fluxerr=fltarr(n_elements(wircam.y))
   i2fluxerr=fltarr(n_elements(wircam.y))
   i3fluxerr=fltarr(n_elements(wircam.y))
   i4fluxerr=fltarr(n_elements(wircam.y))

   i1magerr=fltarr(n_elements(wircam.y))
   i2magerr=fltarr(n_elements(wircam.y))
   i3magerr=fltarr(n_elements(wircam.y))
   i4magerr=fltarr(n_elements(wircam.y))
   
   for i=0,n_elements(wircam.mk)-1 do begin
      dist1=((wircam.x[i]-irac.i1.x)^2)+((wircam.y[i]-irac.i1.y)^2)
      dist2=((wircam.x[i]-irac.i2.x)^2)+((wircam.y[i]-irac.i2.y)^2)
      dist3=((wircam.x[i]-irac.i3.x)^2)+((wircam.y[i]-irac.i3.y)^2)
      dist4=((wircam.x[i]-irac.i4.x)^2)+((wircam.y[i]-irac.i4.y)^2)
      
      ind1=where((dist1 le 4.5) and (dist1 eq min(dist1)) and (i1flag eq 0),count1)
      ind2=where((dist2 le 4.5) and (dist2 eq min(dist2)) and (i2flag eq 0),count2)
      ind3=where((dist3 le 4.5) and (dist3 eq min(dist3)) and (i3flag eq 0),count3)
      ind4=where((dist4 le 5.5) and (dist4 eq min(dist4)) and (i4flag eq 0),count4)
      if wircam.x[i] ge 0 and wircam.x[i] le 1000 and $
      wircam.y[i] ge 420 and wircam.y[i] le 430 then begin
      	print,wircam.x[i],wircam.y[i]
      endif
     
      if count1 ne 0 then begin
         i1flux[i]=irac.i1.flux[ind1]
         i1mag[i]=irac.i1.mag[ind1]
         i1fluxerr[i]=irac.i1.fluxerr[ind1]
         i1magerr[i]=irac.i1.magerr[ind1]
         i1flag[ind1]=1
      endif else begin
         i1flux[i]=-999.0
         i1mag[i]=-999.0
         i1fluxerr[i]=-999.0
         i1magerr[i]=-999.0
      endelse

      if count2 ne 0 then begin
         i2flux[i]=irac.i2.flux[ind2]
         i2mag[i]=irac.i2.mag[ind2]
         i2fluxerr[i]=irac.i2.fluxerr[ind2]
         i2magerr[i]=irac.i2.magerr[ind2]
         i2flag[ind2]=1
      endif else begin
         i2flux[i]=-999.0
         i2mag[i]=-999.0
         i2fluxerr[i]=-999.0
         i2magerr[i]=-999.0
      endelse

      if count3 ne 0 then begin
         i3flux[i]=irac.i3.flux[ind3]
         i3mag[i]=irac.i3.mag[ind3]
         i3fluxerr[i]=irac.i3.fluxerr[ind3]
         i3magerr[i]=irac.i3.magerr[ind3]
         i3flag[ind3]=1
      endif else begin
         i3flux[i]=-999.0
         i3mag[i]=-999.0
         i3fluxerr[i]=-999.0
         i3magerr[i]=-999.0
      endelse
     
      if count4 ne 0 then begin
         i4flux[i]=irac.i4.flux[ind4]
         i4mag[i]=irac.i4.mag[ind4]
         i4fluxerr[i]=irac.i4.fluxerr[ind4]
         i4magerr[i]=irac.i4.magerr[ind4]
         i4flag[ind4]=1
      endif else begin
         i4flux[i]=-999.0
         i4mag[i]=-999.0
         i4fluxerr[i]=-999.0
         i4magerr[i]=-999.0
      endelse
    
      
   endfor
   
   jflux=(10^((mj)/(-2.5)))*1594.0e3
   hflux=(10^((mh)/(-2.5)))*1024.0e3
   kflux=(10^((mk)/(-2.5)))*667.0e3
 
   ind=where(i4flux ge 0,count)
   print,count
   getds9region,wircam.x[ind],wircam.y[ind],'irac4_dection.reg',color='red'
   merge={id:wircam.id,$
         x:wircam.x,y:wircam.y,$
         mj:wircam.mj,mh:wircam.mh,mk:wircam.mk,$
         mjerr:wircam.mjerr,mherr:wircam.mherr,mkerr:wircam.mkerr,$
         omj:mj,omh:mh,omk:mk,$
         cmj:wircam.cmj,cmh:wircam.cmh,cmk:wircam.cmk,$
         jflux:jflux, hflux:hflux, kflux:kflux,$
         av:wircam.av,avk:wircam.avk,mass:wircam.mass,$
         i1flux:i1flux,i2flux:i2flux,i3flux:i3flux,i4flux:i4flux,$
         i1mag:i1mag,i2mag:i2mag,i3mag:i3mag,i4mag:i4mag,$
         i1fluxerr:i1fluxerr,i2fluxerr:i2fluxerr,i3fluxerr:i3fluxerr,i4fluxerr:i4fluxerr,$
         i1magerr:i1magerr,i2magerr:i2magerr,i3magerr:i3magerr,i4magerr:i4magerr}

END

FUNCTION phertz2pmicron, micron
   
   ;c=double(299792458.00)
   c=double(299792.45800)
   con=(c/micron)*1e9

   return,con
END

PRO MKSED, cat
   COMMON share,imgpath, mappath 
   loadconfig

   ;ind=where( (cat.mj ge 0 and cat.mh ge 0 and cat.mk ge 0)$
   ;         and (cat.i1flux ge 0 ) and (cat.mh-cat.mk ge 1),count)
   ;ind=where( (cat.mj ge 0 and cat.mh ge 0 and cat.mk ge 0)$
   ;         and (cat.i1flux ge 0 and cat.i2flux ge 0),count)
   ind=where((cat.hflux ge 0 and cat.kflux ge 0)$
            and (cat.i1flux gt 0.0 and cat.i2flux gt 0.0 and cat.i3flux gt 0),count)
   print,count
   ;ind=where(cat.mh ge 0)
   check =0
   if check eq 1 then begin
      x=665
      y=211
      ind=where(cat.x ge x-1 and cat.x le x+1 and cat.y ge y-1 and cat.y le y+1)
   endif
   ;ind=where(cat.mj ne 0,count)

   x=cat.x[ind]
   y=cat.y[ind]
   id=cat.id[ind]
   ; Transfer magitude to flux in the unit of mJy
   jflux=cat.jflux[ind]
   hflux=cat.hflux[ind]
   kflux=cat.kflux[ind]
   
   ; Calculate the extinction law and apply it to IRAC data.
   i1a=2.5^(cat.av[ind]*0.071)
   i2a=2.5^(cat.av[ind]*0.058)
   i3a=2.5^(cat.av[ind]*0.054)
   i4a=2.5^(cat.av[ind]*0.054)
   
      
   ; Transform Fv to vFv
   jvfv=jflux*1e-26*phertz2pmicron(1.252)
   hvfv=hflux*1e-26*phertz2pmicron(1.631)
   kvfv=kflux*1e-26*phertz2pmicron(2.146)
   i1vfv=i1a*cat.i1flux[ind]*1e-26*phertz2pmicron(3.56)
   i2vfv=i2a*cat.i2flux[ind]*1e-26*phertz2pmicron(4.52)
   i3vfv=i3a*cat.i3flux[ind]*1e-26*phertz2pmicron(5.73)
   i4vfv=i4a*cat.i4flux[ind]*1e-26*phertz2pmicron(7.91)
   
   i1ferr=cat.i1fluxerr[ind]*1e-26*phertz2pmicron(3.6)
   i2ferr=cat.i2fluxerr[ind]*1e-26*phertz2pmicron(4.5)
   i3ferr=cat.i3fluxerr[ind]*1e-26*phertz2pmicron(5.8)
   i4ferr=cat.i4fluxerr[ind]*1e-26*phertz2pmicron(8.0)
 
   lamda=[1.252,1.631,2.145,3.56,4.52,5.73,7.91]
    !p.multi=[0,4,4]
   set_plot,'ps'
   device,filename=mappath+'iras_band.ps',$
         /color,xsize=20,ysize=20,xoffset=0,yoffset=2
   tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
   
  

   a=fltarr(n_elements(jflux))
   for i=0,n_elements(jflux)-1 do begin
   ;for i=0,15 do begin
      vfv=[jvfv[i],hvfv[i],kvfv[i],i1vfv[i],i2vfv[i],i3vfv[i],i4vfv[i]]
      
      ;err=[0,0,0,i1ferr[i],i2ferr[i],i3ferr[i],i4ferr[i]]
      
      plot,lamda,vfv,/xlog,/ylog,psym=4,yrange=[1e-15,1e-7],$
         title=id[i]
    ;  errplot,lamda,vfv-err,vfv+err
    ;  oplot,[1,10],[1e-11,1e-13],line=2
    ;  oplot,[1,10],[1e-12,1e-15],line=2
      
      vfv1=[i1vfv[i],i2vfv[i],i3vfv[i],i4vfv[i]]
      wave=[3.56,4.52,5.73,7.91]
      inx=where(vfv1 ge 1e-15)
      coef=linfit(alog10(wave[inx]),alog10(vfv1[inx]),sigma=sigma,yfit=yfit)
      a[i]=coef[1]
      ;print,a[i]
    	;if coef[1] ge -2.0 then begin
      ;	plot,lamda,vfv,/xlog,/ylog,psym=4,yrange=[1e-15,1e-9],$
      ;   	title=id[i]
    	;endif
    
      oplot,[2.145,3.56,4.52,5.73,7.91],10^yfit
      ;oplot,[lamda[0],lamda[0]],[1e-12,1e-6],line=3,thick=0.01
      ;oplot,[lamda[1],lamda[1]],[1e-12,1e-6],line=3,thick=0.01
      ;oplot,[lamda[2],lamda[2]],[1e-12,1e-6],line=3,thick=0.01
      ;oplot,[lamda[3],lamda[3]],[1e-12,1e-6],line=3,thick=0.01
      ;oplot,[lamda[4],lamda[4]],[1e-12,1e-6],line=3,thick=0.01
      ;oplot,[lamda[5],lamda[5]],[1e-12,1e-6],line=3,thick=0.01
      ;oplot,[lamda[6],lamda[6]],[1e-12,1e-6],line=3,thick=0.01
      ;wait,0.5
   endfor
   
   c1=where(a ge 0.1,count1)
   c2=where(a ge -2.0 and a lt 0.1,count2)
   c3=where(a le -2.0,count3)
   ;cc=[c1]
   
   getds9region,x[c1],y[c1],'ysoI',color='red'
	getds9region,x[c2],y[c2],'ysoII',color='green'
   print,'Stars =',count3
	print,'class 1=',count1
	print,'class 2=',count2
   device,/close
   !p.multi=0
   set_plot,'x'
   
   ; Calculate the YSO ratio.
   ;i1=where((x ge 564 and x le 745 and y ge 286 and y le 449) and $
   ;  (a ge -2.0), c1,complement=inx)
   ;i2=where((((x-476.0)^2 + (y-515.0)^2) le 28000) and $
   ;  (a ge -2.0), c2,complement=inx)
   ;i3=where((x ge 564 and x le 745 and y ge 286 and y le 449) and $
   ;  (a le -2.0), c3,complement=inx)
   ;i4=where((((x-476.0)^2 + (y-515.0)^2) le 28000) and $
   ;  (a le -2.0), c4,complement=inx)

	;print,c1,c2,c3,c4
END


PRO SEDPLOT, cat
   COMMON share,imgpath, mappath 
   loadconfig
   ind=where((cat.hflux ge 0 and cat.kflux ge 0)$
            and (cat.i1flux ge -1.0 and cat.i2flux ge -1.0 and cat.i3flux ge -1.0),count)

   x=cat.x[ind]
   y=cat.y[ind]
   id=cat.id[ind]
   
   ; Transfer magitude to flux in the unit of mJy
   jflux=cat.jflux[ind]
   hflux=cat.hflux[ind]
   kflux=cat.kflux[ind]

   
   ; Transform Fv to vFv
   jvfv=jflux*1e-26*phertz2pmicron(1.252)
   hvfv=hflux*1e-26*phertz2pmicron(1.631)
   kvfv=kflux*1e-26*phertz2pmicron(2.146)
   i1vfv=cat.i1flux[ind]*1e-26*phertz2pmicron(3.56)
   i2vfv=cat.i2flux[ind]*1e-26*phertz2pmicron(4.52)
   i3vfv=cat.i3flux[ind]*1e-26*phertz2pmicron(5.73)
   i4vfv=cat.i4flux[ind]*1e-26*phertz2pmicron(7.91)
   
   i1ferr=cat.i1fluxerr[ind]*1e-26*phertz2pmicron(3.6)
   i2ferr=cat.i2fluxerr[ind]*1e-26*phertz2pmicron(4.5)
   i3ferr=cat.i3fluxerr[ind]*1e-26*phertz2pmicron(5.8)
   i4ferr=cat.i4fluxerr[ind]*1e-26*phertz2pmicron(8.0)

   lamda=[1.252,1.631,2.145,3.56,4.52,5.73,7.91]
   
   !p.multi=[0,4,4]
   set_plot,'ps'
   ;device,filename=mappath+'iras_band.ps',$
   ;      /color,xsize=20,ysize=20,xoffset=0,yoffset=2
   ;tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]

	for i=0,20 do begin
		plot,findgen(100)
	
	endfor

	device,/close	
   !p.multi=0
   set_plot,'x'

	
END



PRO EXAMPLESED, cat,Ps=ps
   COMMON share,imgpath, mappath 
   loadconfig
   
   ;ind=[22,209,590,335]-1
   ;ind=where(cat.id eq 163 or cat.id eq 2)
   ;x=cat.x[ind]
   ;y=cat.y[ind]
   ;id=cat.id[ind]
   ; Transfer magitude to flux in the unit of mJy
   jflux=cat.jflux;[ind]
   hflux=cat.hflux;[ind]
   kflux=cat.kflux;[ind]

   
   ; Transform Fv to vFv
   jvfv=jflux*1e-26*phertz2pmicron(1.252)
   hvfv=hflux*1e-26*phertz2pmicron(1.631)
   kvfv=kflux*1e-26*phertz2pmicron(2.146)
   i1vfv=cat.i1flux*1e-26*phertz2pmicron(3.56)
   i2vfv=cat.i2flux*1e-26*phertz2pmicron(4.52)
   i3vfv=cat.i3flux*1e-26*phertz2pmicron(5.73)
   i4vfv=cat.i4flux*1e-26*phertz2pmicron(7.91)
   
   ;i1ferr=cat.i1fluxerr[ind]*1e-26*phertz2pmicron(3.6)
   ;i2ferr=cat.i2fluxerr[ind]*1e-26*phertz2pmicron(4.5)
   ;i3ferr=cat.i3fluxerr[ind]*1e-26*phertz2pmicron(5.8)
   ;i4ferr=cat.i4fluxerr[ind]*1e-26*phertz2pmicron(8.0)
 
   lamda=[1.252,1.631,2.145,3.56,4.52,5.73,7.91]

   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'examplesed.eps',$
         /color,xsize=10,ysize=25,xoffset=0.4,yoffset=10,$
         SET_FONT='Helvetica',/TT_FONT,/encapsulated
         
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
   endif else begin
     blue=65535
      red=255
      green=32768    
   endelse
  
   erase & multiplot, [1,3];,mxtitle='Wavelength (!9m!Xm)'
   
   ind=where(cat.id eq 208)
   vfv=[jvfv[ind],hvfv[ind],kvfv[ind],i1vfv[ind],i2vfv[ind],i3vfv[ind],i4vfv[ind]]
   plot,lamda,vfv,/xlog,/ylog,psym=6,yrange=[1e-15,1e-10],xrange=[1.0,10],$
   	xthick=5.0,ythick=5.0,font=1,charsize=2.0
   xyouts,5 ,1e-11,'Class I/0',charsize=1.5,font=1
   oplot,lamda,vfv,line=1,thick=5.0 & multiplot

   ind=where(cat.id eq 197)
   vfv=[jvfv[ind],hvfv[ind],kvfv[ind],i1vfv[ind],i2vfv[ind],i3vfv[ind],i4vfv[ind]]
   plot,lamda,vfv,/xlog,/ylog,psym=6,yrange=[1e-15,1e-10],xrange=[1.0,10],$
   	xthick=5.0,ythick=5.0,font=1,charsize=2.0
   xyouts,5,1e-11,'Class II',charsize=1.5,font=1
   oplot,lamda,vfv,line=1,thick=5.0 & multiplot

   ind=where(cat.id eq 163)
   vfv=[jvfv[ind],hvfv[ind],kvfv[ind],i1vfv[ind],i2vfv[ind],i3vfv[ind],i4vfv[ind]]
   plot,lamda,vfv,/xlog,/ylog,psym=6,yrange=[1e-15,1e-10],xrange=[1.0,10],$
   	xthick=5.0,ythick=5.0,font=1,charsize=2.0,$
      xtitle='Wavelength (!9m!Xm)', ytitle='!9l!XF!I!9l!X!N (erg cm!E-2!N s!E-1!N)'
   xyouts,5,1e-11,'Star',charsize=1.5,font=1
   oplot,lamda,vfv,line=1,thick=5.0 & multiplot
   

   multiplot,[1,1],/init
   cleanplot,/silent

   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif

  
END


PRO DUMPMERGECAT, cat	
   COMMON share,imgpath, mappath 
   loadconfig

	close,1
	openw,1,mappath+'source.cat'
	
	hdr=headfits(imgpath+'s233ir_j.fits')
	
	xyad,hdr,cat.x,cat.y,ra,dec
	radec,ra,dec,ihr,imin,xsec,ideg,imn,xsc
	
	for i=0,n_tags(cat)-1 do begin
			ind=where(cat.(i) le -99,count)
			if count gt 0 then cat.(i)[ind]=0.0
			
			ind=where(finite(cat.(i),/infinity),count)
			if count gt 0 then cat.(i)[ind]=0.0
	endfor

	
  ;ind=where((cat.hflux ge 0 and cat.kflux ge 0)$
  ;         and (cat.i1flux gt 0 and cat.i2flux gt 0),count)
  ind= where(cat.hflux ne 0 and cat.kflux ne 0,count)
	;print,cat.jflux[311],cat.hflux[311],cat.kflux[311]
	for i=0, count-1 do begin
		;radec=adstring(ra[ind[i]],dec[ind[i]])
		;strput,radec,':',3
      ;strput,radec,':',6
      ;strput,radec,':',16
      ;strput,radec,':',19
	   jflux=cat.jflux[ind[i]]
	   hflux=cat.hflux[ind[i]]
	   kflux=cat.kflux[ind[i]]
	   if cat.id[ind[i]] eq 639 then begin
	   
		print,cat.jflux[ind[i]],cat.hflux[ind[i]],cat.kflux[ind[i]] 
		print,cat.i1flux[ind[i]],cat.i2flux[ind[i]],cat.i3flux[ind[i]],cat.i4flux[ind[i]]
	   endif 
		
		jfluxerr=((10^((cat.mj[ind[i]]+11.28-cat.mjerr[ind[i]])/(-2.5))) - $
			(10^((cat.mj[ind[i]]+11.28+cat.mjerr[ind[i]])/(-2.5))) )*1594.0e3
		hfluxerr=((10^((cat.mh[ind[i]]+11.28-cat.mherr[ind[i]])/(-2.5))) - $
			(10^((cat.mh[ind[i]]+11.28+cat.mherr[ind[i]])/(-2.5))) )*1024.0e3
		kfluxerr=((10^((cat.mk[ind[i]]+11.28-cat.mkerr[ind[i]])/(-2.5))) - $
			(10^((cat.mk[ind[i]]+11.28+cat.mkerr[ind[i]])/(-2.5))) )*667.0e3

		;print,jflux,cat.mj[ind[i]]+11.28
      
		if (jflux gt 0) and (jflux ge jfluxerr) then dj=1 else dj=0
		if (hflux gt 0) and (hflux ge hfluxerr) then dh=1 else dh=0
		if (kflux gt 0) and (kflux ge kfluxerr) then dk=1 else dk=0
		if (cat.i1flux[ind[i]] gt 0)  and (cat.i1flux[ind[i]] gt cat.i1fluxerr[ind[i]]) $
			then di1=1 else di1=0
		if (cat.i2flux[ind[i]] gt 0)  and (cat.i2flux[ind[i]] gt cat.i2fluxerr[ind[i]]) $
			then di2=1 else di2=0
		if (cat.i3flux[ind[i]] gt 0)  and (cat.i3flux[ind[i]] gt cat.i3fluxerr[ind[i]]) $
			then di3=1 else di3=0
		if (cat.i4flux[ind[i]] gt 0)  and (cat.i4flux[ind[i]] gt cat.i4fluxerr[ind[i]]) $
			then di4=1 else di4=0

		
		printf,1,format='(A30,2(1X,F9.5),7(1X,I1),14(1X,E11.4))',$
			;string(cat.id[ind[i]])+'_'+$
			;string(cat.x[ind[i]],format='(F7.2)')+'_'+$
			;string(cat.y[ind[i]],format='(F7.2)'),$
			string(cat.id[ind[i]]),$
			ra[ind[i]],dec[ind[i]],dj,dh,dk,di1,di2,di3,di4,$
			jflux,jfluxerr,$
			hflux,hfluxerr,$
			kflux,kfluxerr,$
			cat.i1flux[ind[i]],cat.i1fluxerr[ind[i]],$
			cat.i2flux[ind[i]],cat.i2fluxerr[ind[i]],$
			cat.i3flux[ind[i]],cat.i3fluxerr[ind[i]],$
			cat.i4flux[ind[i]],cat.i4fluxerr[ind[i]];,$
			;cat.av[ind[i]],cat.mass[ind[i]]
	endfor
	close,1

END


Pro LOADSEDFIT
   COMMON share,imgpath, mappath 
   loadconfig

	readcol,mappath+'output_yso_good.txt',format='(A30,F9.5,F9.5)',$
		id,ra,dec;,d1,d2,d3,d4,d5,d6,d7,j,je,h,he,k,ke,i1,i1e,i2,i2e,i3,i3e,i4,i4e
	
   hd=headfits(imgpath+'s233ir_h2.fits')
	adxy,hd,ra,dec,x,y
  ;getds9region,x,y,'sedfitter',color='yellow'
  getds9text,id,x,y,'sedfitter_text',color='yellow'
END



