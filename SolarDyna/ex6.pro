@circle

;set_plot,'ps'
;device,filename='rochelobe.eps',$
;   /color,xsize=20,ysize=20,xoffset=0.4,yoffset=10,$
;   SET_FONT='Helvetica',/TT_FONT,/encapsulated
;      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
;      red=1
;      green=2
;      blue=3

; Assuming the u1=0.99
u1=0.8
u2=1.0-u1
 

; Preparing data points and restrit them only on x^2+y^2=1
data=circle(0,0,u1)
xx=reform(data[0,*])
yy=reform(data[1,*])



; Plot the figure
plot,[-1.5,1.5],[-1.5,1.5],/nodata,xstyle=1,ystyle=1
;oplot,xx,yy,color=red
flag=0

;arrow,0,0,1*cos(ang),1*sin(ang),/data
ind=where(px^2+py^2 eq 1)

;print,atan(py[ind]/px[ind])*180.0/!pi

; Plot the roche lobe 
xx=(findgen(900)-450)/300
yy=(findgen(900)-450)/300
for i=0,n_elements(xx)-1 do begin
   for j=0,n_elements(yy)-1 do begin
      x=xx[i]
      y=yy[j]

      
      r1=sqrt((x+u2)^2+y^2)
      r2=sqrt((x-u1)^2+y^2)
      
      fl=3+u2
      fr=(x^2)+(y^2)+2*((u1/r1)+(u2/r2))
      if (abs(fl-fr) le 0.001 ) then begin
         plots,x,y,/data,psym=2,symsize=0.1
       endif
      ;if (x^2)+(y^2)-1 le 0.001 then begin
      ;   plots,x,y,/data,psym=4
      ;endif
      
   endfor
endfor


;device,/close
;set_plot,'x'
end








