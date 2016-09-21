;function borys_sn,n0,s0,alpha,beta,s

n0=1.5d4
s0=10
alpha=-0.8
beta=-2.5
s=(findgen(200)+1)/10

	n=fltarr(n_elements(s))
	n=n0*((s/s0)^(alpha));*((1-(s/s0))^(beta))
;	return,n
end
