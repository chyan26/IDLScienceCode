

PRO DUSTMAP, cat, PS=ps
   COMMON share,conf
   loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+'dustmap.eps',$
         /color,xsize=20,ysize=20,xoffset=0.4,yoffset=10,$
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
   
   x=cat.x
   y=cat.y
   av=cat.avk
   !x.title = "RA offset (arcmin)"  & !y.title = "Dec offset (arcmin)"
   !p.charsize = 1.1
   !x.range=[-1,1]
   !y.range=[-1,1]
   !p.font=1
   !x.thick=2.0 & !y.thick=2.0
   
   im=fltarr(1024,1024)
   im[*,*]=0.0
   for i=0, n_elements(x)-1 do begin
      if av[i] ge 0 then begin
      im[fix(x[i]),fix(y[i])]= im[fix(x[i]),fix(y[i])]+av[i]
      endif
   endfor
   ;xim=rebin(im,256,256)
   psf = psf_gaussian(npixel=128, fwhm=64)
   dust=convolve(im,psf)
   th_image_cont,max(dust)-dust,/nocont,/nobar,crange=[0,max(dust)]
   if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
   endif
END


PRO LOADCTTS, iso
	hk=(findgen(51)+45)/100
	
	jh=0.58*hk+0.52
	
	mh=findgen(51)/10

	mk=mh-hk
	mj=jh+mh


   iso={mj:mj,mh:mh,mk:mk}
END

