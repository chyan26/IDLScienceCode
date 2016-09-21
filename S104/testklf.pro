

PRO TESTKLF
age=[(findgen(10)+1)/100.0,(findgen(10)+1)/10.0,findgen(10)+1]


muenchimf,m3,n3,rm3
set_plot,'ps'
device,filename='~/testklf.eps',ysize=25,xsize=20,yoffset=1,xoffset=0,/color
tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
!p.multi=[0,2,4]
for i=0,n_elements(age)-1 do begin
  t=age[i]
  loadiso_dm,dm97_iso,age=t,av=0
  t=age[i]
  loadiso_sdf,sdf_iso,age=t,av=0
  
  ind1=where(rm3 ge min(dm97_iso.mass) and rm3 le max(dm97_iso.mass))
  mk1=interpol(dm97_iso.mk,dm97_iso.mass,rm3[ind1])
  
  ind2=where(rm3 ge min(sdf_iso.mass) and rm3 le max(sdf_iso.mass))
  mk2=interpol(sdf_iso.mk,sdf_iso.mass,rm3[ind2])
  
  t=age[i]
  modelklf,rm3,klf1,age=t
  
  mag_min=-5
  mag_max=10
  bin=0.5
  
  h1=histogram(mk1,min=mag_min,max=mag_max,bin=bin)
  xh1=(findgen(n_elements(h1))*bin)+mag_min
  
  h2=histogram(mk2,min=mag_min,max=mag_max,bin=bin)
  xh2=(findgen(n_elements(h2))*bin)+mag_min

  h2=histogram(mk2,min=mag_min,max=mag_max,bin=bin)
  xh2=(findgen(n_elements(h2))*bin)+mag_min
  
  
  plot,xh1,alog10(h1),yrange=[0,3]
  oplot,xh2,alog10(h2),line=4
  oplot,klf1.xh,alog10(klf1.h)-0.1,line=3,color=red
  xyouts,-4,2.6,'age= '+strcompress(string(age[i]),/remove)
endfor



set_plot,'x'
END