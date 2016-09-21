
!p.multi=[0,2,2]
s=series(2.0,5.0,30)
;device,/close
s=[3.0]
for i=0, n_elements(s)-1 do begin

set_plot,'ps'
sigma=s(i)

device,filename='/scr1/Confusion/Detect/sma_result_a_'+strmid(strcompress(string(sigma),/remov),0,3)+'.ps',/color,xsize=20,ysize=20,$
       yoffset=5,xoffset=1

sma_detect,1,4,sigma,1
device,/close
endfor
set_plot,'x'

!p.multi=[0]
end

;When change the configuration, DO NOT forget change the subroutine REJECT_FALS
