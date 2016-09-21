!p.multi=[0,2,2]
set_plot,'ps'
device,filename='/home/chyan/Thesis/Latex/sma_mock_image.eps'$
	,/encapsulated,xsize=20,ysize=20
;s=series(2.0,5.0,30)
s=3.0

for i=0, n_elements(s)-1 do begin
	sigma=s(i)
	for j=1,4 do begin
		sma_detect,2,2,sigma,j
	endfor
endfor
device,/close
set_plot,'x'
!p.multi=0
end
