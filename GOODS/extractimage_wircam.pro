;05/06/2008
;written by C. H. Yan
;modified by L. Lin
;1)modify the image path
;2)use the WIRCAM K-band RA DEC for all images

;11/11/2010
;modify to allow for inputing the object id array in the command line

; This program is used to cut the image from all possible band for a give catalog.

PRO LOADCONFIG
   COMMON share,conf

   ;Setting for Mac computer
   if strcmp(!VERSION.OS,'linux') then begin
     path='/arrays/cfht/cfht_3/chyan/GOODSN/'
   endif else begin
     path='/Volumes/Data/Projects/GOODSN/'
   endelse
  
   hst_path=path+'HST/'
   hdf_path=path+'HDF/'
   cat_path=path+'Catalog/'
   wircam_path=path+'WIRCam/'
   spitzer_path=path+'Spitzer/'
   
	; Unit in arcsecond
	xsize=15.0
	ysize=15.0
	
	catalog=cat_path+'wircam_k_tkrs_goods_irac_mips_irs16_xray.fits'
	
	pspath=path+'PS/'
	
	conf={path:path,$
	      hst_path:hst_path,$
	      hdf_path:hdf_path,$
	      cat_path:cat_path,$
	      wircam_path:wircam_path,$
	      spitzer_path:spitzer_path,$
	      ysize:ysize,$
	      xsize:xsize,$
	      catalog:catalog,pspath:pspath} 
END

PRO LOADCAT, cat, index=index
   COMMON share, conf
   loadconfig
	
	file=conf.catalog
	print, 'Loading catalog = ', file
	
	tb=mrdfits(file,1)
	
	if keyword_set(index) then begin
		id=reform(tb[index].wircam_k_k_id)

		hst_ra=reform(tb[index].wircam_k_ra)
		hst_dec=reform(tb[index].wircam_k_dec)
		;hst_sec=reform(tb[index].goods_sector)
	
		hdf_ra=reform(tb[index].wircam_k_ra)
		hdf_dec=reform(tb[index].wircam_k_dec)
	   
 		wir_ra=reform(tb[index].wircam_k_ra)
		wir_dec=reform(tb[index].wircam_k_dec)
	   
  		irac_ra=reform(tb[index].wircam_k_ra)
		irac_dec=reform(tb[index].wircam_k_dec)
		irac_ch1=reform(tb[index].irac_ch1)
		irac_ch2=reform(tb[index].irac_ch2)
		irac_ch3=reform(tb[index].irac_ch3)
		irac_ch4=reform(tb[index].irac_ch4)
      
      mips_ra=reform(tb[index].wircam_k_ra)
      mips_dec=reform(tb[index].wircam_k_ra)
      
      
	endif else begin
      id=reform(tb.wircam_k_k_id)

      hst_ra=reform(tb.wircam_k_ra)
      hst_dec=reform(tb.wircam_k_dec)
      ;hst_sec=reform(tb.goods_sector)
   
      hdf_ra=reform(tb.wircam_k_ra)
      hdf_dec=reform(tb.wircam_k_dec)
      
      wir_ra=reform(tb.wircam_k_ra)
      wir_dec=reform(tb.wircam_k_dec)
      
      irac_ra=reform(tb.wircam_k_ra)
      irac_dec=reform(tb.wircam_k_dec)
      irac_ch1=reform(tb.irac_ch1)
      irac_ch2=reform(tb.irac_ch2)
      irac_ch3=reform(tb.irac_ch3)
      irac_ch4=reform(tb.irac_ch4)
      
      mips_ra=reform(tb.wircam_k_ra)
      mips_dec=reform(tb.wircam_k_ra)
	endelse
	cat={id:id,hst_ra:hst_ra,hst_dec:hst_dec,hdf_ra:hdf_ra,hdf_dec:hdf_dec,$
			wir_ra:wir_ra,wir_dec:wir_dec,irac_ra:irac_ra,irac_dec:irac_dec,$
			irac_ch1:irac_ch1,irac_ch2:irac_ch2,irac_ch3:irac_ch3,irac_ch4:irac_ch4,$
			mips_ra:mips_ra,mips_dec:mips_dec}   
   
