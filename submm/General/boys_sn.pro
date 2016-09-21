s=series(0.01,20,100)

n0=1.55d4
alpha=0.8
s0=10
beta=2.5

n=n0*(s/s0)^(-alpha)*(1+(s/s0))^(-beta)

plot,s,n,/xlog,/ylog

end
