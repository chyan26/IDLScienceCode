PRO WIRCAM_ADDINGBACK, image, header, chipcode
imsize = [2048,2048]

; guide box location
   x0 = sxpar(header, 'WCPOSX'+strtrim(chipcode,2))
   dx = sxpar(header, 'WCSIZEX')
   y0 = sxpar(header, 'WCPOSY'+strtrim(chipcode,2))
   dy = sxpar(header, 'WCSIZEY')

	ind=where(image eq -7000.0)
	image[ind]=!values.f_nan
	image[x0-dx/2:x0+dx/2,y0-dy/2:y0+dy/2]=!values.f_nan
	
; remove crosstalk caused by guider box (Is it crosstalk? anyway...)
; IF strmid(sxpar(header, 'WCGDUSE'+strtrim(chipcode,2)),0,4) EQ 'TRUE' THEN BEGIN
IF (chipcode EQ '1' AND strtrim(sxpar(header, 'WCGDUSE1'),2) EQ 'TRUE') OR $
   (chipcode EQ '4' AND strtrim(sxpar(header, 'WCGDUSE4'),2) EQ 'TRUE') THEN BEGIN
   
	subimage = image[x0-2:x0+dx-1+2,*]
   subimage[*, 0:y0] = !values.f_nan
	
	y1 = max([y0-20,0])
   y2 = min([y0+dy+20-1,2047])
   subimage[*, y1:y2] = !values.f_nan
   sky, subimage, bg, rms, /silent, /nan
   A = where(subimage-bg GT 3.5*rms)
   IF total(A) NE -1 THEN subimage[A] = !values.f_nan
   subimage = smooth(subimage,3,/nan,/edge_truncate)
   A = where(subimage-bg GT 1.2*rms)
   IF total(A) NE -1 THEN subimage[A] = !values.f_nan
   subimage = subimage[2:dx+1, *]
  
   IF x0 LT 1024 THEN subimage2 = image[x0+dx+2:x0+dx+40,*]
   IF x0 GE 1024 THEN subimage2 = image[x0-2-40:x0-2,*]
   sky, subimage2, bg, rms, /silent, /nan
   A = where(subimage2-bg GT 3.5*rms)
   IF total(A) NE -1 THEN subimage2[A] = !values.f_nan
   subimage2 = smooth(subimage2,3,/nan,/edge_truncate)
   A = where(subimage2-bg GT 1.2*rms)
   IF total(A) NE -1 THEN subimage2[A] = !values.f_nan
	
	print, 'x0 = ', x0
	print, 'y0 = ', y0
   FOR j=0,255 DO BEGIN
     subimage_small = subimage[*,j*8:(j+1)*8-1]
     w = where(finite(subimage_small) eq 0, num_nan)
     ;if total(w) ne -1 then print, 'num_nan = ', num_nan
     w_nonnan = where(finite(subimage_small) eq 1, num_nonnan)
     ;print, 'j = ', j
     ;print, 'num_nonnan = ', num_nonnan
     if total(w_nonnan) ne -1 then begin
	     subimage_nonnan = subimage_small(w_nonnan)
		  med1 =  median(subimage_nonnan)
     endif else begin
	  	  med1 = 0.0
	  endelse
     
;;    IF finite(med1) EQ 0 THEN med1 = 0.0

;;     subimage2_small = subimage2[*,j*64:(j+1)*64-1]
     subimage2_small = subimage2[*,j*8:(j+1)*8-1]
     w = where(finite(subimage2_small) eq 0, num_nan)
     ;if total(w) ne -1 then print, 'num_nan = ', num_nan
     w_nonnan = where(finite(subimage2_small) eq 1)
     if total(w_nonnan) ne -1 then begin
	     subimage2_nonnan = subimage2_small(w_nonnan)
		  med0 =  median(subimage2_nonnan)
     endif else begin
	  	  med0 = 0.0
	  endelse
     
     image[x0:x0+dx-1,j*8:(j+1)*8-1] = image[x0:x0+dx-1,j*8:(j+1)*8-1] - med1+med0
   ENDFOR

ENDIF 


