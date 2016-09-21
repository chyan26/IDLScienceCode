PRO SMA_SN_CONSTRAIN


t=findgen(100)+1
total_t=300
slope=fltarr(n_elements(t))
err=fltarr(n_elements(t))

set_plot,'ps'
device,filename='/home/chyan/Thesis/Latex/sma_sn_constrain'+$
	strcompress(string(total_t),/remov)+'_sky1.eps',/encapsulated,$
	xsize=20,ysize=20


for i=0,n_elements(t)-1 do begin
	sma_constrain,total_t,t(i),a,b
	slope(i)=a
	err(i)=b
endfor


plot,t,slope,yrange=[1.8,2.5],thick=2,ystyle=1,ytitle='!6Source count slope'$
	,xtitle='Exposure time per pointing (hous, total time is '+strcompress(string(total_t),/remov)+' hours)'

oplot,t,slope+err,line=2
oplot,t,slope-err,line=2

oplot,[0,100],[2,2],line=1
xyouts,20,2.01,'Source count slope from complex luminosity evolution'
device,/close
set_plot,'x'


end
