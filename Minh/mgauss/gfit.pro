PRO gfit

filename='sp.sio-217104-0'
fname=filename+'.dat'
readcol,fname,u,x,v,y,w

nterms=3
n=101
   ; Define the coefficients.
   a = [10.0, 9.0, 2.0]
   print, 'Expected: ', a
   z = (x - a[1])/a[2] ; Gaussian variable

   nterms=3

   ; Fit the data to the function, storing coefficients in
   ; coeff:

   ; weight array
   weight = fltarr(n) + 1.0
   parms = [10.0, 9.0, 2.0]
   yfit = curvefit(x, y, weight, parms, function_name='gauss')

   print, 'Result: ', parms[0:nterms-1]
   ; Plot the original data and the fitted curve:
   PLOT, x, y, psym=10
   OPLOT, x, yfit, THICK=2
end  
