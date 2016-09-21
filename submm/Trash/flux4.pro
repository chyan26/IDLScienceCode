PRO FLUX4

n0=1.1d4
s0=1.79
alpha=0.0
beta=3.13
fov=36              ; FOV is 36 arcsecond


s=(findgen(2000)+1)/200
n=scott_sn(n0,s0,alpha,beta,s)
nn=fltarr(n_elements(n))
n1=fltarr(n_elements(n))
ss=fltarr(n_elements(n))

for i=0, n_elements(n)-2 do begin
	nn(i)= int_tabulated(s(i:i+1),n(i:i+1),/sort)
	ss(i)=(s(i)+s(i+1))/2
endfor



plot,ss,nn,/xlog,/ylog,xrange=[0.01,30],xstyle=1,yrange=[1,1d5],ystyle=1
oplot,s,n

close,1
openw,1,'/scr1/Confusion/Data/temp'
for i=0,n_elements(nn)-1 do begin
        for j=0,nn(i)-1 do begin
                printf,1,format='(f11.9,tr4,f10.4,tr4,f10.4)',ss(i)/1000,3600*randomu(seed),3600*randomu(seed)
        endfor
endfor

data=dblarr(3,12697)


;---------------------------------------------------------------------------
;  Now, extract the a area within given fov.  The center of the field
;    is randomly selected.
;---------------------------------------------------------------------------

close,2
openr,2,'/scr1/Confusion/Data/temp'
readf,2,format='(f11.9,tr4,f10.4,tr4,f10.4)',data
close,2

prefix1='/scr1/Confusion/Data/submm_source'
prefix2='/scr1/Confusion/Data/submm_position'

for i=1,150 do begin
	name1=prefix1+strcompress(string(i),/remove_all)
	name2=prefix2+strcompress(string(i),/remove_all)
	random_region,data,fov,name1,name2
endfor
end

PRO RANDOM_REGION,DATA,FOV,NAME1,NAME2
	jump1: wait,1
	FOV=fov
	NAME1=name1
	NAME2=name2
	random=3600*randomu(seed,2)
	x_center=random(0)
	y_center=random(1)
	xx=reform(data(1,*))-x_center
	yy=reform(data(2,*))-y_center
	ind=where(xx lt fov/2 and xx gt -(fov/2) and yy gt -(fov/2) and yy lt fov/2, count)
	if count eq 0 then goto, jump1
	x=xx(ind)	
	y=yy(ind)
	flux=data(0,ind)
	;--------------------------------------------------------------
	; Involving antenna attenuation
	;--------------------------------------------------------------
	;print,x_center,y_center,data(1,ind(0)),data(2,ind(0))
	n_flux=attenuation(flux,x,y,fov)	
	
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
end
