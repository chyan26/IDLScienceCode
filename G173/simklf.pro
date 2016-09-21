

PRO SALPETERIMF,mass,n,rm
   m = 10^((findgen(81)-40)/20)
   n = imf(m,[-0.1,-1.35],[0.01,0.1,10])*100
   mockstarmass,m,n,mm
	
	mass=m
	rm=mm
END

PRO MSIMF,mass,n,rm
	m = 10^((findgen(81)-40)/20)
	n = imf(m,[-0.25,-1.0,-1.3,-2.3],[0.01,1.0,2.0,10.0,100])*100
  mockstarmass,m,n,mm
	
	mass=m
	rm=mm
	
END


PRO MUENCHIMF, mass, n, rm
   m = 10^((findgen(81)-40)/20)
   n = imf(m,[0,-5,0.73,-0.51,-1.21],[0.01,0.017,0.025,0.12,0.6,10])*100
   mockstarmass,m,n,mm
	
	mass=m
	rm=mm

END


PRO NONIMF, mass, n, rm
   m = 10^((findgen(81)-40)/20)
   n = imf(m,[0,-2.0],[0.01,0.5,100])*100
   mockstarmass,m,n,mm
  
  mass=m
  rm=mm
  

END

PRO TESTIMF, mass, n, rm
   m = 10^((findgen(81)-40)/20)
   n = imf(m,[0,-1.7],[0.01,0.5,100])*100
   mockstarmass,m,2*n,mm
  
  mass=m
  rm=mm
  

END

PRO PP
   MUENCHIMF,m,n,rm  
 
   mm=alog10(rm)
   
   h=histogram(mm,min=min(mm),max=2,bin=0.05) 
   xh=(findgen(n_elements(h))*0.05)+min(mm)
   
   ;print,total(n),n_elements(rm),rm
   plot,xh,alog10(h),yrange=[0,5],xrange=[1,-2],xstyle=1,psym=10
   ;plot,m,n,/xlog,/ylog,yrange=[1,2000],xrange=[10,0.01],xstyle=1
   oplot,alog10(m),alog10(n)
END

PRO RANDOMSTAR, mass, n, random_mass
   j=0
   for i=0L,n_elements(mass)-1 do begin
      if n[i] le 1 then continue
       
      m=fltarr(round(n[i]))
      for k=0L,n_elements(m)-1 do begin
         m[k]=mass[i]+randomu(seed)
      endfor
   
      if j eq 0 then begin
         mm=m
      endif else begin  
         mm=[mm,m]
      endelse
      
      j=j+1
      ;print,j,n_elements(mm),n_elements(m),round(n[i])
   endfor
   random_mass=mm
   
END



PRO MOCKSTARMASS, mass, n, random_mass
  l_mass=alog10(mass)
  number=round(n)
  j=0
  for i=0L,n_elements(mass)-1 do begin
    
    if number[i] gt 0 then begin
      mm=10^(l_mass[i]+(l_mass[i]-l_mass[i+1])*randomu(seed,number[i]))
      ;print,n_elements(mm),number[i],mass[i],mean(mm)
      if j eq 0 then begin
        random_mass=mm
        j=j+1
      endif else begin
        random_mass=[random_mass,mm]
      endelse
    endif
    
   endfor 
END



PRO IMFPLOT, Ps=ps
	COMMON share,setting
	loadconfig
  
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=setting.pspath+'mockimf.eps',$
         /color,xsize=20,ysize=20,xoffset=0.4,yoffset=10,$
         SET_FONT='Helvetica',/TT_FONT,/encapsulated
         
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
   endif else begin
	   blue=65535
      red=255
      green=32768    
   endelse

	salpeterimf,m1,n1,rm1
	msimf,m2,n2,rm2
	testimf,m3,n3,rm3
  muenchimf,m4,n4,rm4
  nonimf,m5,n5,rm5

	plot,m2,n2,/xlog,/ylog,yrange=[1e-3,1e4],xrange=[1e2,1e-2],font=1,$
		xtitle='Mass', ytitle='Number of stars',xthick=7.0,ythick=7.0,charsize=1.7,$
		thick=4.0,ystyle=1
	oplot,m1,n1,line=2,thick=4.0
	oplot,m3,n3,line=3,thick=4.0
  oplot,m4,n4,line=4,thick=4.0,color=red
  oplot,m5,n5,line=5,thick=4.0
	
	if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
	endif


END



PRO SIMKLF, klf, age

	salpeterimf,m1,n1,rm1
	msimf,m2,n2,rm2
	muenchimf,m3,n3,rm3
  ;testimf,m3,n3,rm3

	loadiso_dm,iso,age=age,av=0
	 
	mk1=interpol(iso.mk,iso.mass,rm1)
	mk2=interpol(iso.mk,iso.mass,rm2)
	mk3=interpol(iso.mk,iso.mass,rm3)
 
	 mag_min=-2
   mag_max=7
   bin=0.5
	
	h1=histogram(mk1,min=mag_min,max=mag_max,bin=bin)
   xh1=(findgen(n_elements(h1))*bin)+mag_min

	h2=histogram(mk2,min=mag_min,max=mag_max,bin=bin)
   xh2=(findgen(n_elements(h2))*bin)+mag_min

	h3=histogram(mk3,min=mag_min,max=mag_max,bin=bin)
   xh3=(findgen(n_elements(h3))*bin)+mag_min
 
 	klf={h1:h1,xh1:xh1,mk1:mk1,h2:h2,xh2:xh2,mk2:mk2,h3:h3,xh3:xh3,mk3:mk3}
 
 ;plot,xh,h,psym=10,/ylog,yrange=[1,10e3]

