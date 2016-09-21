c=3.0d5
omega=1.0
h0=100.0
l=1.3d7
v=110
z=(findgen(10000)+1)/100
s=fltarr(3,n_elements(z))
wave=2000 + INDGEN(10)*100  
temp=6000

bbflux=planck(wave,temp)    ; wave conver to angstroms by multipled by 10^(-4)
plot,wave,bbflux


d=((2*c)/(h0*omega^2*(1+z)))*(omega*z+(omega-2)*(sqrt(omega*z+1)-1))
s=l/(4*!pi*d^2*(1+z)^2*v)
s1=s^(-1.5)

window,1
wset,1
plot,z,s,/xlog,/ylog,xrange=[0.01,20],yrange=[0.0000001,10],xstyle=1,ystyle=1
wset,0
end
