  



;as=9.58201720 ;au
as=1433449370.0
ms=5.6846d26

;aj=5.204267  ;au
aj=778547200.0 ;km
mj=1.8986d27

r=6.955e5
m=1.9891d30
ns=1.0/29.657296 ;yr

g=6.67259e-11

;ns=sqrt((g*m/as^3)*(1.0+1.5*j2eff*(r/as)^2))

p=0.75*(mj/m)*((aj/as)^2)*ns
print,1.0/p


END