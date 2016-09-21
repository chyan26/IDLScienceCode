
FUNCTION GETSERIES, first, last, step
  total=(last-first)/step+1
  
  return,(findgen(total))*step+first
END

FUNCTION  DVDX,a,x,v
  alpha=a
  lf=((x-v)^2-1)
  rf=(alpha*(x-v)-2/x)*(x-v)
  return,lf/rf
END

PRO RUN
  h=0.01
  x=getseries(0,500,h)
  v=fltarr(n_elements(x))
  v0=0.0
  v[n_elements(v)-1]=v0
  a=2.2
  
  for i=n_elements(x)-1,1,-1 do begin
    f=dvdx(a,x[i],v[i])
    k1=h*f
    k2=h*dvdx(a,x[i]-h/2,v[i]+k1/2.0)
    k3=h*dvdx(a,x[i]-h/2,v[i]+k2/2.0)
    k4=h*dvdx(a,x[i]-h,v[i]+k3)
    
    v[i]=v[i-1]+(k1/6.0)+(k2/3.0)+(k3/3.0)+(k4/6.0)
  endfor
  plot,x,v,xrange=[0,0.1]
  ;print,x,v
END