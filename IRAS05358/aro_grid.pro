;05:39:10.4 +35:45:19

ref=[84.7916667,35.7552]
;ref=[0.0,0.0]

k=1

for j=-7,7 do begin
for i=-7,7 do begin
	s=adstring([ref[0]-(0.0027*i),ref[1]-(0.0027*j)])+'  J2000'+' S233IRGD'+$
		strcompress(string(k),/remove)+' -17.0  LSR  RAD'
	print,s
	k=k+1
	;print, -10.0*i,-10.0*j
endfor
endfor


END