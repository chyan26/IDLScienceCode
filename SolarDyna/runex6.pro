

ratio=[0.2,0.1,1e-2,1e-3,1e-4,1e-5,1e-6,1e-7]

for j=0, n_elements(ratio)-1 do begin
  u2=ratio[j]
  u1=1.0-u2
  
  theta=findgen(900)/10
  res=fltarr(n_elements(theta))
  
  ;Find out the solution
  for i=0,n_elements(theta)-1 do begin
    ang=theta[i]
    r=u1
    r1=sqrt(r^2+2*u2*r*cos(ang*!pi/180)+u2^2)
    r2=sqrt(r^2-2*u1*r*cos(ang*!pi/180)+u1^2)
    
    fl=3.0+u2
    fr=(r^2)+2*((u1/r1)+(u2/r2))
    
    res[i]=abs(fr-fl)
  end
  
  ind=where(res eq min(res), count)
  if count eq 1 then begin
  print,ratio[j],theta[ind[0]]
  endif
  endfor
end



       u2           theta  
     0.200000      31.5000
     0.100000      27.2000
    0.0100000      24.2000
   0.00100000      23.9000
  0.000100000      23.9000
  1.00000e-05      23.9000