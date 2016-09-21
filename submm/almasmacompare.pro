; almasmacompare
; .r plot_scubacount   1st! to get s2, n2

m=5000
md =5.
s=10d^(((findgen(m))*(12.0/30.0))-9)
n1=scott_sn(1.1d4,1.79,0.0,3.13,s)

m2=(fix(m/md))
n2 = dblarr(m2)
s2 = dblarr(m2)

for i=1,m2 do begin
	n2(i-1)= int_tabulated(s(0:i*md-1),n1(0:i*md-1),/sort)  
	s2(i-1)=s(i*md-1)
endfor


ssma = 3.*3.  ; sma sensitivity per hr in mjy
salma = 0.05 * 3.

frsma = 0./6.
drsma = 0.857

fralma = .1
dralma = .9

fovsma = 36.   ;fov in arcsec
fovalma = 18.

timebudget = 2000. ; in hr
tperfov = get_ser(1000, .5, timebudget)
nfov =  timebudget / tperfov

ct_sma = interpol(n2,s2,ssma/sqrt(tperfov))  * (fovsma/3600.)^2 *nfov
ct_alma = interpol(n2,s2,salma/sqrt(tperfov))* (fovalma/3600.)^2*nfov


ct_smaup= drsma/(1-frsma) * ct_sma
ct_smalo= drsma * ct_sma

ct_almaup= dralma/(1-fralma) * ct_alma
ct_almalo= dralma * ct_alma


!p.position=0
!p.multi=[0,1,2]

;plot, tperfov, interpol(n2,s2,salma/sqrt(tperfov)) 

plot, tperfov, [max([ct_alma,ct_smaup,ct_sma]),ct_sma],/xs,/ys,/ylog,/xlog,$
	xtitle='!6exposure per pointing',ytitle='total detected count',/nodata
oplot, tperfov, ct_sma, thick=5
oplot, tperfov, ct_alma,line=2, thick=5

;oplot, tperfov, ct_almaup,line=1
;oplot, tperfov, ct_almalo,line=1

w=where(abs(tperfov-50.) eq min(abs(tperfov-50.)))
oplot, tperfov, ct_smaup,line=3
oplot, tperfov, ct_smalo,line=3
oplot, [tperfov(w(0)),tperfov(w(0))], [ct_smalo(w(0)),ct_smaup(w(0))]


plot, tperfov, ct_sma/ct_alma,/xs,/ys,/xlog,ytitle='SMA/ALMA count ratio',$
   xtitle='exposure per pointing'
;oplot, tperfov, ct_smaup/ct_almaup,line=3
oplot, tperfov, ct_smalo/ct_almalo,line=1
oplot, tperfov, tperfov*0+1.,line=2


det = [23,67.,12,6]
exp =[10,10,8.,7]
good=[6,6,5,6.]

;plot,good/exp, (det-good)/det,psym=5,/xlog


end
