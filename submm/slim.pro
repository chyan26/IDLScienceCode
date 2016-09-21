a0=10^(4.065+0.25)

alpha=series(0.5,2.1,100)
;alpha=1.2
s=series(0.01,1.4,100)

at=fltarr(n_elements(s))
plot,[1.0,2.2],[-4d6,1d6],/nodata
for i=0,n_elements(s)-1 do begin
;for i=0,0 do begin
	rr=(a0*alpha/(alpha-1))*(1.44^(-alpha+1)-s(i)^(-alpha+1))
	aa=2.1d4-abs(rr)
	if max(aa) ge 0 then begin
		print,'s',s(i)
		print,'alpha',alpha(max(where(aa eq max(aa))))
	endif
end


end
