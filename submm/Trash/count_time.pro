!p.multi=[0,2,2]
n0=11160.0
a=0.27
beta=1.85
s=series(0.1,10,2000)
n=barger_sn(n0,a,beta,s)

plot,s,n,/xlog,/ylog


t=findgen(1000)+1
field=2000/t

ds=sma_sen(400,t)
s_sma=3*reform(ds(1,*))

;n_sma=barger_sn(n0,a,beta,s_sma(sort(s_sma)))

n_sma=interpol(n,s,s_sma(sort(s_sma)))
plot,s_sma(sort(s_sma)),n_sma,/xlog,/ylog

plot,t[reverse(sort(t))],n_sma*field[reverse(field)]/14400,/xlog,/ylog

t=t[reverse(sort(t))]
count=n_sma*field[reverse(field)]/14400
plot,t,count,/xlog,/ylog
end
