;************************************************************************
;+
;
;*NAME:
;
;    YFIT    (General IDL Library 01)
;  
;*CLASS:
;
;    Curve fitting
;
;*CATEGORY:
;  
;*PURPOSE:
;
;    Procedure to evaluate Y for a set of function parameters A.
;    Y is assumed to be a gaussian on top of a polynomial baseline
;  
;*CALLING SEQUENCE:
;
;    YFIT,X,A,YFIT
;  
;*PARAMETERS:
;
;    X       (REQ) (I) (1) (F)
;            Required input vector containing the independent variable 
;            data.
;    
;    A       (REQ) (I) (1) (F)
;            Required input vector which contains the fit parameters for
;            the multiple gaussian profile.
;
;            A(3*I)   is the center of the Ith component gaussian.
;
;            A(3*I+1) is the gaussian sigma width of the Ith gaussian 
;                     component.
;
;            A(3*I+2) is the height of the gaussian peak above the baseline
;                     of the Ith component.    
;
;    YFIT    (REQ) (O) (1) (F)
;            Output vector describing multiple gaussian profile. 
;  
;*EXAMPLES:
;
;    see WFIT.PRO
;
;*SYSTEM VARIABLES USED:
;
;*INTERACTIVE INPUT:
;
;*SUBROUTINES CALLED:
;
;    PARCHECK
;    GAUSS
;
;*FILES USED:
;  
;*SIDE EFFECTS:
;  
;*RESTRICTIONS:
;  
;*NOTES:
;  
;    tested with IDL Version 2.1.2  (sunos sparc)    07 Aug 91
;    tested with IDL Version 2.1.2  (ultrix mipsel)  07 Aug 91
;    tested with IDL Version 2.1.2  (vms vax)        07 Aug 91
;
;*PROCEDURE:
;
;    The composite gaussian profile is built up by the sum of the
;    individual gaussian component distributions. The independent variable
;    grid is specified by the input variable X.
;  
;*MODIFICATION HISTORY:
;
;    Aug. 18, 1979  I.D. Ahmad  initial program
;    Mar  21, 1988  CAG    GSFC add VAX RDAF-style prolog, calling sequence
;                               printout and PARCHECK
;    Jul. 30, 1991  GRA  cleaned up; converted code to lower case;
;                        removed the unused parameter "m" from the
;                        procedure calling statement; tested on SUN,
;                        DEC, and VAX.
;
;-
;************************************************************************
 pro yfit,x,a,yfit
;
 npar = n_params()
 if npar eq 0 then begin
    print,'YFIT,X,A,YFIT'
    retall 
 endif  ; npar
 parcheck,npar,3,'YFIT'
;
 yfit = x * 0.0 
;
 for i=0,n_elements(a)/3-1 do begin
    n = 3*i
    gauss,x,a(n),a(n+1),a(n+2),y
    yfit = yfit + y
 endfor  ; i loop
;
 return
 end  ; yfit
