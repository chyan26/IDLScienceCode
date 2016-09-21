PRO STDFWHM, IM, X, Y, PSFBOX, PHOTO, NORMALIZE=normalize
       photo=fltarr(3);

       s=size(im)
       if x-psfbox+1 le 0 or x+psfbox ge s[1] or y-psfbox+1 le 0 $
       or y+psfbox ge s[1] then begin
               print,'This stars is on the edge of image. '+$
               strcompress(string(x),/remove)+' '+$
               strcompress(string(y),/remove)
       endif else begin
               im1=im[x-psfbox+1:x+psfbox,y-psfbox+1:y+psfbox]
					
					
               CNTRD, im1, psfbox, psfbox, x1, y1, 6


               n=0
               flux =fltarr(n_elements(im1))
               r=fltarr(n_elements(im1))
               for i=0,psfbox*2-1 do begin
                       for j=0,psfbox*2-1 do begin
                               flux[n]=im1[i,j]
                               r[n]=sqrt((i-x1)^2+(j-y1)^2)
                               n=n+1
                       endfor
               endfor
					if (keyword_set(normalize)) then	begin
						factor=normalize/max(flux)
					endif else begin
						factor=1
					endelse
						
               ;
               ; Fitting using Gaussian the center may not be at [0,0]
               ;
               estimates=[max(flux)*factor,0,0,median(im1)]
               yfit=gaussfit(r,flux*factor,coeff,estimates=estimates,sigma=sigma,nterm=4)
               fwhm1=sqrt(2*alog(2))*coeff[2]*2*0.2


               oplot,r*0.2,flux*factor,psym=3

               rx=findgen(1000)*0.02
               z=(rx-coeff[1])/coeff[2]
               yy=coeff[0]*exp((-z^2)/2)+coeff[3];+coeff[4]*rx+coeff[5]*rx^2
               oplot,rx*0.2,yy

               !p.multi=0

               photo[0]=coeff[0]
               photo[1]=fwhm1
					photo[2]=coeff[0]+coeff[3]

       endelse


END

PRO AGNFWHM, IM, X, Y, PSFBOX, PHOTO,NORMALIZE=normalize
       photo=fltarr(3);

       s=size(im)
       if x-psfbox+1 le 0 or x+psfbox ge s[1] or y-psfbox+1 le 0 $
       or y+psfbox ge s[1] then begin
               print,'This stars is on the edge of image. '+$
               strcompress(string(x),/remove)+' '+$
               strcompress(string(y),/remove)
       endif else begin
               im1=im[x-psfbox+1:x+psfbox,y-psfbox+1:y+psfbox]

               CNTRD, im1, psfbox, psfbox, x1, y1, 6


               n=0
               flux =fltarr(n_elements(im1))
               r=fltarr(n_elements(im1))
               for i=0,psfbox*2-1 do begin
                       for j=0,psfbox*2-1 do begin
                               flux[n]=im1[i,j]
                               r[n]=sqrt((i-x1)^2+(j-y1)^2)
                               n=n+1
                       endfor
               endfor

               ;
               ; Fitting using Gaussian the center may not be at [0,0]
               ;
               estimates=[max(flux),0,0,median(im1)]
               yfit=gaussfit(r,flux,coeff,estimates=estimates,sigma=sigma,nterm=4)
               fwhm1=sqrt(2*alog(2))*coeff[2]*2*0.2
					print,sigma
					err=sqrt(2*alog(2))*sigma[2]*2*0.2

               plot,r*0.2,flux,psym=1,xrange=[0,4],yrange=[min(flux),min(flux)],$
               xtitle='Radius', ytitle='Flux',$
               title='X= '+strcompress(string(x),/remove)+' Y= '+$
               strcompress(string(y),/remove)+$
               ' MAX='+strcompress(string(coeff[0]),/remove)+$
               ' FWHM1= '+strcompress(string(fwhm1,format='(f5.2)'),/remove)+$
					' +/- '+strcompress(string(err,format='(f5.2)'),/remove),$
                charsize=1.2


               rx=findgen(1000)*0.02
               z=(rx-coeff[1])/coeff[2]
               yy=coeff[0]*exp((-z^2)/2)+coeff[3];+coeff[4]*rx+coeff[5]*rx^2
               oplot,rx*0.2,yy

               !p.multi=0

               photo[0]=coeff[0]
               photo[1]=fwhm1
               photo[2]=max(flux)
       endelse
END

PRO PLOTEDGE, X, Y, BOX
       lim=2*box
       oplot,[x-lim,x-lim],[y-lim,y+lim],thick=2;,color=255
       oplot,[x+lim,x+lim],[y-lim,y+lim],thick=2;,color=255
       oplot,[x-lim,x+lim],[y-lim,y-lim],thick=2;,color=255
       oplot,[x-lim,x+lim],[y+lim,y+lim],thick=2;,color=255
END

FUNCTION IMEXTRACT, IM, X, Y, BOX, EIM

       eim=im[x-box:x+box,y-box:y+box]
       return,eim
END

PRO CFHTIR_PSF_IRAS17596
       path='/arrays/cfht_2/chyan/qso_ir/combined/'
       file=path+'iras17596.fits'
       im=readfits(file)

       
		 set_plot,'ps'
		 
		 agn_x=497.0
		 agn_y=495.9
			
		 std_x=[604.5,38.8,886.5]
		 std_y=[628.3,879.6,606.7]
		 
		 fwhm_x=[271.4,61.7,846.0,761.38]
		 fwhm_y=[214.8,658.0,731.0,725.00]
       
		 ;check fwhm
		 for i=0,n_elements(fwhm_x)-1 do begin
			!p.multi=[0,1,2]
			device,filename='~/fwhm_check'+strcompress(string(i),/remove)+'.ps',$
				xsize=15,ysize=30,xoffset=2,yoffset=0
			th_image_cont,im,/nocont,crange=[1000,2000],/nobar
			plotedge,fwhm_x[i],fwhm_y[i],8
			agnfwhm,im,fwhm_x[i],fwhm_y[i],8,photo_agn
			device,/close		 		
		 endfor	
		 
		 ;exam AGN and standard stars 		 
		 
		 for i=0,n_elements(std_x)-1 do begin
		 	!p.multi=[0,1,2]
			device,filename='~/agn_psf'+strcompress(string(i),/remove)+'.ps',$
				xsize=15,ysize=30,xoffset=2,yoffset=0
		 	th_image_cont,im,/nocont,crange=[1000,2000],/nobar
			plotedge,agn_x,agn_y,8
			plotedge,std_x[i],std_y[i],8
			agnfwhm,im,agn_x,agn_y,8,photo_agn
			
			
			stdfwhm,im,std_x[i],std_y[i],8,photo_std
			device,/close		 	
		 endfor	
       !p.multi=0
END