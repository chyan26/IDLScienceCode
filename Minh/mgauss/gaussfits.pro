@parcheck
@wpolyfits
@wfits
@baserem
;************************************************************************
;+
;*NAME:
;
;    GAUSSFITS     JUNE,1984
;  
;*CLASS:
;  
;*CATEGORY:
;  
;*PURPOSE:
;
;    To fit Gaussians and a polynomial baseline to data points
;  
;*CALLING SEQUENCE:
;
;       GAUSSFITS,X,Y,NDEG,NCOMP,A,YFIT,SIG,comment,prnt=prnt
;  
;*PARAMETERS:
;
;     X  (REQ) (I) (1) (I L F D)
;     Independent variable vector.
;
;     Y  (REQ) (I) (1) (I L F D)
;     Dependent variable vector.
;
;     NDEG  (REQ) (I) (1) (I)
;     Degree of polynomial to be fit to baseline, 0 signifies no 
;     fit is to be made to baseline.
;
;     NCOMP (REQ) (I) (1) (I)
;     Number of Gaussian components.
; 
;  A  (REQ) (O) (1) (I L F D)
;     Vector of function parameters.
;                    A(3I-3) is the center of the Ith Gaussian
;                       A(3I-2) is the 1 sigma width of the Ith Gaussian
;                       A(3I-1) is the height of the Ith Gaussian above
;                               the baseline
;                       A also stores the parameters of the baseline fit
;                       in the last NDEG+1 elements.
;
;     YFIT  (REQ) (O) (1) (I L F D)
;     Vector of calculated Y values.
;
;     SIG   (REQ) (O) (1) (I L F D)
;     Vector of 1 sigma errors in fitted parameters of Gaussians 
;     (ordered like A).
;
;      COMMENT   (OPT) (I) (0) (S)
;               Optional input parameter containing a string to print at
;               top of plot.
;
;       PRNT    (KEY) (I) 
;               If set, Gaussfits will offer option of sending final plot
;               to the default printer (as specified in !IUEPRINT). If not
;               set, no print option is offered.
;  
;*INTERACTIVE INPUT:
;
;        The user specifies the boundary of the feature to be fitted
;        and the approximate location of the Gaussians with the
;        cursor.
;       If keyword PRNT is set, user is prompted for whether final plot
;       should be sent to the laser printer.
;  
;*FILES USED:
;  
;*SYSTEM VARIABLES USED:
;
;  !d.x_ch_size
;  !d.y_ch_size
;  !d.y_size
;  
;*SUBROUTINES CALLED:
;
;  PARCHECK
;     BASEREM
;     GAUSS
;     WFIT
;  
;*SIDE EFFECTS:
;  
;*RESTRICTIONS:
;  
;*PROCEDURE:
;
;        The routine uses BASEREM to fit the baseline with a
;        polynomial or makes no baseline fitting as specified 
;        by the user.  The procedure uses the standard  
;        deviation of a single point in the baseline section of the 
;        data to create an equal-weight vector for all data points.   
;        The user inputs the approximate location and height of each 
;        Gaussian with the cursor.  The procedure uses WFIT to solve for 
;        the center, dispersion, and height of all Gaussian components, 
;        and their 1 sigma errors.  Absolute errors for the Gaussian 
;        parameters are calculated using the 1 sigma errors of a point
;        in the baseline fit. GAUSSFITS outputs a plot showing the data, 
;       the individual Gaussian components, the sum of all components, 
;       and the deviations. The symbols used are shown below:
;          - histogram: vector of data points Y
;          - solid line: the total fit (sum of all Gaussians & baseline)
;          - dots: individual Gaussian components
;          - plus signs: difference between data points and total fit
;  
;*INF_1:
;  
;*EXAMPLES:
;     Fit 2 Gaussians to features around 2800 angstroms using a first
;     order fit to the continuum (after trimming wavelength and flux
;     arrays to 2400 to 3100 angstroms):
;         TRIM,2400,3100,W,F,E
;         GAUSSFITS,W,F,1,2,A,YFIT,SIG
;  
;*NOTES:
;     - The polynomial fit to the baseline is based on ALL the POINTS in the 
;       input arrays minus the region spcified by the user. Users may 
;       therefore want to TRIM the input X and Y arrays if noise spikes, 
;       artifacts, etc. exist that could distort the baseline fit. (See 
;       program TRIM).
;     - When multiple Gaussians are fit (i.e. NCOMP > 1), the baseline fit 
;       excludes points lying between the features.
;     - When fitting multiple Gaussians, the user must specify the left most
;       edge of the 1st feature, and the right-most edge of the 2nd feature.
;     - Input Y array is scaled before baseline and gaussian fitting.
;     - Input X and Y arrays should be specified as real numbers 
;       (i.e., not integers) to avoid errors in precision.
;
;  tested with IDL Version 2.1.2 (sunos sparc)     23 Dec 91
;  tested with IDL Version 2.1.2 (ultrix mispel)   08 Aug 91
;  tested with IDL Version 2.1.2 (vms vax)         23 Dec 91
;  
;*MODIFICATION HISTORY:
;
;        PDP VERSION: I. D. AHMAD
;        VAX mods: R. Thompson & C. Grady
;        June, 1984: N. R. Evans: to correct WFIT calling error,
;              introduce sigma squared weighting, use sigma from 
;              baseline fit to determine absolute errors, correct
;              plotting, and document.
;        7-7-84 RWT modified WT value passed to WFIT, moved YFIT
;              routine to WFIT and updated documentation.
;        9-20-84 RWT deleted unnecessary code, corrected code for extracting
;              feature from input array (i.e. backgnd subtraction) and uses new
;              version of WFIT.
;        4-13-87 RWT VAX mods: add PARCHECK & PLTPARM, remove INSERT, and use
;              SET_XY
;        9-21-87 RWT correct error in DELTAA(IN) calculation
;        10-7-87 CAG rename procedure as GAUSSFITS, and alter order of plotting
;              so that plot autoscales correctly for observed data.
;      11-16-87 RWT VAX mods: remove restrictions of baseline
;              polynomial, improve plot annotation, compress code, 
;              use new BASEREM, and change name to GAUSSFITS
;       8-24-89 RWT Unix mods: 
;       6-25-91 PJL cleaned up; added /down to cursor command; tested on
;         SUN and VAX; updated prolog
;       7-30-91 GRA removed unused parameter "0." from the WFIT calling
;                   statements.
;       8-08-91 GRA added tek branch for prompt strings; added section
;                   in final output to limit x axis range; scaled yg
;                   vector before calling WFIT; modified BASEREM to
;                   scale the ybase vector before calling WPOLYFIT; 
;                   marked cursor selected points with an 'x'; tested
;                   on SUN, DEC, VAX; updated prolog.
;      10-10-91 LLT removed 40A limit to allow CRSCOR to work, features
;         \PJL separated by more than 40A to be examined, and other
;         units to be used; prevent PXLIM error
;      12-20-91 RWT correct PXLIM estimate, scaling of final plot,
;                   and expand documentation.
;     23 Feb 93 LLT Remove xrange/yrange keywords from OPLOT commands
;                   (not allowed in IDL Version 3).
;     11 Oct 93 RWT offer print option and comment line
;-
;************************************************************************
 pro gaussfits,x,y,ndeg,ncomp,a,yfit,sig,comment,prnt=prnt
