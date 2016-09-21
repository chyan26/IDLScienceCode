FUNCTION SMA_SEN,TSYS,T,DS
;This idl program is used to calculate the SMA array sensitivity
;  using designed parameters, especially aperture efficiency
;
k=1.38d6   ; the unit is mJy m#2 / K
nj=1       ; the phase jitter effeciency
nq=0.88    ; corrlator quantum effciency
d=6.0      ; antenna diameter
n=8.0      ; total number of antennas
np=1.0     ; orthogonal polarization correlated
dv=4d9     ; bandwidth = 2G Hz 
tsys=TSYS ; system temperature
dt=T
na=[0.76,0.71,0.51]   ; aperture efficiency 0.76 is for 230 GHz, 0.71 for 345 GHz, 
		      ;   0.51 for 650 GHz

ds=fltarr(n_elements(na),n_elements(dt))
for i=0,n_elements(na)-1 do begin
	ae=na(i)*!pi*(d/2)^2
	ds(i,*)=(2*k*tsys)/(nj*nq*ae*sqrt(np*n*(n-1)*dv*dt*3600))
endfor

return,ds
end
