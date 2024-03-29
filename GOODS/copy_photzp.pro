

path='/arrays/capella/chyan/goodsn/07A/'

spawn,'ls '+path+'909*',result

;result=['893785p_dx_s1.fits','893785p_dx_s2.fits']
for i=0,n_elements(result)-1 do begin
	file=strmid(result[i],33,18)
	slice=fix(strmid(file,12,1))
	;go through each extension
	for ext=1,4 do begin
		h=headfits(path+file,ext=ext)
		zp=sxpar(h,'FOTC_0'+strcompress(string(slice),/remove))
		sxaddpar,h,'PHOT_ZP',zp
		modfits,path+file,0,h,ext=ext
	endfor
	print,i+1,'/',n_elements(result)
endfor 
;h = headfits(path+file,ext=1)
;zp=sxpar(h,'FOTC_01')
;sxaddpar,h,'PHOT_ZP',zp
;modfits,path+file,0,h,ext=1

end