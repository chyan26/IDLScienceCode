PRO GET_STD, value ;,random
	path='/data/gcube/'
	value=fltarr(32)
	; loop 32 outputs
	spawn,'date +%N',seed
	print,seed
	n1=randomu(seed,32)
	n2=randomu(seed,32)
	
	for k=0,31 do begin
		x=strcompress(string(16*fix(127*n1[k])+8),/remove)
		y=strcompress(string((16*fix(4*n2[k])+8)+64*k),/remove)
		file='HP061201NoOverlap-'+x+'-'+y+'-gc.fits'
		;print,'HP061201NoOverlap-'+x+'-'+y+'-gc.fits'
		spawn,'rsync -arvz -e ssh chyan@akua:/data/lokahi/wircam/guidehotpixels/'+$
			file+' '+path
		print,file
		
		
		im=mrdfits(path+file[0])+32768.0
		nim=mediancube(im)
		value[k]=stddev(reform(nim))
	endfor
	;return,value
END


PRO CHECKGCUBE
	;for i=0,2 do begin
		get_std,v1
		get_std,v2
		;if i eq 0 then plot,value,psym=5 else oplot,value,psym=5
	;endfor

END
