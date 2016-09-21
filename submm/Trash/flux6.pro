PRO FLUX6

!except=0
n0=11160.0
a=0.27
beta=1.85
obs_region=10

fov=36              ; FOV is 36 arcsecond


;s=(findgen(2000)+1)/200
s=series(0.001,20,2000)
n=barger_sn(n0,a,beta,s)
;------------------------------------------------------------------------------
;  Getting the differential s-n plot by substracting.
;   s_new => new flux
;   n_new => differential source count in each flux
;------------------------------------------------------------------------------
n_shift=shift(n,-1)
n_shift(n_elements(n_shift)-1)=0
n_shift=n-n_shift


if min(where (n_shift lt 1)) ne 0 then begin 
	index=min(where (n_shift lt 1))
        ss=s(0:index-1)
endif else begin
	index=max(where(n_shift ge 1))
	ss=s(0:index-1)
endelse
nn=fix(n_shift(0:index-1))


plot,ss,nn,/xlog,/ylog,xrange=[0.01,30],xstyle=1,yrange=[0.1,1d5],ystyle=1
oplot,ss,n

close,1
openw,1,'/scr1/Confusion/Data/temp'
for i=0,n_elements(nn)-1 do begin
        for j=0,nn(i)-1 do begin
                printf,1,format='(f11.9,tr4,f10.4,tr4,f10.4)',ss(i)/1000,3600*randomu(seed),3600*randomu(seed)
        endfor
endfor


print,total(nn),n(index)
;data=dblarr(3,40243)

;print,n_elements(data)
;---------------------------------------------------------------------------
;  Now, extract the a area within given fov.  The center of the field
;    is randomly selected.
;---------------------------------------------------------------------------

;close,2
;openr,2,'/scr1/Confusion/Data/temp'
;readf,2,format='(f11.9,tr4,f10.4,tr4,f10.4)',data
;close,2

temp=read_ascii('/scr1/Confusion/Data/temp')
data=reform(double(temp.field1))
;data=dblarr(3,n_elements(a(0,*))-1)
;close,2
;openr,2,'/scr1/Confusion/Data/temp'
;readf,2,format='(f11.9,tr4,f10.4,tr4,f10.4)',data
;close,2



prefix1='/scr1/Confusion/Data/submm_source'
prefix2='/scr1/Confusion/Data/submm_position'

window,1
wset,1
plot,data(1,*),data(2,*),psym=3,xstyle=1,ystyle=1
;oplot,[100,136],[100,100],color=255
;oplot,[100,136],[136,136],color=255
;oplot,[100,100],[100,136],color=255
;oplot,[136,136],[100,136],color=255
;oplotbox,2000,1000,100
;wset,0

for i=1,obs_region do begin
	name1=prefix1+strcompress(string(i),/remove_all)
	name2=prefix2+strcompress(string(i),/remove_all)
	random_region,data,fov,name1,name2
	;print,i
endfor

wset,0
!except=1
end

PRO RANDOM_REGION,DATA,FOV,NAME1,NAME2
	jump1: wait,1
	FOV=fov
	NAME1=name1
	NAME2=name2
	random=3600*randomu(seed,2)
	x_center=random(0)
	y_center=random(1)
	
	oplotbox,x_center,y_center,fov

	xx=reform(data(1,*))-x_center
	yy=reform(data(2,*))-y_center
	ind=where(xx lt fov/2 and xx gt -(fov/2) and yy gt -(fov/2) and yy lt fov/2, count)
	if count eq 0 then goto, jump1
	x=xx(ind)	
	y=yy(ind)
	flux=reform(data(0,ind))
	;--------------------------------------------------------------
	; Involving antenna attenuation and background
	;--------------------------------------------------------------
	
	n_flux=attenuation(flux,x,y,fov)	
	bg=add_background(500,0.00003,fov)	

	close,1
	openw,1,name1
	for i=0,n_elements(flux)-1 do begin
		printf,1,n_flux(i),x(i),y(i)
	endfor
	close,1
	
	;print,x_center,y_center,x,y
	;print,flux(0),x(0),y(0)
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
