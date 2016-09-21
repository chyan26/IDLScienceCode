
z=series(0.1,20,100)
c=2.9979e5
h0=75

obs_v=60

flux=fltarr(n_elements(z))



;set_plot,'ps'
;device,filename='/home/chyan/Thesis/EPS_file/flux_z.eps',/encapsulated,$
;	xsize=20,ysize=20

;plot,[0.1,1d5],[1e-5,2],/xlog,/ylog,xrange=[1.5d4,0.3],yrange=[1e-3,1d2]$
;	,ystyle=1,xstyle=1,/nodata,xtitle='!6Observed Wavelength'$
;	,ytitle='Flux density(mJy)';,ytickformat='(e10.4)'

micron=series(1,1d4,1d4)
nu=(c/micron)*1d9
sed=4d2*1d3*newstarburst_sed(micron,/m82)/micron/nu
sfr=interpol(sed,micron,60)

for i=0,n_elements(z)-1 do begin
	
	
	lam=micron*(1+z(i))
	nu=(c/lam)*1d9

	sed=4d12*3.9d10*1d3*newstarburst_sed(micron,/m82)/micron/nu

	d=lumdist(z(i),h0=h0)
	s=sed/(4*!pi*d^2*(1+z(i)))
;	word='Z = '+strmid(strcompress(string(z(i)),/remov),0,4)
;	xyouts,min(lam),s(where(lam eq min(lam))),word
;	oplot,lam,s
	flux(i)=interpol(s,lam,obs_v)

endfor

plot,z,flux,/xlog,/ylog	
;oplot,[1700,1700],[1e-7,10000],line=2
;oplot,[300,300],[1e-7,10000],line=2

;oplot,[9577,9577],[1e-7,10000],line=3
;oplot,[315,315],[1e-7,10000],line=3

;t=8
;ds=sma_sen(400,t)
;ds=3*ds(1)
;oplot,[0.1,1d6],[ds,ds],line=1
;xyouts,1d4,ds+1,'SMA 8 hour'
;oplot,[300,1700],[ds-1,ds-1],thick=3

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
;device,/close
;set_plot,'x'

end
