g=6.67d-11
m=1.99d30

v=[30.0,10.0,1.0]
n=[0.1,1e4,10.0]
size=[30*1e3,5.0,5.0]

vv=v*1d3
nn=n/(3.086d16)^3

bmin=2*g*m/(vv^2)
bmax=size*3.086d16



t=(vv^3)/(8.0*!pi*g^2*m^2*nn)*(1.0/(alog(bmax/bmin)))/31556926.0 
END