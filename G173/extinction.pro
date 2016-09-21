FUNCTION ABSMAG, final, dist
  amag=final
  amag.mj=final.mj-5*(alog10(dist)-1)
  amag.mh=final.mh-5*(alog10(dist)-1)
  amag.mk=final.mk-5*(alog10(dist)-1)
  return,amag
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
PRO NEWDEREDDEN, cat, corrcat, DISP=disp,ZAMS=zams
   COMMON share,setting
   loadconfig
   
   mj=cat.mj
   mh=cat.mh
   mk=cat.mk
   
   flag=intarr(n_elements(mk))
   av=fltarr(n_elements(mk))
   
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
		endif
   endfor
;   cmj=mj-0.270*av
;   cmh=mh-0.142*av      
;   cmk=mk-0.081*av

;	ind=where(flag ne 0, count)
;		plot,cmh[ind]-cmk[ind],cmj[ind]-cmh[ind],psym=4,xrange=[-0.5,4.5],yrange=[0,5],$
;	xstyle=1,charsize=1.6,symsize=0.3, font=1, xthick=5.0,$
;	ythick=5.0
	;print,flag
	
	; Load averaged isochrone
	;loadavgiso,iso,/sdf
	loadavgiso,iso,age=10,/all
	
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

  if keyword_set(disp) then begin
   plot,cmh-cmk,cmj-cmh,psym=4,xrange=[-0.5,2.5],yrange=[0,3],$
	xstyle=1,charsize=1.6,symsize=0.3, font=1, xthick=5.0,$
	ythick=5.0
	loadiso_zams,iso
	oplot,iso.mh-iso.mk,iso.mj-iso.mh,color=255
  endif 
  
	corrcat={id:cat.id,x:cat.x,y:cat.y,mj:mj,mh:mh,$
		mk:mk,mjerr:cat.mjerr,mherr:cat.mherr,$
		mkerr:cat.mkerr,cmj:cmj,cmh:cmh,$
		cmk:cmk,av:av,avk:av,group:cat.group,ctts:cat.ctts}

	plot,cmh-cmk,cmk,psym=7, $;
		yrange=[13,-5],ystyle=1,xrange=[-1,5], $
		xstyle=1, xtitle='H - Ks',ytitle='M!IKs!N',charsize=2,font=1,$
		symsize=0.3,xthick=5.0,ythick=5.0
	;oplot,ctts.mh-ctts.mk,ctts.mk
;print,av
END

PRO AVGEXT, cat
   COMMON share,setting
   loadconfig
   ind=where(cat.av ge 0.0 and cat.av le 60, count)
   print,'G173 All data (mean)=',mean(cat.av[ind]),' +/-',stddev(cat.av[ind])
   
   ind=where(cat.group eq 1 and cat.av ge 0.0 and cat.av le 60, count)
   print,cat.av[ind]
   
   mad=1.48*median(abs(median(cat.av[ind])-cat.av[ind]))
   
   print,'G173 Cluster (mean)=',mean(cat.av[ind]),' +/-',stddev(cat.av[ind])
   print,'G173 Cluster (median)=',median(cat.av[ind]),' +/-',mad
  
   ind=where(cat.group eq 2 and cat.av ge 0, count)
   print,'Non-G173 Cluster= ',mean(cat.av[ind]),' +/-',stddev(cat.av[ind])

END

