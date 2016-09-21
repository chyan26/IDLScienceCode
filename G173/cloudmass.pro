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

FUNCTION TAUC18O, T, tex

  ;For C18O(J2-1) 
  nu=219.506319d9
  k=1.38d-16      ; erg K-1
  h=6.626d-27
  tbg=2.73
  tex=20
  
  z=(h*nu)/k
  
  return,-alog(1.0-T/(z*((1/(exp(z/tex)-1))-(1/(exp(z/tbg)-1)))))
  ;print,(h*nu)/k
END

; makine sure the calculation process is consistent in my wrting
PRO TESTDEN

  tex=20.0

  stex=[1000,500,300,225.0,150.0,75.0,37.5,18.75,9.375,5.000,2.725]
  lnq=[2.5807,2.2796,2.0580,1.9334,1.7581,1.4595,1.1636,0.8728,0.5924,0.3561,0.1611]
  qtex=exp(lnq)
  q=interpol(qtex,stex,tex)


  h=6.626d-27     ; erg s-1
  k=1.38d-16      ; erg K-1
  c=3.0d10
  
nu_g=219.506319
nu=219.506319d9
aul=6.2d-7
gu=5
Eu=15.9
be=55.89d9

z=(q/gu)*exp(Eu/tex)

print,1e5*((8*!pi*nu^3)/(c^3))*(1.0/(exp(h*nu/k/tex)-1))*z

print,1.94e3*nu_g^2*z

END

FUNCTION RJTEMP, nu, t

 h=6.626d-27     ; erg s-1
 k=1.38d-16      ; erg K-1

z=h*nu/k

return,z*1.0/(exp(z/t)-1)

END

FUNCTION C18ODENSITY, ta, tex
;PRO C18ODENSITY, tex
  
  H2ratio=1e5  
  
  stex=[1000,500,300,225.0,150.0,75.0,37.5,18.75,9.375,5.000,2.725]
  lnq=[2.5807,2.2796,2.0580,1.9334,1.7581,1.4595,1.1636,0.8728,0.5924,0.3561,0.1611]
  qtex=exp(lnq)
  
  h=6.626d-27     ; erg s-1
  k=1.38d-16      ; erg K-1
  
 
  ;tex=20.0
  q=interpol(qtex,stex,tex)
  
  int_tau=0.32

  nu=219.506319d9
  nu_g=219.506319
  aul=6.2d-7
  gu=5.0
  
  Eu=15.9
  
  z=(q/gu)*exp(Eu/tex)
  ;print,z
  
  ;print,1e5*(8*!pi*nu^3/(3d5)^3)/(exp((h*nu)/(k*tex))-1)/aul
  
  ;frac1=gu*(exp(-Eu/tex))
  
  nc18o=1943*nu_g^2/aul*ta*z
  print,nc18o
  nh2=((nc18o/1.79d14)+3.9)*1e21
  ;nh2=nc18o*560.0*1e4
  ;print,Nh2
  return,Nh2
END



FUNCTION CODENSITY,ta,tex
  
  Ymb=1.0       ; Main beam efficiency
  
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
  
  Nh2=Nco*H2ratio;*1.3
  
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
FUNCTION ANGULARAREA, radius=radius, area=area, distance=distance
  ; dsize: the angular diameter in the unit of arcmin 
  ; distance : distance in the unit of kpc
  ; area : area in the unit of arcsec^2
  
  
  ; 1pc =  3.09e18 cm
  ; 1kpc = 3.09e 21 cm
  ; 1' = 2.9089e-4 rad
  ; 1" = 4.8481e-4 rad
  ; 1 arcsec^2 = 2.35294e-11 str
  ; theta = 5 arcmin = 300 arcsec = 5*2.9089e-4 rad
  ; 1 solar mass =  1.98892d33  g
  
  if keyword_set(area) then begin
    size=area*2.35294e-11*(distance*3.09d21)^2
  endif
  
  if keyword_set(radius) then begin
  
    dsize=radius
    theta=dsize*2.9089e-4
    
    size=!pi*((theta*(distance*3.09d21))/2)^2
  
  endif
  
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


PRO AV2MASS
  nh2=av2columnd(13.0)
  area=angulararea(5,1.8)
  print,'N_H2= ', nh2
  print,nh2*area*2*1.67e-24/1.98892d33
  ;mass=n2mass(nh2*angulararea(5,1.8))
  ;print,nh2,area
END

PRO GETCLOUDMASS
  
  ;G173
  nh2=av2columnd(14.65)
  area=angulararea(area=19226.5,distance=1.8)
  mass=nh2*area*2*1.67e-24/1.98892d33
  print,'G173 nh2 (Av) =',nh2
  print,'G173 Mass=',mass
  
  
  nh2=c18odensity(5.0,20)
  area=angulararea(area=19226.5,distance=1.8)
  print,'G173 nh2 (C18O) =',nh2
  print,'G173 Mass=',mass
  
  
  nh2=codensity(160,20)
  area=angulararea(area=19226.5,distance=1.8)
  mass=nh2*area*2*1.67e-24/1.98892d33
  print,'G173 nh2 (12CO) =',nh2
  print,'G173 Mass=',mass
  
  ;G173
  nh2=codensity(267,20)
  area=angulararea(area=33538,distance=1.8)
  ;area=angulararea(radius=3.4,distance=1.8)
  mass=nh2*area*2*1.67e-24/1.98892d33
  print,'S233IR Mass=',mass
END
