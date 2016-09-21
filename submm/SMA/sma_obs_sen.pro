;PRO SMA_OBS_SEN
!p.multi=[0,2,3]

rms=fltarr(25)
rms1=fltarr(25)

t=fix(series(4,100,25))
config=4

rms_table=fltarr(6,n_elements(t))
dev_table=fltarr(6,n_elements(t))

im=fltarr(257,257)

for j=1,4 do begin
config=j
	for i=0, n_elements(t)-1 do begin
	
		name1='/scr1/SMA_sen_test/Fits/sma_'
		name2=['a','b','c','d']
		name3='_'+strcompress(string(indgen(20)+101),/remov)+'.fits'
		im(*,*)=0	
		avgrms=0
		for k=0,n_elements(name3)-1 do begin	
			file=name1+name2(config-1)+'_'+strcompress(string(t(i)),/remov)+name3(k)
		
			temp=readfits(file)
			im=im+temp	
			
			tt=sxpar(headfits(file),'RMS')		
			fwhm1=sxpar(headfits(file),'BMAJ')
			fwhm2=sxpar(headfits(file),'BMIN')
			fwhm=(fwhm1+fwhm2)/2
			temp2=tt*(fwhm*3600)^2
			avgrms=temp2+avgrms
		endfor	
	
		rms(i)=stddev(im)/20.0
		rms1(i)=avgrms/20.0
	endfor

rms_table(j+1,*)=rms1*1000
dev_table(j+1,*)=rms*1000


endfor

ds=sma_sen(400,t)
ds=reform(ds(1,*))

rms_table(0,*)=t
dev_table(0,*)=t

rms_table(1,*)=ds
dev_table(1,*)=ds

plot,rms_table[0,*],rms_table[1,*]
plot,rms_table[0,*],dev_table[2,*]-rms_table[1,*],psym=4
plot,rms_table[0,*],dev_table[3,*]-rms_table[1,*],psym=4
plot,rms_table[0,*],dev_table[4,*]-rms_table[1,*],psym=4
plot,rms_table[0,*],dev_table[5,*]-rms_table[1,*],psym=4

!p.multi=0

;writefits,'/home/chyan/rms_table.fits',rms_table
;writefits,'/home/chyan/dev_table.fits',dev_table


;plot,t,rms_table(0,*),/xlog,/ylog
;oplot,t,rms_table(1,*),psym=4
;oplot,t,dev_table(1,*),psym=5

end
