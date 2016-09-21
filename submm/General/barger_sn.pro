function barger_sn,n0,a,beta,s
	n=fltarr(n_elements(s))
	n=n0/(a+s^(beta))
	return,n
end
