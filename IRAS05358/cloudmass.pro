PRO COMAPTOMASS
  COMMON share,imgpath, mappath
  loadconfig

  co=readfits(imgpath+'ffb2.fits',hd)
  xref=sxpar(hd,'CRPIX1')
  yref=sxpar(hd,'CRPIX2')
  scale=abs(sxpar(hd,'CD1_1'))*3600.0
  
  ind=where(co eq max(co))
  maxi=array_indices(co,ind)
  total_mass=0
  for i=0, sxpar(hd,'NAXIS1')-1 do begin
    for j=0, sxpar(hd,'NAXIS2')-1 do begin
      dist=sqrt((i-maxi[0])^2+(j-maxi[1])^2)*scale
      if dist le 150 then begin
        cloudmass,co[i,j]/0.65,scale,mass
        if co[i,j] ge 0 then total_mass=total_mass+mass
      endif 
      ;print,co[i,j]
    endfor
  endfor
  print,total_mass
END



PRO CLOUDMASS, tb, beam, mass
  h=6.6260688e-34; (J-s)
  k=1.380e-23; (J-K^-1)
  v=345.0e9 ;(Hz)
  tau=0.1
  
  jl=2
  tex=50
  ;tb=110
  
  density=2.382e14*(exp(2.78*jl*(jl+1)/tex)/(jl+1))*$
    ((tex+0.9267)/(1-exp(-h*v/(k*tex))))*(tau/(1-exp(-tau)))*tb
  
  
  ;[H2/CO]*ug*m_H2 = 4.54e-20
  factor=4.54e-20
  
  ; 1pc =  3.09e18
  ; 1kpc = 3.09e 21
  ; 1' = 2.9089e-4 rad
  ; 1" = 4.8481e-4 rad
  ; theta = 5 arcmin = 300 arcsec = 5*2.9089e-4 rad
  ; 1 solar mass =  1.98892d33  g
  
  ;theta=5*2.9089e-4
  theta=beam*4.85e-6
  smass=1.98892d33
  
  size=((!pi*theta^2)/4)*(1.8*3.09d21)^2
  
  ;mass=density*((!pi*theta^2)/4)*(1.8*3.09d21)^2
  mass=density*factor*size/smass
  
  
  ;print,'N_CO = ',density
  ;print,'col. den. = ',density*factor,' g cm^-2'
  ;print,'area = ', size ,'cm^2'
  ;print,'mass = ',density*factor*size/smass, ' M_\odot'
END