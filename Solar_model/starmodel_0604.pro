pro starmodel_0604
;  This program is the to model the structure of
;  present Sun for the course 'Stellar Structure
;  and Evolution.
;
;
;  Program is written by Chi-hung Yan & Pei-Li Ho of NTNU
;
;  4st  revised   May 20, 2002

pc=1.911854820364571d17             ; the central pressure, 10^17 dyne-cm^-3
;pc=1.91d17
tc=15.3d6            ; the central temperature,K
xc=0.336d0             ; The H abundance, ref: Prialnik, D., Stellar Structure and Evolution(Cambri.) pp. 39
yc=0.643d0             ; The HE abudance
xs=0.729d0
ys=0.251d0



rs=6.96d10            ; the radius of the Sun, 10^10 cm
g=6.672d-8            ; the gravitation constant, 10^-8 dyne-/g^2
k=1.38d-16            ; Boltzmann constant for 1 mole, 10^-16 erg/K
sigma=5.67d-5         ; Stefan-Boltzmann constant, 10^-5 erg cm^-2 s^-1 K^-4
mh=1.66d-24           ; H atomic mass ,10^-24g
gamma=5.0d0/3         ; adiabatic gamma for a monatomic gas
n=100
dr=1.0/n*rs           ; the delta r
m_sun=1.9891d33
l_sun=3.847d33

r=findgen(n+1)*dr			;Give an array for radius


;----------------------------------------------
; Creat array will be used later
;----------------------------------------------
m=dblarr(n+1)
lu=dblarr(n+1)
rho=dblarr(n+1)
p=dblarr(n+1)
t=dblarr(n+1)
grad=dblarr(n+1)
epsilon=dblarr(n+1)
kapa=dblarr(n+1)

mm=dblarr(n+1)
luu=dblarr(n+1)
rhoo=dblarr(n+1)
pp=dblarr(n+1)
tt=dblarr(n+1)
gradd=dblarr(n+1)
epsilonn=dblarr(n+1)
kapaa=dblarr(n+1)



x=dblarr(n+1)
y=dblarr(n+1)
mu=dblarr(n+1)

;-----------------------------------
;Calculate the mean molecular weight
;-----------------------------------
for i=0,n do begin
	if (i lt 0.2*n) then begin
		x(i)=xc+((xs-xc)/(0.2*n))*i
		y(i)=yc+((ys-yc)/(0.2*n))*i
		mu(i)=1.0/((x(i)+0.5*y(i)+0.5*(1-x(i)-y(i)))+(x(i)+0.25*y(i)+((1-x(i)-y(i))/(15.5))))
	endif else begin
		x(i)=xs
		y(i)=ys
		mu(i)=1.0/((xs+0.5*ys+0.5*(1-xs-ys))+(xs+0.25*ys+((1-xs-ys)/(15.5))))
	endelse
endfor



;----------------------------------------
;Here, we set some boundary conditions.
;----------------------------------------
m(0)=0
lu(0)=0
rho(0)=(pc*mu(0)*mh)/(k*tc)
p(0)=pc
t(0)=tc
tt(n)=5770
mm(n)=m_sun
luu(n)=l_sun
pp(n)=1.0d9
rhoo(n)=(pp(n)*mu(n)*mh)/(k*tt(n))
epsilon(0)=cal_epsilon(rho(0),t(0),x(0))
kapa(0)=cal_kapa(rho(0),t(0),x(0),y(0))

;-----------------------------------------
;Star to calculate the first shell
;-----------------------------------------
m(1)=(4.0d0/3)*!pi*(r(1)^3)*rho(0)
p(1)=p(0)-((2.0d0/3)*!pi*g*(rho(0)^2.0d0)*(r(1)^2.0d0))
lu(1)=(4.0d0/3)*!pi*(r(1)^3.0d0)*rho(0)*epsilon(0)

;-------------------------------------------------------------------
;Determine either convection or radiation transfer will be operation
;-------------------------------------------------------------------
dtdr_rad=kapa(0)*(rho(0)^2.0d0)*epsilon(0)*(r(1)^2.0d0)/(32.0d0*sigma*t(0)^3.0d0)
dtdr_con=(2.0d0/3.0d0)*!pi*((gamma-1.0d0)/gamma)*mu(0)*mh*g*rho(0)*r(1)^2.0d0/k
grad(1)=3.0*p(0)*kapa(0)*lu(0)/(64*!pi*sigma*g*m(1)*(t(0)^4))
if (grad(1) lt 0.4) then begin
	t(1)=t(0)-dtdr_rad
endif else begin
	t(1)=t(0)-dtdr_con
endelse

rho(1)=(p(1)*mu(1)*mh)/(k*t(1))

;-----------------------------------------
;Star to calculate the other shell
;-----------------------------------------

