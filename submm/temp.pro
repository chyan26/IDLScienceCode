
n0=3.0d4
a=0
alpha=3.2

s=series(0.01,10.0,100)

i=(2*n0*alpha^2*(alpha-1)*s^(2*alpha-2))/(a+s^alpha)^3

plot,s,i
print,int_tabulated(s,i)
end