END

PRO IRACSUBIMAGE, CAT, IMAGE
   COMMON share, conf
   loadconfig
   
	hdr=headfits(conf.spitzer_path+'n_irac_1_s2_v0.30_sci.fits')
   im=readfits(conf.spitzer_path+'n_irac_1_s2_v0.30_sci.fits')
   adxy,hdr,cat.irac_ra,cat.irac_dec,x,y
   
	fim1=fltarr(n_elements(x),10,10)
	
	for i=0,n_elements(x)-1 do begin
      xx=floor(x[i])
		yy=floor(y[i])
		if cat.irac_ra[i] le 0 and  cat.irac_dec[i] le 0 then begin
			fim1[i,*,*]=0.0
		endif else begin
			print,im[xx-4:xx+5,yy-4:yy+5]
			fim1[i,*,*]=im[xx-4:xx+5,yy-4:yy+5]
		endelse
   endfor

	image={i1:fim1}

END

PRO CATALOGIMAGE, CAT, IMAGE
   COMMON share, conf
   loadconfig
 
	subimage,cat.wir_ra,cat.wir_dec,conf.wircam_path+'goodsn_J_080110_WDX.fits',j
	subimage,cat.wir_ra,cat.wir_dec,conf.wircam_path+'goodsn_K_080113_WDX.fits',k  
	
	subimage,cat.wir_ra,cat.wir_dec,conf.hst_path+'nb_v2.0_sc03_blk5_drz.fits',b
	subimage,cat.wir_ra,cat.wir_dec,conf.hst_path+'nv_v2.0_sc03_blk5_drz.fits',v
	subimage,cat.wir_ra,cat.wir_dec,conf.hst_path+'ni_v2.0_sc03_blk5_drz.fits',i
	subimage,cat.wir_ra,cat.wir_dec,conf.hst_path+'nz_v2.0_sc03_blk5_drz.fits',z

	subimage,cat.wir_ra,cat.wir_dec,conf.spitzer_path+'n_mips_1_s1_v0.36_sci.fits',m1
	
	iracsubimage,cat.irac_ra,cat.irac_dec,'1',i1
	iracsubimage,cat.irac_ra,cat.irac_dec,'2',i2
	iracsubimage,cat.irac_ra,cat.irac_dec,'3',i3
	iracsubimage,cat.irac_ra,cat.irac_dec,'4',i4
 	

	;hstsubimage,cat.hst_ra, cat.hst_dec, cat.hst_sec, 'b', hb
	;hstsubimage,cat.hst_ra, cat.hst_dec, cat.hst_sec, 'v', hv
	;hstsubimage,cat.hst_ra, cat.hst_dec, cat.hst_sec, 'i', hi
	;hstsubimage,cat.hst_ra, cat.hst_dec, cat.hst_sec, 'z', hz
	
	image={id:cat.id,b:b,v:v,i:i,z:z,j:j,k:k,i1:i1,i2:i2,i3:i3,i4:i4,m1:m1}

END

