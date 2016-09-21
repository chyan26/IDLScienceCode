
PRO INT_FILTERPASS, nm, tr, xx, cu
  loadconfig
  COMMON share,conf

  ;plot,oyita,pattern
  xx=getseries(0,20,0.1)
  cu=fltarr(n_elements(xx))
  
  anm=getseries(min(nm),max(nm),10)
  atr=interpol(tr,nm,anm)
  ;anm=nm
  ;atr=tr
  for i=0,n_elements(anm)-1 do begin
    dpattern,conf.b, anm[i],x, pattern
    ind=where(xx le max(x))
    pp=atr[i]*interpol(pattern,x,xx[ind])
    cu[ind]=cu[ind]+pp
  endfor
  
  factor=mean(cu[n_elements(cu)-20:n_elements(cu)-1])
  cu=cu*1.0/factor
  ;plot,xx,cu
  ;print,cu
END


; theta is in the unit of mas
PRO INT_STELLARDISK, xx, cu, theta, newcu
  loadconfig
  COMMON share,conf
  

  d=(theta*1e-3)/206265.0*conf.a*conf.au2km
  pt=getseries(-d,d,0.1)
  
  newcu=fltarr(n_elements(cu))
  temp=fltarr(n_elements(cu))
  
  ;plot,xx,cu
  for i=0,n_elements(pt)-1 do begin
    nx=xx+pt[i]
    ;oplot,nx,cu
    temp=temp+interpol(cu,nx,xx)
  endfor
  
  newcu=temp/n_elements(pt) 
  ;oplot,xx,newcu,color=255
  ;print,theta*1e-3,kbotheta

END

PRO SAMPLETIME,xx,newcu,xt,data
  loadconfig
  COMMON share,conf

  t=xx/conf.vt
  xt=getseries(-max(t),max(t),1.0/conf.gexp)
  allcu=[newcu,newcu]
  allt=[-t,t]
  ;print,xt
  data=fltarr(n_elements(xt))
  for i=1,n_elements(xt)-1 do begin
    ind=where(allt ge xt[i-1] and allt lt xt[i])
    data[i]=mean(allcu[ind])
  endfor
  inx=where(data gt 0)
  
  ;plot,t,newcu
  xt=xt[inx]-0.5*1.0/conf.gexp
  data=data[inx]
  ;oplot,xt,data,psym=10
  
END

PRO ADDNOISE,level,sn,data,ndata
  loadconfig
  COMMON share,conf
  
  stddev=level/sn
  ndata=(level*data)+stddev*randomn(seed,n_elements(data))

  ;plot,ndata,psym=10



END





