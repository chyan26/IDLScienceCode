PRO gfit2

filename='sp.sio-217104-0'
fname=filename+'.dat'
readcol,fname,u,x,v,y,w
gaussfits,x,y,2,3,a,yfit,sig
;  This is a interactive program
;    1.  Select the left and right boundary with mouse left buttom
;    2.  Then select the peak of each compoment

oplot,x,yfit,color=255
end  
