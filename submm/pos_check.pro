
name1='/scr1/Confusion/Data/submm_source'
;x_all=0
;y_all=0
i=1
tt=read_ascii(name1+strcompress(string(i),/remov))
x=reform(tt.field1(1,*))	
y=reform(tt.field1(2,*))
plot,x,y,psym=5,xrange=[-18,18],yrange=[-18,18]


for i=58,60 do begin
	tt=read_ascii(name1+strcompress(string(i),/remov))
	aa=reform(tt.field1)
	x1=reform(aa(1,*))
	y1=reform(aa(2,*))
	
	oplot,x1,y1,psym=6
	print,i
endfor

aa=read_ascii('/scr1/Confusion/Data/temp')
x=reform(aa.field1(1,*))
y=reform(aa.field1(1,*))

for i=0, n_elements(x)-1 do begin
	
	x=x-x(i)
	y=y-y(i)
	ind=where (x eq 0 and y eq 0)
	if (n_elements(ind) eq 1) and (ind(0) eq i) then goto,here
	print,'this is field',i+1
	print,'same pos',n_elements(ind)
	print,ind+1
	here:
endfor


end
