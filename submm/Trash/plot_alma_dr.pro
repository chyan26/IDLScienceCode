set_plot,'ps'
device,filename='/home/chyan/Notes/Submm_galaxy/EPS_file/alma_drfr.eps'$
	,/encapsulated,/color,xsize=20,ysize=20$
	,xoffset=0,yoffset=10

prefix1='/scr1/Confusion/Detect/'


plot,[2,5],[0,1],/nodata,xtitle='!6Sigma level',ytitle='Rate'
TVLCT, [0,255,0,0], [0,0,255,0], [0,0,0,255]
for i=1, 1 do begin
	data=read_ascii(prefix1+'count_table')

	dr=data.field1(4,*)/data.field1(2,*)
	fr=(data.field1(3,*)-data.field1(4,*))/data.field1(3,*)
	
	oplot,data.field1(0,*),dr,thick=2,color=i-1
	oplot,data.field1(0,*),fr,thick=2,line=2,color=i-1
endfor
device,/close
device,filename='/home/chyan/Notes/Submm_galaxy/EPS_file/alma_error.eps'$
	,/encapsulated,/color,xsize=20,ysize=20$
	,xoffset=0,yoffset=10
plot,[2,5],[1,6],/nodata,xtitle='!6Sigma level',ytitle='Error propagate factor'
TVLCT, [0,255,0,0], [0,0,255,0], [0,0,0,255]
for i=1, 1 do begin
	data=read_ascii(prefix1+'/count_table')
	dr=data.field1(4,*)/data.field1(2,*)
	fr=(data.field1(3,*)-data.field1(4,*))/data.field1(3,*)
	oplot,data.field1(0,*),sqrt(1+fr)/dr,thick=2,color=i-1
	print,min(sqrt(1+fr)/dr)
endfor
device,/close


set_plot,'x'

end
