;*************************************************************************
;+
;*NAME:
;
;    DETERM   (General IDL Library 01)  July 25 1984
;
;*CLASS: 
;
;    Matrix Arithmetic
;
;*CATEGORY:
;
;*PURPOSE:  
;
;    TO CALCULATE THE DETERMINANT OF A SQUARE MATRIX
;
;*CALLING SEQUENCE:
;
;    DETERM,ARRAY,DET,darr
; 
;*PARAMETERS:
;
;    ARRAY  (REQ) (I) (2) (I L F D)
;           Required input square array for which the determinant is
;           to be calculated.
;
;    DET    (REQ) (O) (0) (F D)
;           Determinant of square matrix.
;
;    DARR   (OPT) (O) (2) (I L F D)
;           optional diagonalized array (note off-diagonal elements
;           not zeroed)
;
;*EXAMPLES: 
; 
;*SYSTEM VARIABLES USED:
;
;*INTERACTIVE INPUT:
;
;*SUBROUTINES CALLED:
;
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
;  tested with IDL Version 2.1.0 (sunos sparc)     20 Jun 91
;  tested with IDL Version 2.1.0 (ultrix mispel)   N/A
;  tested with IDL Version 2.1.0 (vms vax)         21 Jun 91
; 
;*PROCEDURE: 
;
;    DETERM is an IDL version of Bevingtons routine by the same name (p.293)
;    As explained in Bevington, the determinant is calculated from the product
;    of the diagonal elements of a diagonalized matrix.
; 
; 
;*MODIFICATION HISTORY:
;
;    Jul 25 1984 RWT GSFC incorporated into RDAF library, based on a 
;                         procedure by I. Ahmad and documentation updated.
;    Apr 13 1987 RWT GSFC add PARCHECK
;    Mar  8 1988 CAG GSFC add VAX RDAF-style prolog, add printing of the
;                         calling sequence if no parameters have
;                         been specified.
;    Apr 21 1988 RWT GSFC make working set array double precision and make it
;                         an optional output parameter to avoid changing input 
;                         array 
;    Jun 21 1991 PJL GSFC cleaned up; lowercase; tested on SUN and VAX; 
;          updated prolog
;
;-
;***************************************************************************
 pro determ,array,det,darr
;
; Print calling sequence if no parameters have been specified.
;
 if n_params(0) eq 0 then begin
    print,'DETERM,ARRAY,DET,darr'
    retall
 endif  ; n_params(0)
;
; check that all parameters have been specified
;
 parcheck,n_params(0),[2,3],'DETERM'
 pcheck,array,1,001,0011
 s=size(array)
 s1=s(1)-1
 det=1.
 darr = double(array)
 for k=0,s1 do begin
;
; interchange columns if diagonal element is 0
;
    if darr(k,k) eq 0 then begin
       j=k
       while (j lt s1) and (darr(k,j) eq 0) do j=j+1
;
; if matrix is singular set det=0 and end procedure
;
       if darr(k,j) eq 0. then begin
          det=0
          print,'WARNING!  Determinent equals ZERO!'
          return    ; end procedure if matrix singular
       endif else begin
;
;  if nonzero diagonal element found, swap
;
          for i=k,s1 do begin
             save=darr(i,j)
             darr(i,j)=darr(i,k)
             darr(i,k)=save
          endfor  ; i loop
       endelse  ; j eq s1
       det=-det    ; column swap changes sign of determinant
    endif  ; darr(k,k)
;
; subtract row k from lower rows to get diagonal matrix
;
    arrkk=darr(k,k)
    det=det*arrkk
    if k lt s1 then begin       ; if not at last row, proceed
       k1=k+1
       for i=k1,s1 do begin
          for j=k1,s1 do darr(i,j)=darr(i,j)-darr(i,k)*(darr(k,j)/arrkk)
       endfor  ; i
    endif  ; k lt s1
 endfor  ; k
 return
 end  ; determ