; This is a new dereddening method us
PRO NEWDEREDDEN, cat, corrcat 
   COMMON share,conf
   loadconfig
   
   mj=cat.mj
   mh=cat.mh
   mk=cat.mk
   
   ctts=intarr(n_elements(mk))
   flag=intarr(n_elements(mk))
   av=fltarr(n_elements(mk))
   
   ctts[*]=0
   for i=0, n_elements(mj)-1 do begin
   	if (mj[i] le -100) then av[i]=15.0
   endfor
   
   ; First, rule out star at CTTS locus
   for i=0, n_elements(mj)-1 do begin
   		; left boundary
      		y1=1.7*(mh[i]-mk[i])+0.031	
       
       	; right boundary
      		y2=1.7*(mh[i]-mk[i])-0.544
      		y3=0.58*(mh[i]-mk[i])+0.52
		if ((mj[i]-mh[i]) le y1) and ((mj[i]-mh[i]) ge y2-0.2) and ((mj[i]-mh[i]) ge y3) then begin
			;av[i]=(y2-(mj[i]-mh[i]))		
			
			;av[i]=abs(y2-((mj[i]-mh[i])))/0.107
			flag[i]=1
         ctts[i]=1;              
		endif
   endfor
   
   cmj=mj-0.270*av
   cmh=mh-0.142*av      
   cmk=mk-0.081*av

 	ind=where(flag ne 0, count)
 	;	plot,cmh[ind]-cmk[ind],cmj[ind]-cmh[ind],psym=4,xrange=[-0.5,4.5],yrange=[0,5],$
 	;xstyle=1,charsize=1.6,symsize=0.3, font=1, xthick=5.0,$
 	;ythick=5.0
	;print,flag
	
	; Load averaged isochrone
	loadavgiso,iso

	; Now, use H and K to correct extinction
	x=mh-mk
	y=mk

	for i=0, n_elements(mj)-1 do begin
		if flag[i] ne 1 then begin
			j=0
			; Check if the star is at left hand side
			dx=x[i]-interpol(iso.mh-iso.mk,iso.mk,y[i])
			; give a -999 to star at left have side of isochrone
			if (dx le 0) then begin
				av[i]=-999.0
				continue
			endif 
			
			while (1) do begin
				j=j+1
				x_ln=0.9-0.01*j
	
				y_up=1.78*x_ln+(y[i]-1.78*x[i])
				x_cu=interpol(iso.mh-iso.mk,iso.mk,y_up)
	 			
				if x_ln-x_cu ge 0 then begin
	 				xpt=x_cu
	 			endif else begin
	 				xpt=(x_cu+x_ln)/2
					break
	 			endelse
			endwhile
			av[i]=abs(y[i]-y_up)/0.112

		endif 	
	endfor

	; Correct extinction for CTTS
	id=where(ctts eq 1) 
	plot, mh[id]-mk[id]$
	  ,mj[id]-mh[id],psym=4,xrange=[-0.5,5],yrange=[0,5]
  
  ahk=(mh[id]-mk[id])
  ajh=(mj[id]-mh[id])
  hk=(((ajh)-1.69*(ahk))-0.52)/(-1.12)
	jh=0.58*hk+0.52
	av1=(ajh-jh)/(0.107)
	av2=(ahk-hk)/(0.063)
	print,jh[1],hk[1],ajh[1],ahk[1]
	print,av1,av2
	av[id]=av2
	
	;loadctts,iso
	;for i=0, n_elements(mj)-1 do begin
	;	if flag[i] eq 1 then begin
			; Calcluate the new H-K
	;		hk=(((mj[i]-mh[i])-1.31*(mh[i]-mk[i]))-0.52)/(-0.73)
	;		jh=0.58*hk+0.52
			;vector=sqrt(((mj[i]-mh[i])-jh)^2+((mh[i]-mk[i])-hk)^2)
			
	;		av1=(jh-(mj[i]-mh[i]))/(-0.107)
	;		av2=(hk-(mh[i]-mk[i]))/(-0.063)
	;		print,av1,av2
	;		av[i]=av1
			;print,av[i]
			;j=0
			; Check if the star is at left hand side
			;dx=x[i]-interpol(iso.mh-iso.mk,iso.mk,y[i])
			; give a -999 to star at left hand side of isochrone
			;if (dx le 0) then begin
			;	av[i]=-999.0
			;	continue
			;endif 
			
			;while (1) do begin
			;	j=j+1
			;	x_ln=0.9-0.01*j
	
			;	y_up=1.78*x_ln+(y[i]-1.78*x[i])
			;	x_cu=interpol(iso.mh-iso.mk,iso.mk,y_up)
	 			
			;	if x_ln-x_cu ge 0 then begin
	; 				xpt=x_cu
	 		;	endif else begin
	 		;		xpt=(x_cu+x_ln)/2
			;		break
	 		;	endelse
			;endwhile
			;av[i]=abs(y[i]-y_up)/0.112

	;	endif 	
	;endfor


   cmj=mj-0.282*av
   cmh=mh-0.175*av      
   cmk=mk-0.112*av
   
   ;plot,cmh[ind]-cmk[ind],cmj[ind]-cmh[ind],psym=4,xrange=[-0.5,2],yrange=[0,2],$
	;xstyle=1,charsize=1.6,symsize=0.3, font=1, xthick=5.0,$
	;ythick=5.0
	;aa=(findgen(6)+5)/10
  ;bb=0.58*aa+0.52
	;oplot,aa,bb
	;oplot,iso.mh-iso.mk,iso.mj-iso.mh

	ind=where(av ge -100 and av le 1000)
	corrcat={id:cat.id[ind],x:cat.x[ind],y:cat.y[ind],mj:mj[ind],mh:mh[ind],$
		mk:mk[ind],mjerr:cat.mjerr[ind],mherr:cat.mherr[ind],$
		mkerr:cat.mkerr[ind],cmj:cmj[ind],cmh:cmh[ind],$
		cmk:cmk[ind],av:av[ind],avk:av[ind],group:cat.group[ind],ctts:ctts[ind]}

	check = 1
	if check eq 1 then begin 
	plot,cmh-cmk,cmk,psym=7, $;
		yrange=[13,-5],ystyle=1,xrange=[-1,5], $
		xstyle=1, xtitle='H - Ks',ytitle='M!IKs!N',charsize=2,font=1,$
		symsize=0.3,xthick=5.0,ythick=5.0
   oplot,iso.mh-iso.mk,iso.mk

	endif	
	;oplot,ctts.mh-ctts.mk,ctts.mk
;print,av
END














