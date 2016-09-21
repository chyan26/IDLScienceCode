size=15


fit='/scr1/SMA_sky1_50hr/Fits/sma_d_030526_8.fits'
pos='/scr1/SMA_sky1_50hr/Data/submm_position8'

im=readfits(fit)
temp=read_ascii(pos)
x=(-1*reform(temp.field1(5,*))/0.14)+128
y=(reform(temp.field1(6,*))/0.14)+128

imm=fltarr(257,257)
imm[*,*]=1
for i=0, n_elements(x)-1 do begin
	xstart=x(i)-size
	xend=x(i)+size
	ystart=y(i)-size
	yend=y(i)+size
	
	if x(i) ge 257-size then xend=256
	if x(i) le size then xstart=0
	if y(i) ge 257-size then yend=256
	if y(i) le size then ystart=0
	imm[xstart:xend,ystart:yend]=0
endfor

new=imm*im


end
