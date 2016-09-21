PRO IMGEXTRACT, cra, cdec, imsize, oim, ohd, nim, nhd
  Compile_opt idl2
  On_error,2

  npar = N_params()

  if ( npar EQ 0 ) then begin
        print,'Syntax - IMGEXTRACT, cra, cdec, oim, ohd, nim, nhd'
        print,'CRA and CDEC must be in decimal DEGREES'
        return
  endif                                                                  
  
  adxy,ohd,cra,cdec,x,y
  rad=fix(imsize/2.0)  
  hextract,oim,ohd,nim,nhd,fix(x-rad+1),fix(x+rad),fix(y-rad+1), fix(y+rad)
  
  return 
END

PRO RESIZEIMAGE;, image, header
   COMMON share,setting
   loadconfig
	
	im1=readfits(setting.wircampath+'SH2-104_J_coadd.fits',hd1)
	im2=readfits(setting.wircampath+'SH2-104_H_coadd.fits',hd2)
	im3=readfits(setting.wircampath+'SH2-104_KS_coadd.fits',hd3)


  ;imgextract, 304.48785,36.76065, 512, im1, hd1, nim1, nhd1
  ;imgextract, 304.48785,36.76065, 512, im2, hd2, nim2, nhd2
  ;imgextract, 304.48785,36.76065, 512, im3, hd3, nim3, nhd3
  imgextract, 304.493, 36.75059, 1024, im1, hd1, nim1, nhd1
  imgextract, 304.493, 36.75059, 1024, im2, hd2, nim2, nhd2
  imgextract, 304.493, 36.75059, 1024, im3, hd3, nim3, nhd3

	writefits,setting.fitspath+'s104_j.fits',nim1,nhd1
	writefits,setting.fitspath+'s104_h.fits',nim2,nhd3
	writefits,setting.fitspath+'s104_k.fits',nim3,nhd3
	
	; Now cutting the reference image
  imgextract, 304.52016, 36.831121, 1024, im1, hd1, rim1, rhd1
  imgextract, 304.52016, 36.831121, 1024, im2, hd2, rim2, rhd2
  imgextract, 304.52016, 36.831121, 1024, im3, hd3, rim3, rhd3
	
  writefits,setting.fitspath+'s104_j_ref.fits',rim1,rhd1
  writefits,setting.fitspath+'s104_h_ref.fits',rim2,rhd3
  writefits,setting.fitspath+'s104_k_ref.fits',rim3,rhd3
	
	;image={j:nim1,h:nim2,k:nim3}
	;header={j:nhd1,h:nhd2,k:nhd3}
	
	return

END

PRO RESIZECONT
   COMMON share,setting
   loadconfig
   im1=readfits(setting.path+'COORD_MINH.FITS',hd1)
   imgextract, 304.48785,36.76065, 15, im1, hd1, nim1, nhd1
   writefits,setting.fitspath+'continuum.fits',nim1,nhd1
END

PRO TRICOLOR
   COMMON share,setting
   loadconfig
	im1=readfits(setting.wircampath+'SH2-104_J_coadd.fits',hd1)
	im2=readfits(setting.wircampath+'SH2-104_H_coadd.fits',hd2)
	im3=readfits(setting.wircampath+'SH2-104_KS_coadd.fits',hd3)
	im4=readfits(setting.path+'COORD_MINH.FITS',hd4)

	;
	; scale image to the same dimension
	hastrom, im2,hd2,tim2,thd2,hd1
	hastrom, im3,hd3,tim3,thd3,hd1
	hastrom, im4,hd4,tim4,thd4,hd1

	ind=where(tim4 le 0.0003)
	tim4[ind]=0
	
	writefits,setting.wircampath+'j.fits',im1,hd1
	writefits,setting.wircampath+'h.fits',tim2,thd2
	writefits,setting.wircampath+'k.fits',tim3,thd3
	writefits,setting.wircampath+'cs.fits',tim4,thd4
	
	cd,setting.wircampath
	spawn, 'stiff -c stiff.conf k.fits '$
		+'h.fits j.fits '$
		+'-GAMMA 1.5 -COLOUR_SAT 1.1 -MIN_LEVEL 0.01'

	spawn, 'rm -rf j.fits h.fits k.fits '
END

PRO LOADREF, image, header
  COMMON share,setting
  loadconfig
  
  nim1=readfits(setting.fitspath+'s104_j_ref.fits',nhd1)
  nim2=readfits(setting.fitspath+'s104_h_ref.fits',nhd2)
  nim3=readfits(setting.fitspath+'s104_k_ref.fits',nhd3)
  
  image={j:nim1,h:nim2,k:nim3}
  header={j:nhd1,h:nhd2,k:nhd3}


END


PRO LOADS104, image, header
	COMMON share,setting
	loadconfig
	
	nim1=readfits(setting.fitspath+'s104_j.fits',nhd1)
	nim2=readfits(setting.fitspath+'s104_h.fits',nhd2)
	nim3=readfits(setting.fitspath+'s104_k.fits',nhd3)
	
	image={j:nim1,h:nim2,k:nim3}
	header={j:nhd1,h:nhd2,k:nhd3}

END
