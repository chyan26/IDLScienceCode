!p.multi=[0,2,2]

s=series(0.01,10,2000)
n=barger_sn(20428.0,1.055,2.252,s)

obs_t=50
;obs_t=findgen(1000)+1

total_t=350

field=total_t/obs_t
factor=field*0.36/3600
;factor=field*0.09/3600

ds=sma_sen(400,obs_t)
;ds=alma_sen(400,obs_t)
no=interpol(n,s,ds(1))


nn=n/no
plot,s,nn,/xlog,/ylog
flux=interpol(s,nn,randomu(seed,no*factor))
h=n_elements(where(flux gt 3*ds(1)))

ss=3*ds(1)
;h=fltarr(n_elements(ss))
;for i=0,n_elements(ss)-1 do begin
;        h(i)=n_elements(where(flux gt ss(i)))
;endfor



;set_plot,'ps'
plot,s,n,/xlog,/ylog
oploterr,ss,h/factor,2*sqrt(h)/factor,4

plot,s,n,/xlog,/ylog
plots,ss,h/factor,psym=4
errplot,ss,(h+2*sqrt(h))*2.7/factor,(h-2*sqrt(h))*2.7/factor

;device,/close
set_plot,'x'
!p.multi=0
end
