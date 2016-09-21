function scott_sn,n0,s0,alpha,beta,s
	n=fltarr(n_elements(s))
	n=(1/(((s/s0)^alpha)+((s/s0)^beta)))*(n0/s0)
	return,n
end
