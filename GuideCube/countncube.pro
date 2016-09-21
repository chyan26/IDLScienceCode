	path='/data/gcube/'

	;spawn, 'ls '+path+' > ~/test'
	for i=0,10 do begin
		for j=0,10 do begin
			x=strcompress(string(8+16*i),/remove)
			y=strcompress(string(8+16*j),/remove)
			filename='HP060120NoOverlap-'+x+'-'+y+'-gc.fits'
			;spawn,'more ~/test |grep HP060120NoOverlap-'+strcompress(string(k),/remove)+'- | wc -l',result
			
			
			; Read image
			im=mrdfits(path+filename,/silent)+32768.0
			nim=im[16:31,16:31,*]
			im2d=mediancube(nim)
			if (j eq 0 and i eq 0) then begin 
				value=stddev(reform(im2d)) 
			endif else begin
				value=[value,stddev(reform(im2d))]
			endelse
			;print,filename,value
		endfor
	endfor

	h=histogram(value,bin=10)
	plot,(findgen(n_elements(h))+1)*10,h,psym=10


END