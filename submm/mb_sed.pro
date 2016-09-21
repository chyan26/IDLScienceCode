!except=0

factor=10^4

v=(findgen(1000)+1)^8
;v=353.0d9
l=850.0*factor
temp=45.0

flux1=planck(l,temp)

h=6.626d-27
k=1.3807d-16
c=3.0^10
flux=fltarr(n_elements(v))

flux=(2*h*v^3/c^2)*(1/(exp(v*h/k/temp)-1))


end

