
; Number of total YSO
nyso=432
;nyso=292

; Mean mass of YSO in the unit of M_\odot
myso=0.5

;
t=4.0

; Gass mass in the unit of M_\odot
m_gas=2182

; Surface are in the unit pc^2
area=31.4

; The mass of sun in the unit of g
m_sun=1.9891d33 ; g

h2_mass=2.3*1.67d-24

r=sqrt(area/!pi)*3.08567758d18
volume=(4/3)*!pi*r^3

; Converting factor from M_sun pc-3 to H cm-3
density=m_gas*m_sun/volume/h2_mass



sfr_ff=(34*nyso*myso)/(t*m_gas*sqrt(density))
print,'SFR_ff=',sfr_ff

print, m_gas*m_sun/(area*(3.08567758d18)^2) 






END

