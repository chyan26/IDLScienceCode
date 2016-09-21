PRO NCOLUMNCO
; To calculate molecular column density of CO
; 2008. 5. 26. ; 2004. 10. 22.; 1997. 6. 2.

  PH = 6.6262E-27
  BK = 1.3806E-16
  CC = 2.9979E10
  Msun=1.989E33
  G=6.6732E-8
  pc=3.E18

  kms=1.0E5
  pi = 3.14159
  ln2 = 0.693147 ; ALOG(2)
  
  YN=''

One:;---------   CO  3-2

  BMol=55.67

  PRINT, ' '
  PRINT, ' -- CO 3-2 -- '
  PRINT, ' '

  Fnu1=345.6960  ; 3-2  - Frequency [GHz]

  Gu1=7.   ;  Statistical weight gu 

  Aul1=2.6d-6   ; Einstein Coefficient [s-1] 

  Eu1=33.2   ;  Upper level Energy [K] 

  YetaB1=0.65  ; ARO at 109.8 GHz   - Antenna Beam efficiency 

  Trot=20.  ; Rot.T [K] & Z(T) (1) 

  ZT = BK * Trot / PH / (BMol * 1.e9)
  print,'  Z(T)= ',ZT

  hvkt=PH*Fnu1*1.e9 / BK / Trot
  print,'  hv/kT= ',hvkt
  print,'  exp(hv/kT)= ',exp(hvkt)

NewOne:
  PRINT, ' '
  READ, Yint1, PROMPT='  Input Integrated Intensity [K km/s]: Yint(1)= '

  ColNu1=1940. * Fnu1^2 * Yint1 /YetaB1 /Aul1
  
  frac1=Gu1 * exp(-Eu1/Trot)
  TotalN1=ColNu1 * ZT / frac1
  print, '  Frac1= ',frac1
  PRINT,' '
  PRINT, ' > Trot = ', Trot, '     > Total N(CO) = ', $
   TotalN1, FORMAT='(A, f10.2, A, e12.2)'
  PRINT,' '

Ggut:;-----------------END--------------------------------------
  END





FUNCTION CODENSITY,ta,tex
  
  Ymb=0.65        ; Main beam efficiency
  
  aul=2.6d-6      ; s-1
  nu=345.795975d9 ; Hz
  nu_g=345.795975 ; GHz
  c=2.998d10      ;cm/s
  h=6.626d-27     ; erg s-1
  k=1.38d-16      ; erg K-1
  be=55.67d9      ; Hz 
  gu=7.0
  Eu=33.2         ;
  H2ratio=1e5     
  
  
  tex=tex
  
  Z=k*tex/(be*h)
  frac1=gu*(exp(-Eu/tex))
 
  Nco= 1943.0*nu_g^2/aul*(ta/Ymb)*Z/frac1
  
  Nh2=Nco*H2ratio*1.3
  
  return,Nh2
  
END

; This function calculate the column density based on the Av
FUNCTION AV2COLUMND, av
  ; Here we use the relation from Frerking et al. (1982) 
  n=av*0.94
  nh2=n*1e21
  return, nh2
  
END


; This function calculates the physical size of a region in the unit of "cm^2"
FUNCTION ANGULARAREA, dsize, distance
  ; dsize: the angular diameter in the unit of arcmin 
  ; distance : distance in the unit of kpc
  
  ; 1pc =  3.09e18 cm
  ; 1kpc = 3.09e 21 cm
  ; 1' = 2.9089e-4 rad
  ; 1" = 4.8481e-4 rad
  ; theta = 5 arcmin = 300 arcsec = 5*2.9089e-4 rad
  ; 1 solar mass =  1.98892d33  g
  theta=dsize*2.9089e-4
  
  size=((!pi*theta^2)/4)*(distance*3.09d21)^2
  return, size
END

; This function convert the total number of H2 to mass in the unit of M{_\odot}
FUNCTION N2MASS, n_total
  ;m_H2 = 4.54e-20
  factor=2*1.67e-24
  smass=1.98892d33
  mass=n_total*factor/smass
  return, mass
END


