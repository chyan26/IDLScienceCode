

PRO SALPETERIMF,mass,n,rm
   m = 10^((findgen(81)-40)/20)
   n = imf(m,[-0.5,-1.35],[0.01,0.1,100])*50
   randomstar,m,n,mm
	
	mass=m
	rm=mm
END

PRO MSIMF,mass,n,rm
	m = 10^((findgen(81)-40)/20)
	n = imf(m,[-0.25,-1.0,-1.3,-2.3],[0.01,1.0,2.0,10.0,100])*100
   randomstar,m,n,mm
	
	mass=m
	rm=mm
	
END


PRO MUENCHIMF, mass, n, rm
   m = 10^((findgen(81)-40)/20)
   n = imf(m,[0,-5,0.73,-0.51,-1.21],[0.01,0.017,0.025,0.12,0.6,100])*100
   randomstar,m,n,mm
	
	mass=m
	rm=mm

END


PRO NONIMF, mass, n, rm
   m = 10^((findgen(81)-40)/20)
   n = imf(m,[0,-1.5],[0.01,0.5,100])*100
   randomstar,m,n,mm
	
	mass=m
	rm=mm
	

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

PRO IMFPLOT, Ps=ps
	COMMON share,imgpath, mappath
	loadconfig
  
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=mappath+'mockimf.eps',$
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
	muenchimf,m3,n3,rm3

	plot,m2,n2,/xlog,/ylog,yrange=[1e-3,1e4],xrange=[1e2,1e-2],font=1,$
		xtitle='Mass', ytitle='Number of stars',xthick=7.0,ythick=7.0,charsize=1.7,$
		thick=4.0,ystyle=1
	oplot,m1,n1,line=2,thick=4.0
	oplot,m3,n3,line=3,thick=4.0

	if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
	endif


END

PRO SIMKLF, klf, age

	salpeterimf,m1,n1,rm1
	msimf,m2,n2,rm2
	muenchimf,m3,n3,rm3


	loadiso_dm98,iso,age=age,av=0
	 
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
 
 	klf={h1:h1,xh1:xh1,h2:h2,xh2:xh2,h3:h3,xh3:xh3}
 
 ;plot,xh,h,psym=10,/ylog,yrange=[1,10e3]

END








