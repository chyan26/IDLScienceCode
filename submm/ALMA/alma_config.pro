

raw=read_ascii('/home/chyan/Array_config/ALMA/pad_location_172')
pad=reform(raw.field01)

pad(1,*)=pad(1,*)-pad(1,0)
pad(2,*)=pad(2,*)-pad(2,0)

set_plot,'ps'
!p.multi=[0,2,2]
device,filename='/home/chyan/Notes/Submm_galaxy/Latex/alma_config.ps'$
	,xsize=20,ysize=20,yoffset=1,xoffset=0,/encapsulated

con=[1,11,23,29]

for j=0,n_elements(con)-1 do begin
	index=where (pad(con(j)+3,*) eq 1)
	npad=pad(*,index)
	close,2
	openw,2,'/home/chyan/Array_config/ALMA/alma_'+strcompress(string(con(j)),/remov)+'.ant'

	for i=0,n_elements(index)-1 do begin
		printf,2,npad(1,i),npad(2,i),npad(3,i)
	endfor
	
	close,2
	no=strcompress(string(n_elements(index)),/remov)
	config=strcompress(string(con(j)),/remov)
	plot,npad(1,*),npad(2,*),psym=1,$
		title='ALMA configuration #'+config+' N= '+no,$
		xrange=[-3000,3000],xstyle=1,$
		yrange=[-3000,3000],ystyle=1,$
		xtitle='!6E-W distance (meters)',xcharsize=1.5,xtickinterval=3000,$
		ytitle='!6E-W distance (meters)',ycharsize=1.5,ytickinterval=3000
endfor

device,/close
set_plot,'x'
!p.multi=0

end
