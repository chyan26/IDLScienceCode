PRO venus
  
  v={a:0.72333199,$
  ec:0.00677323,$
  l:181.97973,$
  dl:712136.06,$
  nr:415.0,$
  cpi:77.45645,$
  dcpi:-108.80}

jd=2450375.91667d
t=(jd-2451545.0)/36525.0
print,t
cal_kepler_eq,m0,v.l,v.dl,v.nr,v.cpi,v.a,v.ec,t,et,ft,theta,r

print,r[0],theta[0]

keq,v,t,tt,rr

print,rr,tt
END

PRO NEWRUN
  earth={ a:1.0,$
        ec:0.01671022,$
         l:100.46435,$
         dl:1293740.63,$
         nr:99.0,$
         cpi:102.94719,$
         dcpi:1560.0}
  
  t=findgen(10000)
  cal_kepler_eq,m0,earth.l,earth.dl,earth.nr,earth.cpi,earth.a,earth.ec,t,et2,ft2,theta2,r2,lamda
  
  for i=0, n_elements(t)-1 do begin       
    print,t[i],theta2[i],m0[i]*180.0/!pi,lamda[i]
  endfor
END

