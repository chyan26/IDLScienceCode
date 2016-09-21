PRO DEREDDEN, absmag, corrcat
	COMMON share,imgpath, mappath	
	loadconfig
;	!p.multi=[0,1,2]
	
  	x=absmag.mj-absmag.mh
  	y=absmag.mj

		
	loadavgiso,iso

	for i=0, n_elements(x)-1 do begin
		;print,'JH',i
		j=0
		; Check if the data point is at the right hand side of isochorne
		dx=x[i]-interpol(iso.mj-iso.mh,iso.mj,y[i])
		if dx le 0 or (absmag.mj[i] le -100)then begin
			if i eq 0 then begin
				cmh1=y[i]-x[i]
				cmj=y[i]
				avj=0.0
			endif else begin
				cmh1=[cmh1,y[i]-x[i]]
				cmj=[cmj,-999.0]
				avj=[avj,-999.0]
			endelse
			continue
		endif 

		while (1) do begin
			j=j+1
			;x_ln=0.9-0.0001*j
			x_ln=0.9-0.01*j
			y_up=2.64*x_ln+(y[i]-2.64*x[i])
			x_cu=interpol(iso.mj-iso.mh,iso.mj,y_up)
 			
			if x_ln-x_cu ge 0 then begin
 				xpt=x_cu
 			endif else begin
 				xpt=(x_cu+x_ln)/2
				break
 			endelse
			
		endwhile
;		oplot,[x_ln,xpt],[y_up,y_up],psym=5
		;print,y_up-xpt,y_up,abs(y[i]-y_up)/0.282
		if i eq 0 then begin
			cmh1=y_up-xpt
			cmj=y_up
			avj=abs(y[i]-y_up)/0.282
		endif else begin
			cmh1=[cmh1,y_up-xpt]
			cmj=[cmj,y_up]
			avj=[avj,abs(y[i]-y_up)/0.282]
		endelse
	endfor

;	print,'----------'
	;
	; H-K and K plot
	;
; 	x=absmag.mh[0:2]-absmag.mk[0:2]
; 	y=absmag.mk[0:2]
	x=absmag.mh-absmag.mk
	y=absmag.mk
	
;	plot,x,y,psym=1, $
;		yrange=[13,-5],ystyle=1,xrange=[-1,5], $
;		xstyle=1

;	oplot,iso.mh-iso.mk,iso.mk
;	oplot,iso1.mh-iso1.mk,iso1.mk
	for i=0, n_elements(x)-1 do begin
		;print,'HK',i
		j=0
		; Check if the data point is at the right hand side of isochorne
		dx=x[i]-interpol(iso.mh-iso.mk,iso.mk,y[i])
		if (dx le 0) or (absmag.mk[i] le -100) then begin
			if i eq 0 then begin
				cmh2=x[i]+y[i]
				cmk=y[i]
				avk=0.0
			endif else begin
				cmh2=[cmh2,y[i]+x[i]]
				cmk=[cmk,-999.0]
				avk=[avk,-999.0]
			endelse
			continue
		endif 

		while (1) do begin
			j=j+1
			;x_ln=0.9-0.0001*j
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
		
		;oplot,[x_ln,xpt],[y_up,y_up],psym=5
		;print,y_up+xpt,y_up,abs(y[i]-y_up)/0.112
 		if i eq 0 then begin
 			cmh2=y_up+xpt
 			cmk=y_up
 			avk=abs(y[i]-y_up)/0.112
 		endif else begin
 			cmh2=[cmh2,y_up+xpt]
			cmk=[cmk,y_up]
			avk=[avk,abs(y[i]-y_up)/0.112]
 		endelse
	endfor
   
   ; Go through each star and check for the Av_J and Av_k
   for i=0, n_elements(x)-1 do begin
      ; If star is not detected in J or no extinction for JH, then set cmh1 to NaN
      if absmag.mj[i] le -900.0 or cmj[i] le -900.0 then begin
      	cmh1[i]=-999.0
      	;cmh2[i]=-999.0
  	  endif
      if absmag.mk[i] le -900.0 or cmk[i] le -900.0 then begin
      	cmh2[i]=-999.0
      	;cmh2[i]=-999.0
      endif
      ;if avk[i] eq 0 or avj[i] eq 0 then begin
      ;   print,absmag.mj[i],absmag.mh[i],absmag.mk[i],avj[i],avk[i],cmj[i]$
      ;   	,cmh1[i],cmh2[i],cmk[i]
      ;endif
   endfor
   	
   ;ind=where(cmk ge -99.0)
   
	corrcat={x:absmag.x,y:absmag.y,mj:absmag.mj,mh:absmag.mh,$
		mk:absmag.mk,mjerr:absmag.mjerr,mherr:absmag.mherr,$
		mkerr:absmag.mkerr,cmj:cmj,cmh1:cmh1,cmh2:cmh2,$
		cmk:cmk,avj:avj,avk:avk}
; 	corrcat={x:absmag.x[ind],y:absmag.y[ind],mj:absmag.mj[ind],$
; 		mh:absmag.mh[ind],$
; 		mk:absmag.mk[ind],mjerr:absmag.mjerr[ind],mherr:absmag.mherr[ind],$
; 		mkerr:absmag.mkerr[ind],cmj:cmj[ind],cmh1:cmh1[ind],cmh2:cmh2[ind],$
; 		cmk:cmk[ind],avj:avj[ind],avk:avk[ind]}
	
;	print,avk,avj
	!p.multi=0
END


