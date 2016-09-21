pro modeling

set_plot,'ps'
device,filename='/home/chyan/temp.ps',xsize=20,ysize=25,$
	xoffset=0,yoffset=0

!p.multi=[0,2,3]

micron=series(10.0,1000.0,1000)
z=series(0.01,20.0,50)
h0=75				; Hubble constant
alpha=3				; 
obs=850			; Observation frequency
omega=1				; 
c=3d5				; Speed of light
s=series(0.01,100.0,50)         ; Observed flux
d=lumdist(z,h0=h0)

;flux=planck(wave,60)
sed=newstarburst_sed(micron,/arp220)
nu=c/micron
flux=1d7*sed*nu
;-------------------------------------------------------------
;plot a black body spectrum
;-------------------------------------------------------------
plot,micron,flux,/xlog,/ylog,xrange=[10,1000]


;-------------------------------------------------------------
; Calulate the flux observed for a object at different z. 
; Then, plot it.
;-------------------------------------------------------------
l=fltarr(n_elements(z))
for i=0,n_elements(z)-1 do begin
	l(i)=interpol(flux,micron*(1+z(i)),obs)
endfor

s=l/(4*!pi*d^2*(1+z))
plot,z,s,/xlog,/ylog

;---------------------------------------------------------------------------
; Now, calculate the source count
;---------------------------------------------------------------------------;s_local=s
n_total=fltarr(n_elements(s_local))

for j=0,49 do begin
	;-------------------------------------------------------------------
	; Calculated luminosity distance
	;-------------------------------------------------------------------
	dd=d(j)
	
	;-------------------------------------------------------------------
	; First, calculate the luminosity at rest frame 
	;-------------------------------------------------------------------
	l_rest_obs=s_local*(4*!pi*dd^2*(1+z(j)))*(1+z(j))^alpha

	;-------------------------------------------------------------------
	; calculated the factor between observation freq. and 60 micron
	;-------------------------------------------------------------------
	factor=interpol(flux,micron*(1+z(j)),60)/interpol(flux,micron*(1+z(j)),obs)

	;-------------------------------------------------------------------
	; Now, the luminosity at rest frame 60 micron is evaluated
	;-------------------------------------------------------------------
	l_rest_60=l_rest_obs*factor

	;-------------------------------------------------------------------
	; Calculate the luminosity function at give z and apply redshift
	;  evolution
	;--------------------------------------------------------------------
	l_function,h0,l_rest_60,na
	n=na*(1+z(j))^alpha
	

	;plot,s_local,l_rest_obs,/xlog,/ylog
	;--------------------------------------------------------------------
	;plot differential source count at given z
	;-------------------------------------------------------------------
	plot,s_local,n,/xlog,/ylog
	
	;---------------------------------------------------------------------
	; Integrate the differential source count at given z
	;---------------------------------------------------------------------
	nn=fltarr(n_elements(n))
	for i=0,n_elements(n)-2 do begin
		nn(i)=int_tabulated(s_local(i:n_elements(s_local)-1),n(i:n_elements(n)-1))
	endfor

	;plot,s_local,nn,/xlog,/ylog
	
	if j eq 0 then begin
		z_t=series(0.001,z(j),10)
	endif else begin
		z_t=series(z(j-1),z(j),10)
	endelse
	dv=d^2*(1+z_t)^3*c/(h0*(1+z_t)*sqrt(1+omega*z_t))

	v=int_tabulated(z_t,dv)
	nz=v*nn
	plot,z_t,dv;,/xlog,/ylog;,yrange=[0.0001,1]
	plot,s_local,nz
	n_total=nz+n_total

endfor

plot,s_local,n_total/4,/xlog,/ylog,yrange=[1,max(n_total)],xrange=[10,100]


!p.multi=0

device,/close
set_plot,'x'

end

;------------------------------------------------------------------------
;  This subroutine is used to produce 60 micron luminosity function
;	at z = 0
;------------------------------------------------------------------------
PRO l_function, H0, L, N

	h=h0/100.0
	c=2.6d-2*h^3
	alpha=1.09d0
	sigma=0.723d0
	l_s=(10^8.47)/(h^2)
	n=c*((l/l_s)^(1-alpha))*exp((-1/(2*sigma^2))*((alog10(1+(l/l_s)))^2))

end