; This routine calculate the cloud mass based on the Av 
PRO AV2MASS
  nh2=av2columnd(13.0)
  area=angulararea(5,1.8)
  print,'N_H2= ', nh2
  print,nh2*area*2*1.67e-24/1.98892d33
  ;mass=n2mass(nh2*angulararea(5,1.8))
  ;print,nh2,area
END

FUNCTION GETSERIES, first, last, step
  total=(last-first)/step+1
  
  return,(findgen(total))*step+first
END

PRO MASSPROFILE,Ps=ps
   COMMON share,conf
   loadconfig
   ;!p.multi=[0,1,2]
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+'profile.eps',$
         /color,xsize=20,ysize=15,xoffset=0,yoffset=5,$
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
         
   
   
   im=readfits(conf.fitspath+'ffb2.fits',hd)
   ;ind=where(im eq max(im))
   ;coord=array_indices(im,ind)
   coord=[248.0,268.0]
   ra=84.799197
   dec=35.764187
   
   radius=getseries(3,100,10)
   t=fltarr(n_elements(radius))
   n=fltarr(n_elements(radius))
   mm=fltarr(n_elements(radius))
   for i=0,n_elements(radius)-1 do begin
      for x=0,511 do begin
        for y=0,511 do begin
          dist=sqrt((x-coord[0])^2+(y-coord[1])^2)
          if dist le radius[i] then begin
            ;print,dist,x,y,radius[i],im[x,y]
            t[i]=t[i]+im[x,y]
            n[i]=n[i]+1
          endif
          
        endfor
      endfor
   endfor
   
   
   ;for i=n_elements(t)-1,1,-1 do t[i]=t[i]-t[i-1]
   ;for i=n_elements(n)-1,1,-1 do n[i]=n[i]-n[i-1]
   meant=t/n
   print,meant
   ;print,meant
   area=angulararea(2*radius*0.04,1.8)
   ;print,area
   ;for i=n_elements(area)-1,1,-1 do area[i]=area[i]-area[i-1]
   ;print,'-' 
   ;print,area
   gmass=n2mass(codensity(meant,20)*area)
   ;plot,radius*0.04,gmass,xtitle='Radius (arcmin)',ytitle='Mass'
   print,total(gmass)
   
   ;oplot,r,mm,line=red
   
   plot,radius*0.04,gmass,xtitle='Radius (arcmin)',ytitle='Mas',psym=4,$
      font=1,charsize=1.5,thick=5,xthick=2,ythick=2
   ;print,mm
   ;print,r
   ;for i=1
  if keyword_set(PS) then begin
     device,/close
     set_plot,'x'
  endif
  
  clearplt,/all
  resetplt,/all
  !p.multi=0


END

PRO SFEPROFILE,cat,Ps=ps
   COMMON share,conf
   loadconfig
   ;!p.multi=[0,1,2]
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+'sfeprofile.eps',$
         /color,xsize=20,ysize=15,xoffset=0,yoffset=5,$
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
   coord=[248.0,268.0]
   ra=84.799197
   dec=35.764187
  
   radius=getseries(2.5,62.5,5)
   mm=fltarr(n_elements(radius))
   area=angulararea(2*radius*0.04,1.8)
   for i=n_elements(area)-1,1,-1 do area[i]=area[i]-area[i-1]
   gmass=n2mass(av2columnd(12.97)*area)
   r=radius*0.04
   hdr=headfits(conf.fitspath+'s233ir_k.fits')
   
   for j=0,n_elements(r)-1 do begin
     for i=0,n_elements(cat.x)-1 do begin
        xyad,hdr,cat.x[i],cat.y[i],a,d
        d=sqrt((a-ra)^2+(d-dec)^2)*60
        if (d le r[j]) and (cat.mass[i] ge 0) then begin
          mm[j]=mm[j]+cat.mass[i]
        endif
     endfor
   endfor
   
   for i=n_elements(mm)-1,1,-1 do mm[i]=mm[i]-mm[i-1]
   ;oplot,r,mm,line=red
   
   plotsym,4,2,/fill
   plot,r,mm/(mm+gmass),xrange=[0,2.5],xtitle='Radius (arcmin)',ytitle='Star formation efficiency',psym=8,$
      font=1,charsize=1.5,thick=5,xthick=3,ythick=3
   
   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif

  clearplt,/all
  resetplt,/all
  !p.multi=0

END