PRO MAPIMAGE, IMAGE, PS=ps
   COMMON share, conf
   loadconfig
	
	name=tag_names(image)
   nimages=n_elements(image.(1)(*,0,0)) 
	for j=0, n_elements(image.(1)(*,0,0))-1 do begin
      ;!p.multi=0
       
		if keyword_set(PS) then begin
			
			set_plot,'ps'
			filename=conf.pspath+strcompress(string(image.id[j]),/remove)+'_image_wircamradec.ps'
			device,filename=filename,$
			/color,xsize=100,ysize=10,xoffset=2,yoffset=0,/landscape
			
			tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
			red=1
			green=2   
		endif 
		resetplt,/all
		multiplot,/reset
		erase & multiplot, [11,1],/square
		for i=1, n_tags(image)-1 do begin
		   
			!p.title = "!6"+name(i)
			!p.charsize = 1.3
			!x.thick=5.0
			!y.thick=5.0
			;!x.title = "!6RA offset(arcsec)"  & !y.title = "!6Dec offset(arcsec)"
			!x.tickname=' '
			!y.tickname=' '
			
			im=reform(image.(i)[j,*,*])
			
			if strcmp(name[i],'HI') eq 1 or strcmp(name[i],'HZ') eq 1 or $ 
				strcmp(name[i],'HB') eq 1 or strcmp(name[i],'HV')then begin
			 th_image_cont,0.03-im,/nocont,/nobar,xrange=[-6,6],yrange=[-6,6],$
			 	crange=[0,0.03]
			 multiplot	
			endif else begin
				peak=median(im)
            width=stddev(im)
            
            img=gmascl(im, gamma=0.7, MIN=0, MAX=max(im))
            
            th_image_cont,max(img)-img,/nocont,/nobar,xrange=[-(conf.xsize/2),(conf.xsize/2)],$
				yrange=[-(conf.ysize/2),conf.ysize/2]
            multiplot
			endelse 
		endfor
		multiplot,/reset
		
		if keyword_set(PS) then begin		   
			xyouts,0,0,filename,/device
			device,/close
			set_plot,'x'
		endif
		
	end
	
	resetplt,/all
	
END

PRO IRACSUBIMAGE, RA, DEC, BAND, IMAGE 
   COMMON share, conf
   loadconfig
   
   fits1=conf.spitzer_path+'n_irac_'+band+'_s1_v0.30_sci.fits'
   fits2=conf.spitzer_path+'n_irac_'+band+'_s2_v0.30_sci.fits'
   
   hdr1=headfits(fits1)
   hdr2=headfits(fits2)
   
   im1=readfits(fits1)
   im2=readfits(fits2)
   
   adxy,hdr1,ra,dec,x1,y1
   adxy,hdr2,ra,dec,x2,y2
   
   d1=ceil(conf.xsize/(sxpar(hdr1,'CD2_2')*3600))/2
   d2=ceil(conf.xsize/(sxpar(hdr2,'CD2_2')*3600))/2
   
   fim1=fltarr(n_elements(x1),d1*2,d1*2)
   ;fim2=fltarr(n_elements(x2),d2*2,d2*2)
   
   for i=0,n_elements(x1)-1 do begin
      xx1=floor(x1[i])
      xx2=floor(x2[i])
      
      yy1=floor(y1[i])
      yy2=floor(y2[i])
      
      if ra[i] le 0 and  dec[i] le 0 then begin
         fim1[i,*,*]=0.0
         ;fim2[i,*,*]=0.0
      endif else begin
         if total(im1[xx1-(d1-1):xx1+d1,yy1-(d1-1):yy1+d1]) eq 0 then begin
            fim1[i,*,*]=im2[xx2-(d2-1):xx2+d2,yy2-(d2-1):yy2+d2]
         endif else begin
            fim1[i,*,*]=im1[xx1-(d1-1):xx1+d1,yy1-(d1-1):yy1+d1]
         endelse
         ;fim1[i,*,*]=im1[xx1-(d1-1):xx1+d1,yy1-(d1-1):yy1+d1]
         ;fim2[i,*,*]=im2[xx2-(d2-1):xx2+d2,yy2-(d2-1):yy2+d2]
      endelse
   endfor

   image=fim1
END


