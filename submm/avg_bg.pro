
bg_field=2
field=2

name1='/scr1/Confusion/Background/sma_d_030425_'
name2='_bg'
name3='.fits'

data=fltarr(257,257)

for i=1,bg_field do begin
	filename=name1+strcompress(string(field),/remov)+name2+strcompress(string(bg_field),/remov)+name3
	im=readfits(filename)
	data=im+data
endfor

data=data/bg_field		


rms=stddev(data)
th_image_cont,data,/aspect,ct=0,crange=[0.5*rms,3*rms],levels=[2*rms,3*rms],c_color=255

imm=smooth2(data,10)
fwhm=31
hmin=3.0*rms
sharplim=[0.07,1.0]
roundlim=[-0.6,1.0]
find,imm,x,y,flux,sharp,round,hmin,fwhm,roundlim,sharplim,/silent
oplot,x,y,psym=5,color=255


end