END


PRO PLOTSIM
  COMMON share,setting
  loadconfig
  
  
  
  set_plot,'ps'
  device,filename=setting.pspath+'plotsim.eps',$
    /color,xsize=15,ysize=10,xoffset=0.4,yoffset=10,$
           SET_FONT='Helvetica',/TT_FONT,/encapsulated
   
        tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
  
  ;!p.multi=[0,2,5]
  
  salpeterimf,m1,n1,rm1
  msimf,m2,n2,rm2
  testimf,m3,n3,rm3
  muenchimf,m4,n4,rm4
  nonimf,m5,n5,rm5
  
  ;for i=1,10.1 do begin
  ;t=i
  
  modelklf,rm1,klf1,age=10
  modelklf,rm2,klf2,age=10
  modelklf,rm3,klf3,age=10
  modelklf,rm4,klf4,age=10
  modelklf,rm5,klf5,age=10
  
  plot,klf1.xh,alog10(klf1.h),yrange=[1,4],xrange=[-2,10]
  oplot,klf2.xh,alog10(klf2.h),lin=2
  oplot,klf3.xh,alog10(klf3.h),lin=3
  oplot,klf4.xh,alog10(klf4.h),lin=4
  oplot,klf5.xh,alog10(klf5.h),lin=5
  
  ;modelklf,rm1,klf1,age=0.4
  ;modelklf,rm2,klf2,age=0.4
  ;modelklf,rm3,klf3,age=0.4
  
  ;oplot,klf1.xh,alog10(klf1.h),color=red
  ;oplot,klf2.xh,alog10(klf2.h),lin=2,color=red
  ;oplot,klf3.xh,alog10(klf3.h),lin=3,color=red
  
  ;simklf,klf,0.1
  ;oplot,klf.xh1,alog10(klf.h1),color=blue
  ;oplot,klf.xh2,alog10(klf.h2),lin=2,color=blue
  ;oplot,klf.xh3,alog10(klf.h3),lin=2,color=blue
  ;xyouts,0,5000,strcompress(string(i),/remove)
  ;endfor
  ;!p.multi=0
  device,/close
  set_plot,'x'
END

; This function makes an averaged KLF 
PRO AVGKLF, mlf
  
    salpeterimf,m1,n1,rm1
    msimf,m2,n2,rm2
    muenchimf,m3,n3,rm3
    
    for i=1, 6 do begin
      t1=i
      t2=i
      t3=i
      modelklf,rm1,klf1,age=t1,factor=1.5
      modelklf,rm2,klf2,age=t2,factor=1.5
      modelklf,rm3,klf3,age=t3,factor=1.5
      
      if i eq 1 then begin
        hh1=klf1.h
        hh2=klf2.h
        hh3=klf3.h
      endif
      hh1=hh1+klf1.h
      hh2=hh2+klf2.h
      hh3=hh3+klf3.h
    endfor
    hh1=alog10(hh1/6)
    hh2=alog10(hh2/6)
    hh3=alog10(hh3/6)
    
    
  
   set_plot,'ps'
   device,filename='~/ageklf.eps',$
    /color,xsize=20,ysize=20,xoffset=0.4,yoffset=10,$
           SET_FONT='Helvetica',/TT_FONT,/encapsulated
    tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
    
    plot,klf1.xh,hh1,yrange=[0,3],line=1
    oplot,klf2.xh,hh2,line=2
    oplot,klf3.xh,hh3,line=3
    
    yfit1 = GAUSSFIT(klf1.xh[0:23], hh1[0:23], coeff1,estimates=[1,4,4,1], NTERMS=4)
    oplot,klf1.xh[0:23],yfit1[0:23],thick=2,line=1,color=red
    print,coeff1
    yfit2 = GAUSSFIT(klf2.xh[0:23], hh2[0:23], coeff2,estimates=[1,4,4,1], NTERMS=4)
    oplot,klf2.xh[0:23],yfit2[0:23],thick=2,line=2,color=red
    print,coeff2
    yfit3 = GAUSSFIT(klf3.xh[0:23], hh3[0:23], coeff3,estimates=[1,4,4,1], NTERMS=4)
    oplot,klf3.xh[0:23],yfit3[0:23],thick=2,line=3,color=red
    print,coeff3
    
    ;print,'FWHM= ',2*SQRT(2*ALOG(2))*coeff[2]
    device,/close
    set_plot,'x'
    
    mlf={xh1:klf1.xh,xh2:klf2.xh,xh3:klf3.xh,hh1:hh1,hh2:hh2,hh3:hh3,$
        coeff1:coeff1,coeff2:coeff2,coeff3:coeff3,yfit1:yfit1,yfit2:yfit2,yfit3:yfit3}

END













