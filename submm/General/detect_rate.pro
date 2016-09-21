s=series(0.01,100,1000)
n=sky3_sn(100,1000)

;t=series(1.0,10000,10000)
;ds=alma_sen(400,t)
;ds=reform(ds(1,*))
;n=barger_sn(20428.0,1.055,2.252,ds)

plot,s,n*0.09/3600,/xlog,/ylog
end
