
!p.multi=[0,2,2]

;s=series(2.5,3.4,10)
s=3.0
set_plot,'ps'
for i=0, n_elements(s)-1 do begin
sigma=s(i)

device,filename='/scr1/alma_result_'+strmid(strcompress(string(sigma),/remov),0,3)+'.ps',/color,xsize=20,ysize=20,$
       yoffset=5,xoffset=1

alma_detect,1,256,sigma,1
device,/close
endfor

set_plot,'x'

!p.multi=[0]
end
