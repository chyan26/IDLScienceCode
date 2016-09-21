PRO FLUX10

;-------------------------------------------
;  Setting basic parameters
;-------------------------------------------
!except=0
n0=20428.0
a=1.055
beta=2.252
obs_region=256
bk_region=2
fov=18.0             ; FOV is 36 arcsecond for SMA, 18 for ALMA
ra=12.608	    ; RA and Dec of HDF 
dec=62.236
;--------------------------------------------

;--------------------------------------------
;  Plot source count model.  Here we use
;   Barger, 1999 
;--------------------------------------------
s=series(0.0001,20,2000)
n=barger_sn(n0,a,beta,s)
;--------------------------------------------

;--------------------------------------------
;  Produce a data array with random distributed
;    flux and potision
;--------------------------------------------
nn=n/max(n)
h=fltarr(n_elements(s))
flux=interpol(s,nn,randomu(seed,max(n)))
data=fltarr(3,n_elements(flux))
data(0,*)=flux/1000
data(1,*)=3600*randomu(seed,n_elements(flux))
data(2,*)=3600*randomu(seed,n_elements(flux))
;---------------------------------------------------

;---------------------------------------------------
;  Check the data with 1. plot source count model
;                      2. plot flux distribution
;                           using symbol
;                      3. plot differential source
;                            count
;---------------------------------------------------
plot,s,n,/xlog,/ylog


h=fltarr(n_elements(s))
for i=0,n_elements(s)-1 do begin
        h(i)=n_elements(where(flux gt s(i)))
endfor
oplot,s,h,psym=4


hh=histogram(flux,min=min(s),max=max(s),bin=s(1)-s(0))
oplot,s,hh
;----------------------------------------------------


prefix1='/scr1/Confusion/Data/submm_source'
prefix2='/scr1/Confusion/Data/submm_position'
prefix3='/scr1/Confusion/Data/submm_radec'
prefix4='/scr1/Confusion/Background/bg_source'
prefix5='/scr1/Confusion/Background/bg_position'

window,1
wset,1
plot,data(1,*),data(2,*),psym=3,xstyle=1,ystyle=1


for i=1,obs_region do begin
	name1=prefix1+strcompress(string(i),/remove_all)
	name2=prefix2+strcompress(string(i),/remove_all)
	name3=prefix3+strcompress(string(i),/remove_all)
	random_region,data,fov,ra,dec,name1,name2,name3
endfor

for j=1, bk_region do begin
	name4=prefix4+strcompress(string(j),/remove_all)
	name5=prefix5+strcompress(string(j),/remove_all)
	close,1
	openw,1,name4
	close,2
	openw,2,name5
	bg=add_background(10,0.000005,fov)
	for i=0,n_elements(bg(0,*))-1 do begin
		printf,1,bg(0,i),bg(1,i),bg(2,i)
		printf,2,'star ','arcsec ','arcsec ',i+1,' yes',$
                bg(1,i),bg(2,i),' 1'
	endfor
	close,1
	close,2
endfor

wset,0
!except=1
end

PRO RANDOM_REGION, DATA, FOV, RA, DEC, NAME1, NAME2, NAME3
	
	FOV=fov
	RA=ra
	DEC=dec
	NAME1=name1
	NAME2=name2
	NAME3=name3
	x_center=3600*randomu(seed)
	y_center=3600*randomu(seed)

	xx=reform(data(1,*))-x_center
	yy=reform(data(2,*))-y_center
	ind=where(xx lt fov/2 and xx gt -(fov/2) and yy gt -(fov/2) and yy lt fov/2, count)
	if count ne 0 then begin
		oplotbox,x_center,y_center,fov
		x=xx(ind)
		y=yy(ind)
		
	
		;print,x,y
		flux=reform(data(0,ind))
		;--------------------------------------------------------------
		; Involving antenna attenuation and background
		;--------------------------------------------------------------

		n_flux=attenuation(flux,x,y,fov)
		fbg=add_background(100,0.000005,fov)
		
		close,1
	
		openw,1,name1
		for i=0,n_elements(flux)-1 do begin
			printf,1,n_flux(i),x(i),y(i)			
		endfor
		for i=0,n_elements(fbg(0,*))-1 do begin
			printf,1,fbg(0,i),fbg(1,i),fbg(2,i)			
		endfor
		close,1

		;----------------------------------------------------------------------------
		;  Produce a position file for miriad to overlay on radio map
		;----------------------------------------------------------------------------
		close,3
		openw,3,name2
		for i=0,n_elements(x)-1 do begin
		       printf,3,'star ','arcsec ','arcsec ',i+1,' yes',$
			x(i),y(i),' 1'
		endfor
		close,3
		;-----------------------------------------------------------------
		;  Produce a position file contains the RA and Dec. for
		;    mock observation
		;-----------------------------------------------------------------
	endif else begin
		oplotbox2,x_center,y_center,fov
		bg=add_background(100,0.000005,fov)
		close,1
		openw,1,name1
		for i=0,n_elements(bg(0,*))-1 do begin
			printf,1,bg(0,i),bg(1,i),bg(2,i)
		endfor
		close,1
		close,3
		openw,3,name2
		for i=0,n_elements(bg(0,*))-1 do begin
		       printf,3,' '
		endfor
		close,3
	endelse

	ra_obs=ra+(x_center-1800)/3600		
	dec_obs=dec+(y_center-1800)/3600
	close,4
	openw,4,name3
	printf,4,'RA',ra_obs
	printf,4,'Dec',dec_obs
	close,4
	return

end

FUNCTION ATTENUATION,FLUX,X,Y,FOV,N_FLUX
	x=X
	y=Y
	flux=FLUX
	n_flux=fltarr(n_elements(flux))
	psf_y=psf_gaussian(ndimen=1,npixel=fov*2,fwhm=fov)
	psf_x=findgen(fov*2)-fov


	for i=0,n_elements(flux)-1 do begin
		n_flux(i)=flux(i)*psf_y(where (psf_x eq fix(sqrt(x(i)^2+y(i)^2))))
	endfor
	return,n_flux
END

PRO OPLOTBOX,XCENTER,YCENTER,SIZE
	xcenter=XCENTER
	ycenter=YCENTER
	size=SIZE
	r=size/2
	oplot,[xcenter-r,xcenter+r],[ycenter+r,ycenter+r],color=255
	oplot,[xcenter-r,xcenter+r],[ycenter-r,ycenter-r],color=255
	oplot,[xcenter+r,xcenter+r],[ycenter-r,ycenter+r],color=255
	oplot,[xcenter-r,xcenter-r],[ycenter-r,ycenter+r],color=255
END

PRO OPLOTBOX2,XCENTER,YCENTER,SIZE
	xcenter=XCENTER
	ycenter=YCENTER
	size=SIZE
	r=size/2
	oplot,[xcenter-r,xcenter+r],[ycenter+r,ycenter+r];,color=255
	oplot,[xcenter-r,xcenter+r],[ycenter-r,ycenter-r];,color=255
	oplot,[xcenter+r,xcenter+r],[ycenter-r,ycenter+r];,color=255
	oplot,[xcenter-r,xcenter-r],[ycenter-r,ycenter+r];,color=255
END
FUNCTION ADD_BACKGROUND, NUMBER, FLUX, FOV, BG
	flux=FLUX
	number=NUMBER
	bg=fltarr(3,number)
	x_ba=fov*randomu(seed,number)-(fov/2)
	y_ba=fov*randomu(seed,number)-(fov/2)
	bg(0,*)=flux
	bg(1,*)=x_ba
	bg(2,*)=y_ba
	return, bg
END
