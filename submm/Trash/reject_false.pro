back=6

s=series(2.5,3.4,10)

for k=0, n_elements(s)-1 do begin
s1=strmid(strcompress(string(s(k)),/remov),0,3)
raw=read_ascii('/scr1/Mock_alma_0418_nsn_at/Detect/alma_detecion_'+s1)
d=reform(raw.field1) 
index=where(d(3,*) eq back)
x=reform(d(1,index))
y=reform(d(2,index))
total=n_elements(d(3,*))

for i=1,256 do begin
	ind=where(d(3,*) eq i)
	xx=reform(d(1,ind))
	yy=reform(d(2,ind))
	for j=0,n_elements(x)-1 do begin
		r=(x(j)-xx)^2+(y(j)-yy)^2		
		if min(r) lt 10 then begin
			total=total-1
		endif
	endfor
			

endfor
print,s(k),total
endfor

end