for i=2,n do begin
	epsilon(i-1)=cal_epsilon(rho(i-1),t(i-1),x(i-1))
	kapa(i-1)=cal_kapa(rho(i-1),t(i-1),x(i-1),y(i-1))
	m(i)=m(i-1)+(4.0d0*!pi*(r(i-1)^2)*rho(i-1))*dr
	p(i)=p(i-1)-((g*m(i-1)*rho(i-1))/(r(i-1)^2))*dr
	lu(i)=lu(i-1)+(4.0d0*!pi*(r(i-1)^2)*rho(i-1)*epsilon(i-1))*dr

	grad(i)=3.0*p(i-1)*kapa(i-1)*lu(i-1)/(64*!pi*sigma*g*m(i-1)*(t(i-1)^4))

	if (grad(i) lt 0.4) then begin
		dtdr=(3.0d0*lu(i)*kapa(i-1)*rho(i-1))/(4.0d0*!pi*(r(i)^2.0d0)*16.0d0*sigma*t(i-1)^3.0d0)
	endif else begin
   		dtdr=((gamma-1.0d0)/gamma)*mu(i-1)*mh*g*m(i-1)/(k*r(i-1)^2)
    endelse
	t(i)=t(i-1)-dtdr*dr
   	rho(i)=(p(i)*mu(i)*mh)/(k*t(i))
endfor


;----------------------------------------------------------------------------------------------------------------------
; Backward from outside
;----------------------------------------------------------------------------------------------------------------------

for i=n-1,0,-1 do begin
	epsilonn(i+1)=cal_epsilon(rhoo(i+1),tt(i+1),x(i+1))
	kapaa(i+1)=cal_kapa(rhoo(i+1),tt(i+1),x(i+1),y(i+1))
	mm(i)=mm(i+1)-(4.0d0*!pi*(r(i+1)^2)*rhoo(i+1))*dr
	pp(i)=pp(i+1)+((g*mm(i+1)*rhoo(i+1))/(r(i+1)^2))*dr
	luu(i)=luu(i+1)-(4.0d0*!pi*(r(i+1)^2)*rhoo(i+1)*epsilonn(i+1))*dr
	gradd(i)=3.0*pp(i+1)*kapaa(i+1)*luu(i+1)/(64*!pi*sigma*g*mm(i+1)*(tt(i+1)^4))
	if (gradd(i) lt 0.4) then begin
		dtdr=(3.0d0*luu(i)*kapaa(i+1)*rhoo(i+1))/(4.0d0*!pi*(r(i)^2.0d0)*16.0d0*sigma*tt(i+1)^3.0d0)
	endif else begin
   		dtdr=((gamma-1.0d0)/gamma)*mu(i+1)*mh*g*mm(i+1)/(k*r(i+1)^2)
    endelse
	tt(i)=tt(i+1)+dtdr*dr
   	rhoo(i)=(pp(i)*mu(i)*mh)/(k*tt(i))
endfor

;------------------------------------------------------------------------------------------------------------------------
;------------------------------------------------------------------------------------------------------------------------





close,1
openw,1,'~chyan/starmodel.txt'
printf,1,format="(10x,'Radius',9x,'Density',11x,'Mass',10x,'Pressure',7x,'Luminosity',6x,'Temperature',5x,'Grad')"
for i=0,n do begin
	printf,1,format="(i3,6(x,e15.5),tr4,f6.3)",i,r(i),rho(i),m(i),p(i),lu(i),t(i),grad(i)
endfor
close,1



set_plot,'ps'
!p.multi=[0,2,3]
device,filename='~chyan/starmodel.ps',xsize=20,ysize=20,yoffset=3,xoffset=1
plot,r/rs,m/m_sun,yrange=[0,1.2]
oplot,r/rs,mm/m_sun
oplot,r/rs,lu/l_sun,linestyle=1
oplot,r/rs,luu/l_sun,linestyle=1

plot,r/rs,p,title='Pressure'
oplot,r/rs,pp
plot,r/rs,t,title='Temparature'
oplot,r/rs,tt
plot,r/rs,rho,title='Density'
oplot,r/rs,rhoo
plot,r/rs,x,title='H & He'
oplot,r/rs,y
device,/close
set_plot,'x'

end







function cal_epsilon,rho,t,x
    t6=t*1.0d-6
    epsilon=2.38d6*rho*(x^2.0d0)*(t6^(-2.0d0/3))*exp(-33.8d0*(t6^(-1.0d0/3)))
    ;print,epslon,rho,t6,x
return,epsilon
end



function cal_kapa,rho,t,x,y
    tog_bf=2.82d0*(rho*(1.0d0+x))^0.2d0
    k_bf=(4.34d25/tog_bf)*(1.0d0-x-y)*(1.0d0+x)*rho/t^3.5d0
    k_ff=3.68d22*(x+y)*(1.0d0+x)*rho/t^3.5d0
    k_e=0.2d0*(1.0d0+x)
    kapa=k_bf+k_ff+k_e
return,kapa
end
