
raw=read_ascii('/scr1/Mock_sma_0417_AT/Detect/sma_rate')

d=reform(raw.field1)

plot,d(0,*),d(2,*),psym=4
oplot,d(0,*),d(2,*)
oplot,d(0,*),d(1,*),line=2

end