PRO LOADAVGISO, iso
   COMMON share,imgpath, mappath 
   loadconfig
   
   mk=(findgen(48)-4)/4.0
   mh=fltarr(n_elements(mk))
   mj=fltarr(n_elements(mk))
   for i=0,n_elements(mk)-1 do begin
      age=[1,2,3,5,7,10]
      for j=0,5 do begin
         loadiso_dm98,iso,av=0,age=age[j]
         if j eq 0 then begin
            mmh=interpol(iso.mh,iso.mk,mk[i])
            mmj=interpol(iso.mj,iso.mk,mk[i])
         endif else begin
            mmh=[mmh,interpol(iso.mh,iso.mk,mk[i])]
            mmj=[mmj,interpol(iso.mj,iso.mk,mk[i])]
         endelse
       endfor
       mh[i]=mean(mmh)
       mj[i]=mean(mmj)
   endfor

   iso={mj:mj,mh:mh,mk:mk}
END

; This is the function use NICE method to correct extinction
PRO NICE, absmag, cor
   COMMON share,imgpath, mappath 
   loadconfig

   ; first of all, load isochrone to get average H-K 
   age=[1,2,3,5,7,10]
   for i=0,5 do begin
      loadiso_dm98,iso,av=0,age=age[i]
      if i eq 0 then begin
         mh=reform(iso.mh)
         mk=reform(iso.mk)
      endif else begin
         mh=[mh,reform(iso.mh)]
         mk=[mk,reform(iso.mh)]
      endelse
   endfor
   
   hk_in=mean(mh-mk)
   av=fltarr(n_elements(absmag.x))
   for i=0, n_elements(absmag.x)-1 do begin
      av[i]=((absmag.mh[i]-absmag.mk[i])-hk_in)/0.063
   endfor
   print,mean(mh-mk)
   cor={x:absmag.x,y:absmag.y,mj:absmag.mj,mh:absmag.mh,$
      mk:absmag.mk,mjerr:absmag.mjerr,mherr:absmag.mherr,$
      mkerr:absmag.mkerr,avk:av,av:av}
   
END


; This function transform the luminosity to stellar mass
PRO GETMASS, cat, result
   COMMON share,imgpath, mappath 
   loadconfig

   neage=0.5   
   swage=1
   fsage=7
   
   mass=fltarr(n_elements(cat.x))
   
   ; Data of NE cluster
   loadiso_dm98,iso,av=0,age=neage
   ;neind=where(((cat.x-537.0)^2 + (cat.y-530.0)^2) le 11000,count)
   neind=where(cat.group eq 1 ,count) 
   mass[neind]=interpol(iso.mass,iso.mk,cat.cmk[neind])

   ; Data of SW cluster
   loadiso_dm98,iso,av=0,age=swage
   swind=where(cat.group eq 2 ,count) 
   mass[swind]=interpol(iso.mass,iso.mk,cat.cmk[swind])
   ;plot,cat.cmh[swind]-cat.cmk[swind],cat.cmk[swind],psym=4,yrange=[13,-5],ystyle=1,xrange=[-1,5]
   ;oplot,iso.mh-iso.mk,iso.mk
   ;print,mass[swind]
      
   ; Data of field stars
   loadiso_dm98,iso,av=0,age=fsage
   inx=where(cat.group eq 3 ,count) 
   mass[inx]=interpol(iso.mass,iso.mk,cat.cmk[inx])
   
   for i=0, n_elements(mass)-1 do begin
      if mass[i] ge 1000 then mass[i]=-999.0
   endfor

   result={id:cat.id,x:cat.x,y:cat.y,mj:cat.mj,mh:cat.mh,$
      mk:cat.mk,mjerr:cat.mjerr,mherr:cat.mherr,$
      mkerr:cat.mkerr,cmj:cat.cmj,cmh:cat.cmh,$
      cmk:cat.cmk,av:cat.av,avk:cat.avk,mass:mass,group:cat.group}

END

PRO DUSTMAP, cat, PS=ps
   COMMON share,imgpath, mappath 
   loadconfig
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'dustmap.eps',$
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
   COMMON share,imgpath, mappath 
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
      		y2=0.58*(mh[i]-mk[i])+0.52
		if ((mj[i]-mh[i]) le y1) and ((mj[i]-mh[i]) ge y2) then begin
			;av[i]=(y2-(mj[i]-mh[i]))		
			
			;av[i]=abs(y2-((mj[i]-mh[i])))/0.107
			flag[i]=1
         ctts[i]=1;              
		endif
   endfor
   cmj=mj-0.270*av
   cmh=mh-0.142*av      
   cmk=mk-0.081*av

; 	ind=where(flag ne 0, count)
; 		plot,cmh[ind]-cmk[ind],cmj[ind]-cmh[ind],psym=4,xrange=[-0.5,4.5],yrange=[0,5],$
; 	xstyle=1,charsize=1.6,symsize=0.3, font=1, xthick=5.0,$
; 	ythick=5.0
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
	loadctts,iso
	for i=0, n_elements(mj)-1 do begin
		if flag[i] eq 1 then begin
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


   cmj=mj-0.282*av
   cmh=mh-0.175*av      
   cmk=mk-0.112*av
   
   ;plot,cmh-cmk,cmj-cmh,psym=4,xrange=[-0.5,4.5],yrange=[0,5],$
	;xstyle=1,charsize=1.6,symsize=0.3, font=1, xthick=5.0,$
	;ythick=5.0
	;oplot,iso.mh-iso.mk,iso.mj-iso.mh

	ind=where(av ge -100 and av le 1000)
	corrcat={id:cat.id[ind],x:cat.x[ind],y:cat.y[ind],mj:mj[ind],mh:mh[ind],$
		mk:mk[ind],mjerr:cat.mjerr[ind],mherr:cat.mherr[ind],$
		mkerr:cat.mkerr[ind],cmj:cmj[ind],cmh:cmh[ind],$
		cmk:cmk[ind],av:av[ind],avk:av[ind],group:cat.group[ind]}

	check = 0
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














