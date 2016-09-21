
n0=20428.0
a=1.055
beta=2.252
s=series(0.01,20,200)

n=beta*n0*s^(beta+1)/(a+s^beta)^2


;s=series(0.01,20,200)
;n=barger_sn(n0,a,beta,s)

;s=series(0.23,20,1000)
;n=power_sn(20,1000)

nn=n/1.5d5
plot,s,n,/xlog,/ylog

slim=0.4
ind=where(s le slim)
print,sqrt(int_tabulated(s(ind),nn(ind)))

;t=findgen(10000)+1
;dd=sma_sen(400,t)
;ds_sma=3.4*reform(dd(1,*))
;field=1000.0/t
;ct_sma=barger_sn(20428.0,1.055,2.252,ds_sma)*0.005/3600
;plot,t,ct_sma,/xlog,/ylog
end
