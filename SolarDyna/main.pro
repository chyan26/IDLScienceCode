
PRO KEQ, planet,t,theta,r
  
  l=planet.l
  dl=planet.dl
  nr=planet.nr
  cpi=planet.cpi
  ec=planet.ec
  a=planet.a
  dcpi=planet.dcpi
  
  ; First of all, calculate the lambda
  lambda=l+(dl/3600.0+360.0*nr)*t/36525.0  ;mean longitude  
  lambda=lambda-floor(lambda/360)*360 ;value have to be  0 ~ 360
  
  ; Calculate the curli_pi
  ccpi=cpi
  
  ; Then calculate the mean anamoly
  m0=lambda-ccpi
  if m0 le 0 then m0=m0+360
  m0=m0*!pi/180    ;in radius
  
  ; Solve Kepler's Equation (2.79)
  e=m0+ec*sin(m0)+(ec^2)*(0.5*sin(2*m0))+(ec^3)
  
  ; Calcuate true anomaly (2.43)
  f=acos((cos(e[0])-ec)/(1-ec*cos(e[0])))
  if e gt !pi then f=2*!pi-f
  
  theta=ccpi+f*180.0/!pi
  if theta gt 360 then theta=theta-360
 
  ;Calulate the distance from Sun
  r=a*(1-ec*cos(e[0]))
  
    
END


PRO RUN

  ; Convert the date to JD
  jdcnv, 1985, 1, 1, 0., j1
  jdcnv, 2003, 7, 1, 0., j2
  tdate=j2-j1+1
  
  ; build an array of t in Julian centries
  t=((j1+findgen(tdate))-2451545.0)
    
  mars={ a:1.52333199,$
        ec:0.09341233,$
         l:355.45332,$
         dl:217103.78,$
         nr:53.0,$
         cpi:336.04084,$
         dcpi:1198.0}
  
  earth={ a:1.0,$
        ec:0.01671022,$
         l:100.46435,$
         dl:1293740.63,$
         nr:99.0,$
         cpi:102.94719,$
         dcpi:1560.0}
  
  
  for i=0,n_elements(t)-1 do begin
  ;print,t[i]
  keq,mars,t[i],m_theta,m_r
  keq,earth,t[i],e_theta,e_r
 
  if (abs(m_theta-e_theta) le 0.23) then begin
    daycnv, t[i]+2451545.0, yr, mn, day, hr
    print,format='(f6.2,tr3,f6.2,f5.2,f5.2,f5.2,tr3,a)',m_theta,e_theta,m_r,e_r,m_r-e_r,' '+strcompress(string(yr),/remove)+$
        '/'+strcompress(string(mn),/remove)+'/'+strcompress(string(day),/remove)
  end
  endfor



END









