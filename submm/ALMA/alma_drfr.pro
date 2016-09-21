!p.multi=0
;!p.multi=[0,2,1]
set_plot,'ps'
device,filename='/home/chyan/Thesis/Latex/alma_mock_image1.eps'$
	,/encapsulated,xsize=20,ysize=20
;s=series(2.0,5.0,30)
s=3.0


for i=0, n_elements(s)-1 do begin
	sigma=s(i)
	for j=1,1 do begin
		alma_detect_new,1,1,sigma,j
	
	endfor
endfor
device,/close
set_plot,'x'

end
