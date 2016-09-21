
PRO SUBIMAGING

path='/Volumes/Data/Projects/SN2012aw/'

file1=path+'hst_05397_1e_wfpc2_f439w_wf_drz.fits'
file2=path+'hst_05397_1h_wfpc2_f439w_wf_drz.fits'

im1=mrdfits(file1,1,hd1)
im2=mrdfits(file2,2,hd2)

im=im1+(im2+mean(im2))


writefits,path+'test.fits',im

END



PRO LULINSEEING
   COMMON share,conf
   loadconfig



   spawn,'sex -c '+conf.confpath+'sex.conf '+conf.fitspath+'20120317_M95_5-001r300-cal.fit'$
   	  +' -CHECKIMAGE_NAME '$
      +conf.fitspath+'lulin_b_check.fits -CATALOG_NAME '+conf.catpath+'lulin_b.sex -MAG_ZEROPOINT 20 '$
      +' -PARAMETERS_NAME '+conf.confpath+'default.param '$
      +' -FILTER_NAME '+conf.confpath+'default.conv '$
      +' -STARNNW_NAME '+conf.confpath+'default.nnw '$
      +' -PHOT_FLUXFRAC 0.5 -PHOT_APERTURES 10 -ANALYSIS_THRESH 10.0 '$
      +' -DETECT_THRESH 10.0 -BACKPHOTO_TYPE LOCAL -BACK_SIZE 5 '
	
	readcol,conf.catpath+'lulin_b.sex',format='(f,f,f,d,d,f,f,f,f,f,f,f,f,f,f,f)'$
   	  ,id,x,y,ra,dec,flux,ferr,mag,magerr,a,b,i,e,fwhm,flag,class,/silent
		
	ind=where(class ge 0.85 and fwhm ge 0 and flag eq 0)
	print,fwhm
	print,n_elements(ind),median(fwhm)*0.5


END