pro cal_kepler_eq,m0,lamda_0,var_lamda,nr,curli_pi,a,ec,t,et,ft,theta,r,lamda

num=n_elements(t)

et=fltarr(num); eccentric anamaly
ft=fltarr(num);true anamaly
theta=fltarr(num)
r=fltarr(num)

maxiter=30  ;max iteration number
delta=1.0E-5 ;for f

lamda=lamda_0+(var_lamda/3600+360*nr)*t/36500  ;mean longitude

lamda=lamda-floor(lamda/360)*360 ;longitude must lie between 0 and 360
;print,lamda

m0=lamda-curli_pi  ;mean anamoly
ww=where(m0 lt 0)
 m0(ww)=m0(ww)+360

m0=m0*!pi/180    ;in radius


for i=0,num-1 do begin
;for solving numerical solution of Kepler's equation
   iter=0

    m=m0(i)
    ;if m lt 0 then m=m+2*!pi
    e=m
 ;   print,m

    f=e-ec*sin(e)-m

    while abs(f) gt delta and iter lt maxiter do begin

      e=e-f/(1.0-ec*cos(e))
      f=e-ec*sin(e)-m
      iter=iter+1

    endwhile

    ;cal true anamoly ff and theta to the reference frame
    ff=acos((cos(e)-ec)/(1-ec*cos(e)))
    if e gt !pi then ff=2*!pi-ff

    theta0=curli_pi+ff*180.0/!pi
    if theta0 gt 360 then theta0=theta0-360

    et(i)=e
    ft(i)=ff
    theta(i)=theta0

    ;cal distance from Sun
    r0=a*(1-ec*cos(e))
    r(i)=r0

endfor

;print,f,e*180.0/!pi

return
end

