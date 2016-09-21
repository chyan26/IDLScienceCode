PRO taosgensubfits, file, outfile, lines

readcol,file,y,pix,format='(f,f)'

y = y[51:2098]
pix = pix[51:2098]

im = fltarr(n_elements(y),lines)

for i=0,lines-1 do begin
		im[*,i]=pix[*]
endfor

writefits,outfile,im

end