function md_planck,freq,temp
	h=6.626d-27
	k=1.3807d-16
	v=freq*10^9
	c=3.0d10
	flux=fltarr(n_elements(freq))
	flux=((2*h*v^3)/c^2)*(1/(exp(h*v/k*temp)-1))
	return,flux
end
