FUNCTION ADSTR2AD, string
  de=fltarr(n_elements(string))
  for i=0, n_elements(string)-1 do begin
    num=strsplit(string[i],':',/EXTRACT)
    de[i]=num[0]+num[1]/60.0+num[2]/3600.0
  endfor
  return,de
  
END


PRO makefitmap

	
	imsize=512
	angsize=4 ; 4 arcmin
	
	xcen=3.0  ;arcmin
	ycen=-1.0 ;arcmins
	
	str_ra='20:18:00'
	str_dec='36:45:00'
	
	ra=adstr2ad(str_ra)*15
	dec=adstr2ad(str_dec)

	readcol,'/Volumes/disk1s1/Projects/S104-HCN/yint-hcn-12m-fb1sum.dat',a,x,y,z
	im=readfits('/Volumes/disk1s1/Projects/S104-HCN/hcn.fits',header)
	

	 
	sxaddpar,header,'SIMPLE','T'  ,'Standard FITS'                               
	sxaddpar,header,'BITPIX',-32  ,'Bits per pixel (not applicable)'                
	sxaddpar,header,'NAXIS   ', 2 ,'Number of axes'                                 
	;sxaddpar,header,'NAXIS1  ', imsize ,'Number of pixel columns'                        
	;sxaddpar,header,'NAXIS2  ', imsize ,'Number of pixel rows'                           
	sxaddpar,header,'CTYPE1  ','RA---TAN' 
	sxaddpar,header,'CTYPE2  ','DEC---TAN'
	sxaddpar,header,'CUNIT1  ','deg'
	sxaddpar,header,'CUNIT2  ','deg'	
	sxaddpar,header,'CRVAL1  ', ra[0]
	sxaddpar,header,'CRVAL2  ',	dec[0]
	sxaddpar,header,'CRPIX1  ', fix(imsize/2)
	sxaddpar,header,'CRPIX2  ', fix(imsize/2)
	sxaddpar,header,'CDELT1  ', -angsize/60.0/imsize
	sxaddpar,header,'CDELT2  ', angsize/60.0/imsize
	;sxaddpar,header,'CD1_1   ', -angsize/60.0/imsize
	;sxaddpar,header,'CD1_2   ', 0.0
	;sxaddpar,header,'CD2_1   ', 0.0
	;sxaddpar,header,'CD2_2   ', -angsize/60.0/imsize

	writefits,'/Volumes/disk1s1/Projects/S104-HCN/whcn.fits',im,header
END