PRO SUBIMAGE, RA, DEC, FITS, IMAGE 
	COMMON share, conf
   loadconfig
	
	hdr=headfits(fits)
   im=readfits(fits)
	adxy,hdr,ra,dec,x,y
	d=ceil(conf.xsize/(sxpar(hdr,'CD2_2')*3600))/2
	fim1=fltarr(n_elements(x),d*2,d*2)
	
	for i=0,n_elements(x)-1 do begin
      xx=floor(x[i])
		yy=floor(y[i])
		if ra[i] le 0 and  dec[i] le 0 then begin
			fim1[i,*,*]=0.0
		endif else begin
			fim1[i,*,*]=im[xx-(d-1):xx+d,yy-(d-1):yy+d]
		endelse
   endfor

	image=fim1
END



PRO HSTSUBIMAGE, RA, DEC, SEC, BAND, IMAGE
	COMMON share, conf
	loadconfig
	
	hdr=headfits(conf.hst_path+'h_n'+band+'_sect13_v1.0_drz_img.fits')
	d=ceil(conf.xsize/(sxpar(hdr,'CD2_2')*3600))/2
	fim1=fltarr(n_elements(ra),d*2,d*2)
	
	for i=0, n_elements(ra)-1 do begin
;;		if ra[i] le 0 and  dec[i] le 0 then begin
		if sec[i] le 0 then begin
			fim1[i,*,*]=0.0
		endif else begin
			file='h_n'+band+'_sect'+strcompress(string(sec[i]),/remove)+$
			'_v1.0_drz_img.fits'
			hdr=headfits(hst_path+file)
			im=readfits(hst_path+file)
			adxy,hdr,ra[i],dec[i],x,y
			xx=floor(x)
			yy=floor(y)
			;print,file,x,y
			
			xs=0
			xe=2*d-1
			ys=0
			ye=2*d-1
			
			if xx-(d-1) le 0 then begin
				x0=0 
				xs=(d*2-1)-(xx+d)
			endif else begin
				x0=xx-(d-1)
			endelse
			
			if yy-(d-1) le 0 then begin
				y0=0
				ys=(d*2-1)-(yy+d)
			endif else begin
				y0=yy-(d-1)
			endelse
			
			if xx+d ge sxpar(hdr,"NAXIS1") then begin
				x1=sxpar(hdr,"NAXIS1")-1
				xs=(d*2-1)-(x1-(xx-(d-1)))
			endif else begin 
				x1=xx+d
			endelse
			
			if yy+d ge sxpar(hdr,"NAXIS2") then begin
				y1=sxpar(hdr,"NAXIS2")-1
				ys=(d*2-1)-(y1-(yy-(d-1)))
			endif else begin
				y1=yy+d
			endelse
			
			;fim1[i,*,*]=im[xx-(d-1):xx+d,yy-(d-1):yy+d]
			fim1[i,xs:xe,ys:ye]=im[x0:x1,y0:y1]
		endelse

			
	endfor 
	image=fim1
END

PRO SAVEFITS, image
   COMMON share, conf
   loadconfig
   
   
   for j=0, n_elements(image.(1)(*,0,0))-1 do begin
      filename=strcompress(string(image.id[j]),/remove)+'_image_wircamradec.fits'
      fxhmake,header
      sxaddpar,header,'EXTEND','T'
      fxwrite,conf.pspath+filename,header       
;       
       for i=1, n_tags(image)-1 do begin
          im=reform(image.(i)[j,*,*])
          writefits,conf.pspath+filename,im,/append
       endfor
 
   end

END


PRO EXTRACTIMAGE_WIRCAM, ind
	
;;print, 'ind = ', ind


;;	ind=[5246,7667,7909,10668,12366,13191,13814,$
;;15094,15620,16933,18370,18743,18993,19197,20650,21742,22396,22932,$
;;23929,24172,24799,24858]

;;	ind=[7667,10668,12366,13814,$
;;	ind=[7667,10668,12366,13814,$
;;15094,15620,16933,18993,19197,22396,23693,$
;;24172,24858]

	ind=[13459,15252];,19297,20967,31731,33833]
	index=ind-1
	loadcat,cat,index=index
	catalogimage,cat,image
	mapimage,image,/ps
   savefits,image
;print, 'cat_path = ', cat_path
END
