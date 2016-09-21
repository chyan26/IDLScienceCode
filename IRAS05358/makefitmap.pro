PRO makefitmap

	
	imsize=512
	fov=20.0/60
	ra=(5.0+(39.0/60)+(10.4/3600))*15
	dec=35.0+(45.0/60)+(19.0/3600)
	
	readcol,'/Volumes/disk1s1/Projects/ARO/fname.tab',a,x,y,z
	im=griddata(x,y,z,dimension=imsize)
	 
	sxaddpar,header,'SIMPLE','T'  ,'Standard FITS'                               
	sxaddpar,header,'BITPIX',-32  ,'Bits per pixel (not applicable)'                
	sxaddpar,header,'NAXIS   ', 2 ,'Number of axes'                                 
	sxaddpar,header,'NAXIS1  ', imsize ,'Number of pixel columns'                        
	sxaddpar,header,'NAXIS2  ', imsize ,'Number of pixel rows'                           
	sxaddpar,header,'CTYPE1  ','RA---TAN' 
	sxaddpar,header,'CTYPE2  ','DEC---TAN'
	sxaddpar,header,'CUNIT1  ','deg'
	sxaddpar,header,'CUNIT2  ','deg'	
	sxaddpar,header,'CRVAL1  ', ra
	sxaddpar,header,'CRVAL2  ',	dec
	sxaddpar,header,'CRPIX1  ', fix(imsize/2)
	sxaddpar,header,'CRPIX2  ', fix(imsize/2)
	sxaddpar,header,'CD1_1   ', -fov/imsize 
	sxaddpar,header,'CD1_2   ', 0.0
	sxaddpar,header,'CD2_1   ', 0.0
	sxaddpar,header,'CD2_2   ', fov/imsize 

	writefits,'~/ffb2.fits',reverse(smooth(im,3)),header
END