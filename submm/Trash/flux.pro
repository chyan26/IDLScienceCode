
n0=1.1d5
s0=1.79
alpha=0.2
beta=3.13

s=(findgen(10000)+1)/100
n=(1/(((s/s0)^alpha)+((s/s0)^beta)))*(n0/s0)

plot,s,n,/xlog,/ylog,xrange=[0.1,30],xstyle=1,yrange=[1,n0],ystyle=1

nn=shift(n,-1)
nn(n_elements(nn)-1)=0
nn=n-nn

;plot,s,nn,/xlog,/ylog,xrange=[0.1,30],xstyle=1,yrange=[1,10000],ystyle=1
index=min(where (nn lt 1))

s0=s(0:index-1)
n0=fix(nn(0:index-1))
data=fltarr(3,total(n0))
close,1
openw,1,'/home/chyan/idl_script/submm/temp'
for i=0,n_elements(n0)-1 do begin
	for j=0,n0(i)-1 do begin
		printf,1,s0(i)/1000,3600*randomu(seed),3600*randomu(seed)
	endfor
endfor
close,1

close,2
openr,2,'/home/chyan/idl_script/submm/temp'
readf,2,data
close,2
data(1,*)=data(1,*)-1800
data(2,*)=data(2,*)-1800
ind=where ( data(1,*) lt 18 and data(1,*) gt -18 and data(2,*) gt -18 and data(2,*) lt 18)

close,1
openw,1,'/scr1/Confusion/submm_source'
printf,1,data(*,ind)
close,1

close,3
openw,3,'/scr1/Confusion/submm_source_position'
for i=0,n_elements(data(0,ind))-1 do begin
	printf,3,'star ','arcsec ','arcsec ',i+1,' yes',$
		data(1,ind(i)),data(2,ind(i)),' 3'
endfor
close,3

set_plot,'ps'
device,filename='~chyan/Notes/Submm_galaxy/Tex/sn_plot.eps',/encapsul
plot,s,n,/xlog,/ylog,xrange=[0.1,30],xstyle=1,yrange=[1,10000],ystyle=1,$
	xtitle='Flux (mJy)', ytitle='Number density'
device,/close
set_plot,'x'
end
