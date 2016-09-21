PRO COUNT_TIME_ALMA, S, N, T, TOTAL_T, T_SYS, COUNT
	s=S
	n=N			
	t=T			; obs. time
	count=COUNT		; count in diff. stradegy
	total_t=TOTAL_T		; total observation time budget
	t_sys=T_SYS		; sytem temperature	
	field=total_t/t

	ds=alma_sen(t_sys,t)
	s_sma=3*reform(ds(1,*))

	n_sma=interpol(n,s,s_sma(sort(s_sma)))

	t=t[reverse(sort(t))]
	count=n_sma*field[reverse(field)]/3600*0.09

END
