
z=[1,2,3,4]

set_plot,'ps'
device,filename='/h/chyan/flux_z.eps',/encapsulated,$
	xsize=20,ysize=20

plot,[0.1,1d5],[0.1,2],/xlog,/ylog,xrange=[10d3,1],yrange=[0.5,100]$
	,ystyle=1,xstyle=1,/nodata,xtitle='!6Observed Wavelength (!7l!6m)'$
	,ytitle='Flux density(mJy)',charsize=1.3;,ytickformat='(e10.4)'
for i=1,n_elements(z)-1 do begin
	c=2.9979e5
	h0=75

	micron=series(1,1d4,1d4)
	lam=micron*(1+z(i))
	nu=(c/lam)*1d9

	sed=1d13*3.9d10*1d3*newstarburst_sed(micron,/m82)/micron/nu

	d=lumdist(z(i),h0=h0)
	s=sed/(4*!pi*d^2*(1+z(i)))
	word='Z = '+strmid(strcompress(string(z(i)),/remov),0,4)
	xyouts,min(lam),s(where(lam eq min(lam))),word
	oplot,lam,s
	
endfor
	
;oplot,[1700,1700],[1e-7,10000],line=2
;oplot,[300,300],[1e-7,10000],line=2

;oplot,[9577,9577],[1e-7,10000],line=3
;oplot,[315,315],[1e-7,10000],line=3

t=8
;ds=sma_sen(400,t)
ds=3*5
oplot,[0.1,1d6],[ds,ds],line=1
xyouts,1d4,ds+1,'SMA 8 hour sensitivity'
oplot,[300,1700],[ds-1,ds-1],thick=3

;t=8
;ds=alma_sen(400,t)
;ds=3*ds(1)
;oplot,[0.1,1d6],[ds,ds],line=1
;xyouts,1d4,ds+0.01,'ALMA 8 hour'
;oplot,[315,9577],[ds-0.01,ds-0.01],thick=3

;oplot,[300,1700],[ds,ds]
;oplot,[300,300],[1e-7,10000],line=2

;oplot,[9577,9577],[1e-7,10000],line=3
;oplot,[315,315],[1e-7,10000],line=3
device,/close
set_plot,'x'

end
