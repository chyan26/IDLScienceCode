;******************************************************************************
;+
;*NAME:
;
;    WPOLYFIT     (General IDL Library 01) 7-25-84
; 
;*CLASS:
;
;    Curve fitting
;
;*CATEGORY:
;
;*PURPOSE:
;
;    To fit a weighted polynomial to data points using the
;    method of least-squares.
; 
;*CALLING SEQUENCE:
;
;    WPOLYFIT,X,Y,WEIGHT,NDEG,A,YFIT,CHISQR
; 
;*PARAMETERS: 
;
;    X        (REQ) (I) (1) (I L F D)
;             Required input vector containing the independent variable
;
;    Y        (REQ) (I) (1) (F)
;             Required input vector containing the dependent variable.
;
;    WEIGHT   (REQ) (I) (0 1) (F)
;             Required input scalar (which is converted to vector) or
;             vector giving the weights for each data point.
;
;    NDEG     (REQ) (I) (0) (I)
;             Required input scalar denoting the degree of the polynomial 
;             to be fit.
;
;    A        (REQ) (O) (1) (F)
;             Required output vector containing the coefficients of the
;             polynomial to be fit.
;             YFIT=A(0)+A(1)*X+A(2)*X^2+...A(NDEG)*X^NDEG
;
;    YFIT     (REQ) (O) (1) (F)
;             Required output vector containing the calculated values, based
;             on the preceding equation, at each value of X.
;
;    CHISQ    (REQ) (O) (0) (F)
;             Required output scalar denoting the reduced chi square statistic
;             for the fit.
; 
;*EXAMPLES:
;
;    To fit a quadratic function to spectral continuum data with uniform
;    weighting:
;
;        wpolyfit,wcon,fcon,wcon*0.+1.,2,a,yfit,chisq
;
;*SYSTEM VARIABLES USED:
;
;    none
;
;*INTERACTIVE INPUT:
;
;    none
;
;*SUBROUTINES CALLED:
;
;    DETERM
;    PARCHECK
;    PCHECK
;
;*FILES USED:
; 
;*SIDE EFFECTS:
;
;*RESTRICTIONS:
;
;*NOTES:
;
;    tested with IDL Version 2.0.10 (sunos sparc)     27 Jun 91
;    tested with IDL Version 2.1.0  (ultrix mipsel)   27 Jun 91
;    tested with IDL Version 2.1.0  (vms vax)         27 Jun 91
;
;*PROCEDURE:
;
;    WPOLYFIT is an IDL version of Bevingtons program POLFIT (p. 140)
;    As explained in Bevington, the method of least-squares is used to
;    calculate the coefficients. The routine DETERM is used to calculate
;    the determinant of the constructed matrices.
; 
;*MODIFICATION HISTORY:
;
;    ????         I.D. Ahmad       initial program
;    Jul 25, 1984  RWT  GSFC corrected CHISQ calculation for NDEG=0
;                            and updated documentation
;    Jan 30, 1985  RWT  GSFC added compilation of PCHECK, allow
;                            scalar WEIGHT and floating point NDEG.
;    Jul 10, 1985  RWT  GSFC correct chisq calculation for NDEG>0,
;                            remove scaling, and add double precision.
;    Sep 23, 1985  RWT  GSFC modified for DIDL (use double 
;                            precision variables, use N_ELEMENTS,
;                            remove scaling, and correct CHISQ calculation
;                            for NDEG>0.
;    Apr 15, 1987  RWT  GSFC add PARCHECK
;    Dec  3, 1987  RWT  GSFC add procedure call listing and correct
;                            error when WEIGHT(0)=0.
;    Mar 21, 1988  CAG  GSFC add VAX RDAF-style prolog.
;    Apr 21, 1988  RWT  GSFC use new DETERM_PDP      
;    Aug 29, 1989  RWT  modify for SUN IDL
;    Jun 21  1991  GRA  CASA cleaned up; tested on SUN, DEC, VAX;
;                            updated prolog;
;    11 May 94  PJL  print a warning if any of the weights are negative
;
;- 
;******************************************************************************
 pro wpolyfit,xin,yin,weight,ndeg,a,yfit,chisqr
;
 npar = n_params(0)
 if (npar eq 0) then begin
    print,'WPOLYFIT,XIN,YIN,WEIGHT,NDEG,A,YFIT,CHISQR'
    retall 
 endif  ; npar eq 0
 parcheck,npar,7,'WPOLYFIT'
 pcheck,xin,1,010,0011
 pcheck,yin,2,010,0011
 pcheck,weight,3,110,0011
;
;  print a warning if any of the weights are negative
;
 temp = where(weight lt 0,count)
 if (count gt 0) then begin
    print,' '
    print,'WARNING:  ' + strtrim(count,2) + ' of the ' +   $
       strtrim(n_elements(weight),2) + ' weight values are negative.'
    print,'ACTION:  continuing'
    print,' '
 endif  ; count gt 0
;
 ndeg   = fix(ndeg)
 x      = double(xin) 
 y      = double(yin)
 s      = fix(n_elements(x))
 chisq  = 0 & flag = 0 ; indicates whether x has been adjusted to avoid overflow
 nterms = ndeg + 1                   ; number of terms in polynomial
 array  = dblarr(nterms,nterms)      ; matrix for solving simultaneous eqns.
 a      = dblarr(nterms)
 w      = size(weight)
 if (w(0) lt 1) then weight = fltarr(s) + 1.0
;
; if ndeg = 0, simply average y
;
 if (ndeg eq 0) then begin
    tw  = total(weight)
    a(0)= total(y*weight) / tw
    a0  = a(0)
    yfit = 0.*x + a0
    chisqr = (yfit - y)
    chisqr = total(weight*chisqr*chisqr) / (s - 1)
 endif else begin
   ;
   ; else proceed with polynomial fit
   ;
   ;
   ; reduce x by an order of magnitude to avoid overflow
   ;
    while 100000000.^(1. / ndeg) le max(x) do begin
       x = x / 10.
       flag = flag + 1
    endwhile
   ;
   ; accumulate sums
   ;
    nmax = 2*nterms - 1
    sumx = dblarr(nmax)
    sumy = a
    indx = indgen(nmax)
    indy = indgen(n_elements(sumy))
   ;
   ; accumulate x^n and y*x^n
   ;
    for i = 0,s-1 do begin
       addx = 0.*sumx
       addy = 0.*sumy
       if (x(i) ne 0.0) then begin
          addx = weight(i)*abs(x(i))^indx
          addy = weight(i)*y(i)*abs(x(i))^indy
          if (x(i) lt 0.) then begin
             addx = addx - 2.*(addx)*(indx mod 2)
             addy = addy - 2.*(addy)*(indy mod 2)
          endif  ; x(i) lt 0
       endif  ; x(i) ne 0
       sumx = sumx + addx
       sumy = sumy + addy
    endfor  ; i
    chisq = chisq + total(weight*y*y)
   ;
   ; construct matrices & calculate coefficients
   ;
    for k = 0,ndeg do  $
        for j = 0,ndeg do array(j,k) = sumx(j + k)
    determ,array,delta
   ;
   ; if matrix is singular, end program
   ;
    if (delta eq 0) then begin
       chisqr = 0
       a = a * 0
    end else begin
       for l = 0,ndeg do begin
          arr = array
           arr(0,l) = sumy(0:ndeg)
          ; for j = 0,ndeg do arr(j,l) = sumy(j)
          determ,arr,det
          a(l) = det / delta
       endfor ; l
      ;
      ; calculate reduced chi square
      ;
       for j = 0,ndeg do begin
          chisq = chisq - 2.*a(j)*sumy(j)
          for k = 0,ndeg do chisq = chisq + a(j)*a(k)*sumx(j + k)
       endfor ; j
       chisqr = float(chisq) / (s - nterms)
      ;
      ; calculate yfit
      ;
       yfit = fltarr(s)
       xn = yfit + 1.
       yfit = yfit + a(0)
       for i = 1,ndeg do begin
          xn = xn*x
          yfit = yfit + a(i)*xn
       endfor  ; i loop
      ;
       if (flag ne 0) then begin
          x = x * 10.0^flag
          a = a / (10.0^flag)^indgen(n_elements(a))
       endif  ; flag ne 0
    endelse  ; delta ne 0
 end ; ndeg ne 0
;
 return
 end  ; wpolyfit
