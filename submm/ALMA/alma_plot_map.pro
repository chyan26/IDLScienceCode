!p.multi=[0,2,2]

s=3.0

for i=0, n_elements(s)-1 do begin
	sigma=s(i)
	for j=1,3 do begin
		alma_detect,94,94,sigma,j
		
	endfor
endfor

!p.multi=0

end
