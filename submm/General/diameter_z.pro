PRO DIAMETER_Z

set_plot,'ps'
device,filenam='/home/chyan/Temp/diameter_z.eps',/encapsulated,$
	xsize=20,ysize=20,xoffset=1,yoffset=1

z=series(0.1,10,200)
si=[0.1,0.5,1,15]
ssi=strcompress(string(si),/remov)

da=fltarr(n_elements(si),n_elements(z))

plot,[0,10],[0,10],/nodata,/xlog,/ylog,xrange=[0.1,10],yrange=[0.01,10],$
	xstyle=1,ystyle=1,xtitle='!6Redshift (z)', $
	ytitle='Angular size (arcsecond)'
for i=0,n_elements(si)-1 do begin
	da(i,*)=zang(si(i),z)
	oplot,z,da(i,*),thick=2
	xyouts,z(2),da(i,2),strmid(ssi(i),0,3)+' kpc',charsize=1.3
endfor

oplot,[0.1,10],[0.13,0.13],line=2
xyouts,1,0.138,'ALMA angular resolution'

oplot,[0.1,10],[0.35,0.35],line=1
xyouts,1,0.358,'SMA angular resolution'

oplot,[0.1,10],[2.0,2.0],line=1
xyouts,1,2.08,'SMA compact angular resolution'

oplot,[3.54,3.54],[0.01,10.0],line=1

device,/close
set_plot,'x'




end
