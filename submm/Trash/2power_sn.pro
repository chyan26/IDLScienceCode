;FUNCTION 2POWER_SN, S_MAX, S_NO, N

function power_sn, s_max, s_no, n
	; This function returns a source count model in the form of
	;    2 power law.  The faintest point is located at 0.23 mJy.
	;    	
	;    S_MAX: Max flux in mJy
	;    S_NO:  Sampling number.
	;

	a0=11614.0
	a1=17500.0

	alpha=-1.067
	beta=-2.218

	s=series(0.23,s_max,s_no)
	n=fltarr(n_elements(s))

	s_a=where(s lt 1.45)
	s_b=where(s gt 1.45)

	ss_a=n_elements(s_a)

	n(0:ss_a-1)=a0*(s(s_a)^alpha)
	n(ss_a:n_elements(s)-1)=a1*(s(s_b)^beta)
	
	return

END
