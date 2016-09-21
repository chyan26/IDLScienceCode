PRO FLUX3

;jump1: wait,1
n0=1.1d4
s0=1.79
alpha=0.0
beta=3.13
fov=36              ; FOV is 36 arcsecond


s=(findgen(2000)+1)/200
;n=(1/(((s/s0)^alpha)+((s/s0)^beta)))*(n0/s0)
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
;-----------------------------------------------------------------------------
; Plot a EPS file 
;-----------------------------------------------------------------------------
;set_plot,'x'
;set_plot,'ps
;device,/encapsulated,filename='~chyan/Notes/Submm_galaxy/EPS_file/sn_plot.eps'
;plot,s,nn,/xlog,/ylog,xrange=[0.01,100],xstyle=1,yrange=[1,1d5],ystyle=1,$
;xtitle='Flux (mJy)', ytitle='Number density'
;device,/close
;set_plot,'x'

;---------------------------------------------------------------------------
;  The following section produce a list contains all source in 1 square
;    degree, with flux, x offset and y offset in arcsecond.
;---------------------------------------------------------------------------
;s_new=ss
;n_new=nn
close,1
openw,1,'/home/chyan/idl_script/submm/temp'
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
openr,2,'/home/chyan/idl_script/submm/temp'
readf,2,format='(f11.9,tr4,f10.4,tr4,f10.4)',data
close,2
random_region,data,fov
end

PRO RANDOM_REGION,DATA,FOV
	FOV=fov
	x_center=(3600*randomu(seed))
	y_center=(3600*randomu(seed))
	data(1,*)=data(1,*)-x_center
	data(2,*)=data(2,*)-y_center
	ind=where(data(1,*) lt fov/2 and data(1,*) gt -(fov/2) and data(2,*) gt -(fov/2) and data(2,*) lt fov/2, count)
	;if count eq 0 then goto, jump1
	
	;--------------------------------------------------------------
	; Involving antenna attenuation
	;--------------------------------------------------------------
	psf_y=psf_gaussian(ndimen=1,npixel=fov*2,fwhm=fov)
	psf_x=findgen(fov*2)-fov
	;aa=fltarr(n_elements(ind))
	for i=0,n_elements(ind)-1 do begin
		data(0,ind(i))=data(0,ind(i))*psf_y(where (psf_x eq fix(sqrt(data(1,ind(i))^2+data(2,ind(i))^2))))
	end
	close,1
	openw,1,'/scr1/Confusion/submm_source'
	printf,1,data(*,ind);,aa(*)
	close,1

	;----------------------------------------------------------------------------
	;  Produce a position file for miriad to overlay on radio map
	;----------------------------------------------------------------------------
	close,3
	openw,3,'/scr1/Confusion/submm_source_position'
	for i=0,n_elements(data(0,ind))-1 do begin
	       printf,3,'star ','arcsec ','arcsec ',i+1,' yes',$
                data(1,ind(i)),data(2,ind(i)),' 1'
	endfor
	close,3
	return

end
