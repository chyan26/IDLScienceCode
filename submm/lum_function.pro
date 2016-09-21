;  This is the plot of 60 micron luminosity function
;  from IRAS galaxies.  ( Saunders, W, et al., 1990, 242, 318)
;

h0=50.0
h=h0/100.0
l=10^(dindgen(75 )/5)
c=2.6d-2*h^3
alpha=1.09d0
sigma=0.723d0
l_s=(10^8.47)/(h^2)

;set_plot,'ps'
n=c*((l/l_s)^(1-alpha))*exp((-1/(2*sigma^2))*((alog10(1+(l/l_s)))^2))
plot,l,n,/xlog,/ylog,yrange=[10d-10,0.01],xrange=[10d7,10d12],xstyle=1,ystyle=1
;device,/close
;set_plot,'x'
end