;
 npar = n_params()
 if npar eq 0 then begin
    print,' GAUSSFITS,X,Y,NDEG,NCOMP,A,YFIT,SIG,comment,prnt=prnt'
    retall
 endif  ; npar
 parcheck,npar,[7,8],'GAUSSFITS'
;
 ind    = 3 * ncomp
 nterms = ndeg + ind + 1
 npts   = n_elements(x)
 b      = fltarr(ind)
 bscl   = b
 a      = fltarr(nterms)
 deltaa = b
 sig    = b
;
; fit polynomial to baseline
;
 xl = 0.0 & xr = 0.0
 baserem,x,y,ndeg,xl,xr,a,ybf,chis
;
; extract feature & subtract background from y array 
;
 xg = x(xl:xr)
 i = 0
 yfit = a(ind)
 while i lt ndeg do begin
    i = i+1
    yfit = yfit + a(ind+i)*(xg^i)
 endwhile  ; i
 yg = y(xl:xr) - yfit
;
; estimate starting parameters of gaussian(s) for wfit
;
 b1 = (x(xr) - x(xl))/(6.4*ncomp)  ; first estimate of one sigma width
 sq = sqrt((xr - xl + 1.)/ncomp)*3.
; 
; scale y parameters and chis to avoid floating overflow in wfit
;
 yav = total(yg)/n_elements(yg)
 ygscl = yg/yav
 chiscl = chis/(yav^2)
;
 plot,xg,yg,psym=10
 xpos = !d.x_ch_size 
 ypos = !d.y_size - !d.y_ch_size 
 dely = 1.1 * !d.y_ch_size
;
 if (strlowcase(!d.name) eq 'tek') then begin
    st = $
     'Place cursor at each component peak (left to right) & press any key'
 endif else begin
    st = $
     'Place cursor at each component peak (left to right) & press mouse button'
 endelse  ; !d.name eq 'tek'
 xyouts,xpos,ypos,font=0,/device,st
;
; 1st estimate of gaussian peak, scale y parameters
;
 for i=0,ncomp-1 do begin
    in = i*3
    cursor,xc,yc,1,/data,/down        
    oplot,[xc],[yc],psym=7,symsiz=1.5
    flush = get_kbrd(0)
    bscl([in,in+1,in+2])  = [xc,b1,yc/yav]
    deltaa([in,in+1,in+2])  = [b1/sq,b1/sq,sqrt(chiscl)]
 endfor  ; i loop
; 
; use wfit to fit gaussian to feature (use 1/chiscl for wt)
;
 ifit  = intarr(ind) + 1
;
 print,' Fitting gaussian to feature...'
 wfit,xg,ygscl,ygscl*0+1/chiscl,ifit,deltaa,bscl,ygsclf,sigscl
 print,' Gaussian has been fit.'
