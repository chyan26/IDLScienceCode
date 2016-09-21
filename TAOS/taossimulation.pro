
file = '/home/chyan/TAOS/out.fits'

im=readfits(file)
im=reform(im,n_elements(im))
h=histogram(im,min=min(im),max=max(im),bin=1)

inx = where(h eq max(h))

xp=findgen(n_elements(h))+min(im)
plot,xp,h,xrange=[xp[inx]-50,xp[inx]+50],psym=10


x=xp[inx-40:inx+40]
y=h[inx-40:inx+40]

yfit=gaussfit(x,y,a)

oplot,x,y,color=255

xyouts,0.94*max(x),0.9*max(h),'Median = '+strcompress(string(a[1]),/remove),$
	charsize=1.5
xyouts,0.94*max(x),0.8*max(h),'RMS = '+strcompress(string(a[2]),/remove),$
	charsize=1.5


end