
n0=1.1d4
s0=1.79
alpha=0.0
beta=3.13
fov=36              ; FOV is 36 arcsecond


s=(findgen(1000)+1)/10
n=(1/(((s/s0)^alpha)+((s/s0)^beta)))*(n0/s0)

plot,s,n,/xlog,/ylog,xrange=[0.1,30],xstyle=1,yrange=[1,n0],ystyle=1

;-----------------------------------------------------------------------------
; Plot a EPS file 
;-----------------------------------------------------------------------------
set_plot,'x'
set_plot,'ps
device,/encapsulated,filename='~chyan/Notes/Submm_galaxy/EPS_file/sn_plot.eps'
plot,s,n,/xlog,/ylog,xrange=[0.1,30],xstyle=1,yrange=[1,n0],ystyle=1,$
xtitle='Flux (mJy)', ytitle='Number density'
device,/close
set_plot,'x'

;------------------------------------------------------------------------------
;  Getting the differential s-n plot by substracting.
;   s_new => new flux
;   n_new => differential source count in each flux
;------------------------------------------------------------------------------
nn=shift(n,-1)
nn(n_elements(nn)-1)=0
nn=n-nn

test=min(where (nn lt 1))
;if min(where (nn lt 1)) ne 0 then begin 
	index=min(where (nn lt 1))
        s_new=s(0:index-1)
;endif else begin
;	index=max(where(nn ge 1))
;	s_new=s(0:index-1)
;endelse
n_new=fix(nn(0:index-1))
data=fltarr(3,total(n_new))
window,1
wset,1
plot,s_new,n_new,/xlog,/ylog,yrange=[1,1000],ystyle=1
wset,0

;---------------------------------------------------------------------------
;  The following section produce a list contains all source in 1 square
;    degree, with flux, x offset and y offset in arcsecond.
;---------------------------------------------------------------------------
close,1
openw,1,'/home/chyan/idl_script/submm/temp'
for i=0,n_elements(n_new)-1 do begin
        for j=0,n_new(i)-1 do begin
                printf,1,s_new(i)/1000,3600*randomu(seed),3600*randomu(seed)
        endfor
endfor
close,1

;---------------------------------------------------------------------------
;  Now, extract the a area within given fov.  The center of the field 
;    is randomly selected.
;---------------------------------------------------------------------------

close,2
openr,2,'/home/chyan/idl_script/submm/temp'
readf,2,data
close,2
x_center=fix(3600*randomu(seed))
y_center=fix(3600*randomu(seed))
data(1,*)=data(1,*)-x_center
data(2,*)=data(2,*)-y_center
ind=where(data(1,*) lt fov/2 and data(1,*) gt -(fov/2) and data(2,*) gt -(fov/2) and data(2,*) lt fov/2)

close,1
openw,1,'/scr1/Confusion/submm_source'
printf,1,data(*,ind)
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
end
