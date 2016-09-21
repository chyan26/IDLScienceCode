
c=2.9979e5
h=6.626e-27
k=1.3807e-16

v=series(1d8,1d13,100000)

micron=series(1,1d4,1d4)
lam=micron*1
nu=(c/lam)*1d9

;sed=1d12*3.9d10*1d3*newstarburst_sed(micron,/m82)/micron/nu
sed=newstarburst_sed(micron,/m82)

nu=v*1
t=10




f1=(2*h*nu^3)/c^2
f2=exp((h*nu)/(k*t))-1

bb=f1*(1/f2)
plot,nu,sed,/xlog,/ylog
oplot,nu,bb
end