IF (chipcode EQ '1' AND strtrim(sxpar(header, 'WCGDUSE1'),2) EQ 'TRUE') OR $
   (chipcode EQ '4' AND strtrim(sxpar(header, 'WCGDUSE4'),2) EQ 'TRUE') THEN BEGIN
 
   subimage = image[x0-2:x0+dx-1+2,*]
   subimage[*, y0:2047] = !values.f_nan

	y1 = max([y0-20,0])
   y2 = min([y0+dy+20-1,2047])
	if y1 gt 4 then begin 
		subimage[*, y1:y2] = !values.f_nan
		sky, subimage, bg, rms, /silent, /nan
		A = where(subimage-bg GT 3.5*rms)
		IF total(A) NE -1 THEN subimage[A] = !values.f_nan
		subimage = smooth(subimage,3,/nan,/edge_truncate)
		A = where(subimage-bg GT 1.2*rms)
		IF total(A) NE -1 THEN subimage[A] = !values.f_nan
		subimage = subimage[2:dx+1, *]
	
		IF x0 LT 1024 THEN subimage2 = image[x0+dx+2:x0+dx+40,*]
		IF x0 GE 1024 THEN subimage2 = image[x0-2-40:x0-2,*]
		sky, subimage2, bg, rms, /silent, /nan
		A = where(subimage2-bg GT 3.5*rms)
		IF total(A) NE -1 THEN subimage2[A] = !values.f_nan
		subimage2 = smooth(subimage2,3,/nan,/edge_truncate)
		A = where(subimage2-bg GT 1.2*rms)
		IF total(A) NE -1 THEN subimage2[A] = !values.f_nan
		
		print, 'x0 = ', x0
		print, 'y0 = ', y0
		FOR j=0,255 DO BEGIN
		subimage_small = subimage[*,j*8:(j+1)*8-1]
		w = where(finite(subimage_small) eq 0, num_nan)
		;if total(w) ne -1 then print, 'num_nan = ', num_nan
		w_nonnan = where(finite(subimage_small) eq 1, num_nonnan)
		;print, 'j = ', j
		;print, 'num_nonnan = ', num_nonnan
		if total(w_nonnan) ne -1 then begin
			subimage_nonnan = subimage_small(w_nonnan)
			med1 =  median(subimage_nonnan)
		endif else begin
			med1 = 0.0
		endelse
		
	;;    IF finite(med1) EQ 0 THEN med1 = 0.0
	
	;;     subimage2_small = subimage2[*,j*64:(j+1)*64-1]
		subimage2_small = subimage2[*,j*8:(j+1)*8-1]
		w = where(finite(subimage2_small) eq 0, num_nan)
		;if total(w) ne -1 then print, 'num_nan = ', num_nan
		w_nonnan = where(finite(subimage2_small) eq 1)
		if total(w_nonnan) ne -1 then begin
			subimage2_nonnan = subimage2_small(w_nonnan)
			med0 =  median(subimage2_nonnan)
		endif else begin
			med0 = 0.0
		endelse
		
		image[x0:x0+dx-1,j*8:(j+1)*8-1] = image[x0:x0+dx-1,j*8:(j+1)*8-1] - med1+med0
		ENDFOR
	endif
ENDIF 




IF  (chipcode EQ '4' AND strtrim(sxpar(header, 'WCGDUSE4'),2) EQ 'TRUE') OR $
   (chipcode EQ '1' AND strtrim(sxpar(header, 'WCGDUSE4'),2) EQ 'TRUE') THEN BEGIN  
   
   subimage = image[*, y0-2:y0+dy-1+2]
   x1 = max([x0-20,0])
   x2 = min([x0+dx+20-1,2047])
   subimage[x1:x2, *] = !values.f_nan
   sky, subimage, bg, rms, /silent, /nan
   A = where(subimage-bg GT 3.2*rms)
   IF total(A) NE -1 THEN subimage[A] = !values.f_nan
   subimage = smooth(subimage,3,/nan,/edge_truncate)
   A = where(subimage-bg GT 1.2*rms)
   IF total(A) NE -1 THEN subimage[A] = !values.f_nan
   subimage = subimage[*, 2:dy+1]
   
   IF y0 LT 1024 THEN subimage2 = image[*, y0+dy+2:y0+dy+40]
   IF y0 GE 1024 THEN subimage2 = image[*, y0-2-40:y0-2]
   sky, subimage2, bg, rms, /silent, /nan
   A = where(subimage2-bg GT 3.0*rms)
   IF total(A) NE -1 THEN subimage2[A] = !values.f_nan
   subimage2 = smooth(subimage2,3,/nan,/edge_truncate)
   A = where(subimage2-bg GT rms)
   IF total(A) NE -1 THEN subimage2[A] = !values.f_nan
   
   FOR j=0,127 DO BEGIN
;;     med1 =  mean(subimage[j*16:(j+1)*16-1, 0:dy/2-1], /nan)
;;     IF finite(med1) EQ 0 THEN med1 = 0.0
;;     med2 =  mean(subimage[j*16:(j+1)*16-1, dy/2:dy-1], /nan)
;;     IF finite(med2) EQ 0 THEN med2 = 0.0
;;     med0 =  mean(subimage2[j*16:(j+1)*16-1,*], /nan)
;;     IF finite(med2) EQ 0 THEN med2 = 0.0

     subimage_small = subimage[j*16:(j+1)*16-1, 0:dy/2-1]
     w = where(finite(subimage_small) eq 0, num_nan)
     ;if total(w) ne -1 then print, 'num_nan = ', num_nan
     w_nonnan = where(finite(subimage_small) eq 1)
     if total(w_nonnan) ne -1 then begin
	     subimage_nonnan = subimage_small(w_nonnan)
		  med1 =  median(subimage_nonnan)
	  endif else begin
	  	  med1 = 0.0
	  endelse
	  
