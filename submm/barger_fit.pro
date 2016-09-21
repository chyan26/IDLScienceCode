pro barger_fit,x,a,f,pder
	bx=1/(a[1]+x^a[2])
	f=a[0]/(bx)
	;if n_params() ge 4 then $
	;	pder =[[bx],[a[0]*x*bx,[replicate(1.0,n_elements(x))]]]
end
