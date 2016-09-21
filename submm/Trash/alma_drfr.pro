
;s=series(2.0,5.0,30)
s=3.0
;set_plot,'ps'
;device,/color
for i=0, n_elements(s)-1 do begin
	sigma=s(i)
	for j=1,1 do begin
		alma_detect,1,256,sigma,j
		;wait,20
	endfor
endfor
;device,/close


end
