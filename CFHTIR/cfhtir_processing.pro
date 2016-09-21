


PRO CFHTIR_PROCESSING


	
	datapath = '/arrays/cfht_2/chyan/CFHTIR/'
	redpath = '/arrays/cfht_2/chyan/qso_ir/'
	calibpath =  redpath+'calib/'

	goto, PG0844
	goto,IRAS17596
	

	
FLAT:	
	flat_suffix = 'f.fits'
	obj_suffix = 'o.fits''

	j_on=[527,528,529,530,531]
	j_off=[532,533,534,535,536]
	
	;j_on=[527,528,529,530,531]
	;j_off=[532,533,534,535,536]

	cfhtir_buildflat, FLAT_ON=j_on, FLAT_OFF=j_off, flatname = 'domeflat_j_20051221.fits'
	
	k_on=[547,548,549,550]
	k_off=[551,552,553,554]

	cfhtir_buildflat, FLAT_ON=k_on, FLAT_OFF=k_off, flatname = 'domeflat_k_20051221.fits'
	
BADPIX:
	cfhtir_buildbadpix, DARK=calibpath+'dark_120s_20051221.fits', $
		flat=	calibpath+'domeflat_j_20051221.fits',$
		file= calibpath+'badpix_20051223.fits'

IRAS17596:


	list=[758,759,760,761,761,$
		   766,767,768,769,770,771,772,773,774,$
			775,776]
	
	;goto,here
	cfhtir_doreduc, file = list, dark = calibpath+'dark_60s_20051221.fits',$
		 flat=calibpath+'domeflat_j_20051221.fits',$
		 badpix=calibpath+'badpix_20051223.fits'
	
	cfhtir_buildsky, file=list, sky='sky_iras_20051222.fits'
	
	
	cfhtir_doreduc, file = list, dark = calibpath+'dark_60s_20051221.fits',$
		 flat=calibpath+'domeflat_j_20051221.fits', sky='sky_iras_20051222.fits',$
		 badpix=calibpath+'badpix_20051223.fits',bias=1000,/invertew

	;here:	 	
	cfhtir_stackimage, file = list, stack='iras17596.fits'

PG0844:

	list=[580,581,582,583,584,$
	      	585,586,587,588,589,$
		590,591,592,593,594,$
		595,596,597,598,599,$
		600,601,602,603,604,$
		605,606,607,608,609,$
		610,611,612]
	
	;cfhtir_doreduc, file = list, dark = calibpath+'dark_60s_20051221.fits',$
	;	 flat=calibpath+'domeflat_j_20051221.fits',$
	;	 badpix=calibpath+'badpix_20051223.fits'
	
	;cfhtir_buildsky, file=list, sky='sky_pg0844_20060108.fits'
	
	;cfhtir_doreduc, file = list, dark = calibpath+'dark_60s_20051221.fits',$
	;	 flat=calibpath+'domeflat_j_20051221.fits', sky='sky_pg0844_20060108.fits',$
	;	 badpix=calibpath+'badpix_20051223.fits',bias=1000,/invertew
	
	cfhtir_stackimage, file = list, stack='pg0844.fits'
	
END