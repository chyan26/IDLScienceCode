
n0=3d4
a=1
alpha=3.2

s=series(0.1,10.0,100)

i=(n0*alpha*s^alpha)/(a+s^alpha)^2

plot,s,i
print,int_tabulated(s,i)
end
