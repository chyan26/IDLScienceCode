;This idl program is used to calculate the ALMA array sensitivity
;  using designed parameters, especially aperture efficiency
;
k=1.38d6   ; the unit is mJy m#2 / K
nj=1       ; the phase jitter effeciency
nq=0.95    ; corrlator quantum effciency
d=12.0      ; antenna diameter
n=64.0      ; total number of antennas
np=2.0     ; orthogonal polarization correlated
dv=2d9     ; bandwidth = 2G Hz 
tsys=400.0 ; system temperature

na=[0.75,0.70,0.63]   ; aperture efficiency 0.75 is for 230 GHz, 0.70 for 345 GHz, 
		      ;   0.63 for 650 GHz

dt=findgen(100)+1
ds=fltarr(n_elements(na),n_elements(dt))
for i=0,n_elements(na)-1 do begin
	ae=na(i)*!pi*(d/2)^2
	ds(i,*)=(2*k*tsys)/(nj*nq*ae*sqrt(np*n*(n-1)*dv*dt*3600))
endfor

set_plot,'ps'
device,/encapsulated,filename='~chyan/Notes/Submm_galaxy/EPS_file/alma_sensitivity.eps'
plot,dt,ds(0,*),linestyle=1,xtitle='Integration time (hours)', ytitle='Sensitivity (mJy)',/xlog,/ylog
oplot,ds(1,*),linestyle=0
oplot,ds(2,*),linestyle=2
device,/close
set_plot,'x'
end
