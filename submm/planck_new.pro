function planck_new,wave,temp
;+
; NAME:
;	PLANCK_NEW()   
; PURPOSE: 
;	To calculate the Planck function in units of ergs/cm2/s/Hz  
;
; CALLING SEQUENCE: 
;	bbflux = PLANCK_NEW( wave, temp) 
;
; INPUT PARAMETERS: 
;	WAVE   Scalar or vector giving the frequencies in **GHz**
;		at which the planck function is to be evaluated.
;	TEMP   Scalar giving the temperature of the planck function in degree K
;
; OUTPUT PARAMETERS:
;	BBFLUX - Scalar or vector giving the planck function at the specified
;		wavelength points.
;
; EXAMPLES:
;	To calculate the blackbody flux (i.e. PI*Intensity) in erg/cm^2/s/A
;	for 30,000 K every 100 Angstroms between 2000A and 2900 A
;   
;	IDL> WAVE = 2000 + INDGEN(10)*100
;	IDL> BBFLUX = PLANCK_NEW(WAVE,30000)
;
; RESTRICTIONS:
;	Values less than approximately 1E-24 are truncated to 0.
;
; PROCEDURE:
;	The wavelength data are converted to cm, and the planck function
;	is calculated for each wavelength point. See Allen (1973), Astrophysical
;	Quantities, section 44 for more information.
;
; MODIFICATION HISTORY:
;	Adapted from the IUE RDAF               August, 1989
;	Converted to IDL V5.0   W. Landsman   September 1997
;-
 On_error,2

 if ( N_elements(wave) LT 1 ) then begin
     print,'Syntax - bbflux = planck_new( wave, temp)'
     return,0
  endif    

  if ( N_elements( temp ) NE 1 ) then $
      read,'Enter a blackbody temperture',temp

  bbflux = wave*0.

; Gives the blackbody flux (i.e. PI*Intensity) ergs/cm2/s/Hz

  w = wave * 1.E9                              ; GHz to Hz    
  ;c1 =  3.74185E-5             ;constants appropriate to cgs units.
  h = 6.6261E-4                 ;planck's constant, unit is Jy 
  C0 = 2.9979E10                ;speed of light, cm s^-1
  C2 =  4.80152E-11             ;constant h/k
  val =  c2*(w/temp)               
  good = where( val LT 88, Ngood )    ;Avoid floating underflow
  if ( Ngood GT 0 ) then  $
      bbflux[ good ] =  (2 * h * wave [ good ]^3) / ( C0^2 * ( exp( val[good])-1. ) )

  return, bbflux              ; Convert to ergs/cm2/s/Hp

  end 