;;     IF finite(med1) EQ 0 THEN med1 = 0.0

     subimage2_small = subimage[j*16:(j+1)*16-1, dy/2:dy-1]
     w = where(finite(subimage2_small) eq 0, num_nan)
     ;if total(w) ne -1 then print, 'num_nan = ', num_nan
     w_nonnan = where(finite(subimage2_small) eq 1)
     if total(w_nonnan) ne -1 then begin
	     subimage2_nonnan = subimage2_small(w_nonnan)
		  med2 =  median(subimage2_nonnan)
     endif else begin
	  	  med2 = 0.0
	  endelse
     
;;     IF finite(med2) EQ 0 THEN med2 = 0.0

     subimage3_small = subimage2[j*16:(j+1)*16-1, *]
     w = where(finite(subimage3_small) eq 0, num_nan)
     ;if total(w) ne -1 then print, 'num_nan = ', num_nan
     w_nonnan = where(finite(subimage3_small) eq 1)
     if total(w_nonnan) ne -1 then begin
	     subimage3_nonnan = subimage3_small(w_nonnan)
     	  med0 =  median(subimage3_nonnan)
	  endif else begin
	  	  med0 = 0.0
	  endelse
;;     IF finite(med0) EQ 0 THEN med0 = 0.0


     image[j*16:(j+1)*16-1, y0:y0+dy/2-1] = image[j*16:(j+1)*16-1, y0:y0+dy/2-1] - med1+med0
     image[j*16:(j+1)*16-1, y0+dy/2:y0+dy-1] = image[j*16:(j+1)*16-1, y0+dy/2:y0+dy-1] - med2+med0
   ENDFOR
ENDIF

image2 = smooth(image,3,/nan,/edge_truncate)
med = median(image2)

;;w = where((finite(image2) EQ 0), num_nan)
;;print, 'num_nan = ', num_nan

if total(where(finite(image2) EQ 0)) ne -1 then begin
	image2[where(finite(image2) EQ 0)] = med
end
sky,image2,bg,rms,/nan,/silent
image2[where(image2 GT bg+3.0*rms)] = !values.f_nan

FOR i=1,510 DO BEGIN
   subimage = image2[*,i*4:(i+1)*4]
;   sky,subimage,bg,rms,/silent,/nan
   bg = median(subimage)
   image[*,i*4:(i+1)*4] = image[*,i*4:(i+1)*4] - bg
ENDFOR


IF  chipcode EQ '1' THEN BEGIN
image2 = smooth(image,3,/nan,/edge_truncate)
med = median(image2)
if total(where(finite(image2) EQ 0)) ne -1 then begin
	image2[where(finite(image2) EQ 0)] = med
endif
sky,image2,bg,rms,/nan,/silent
if total(where(image2 GT bg+3.0*rms)) ne -1 then begin
	image2[where(image2 GT bg+3.0*rms)] = med
endif
FOR i=1,510 DO BEGIN
   subimage = image2[i*4:(i+1)*4, *]
   ; sky,subimage,bg,rms,/silent
   bg = median(subimage)
   image[i*4:(i+1)*4, *] = image[i*4:(i+1)*4, *] - bg
ENDFOR
ENDIF


	ind=where(finite(image) eq 0)
	image[ind]=-7000.0

END

PRO  WIRCAM_ADDGWINGXTALK
	;path='/arrays/capella/wircam/processed/06AT02/J/'
	path='/data/chyan/dgxtalk/'
	spawn,'ls '+path+'[0-9]47606p*.fits',result
	
	;for i=0, n_elements(result)-1 do begin
	for i=0, n_elements(result)-1 do begin
	mhd=headfits(result[i],ext=0)	
	next=sxpar(mhd,'NEXTEND')
	fxwrite,path+'temp.fits',mhd

		for ext=1,next do begin
			hd=headfits(result[i],ext=ext)
			im=mrdfits(result[i],ext)+32768.0-7000.0
			nframe=sxpar(hd,'NAXIS3')
			
			for slice=0, nframe-1 do begin
				dim=float(reform(im[*,*,slice]))
				wircam_addingback, dim, hd, ext
				im[*,*,slice] = dim[*,*]+7000.0
			endfor
			writefits,path+'temp.fits',fix(im-32768.0),hd,/append
		endfor
	
	spawn,'mv -f '+path+'temp.fits'+' '+result[i]+'.dg'
	endfor
	
	
END