;
; unscale y parameters for output, and load output arrays a, b.
;
 ygf = ygsclf*yav
 for i = 0,ncomp-1 do begin
     b(3*i) = bscl(3*i)
     b(3*i+1) = abs(bscl(3*i+1))
     b(3*i+2) = bscl(3*i+2)*yav
     sig(3*i) = sigscl(3*i)
     sig(3*i+1) = sigscl(3*i+1)
     sig(3*i+2) = sigscl(3*i+2)*yav^2
 endfor
 a(0) = b                              ; set first 3 parameters to fit values
;
; insert feature + baseline combination into yfit
;
 yfit  = 0*x
 yfit(xl) = ygf
 i = 0
 bfit = a(ind)
 while i lt ndeg do begin
    i = i+1
    bfit = bfit + a(ind+i)*(x^i)
 endwhile  ; i
 yfit  = yfit + bfit
;
; set graph limits & plot output
;
 llim = min(xg)
 ulim = max(xg)
 ind = where( (x gt llim) and (x lt ulim) ) 
; xs = x(ind)
 ys = y(ind)
 yfits = yfit(ind)
 ydiff = ys - yfits
 pymax = max([max(ys),max(yfits),max(ydiff)])
 pymin = min([min(ys),min(yfits),min(ydiff)])
 pylim = [pymin,pymax]
 pxlim = [llim,ulim]
 plot,x,y,psym=10,yrange=pylim,xrange=pxlim     ; actual pts marked w/ histo.
 oplot,x,yfit,psym=0                            ; fitted pts connected by line
 oplot,x,y-yfit,psym=1                          ; y-yfit shown as '+'
 for i=1,ncomp do begin  
    i3=(i-1)*3
    gauss,x,a(i3),a(i3+1),a(i3+2),yf
;    yfs = yf(ind)
    oplot,x,yf,psym=3                           ; dots for indiv. gaussians
 endfor  ; i loop
;                         
;    add information on Gaussian Component(s)
;
 gtitle ='Gaussian Component(s):  ' 
 if (npar eq 8) then gtitle = gtitle + comment
 ypos = ypos - dely
 xyouts,xpos,ypos,/device,font=0,gtitle 
 ypos = ypos - dely
 xyouts,xpos,ypos,/device,font=0,  $
    '     Center     (error)      Sigma    (error)       Peak     (error)'
 stf = "(2(f11.4,2x,'(',f8.5,')'),1x,e11.2,2x,'(',e8.2,')')"
 for i=0,3*(ncomp-1),3 do begin
    ypos = ypos - dely
    st = string(format=stf,b(i),sig(i), b(i+1),sig(i+1),b(i+2),sig(i+2))
    xyouts,xpos,ypos,font=0,/device,st
 endfor  ; i
;
; see if postscript print file is requested
;
 if (keyword_set(prnt)) then begin
    ans = ''
    ypos = !d.y_size - !d.y_ch_size
    ;
    if !d.name ne 'TEK' then $
    read,' Send this plot to the laser printer? (y/n) ',ans $
    else xyreads,/device,xpos,ypos-((ncomp+3)*dely),ans, $
                 'Send plot to laser printer? (y/n) '
    yesno,ans
    if ans then begin
       plotopen,dev,'gaussfits'
      ;
      ; format plot
      ;
      plot,x,y,psym=10,yrange=pylim,xrange=pxlim     
      oplot,x,yfit,psym=0                            
      oplot,x,y-yfit,psym=1                          
      for i=1,ncomp do begin  
        i3=(i-1)*3
        gauss,x,a(i3),a(i3+1),a(i3+2),yf
        oplot,x,yf,psym=3                           
      endfor  ; i loop
      ;
      ; redefine spacing for new device before annotating plots
      ;
      ypos = !d.y_size - !d.y_ch_size
      xpos = !d.x_ch_size 
      if (!d.name eq 'TEK') then dely = 1.1 * !d.y_ch_size $
                            else dely = 1.3 * !d.y_ch_size
      ypos = ypos - dely
      xyouts,xpos,ypos,/device,font=0,gtitle
      ypos = ypos - dely
      er = '(error)'
      if (!d.name eq 'TEK') then stf = "(3x,a,5x,a,7x,a,4x,a,7x,a,6x,a)" $
          else stf = "(4x,a,7x,a,9x,a,5x,a,9x,a,10x,a)" 
      st = string(format=stf,'Center',er,'Sigma',er,'Peak',er)
      xyouts,xpos,ypos,/device,font=0,st
      stf = "(2(f11.4,2x,'(',f8.5,')'),1x,e11.2,2x,'(',e8.2,')')"
      for i=0,3*(ncomp-1),3 do begin
         ypos = ypos - dely
         st = string(format=stf,b(i),sig(i), b(i+1),sig(i+1),b(i+2),sig(i+2))
         xyouts,xpos,ypos,font=0,/device,st
      endfor  ; i
      ;
       plotprint,dev,'gaussfits'
      ;
    endif  ; ans 
    ;
 endif     ; prnt
;
 return
 end  ; gaussfits

