;This idl program calculated the current SMA sensitivity with 
;  the given parameters.
;
k=1.38d6   ; the unit is mJy m#2 / K
nj=1       ; the phase jitter effeciency
nq=0.88    ; corrlator quantum effciency
d=6.0      ; antenna diameter
n=8.0      ; total number of antennas
np=1.0     ; orthogonal polarization correlated
dv=2d9     ; bandwidth = 2G Hz 
tsys=400.0 ; system temperature

na=[0.70,0.60]   ; current antenna effeciency 0.70 is for 230 GHz, 0.6 for 345 GHz, 
		 

dt=findgen(50)+1
ds=fltarr(n_elements(na),n_elements(dt))
for i=0,n_elements(na)-1 do begin
	ae=na(i)*!pi*(d/2)^2
	ds(i,*)=(2*k*tsys)/(nj*nq*ae*sqrt(np*n*(n-1)*dv*dt*3600))
endfor

set_plot,'ps'
device,/encapsulated,filename='~chyan/Notes/Submm_galaxy/EPS_file/sma_sensitivity_now.eps'
plot,dt,ds(0,*),linestyle=1,xtitle='Integration time (hours)', ytitle='Sensitivity (mJy)'
oplot,ds(1,*),linestyle=0

device,/close
end
