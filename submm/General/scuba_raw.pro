PRO scuba_raw
raw=read_ascii('/home/chyan/Scuba_count/scuba_complete_data.old')
;raw=read_ascii('/home/chyan/Scuba_count/barger99')

data=reform(raw.field1)

plot,data(0,*),data(1,*),psym=4,/xlog,/ylog,yrange=[1,1d5]$
	,xrange=[0.1,20],xstyle=1
errplot,data(0,*),data(1,*)+data(2,*),data(1,*)-data(3,*)

weight=fltarr(n_elements(data(0,*)))
a=[3d4,0.0,2.5]
x=reform(data(0,*))
y=reform(data(1,*))
weight(*)=(1/((data(2,*)+data(3,*))/2))^2
;weight(*)=(1/(data(2,*)))^2
rr=curvefit(x,y,weight,a,sigma,function_name='barger_fit')
print,a
print,sigma
print,sigma/a
s=series(0.1,20,500)
n=barger_sn(a(0),a(1),a(2),s)
;n1=barger_sn(a(0)+3*sigma(0),a(1)-2*sigma(1),a(2)-3*sigma(2),s)
;n2=barger_sn(a(0)-3*sigma(0),a(1)+3*sigma(1),a(2)+3*sigma(2),s)
oplot,s,n
;oplot,s,n1,line=1
;oplot,s,n2,line=1
end

pro barger_fit,x,a,f,pder
	bx=1/(a[1]+x^a[2])
	f=a[0]*(bx)
	if n_params() ge 4 then $
		pder =[[bx],[-a[0]*(bx^2)],[-a[0]*(x^a[2])*alog(x)*(bx^2)]]
end