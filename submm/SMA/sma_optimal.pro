
Dataset='SMA_sky1_50hr'

;name1='/home/chyan/Thesis/Latex/sma_drfr_'+strmid(dataset,4,10)+'.eps'
;name2='/home/chyan/Thesis/Latex/sma_error_'+strmid(dataset,4,10)+'.eps'

name1='/home/chyan/Thesis/Latex/sma_optimal.eps'


set_plot,'ps'
device,filename=name1,/encapsulated,/color,xsize=20,ysize=20$;
	,xoffset=0,yoffset=10
!p.multi=[0,2,2]


prefix2='/scr1/'+dataset+'/Detect/'

config=['SMA_A','SMA_B','SMA_C','SMA_D']


plot,[2,5],[0,1],/nodata,xtitle='!6Sigma level',ytitle='Detection Ratio'

i=0
for i=3, 4 do begin
	data=read_ascii(prefix2+config(i-1)+'/count_table')
	dr=data.field1(4,*)/data.field1(2,*)
	fr=(data.field1(3,*)-data.field1(4,*))/data.field1(3,*)
	oplot,data.field1(0,*),dr,thick=6,line=4-i
	;oplot,data.field1(0,*),fr,thick=1,line=4-i

endfor
plot,[2,5],[0,1],/nodata,xtitle='!6Sigma level',ytitle='False detection Ratio'

i=0
for i=3, 4 do begin
	data=read_ascii(prefix2+config(i-1)+'/count_table')
	dr=data.field1(4,*)/data.field1(2,*)
	fr=(data.field1(3,*)-data.field1(4,*))/data.field1(3,*)
	;oplot,data.field1(0,*),dr,thick=6,line=4-i
	oplot,data.field1(0,*),fr,thick=1,line=4-i

endfor


plot,[2,5],[1,6],/nodata,xtitle='!6Sigma level',ytitle='Error propagate factor'
i=0
for i=3, 4 do begin
	data=read_ascii(prefix2+config(i-1)+'/count_table')
	dr=data.field1(4,*)/data.field1(2,*)
	fr=(data.field1(3,*)-data.field1(4,*))/data.field1(3,*)
	
	
	ddr=sqrt(data.field1(4,*))/data.field1(2,*)
;	dfr=sqrt(data.field1(3,*)-data.field1(4,*))/data.field1(3,*)

	dfr=(sqrt(data.field1(4,*))/data.field1(3,*))+(data.field1(4,*)*sqrt(data.field1(3,*))/data.field1(3,*)^2)

	epf=sqrt(1+fr)/dr

	depf=sqrt((1+fr*ddr^2/(dr)^4)+(dfr^2/(4*(1+fr)*dr)))

	oplot,data.field1(0,*),epf,thick=6,line=4-i
	
	oplot,data.field1(0,*),epf+depf,thick=1,line=4-i
	oplot,data.field1(0,*),epf-depf,thick=1,line=4-i
endfor

plot,[2,5],[1,6],/nodata,xstyle=4,ystyle=4
i=0
for i=3, 4 do begin
	oplot,[2,3],[6-i,6-i],thick=2,line=4-i
endfor
;xyouts,3.2,5,'SMA A Config.',charsize=1.5
;xyouts,3.2,4,'SMA B Config.',charsize=1.5
xyouts,3.2,3,'SMA C Config.',charsize=1.5
xyouts,3.2,2,'SMA D Config.',charsize=1.5

device,/close


set_plot,'x'

!p.multi=0
end
