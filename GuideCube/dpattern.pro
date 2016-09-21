PRO DPATTERN, imp, lamda, xx, Inten
  loadconfig
  COMMON share,conf


  n=20
  nn=n*20+1
  balin = fltarr(nn)
  x     = fltarr(nn)
  oyita = fltarr(nn)                  ;an array of original yita
  yita  = fltarr(nn)                  ;an array of new yita (x-axis)
  www   = fltarr(nn)
  Inten = fltarr(nn)                  ;an array of Intensity of yita (y-axis)
  V2    = fltarr(21,21)
  V1    = fltarr(21,21)
  vv2   = fltarr(21)
  vv1   = fltarr(21)
  U0    = fltarr(nn-20,nn-20)
  U1    = fltarr(nn-20,nn-20)
  U2    = fltarr(nn-20,nn-20)
  uu0   = fltarr(nn-20)
  uu1   = fltarr(nn-20)
  uu2   = fltarr(nn-20)
  
  
  r       = conf.r                            ;set radius:   r = 3000m
  a       = conf.a                              ;set distance: a = 40AU
  ;lamda   = 3                               ;set wavelength: lamda = 3000nm
  F       = sqrt(lamda*conf.nm2km*conf.a*conf.au2km*0.5)         ;set fresnale scale: F = (a*lamda)^0.5/2 m
  rho     = float(r/F)                      ;set radius in F scale: rho
  omega   = 2*(((3^0.75)+(rho^1.5))^0.66)
  ;print,rho
  ;print,omega
  ;omega   = 4.4                             ;set occultation width: omega = 4.4
  b       = imp*omega                      ;set impact parameter:  b = n*omega
  
  
  x       = float(indgen(nn))/20           ;set factor of yita: x = 0,0.05,0.1,...,5
  oyita   = x                               ;set original distance in F scale: oyita
  yita    = (oyita^2 + b^2)^0.5             ;set new      distance in F scale: yita
  balin[*]= 1.0                             ;set base line: y = 1.0
  
  
  for i = 0,20 do begin
      www[i]  = 3.14*rho*yita[i]                                                                                                              ;
      for j = 0,20 do begin
          V2[i,j] = ((-1)^j)*((rho/yita[i])^(2+2*j))*beselj(www[i],2+2*j)
          V1[i,j] = ((-1)^j)*((rho/yita[i])^(1+2*j))*beselj(www[i],1+2*j)
      endfor
      vv2[i] = total(V2[i,*])
      vv1[i] = total(V1[i,*])
      Inten[i] = 1+vv1[i]^2+vv2[i]^2+2*vv2[i]*cos(1.57*(rho+yita[i]^2))-2*vv1[i]*sin(1.57*(rho+yita[i]^2))
  endfor
  
  
  for m = 0,nn-21 do begin
      www[m+20]  = 3.14*rho*yita[m+20]
      for k = 0,80 do begin
          U1[m,k] = ((-1)^k)*((rho/yita[m+20])^(1+2*k))*beselj(www[m+20],1+2*k)
          U2[m,k] = ((-1)^k)*((rho/yita[m+20])^(2+2*k))*beselj(www[m+20],2+2*k)
      endfor
      uu1[m] = total(U1[m,*])
      uu2[m] = total(U2[m,*])
      Inten[m+20] = 1+uu1[m]^2+uu2[m]^2+2*uu2[m]*cos(1.57*(rho+yita[m+20]^2))-2*uu1[m]*sin(1.57*(rho+yita[m+20]^2))
  endfor
  xx=oyita*f
  
  ;plot, oyita, Inten, XTITLE='yita', YTITLE='I(yita)'                ;plot Intensity versus yita
  ;oplot, balin, linestyle = 1                                        ;plot base line (y-axis = 1)

END


