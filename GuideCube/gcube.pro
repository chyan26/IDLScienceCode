PRO LOADCONFIG
	COMMON share,cubepath,calibpath,datapath,redpath
	
	;cubepath='/arrays/cfht_3/chyan/guidecube/'
	;cubepath='/h/archive/current/instrument/wircam/'
	;calibpath='/data/ula/wircam/calib/'
	;datapath='/data/wena/wircam/chyan/gcube/'

	cubepath='/data/newgcube/'
	calibpath='/arrays/menka/wircam/calib/'
	datapath='/data/chyan/gcube/'
	redpath='/arrays/cfht_3/chyan/CFHT/gcube/Reduced/'
	
END

;
;54 sums into 60. 52 sums in to 77. then the sum of 54 and 60 sum into 77.
;
;I would like to change this for the next run so that the original images
;are kept, and those plus the sum are stored as MEF.
PRO LOADGCUBE, file, im77, im52, im54, im60, hdr
   
   hdr=headfits(file)
   bias=sxpar(hdr,'WCCHBIAS')
;   print,bias
   
	if bias lt -1 then bias=0
   
   im77 = mrdfits(file,1,/silent)+32768-bias
   im52 = mrdfits(file,2,/silent)+32768-bias
   im60 = mrdfits(file,3,/silent)+32768-bias
   im54 = mrdfits(file,4,/silent)+32768-bias
   
END

; This function parse the keyword WCGDSEC into an array. 
FUNCTION PARSESEC, wcposx, wcposy
   
   secarr=intarr(4)
   secarr[0]=wcposx
   secarr[1]=wcposx+14
   secarr[2]=wcposy
   secarr[3]=wcposy+14
   
   return,secarr
END

FUNCTION CHECK_GPOS, hdr
	  pos=sxpar(hdr,'WCPOSX1')
	  if pos le -1 then return,0 else return,1

END



; This function will rewrite the image array with flat-field correct number
PRO FLATFIELDING, im77, im52, im54, im60, hdr
   COMMON share,cubepath,calibpath
	loadconfig
	;flatname='/arrays/cfht_2/chyan/WIRCam/calib/domeflat_8302B_20051207_goff_KS_1.fits'
   flatname=calibpath+'domeflat_8302B_20051207_goff_KS_1.fits'
   ;print,total(im52[*,*,0])
   
	flat_im77=readfits(flatname,ext=1,hd77,/silent)
   flat_im52=readfits(flatname,ext=2,hd52,/silent)
   flat_im54=readfits(flatname,ext=3,hd64,/silent)
   flat_im60=readfits(flatname,ext=4,hd60,/silent)
   
   gdsec77=parsesec(sxpar(hdr,'WCPOSX1'),sxpar(hdr,'WCPOSY1'))
   gdsec52=parsesec(sxpar(hdr,'WCPOSX2'),sxpar(hdr,'WCPOSY2'))
   gdsec54=parsesec(sxpar(hdr,'WCPOSX3'),sxpar(hdr,'WCPOSY3'))
   gdsec60=parsesec(sxpar(hdr,'WCPOSX4'),sxpar(hdr,'WCPOSY4'))
   
   flat_gdsec77=flat_im77[gdsec77[0]:gdsec77[1],gdsec77[2]:gdsec77[3]]
   flat_gdsec52=flat_im52[gdsec52[0]:gdsec52[1],gdsec52[2]:gdsec52[3]]
   flat_gdsec54=flat_im54[gdsec54[0]:gdsec54[1],gdsec54[2]:gdsec54[3]]
   flat_gdsec60=flat_im60[gdsec60[0]:gdsec60[1],gdsec60[2]:gdsec60[3]]
   
   ;print,im52[*,*,0]
   for i=0,n_elements(im77[0,0,*])-1 do begin
      im77[*,*,i]=reform(im77[*,*,i])/flat_gdsec77
      im52[*,*,i]=reform(im52[*,*,i])/flat_gdsec52
      im54[*,*,i]=reform(im54[*,*,i])/flat_gdsec54
      im60[*,*,i]=reform(im60[*,*,i])/flat_gdsec60
   endfor
   ;print,flat_gdsec52
   ;print,im52[*,*,0]
   ;print,total(im52[*,*,0])
END

FUNCTION GETAVGFWHM, hdr
   
	fwhm=fltarr(4)
	fwhm[0]=(sxpar(hdr,'WCFWHMX1')+sxpar(hdr,'WCFWHMY1'))/2
	fwhm[1]=(sxpar(hdr,'WCFWHMX2')+sxpar(hdr,'WCFWHMY2'))/2
	fwhm[2]=(sxpar(hdr,'WCFWHMX3')+sxpar(hdr,'WCFWHMY3'))/2
	fwhm[3]=(sxpar(hdr,'WCFWHMX4')+sxpar(hdr,'WCFWHMY4'))/2
   
	if fwhm[0] le 0 or fwhm[0] ge 3.5 then fwhm[0]=2.5
	if fwhm[1] le 0 or fwhm[0] ge 3.5 then fwhm[1]=2.5
	if fwhm[2] le 0 or fwhm[0] ge 3.5 then fwhm[2]=2.5
	if fwhm[3] le 0 or fwhm[0] ge 3.5 then fwhm[3]=2.5
	
	
	return,fwhm
END


FUNCTION GETSKYBACKGROUND, im

	m=min(im)
	if m ge 0 then begin
		b=1
		h=histogram(im,bin=b,min=m)
		x=(findgen(n_elements(h))*b)+m
		
		skb=x[where(h eq max(h))]
		if n_elements(skb) ge 2 then begin
			sky=skb[0]
		endif else begin
			sky=skb
		endelse
	endif else begin
		sky=median(im)
	endelse
	
	return,sky
END



FUNCTION PHOTOMETRY, im, fwhm
   pi=3.14159 
   box=4  ; set integraiotn box
   
   x=7
   y=7 
   
   ; check if the fwhm is larger than 7
   if fwhm gt 5 then fwhm = 5
   
   cntrd, im, x, y, xcen, ycen, fwhm,/silent
   
	xind=where(~finite(xcen),c1)
	yind=where(~finite(ycen),c2)
   
	; if cntrd failed, use find 
	if (c1 eq 1) or (c2 eq 1) then begin
		flux=!values.f_nan
	endif else begin
   
		if xcen gt 4.5 or xcen lt 4.5 then xcen=7.0 
		if ycen gt 4.5 or ycen lt 4.5 then ycen=7.0 
		
		;if abs(xcen) eq !values.f_nan then xcen=7.0
		;if abs(ycen) eq !values.f_nan then ycen=7.0
		
		;print,xcen,ycen
		
		;Integrate flux slightly great than 3*FWHM
		boxsize=ceil(fwhm)
		rad=ceil((2*fwhm)/2)
		star=total(im[ceil(xcen-boxsize):ceil(xcen+boxsize),ceil(ycen-boxsize):ceil(ycen+boxsize)])
		
		;print,star
		
		;Integrate background flux 
		outbox=boxsize+1
		inbox=boxsize+0
		r2=total(im[ceil(xcen-outbox):ceil(xcen+outbox),ceil(ycen-outbox):ceil(ycen+outbox)])
		r1=total(im[ceil(xcen-inbox):ceil(xcen+inbox),ceil(ycen-inbox):ceil(ycen+inbox)])
		;sky=getskybackground(im)*(pi*rad^2)
		
		
		;Calculate the integration area
		npix=n_elements(im[xcen-boxsize:xcen+boxsize,ycen-boxsize:ycen+boxsize])
		npix2=n_elements(im[xcen-outbox:xcen+outbox,ycen-outbox:ycen+outbox])
		npix1=n_elements(im[xcen-inbox:xcen+inbox,ycen-inbox:ycen+inbox])
		
		;Correcting flux based on the ratio of square and circle		
		star=star*(pi*rad^2/npix)
		r2=r2*(pi*(rad+2)^2/npix2)
		r1=r1*(pi*(rad+1)^2/npix1)
		ring=(pi*(rad+2)^2)-(pi*(rad+1)^2)
		
		;sky=(r1-r2)*(npix/(npix2-npix1))
		
		sky=((r2-r1)/ring)*pi*rad^2
		flux=star-sky
		if flux le 0 then flux=!values.f_nan	
	endelse
		;print,star
   return,flux
END

FUNCTION DATAFILTER, data
   
	ncube=(n_elements(data.id))
	
	
	; This filter can filter out all NaN values. These NaN values are mainly
	;  from bad photometry.
	for i=1, 4 do begin
		ind1=where(data.(i) ge 0,count1,complement=inx1)
		
		if count1 gt 0 and count1 ne n_elements(data) then begin   
			newdata=data[ind1].(i)
			newskb=data[ind1].(i+4)
			tid=data[ind1].id
		endif else begin
			newdata=data.(i)
			newskb=data.(i+4)
			tid=data.id
		endelse
		
		if n_elements(newdata) gt 10 then begin
			mad=median(abs(newdata-median(newdata)))
		endif else begin
			mad=-9999999.0
		endelse
		
		if n_elements(newdata) ge 2 then begin
		ind2=where(newdata le median(newdata)+3.0*mad and $
			newdata ge median(newdata)-3.0*mad,count2,complement=inx2)	
		endif else begin
			count2=0
		endelse
		if count2 gt 0 and count2 ne n_elements(newdata) then begin   
			final=newdata[ind2]
			fskb=newskb[ind2]
			fid=tid[ind2]
		endif else begin
			final=newdata
			fskb=newskb
			fid=tid
		endelse

		if i eq 1 then begin
			id1=fid
			d1=final
			skb1=fskb
		endif
		
		if i eq 2 then begin
			id2=fid
			d2=final
			skb2=fskb
		endif
		
		if i eq 3 then begin
			id3=fid
			d3=final
			skb3=fskb
		endif

		if i eq 4 then  begin
			id4=fid
			d4=final
			skb4=fskb
		endif
		
		
	endfor
	
	filter_data={id1:id1,id2:id2,id3:id3,id4:id4,d1:d1,d2:d2,d3:d3,d4:d4,$
		skb1:skb1,skb2:skb2,skb3:skb3,skb4:skb4}
	
	return,filter_data
END

PRO DOANALYSIS, data
	std=stddev(data)
	if std ne 0 then begin
	plot,data,std/sqrt(data/2.9),psym=3,xtitle='Signal', ytitle='S/N ratio'
	endif 
END


PRO GOPHOTO, FILE, DATA
		
   loadgcube,file,im77,im52,im54,im60,hdr
   
	;if check_gpos(hdr) then flatfielding, im77, im52, im54, im60, hdr
   
	ncube=n_elements(im77[0,0,*])
   
   id=indgen(ncube)
	d1=fltarr(ncube)
   d2=fltarr(ncube)
   d3=fltarr(ncube)
   d4=fltarr(ncube)

	skb1=fltarr(ncube)
   skb2=fltarr(ncube)
   skb3=fltarr(ncube)
   skb4=fltarr(ncube)

	  
   fwhm=getavgfwhm(hdr)
   ;print,fwhm
   
   for i=0,ncube-1 do begin     
		d1[i]=photometry(im77[*,*,i],fwhm[0])
		skb1[i]=getskybackground(im77[*,*,i])
		
		d2[i]=photometry(im52[*,*,i],fwhm[1])
		skb2[i]=getskybackground(im52[*,*,i])
		
		d3[i]=photometry(im54[*,*,i],fwhm[2])
		skb3[i]=getskybackground(im54[*,*,i])
		
		d4[i]=photometry(im60[*,*,i],fwhm[3])
		skb4[i]=getskybackground(im60[*,*,i])
   endfor
   
   
	data={id:0,d1:0.0,d2:0.0,d3:0.0,d4:0.0,skb1:0.0,skb2:0.0,skb3:0.0,skb4:0.0} 
	data=replicate(data,ncube)
	
	data.id=id
	data.d1=d1
	data.d2=d2
	data.d3=d3
	data.d4=d4
	
	data.skb1=skb1
	data.skb2=skb2
	data.skb3=skb3
	data.skb4=skb4
	
end



PRO PLOTLIGHTCURVE, DATA, BASENAME
   !p.multi=[0,0,4]
	
	; plot,d1,psym=3
   if data.d1[0] ge 0 and n_elements(data.d1) ge 2 then plot,data.d1,psym=3,title=basename+' #77'	
	if data.d2[0] ge 0 and n_elements(data.d2) ge 2 then plot,data.d2,psym=3,title=basename+' #52'
   if data.d3[0] ge 0 and n_elements(data.d3) ge 2 then plot,data.d3,psym=3,title=basename+' #54'
   if data.d4[0] ge 0 and n_elements(data.d4) ge 2 then plot,data.d4,psym=3,title=basename+' #60'

   
   !p.multi=[0,0,0]
	
	

END

PRO GETSTATS, DATA, STATS
	
	gain=3.8
	
	std1=median(abs(data.d1-median(data.d1)))
	std2=median(abs(data.d2-median(data.d2)))
	std3=median(abs(data.d3-median(data.d3)))
	std4=median(abs(data.d4-median(data.d4)))
	
	mean1=median(data.d1)
	mean2=median(data.d2)
	mean3=median(data.d3)
	mean4=median(data.d4)

	avgskb1=median(data.skb1)
	avgskb2=median(data.skb2)
	avgskb3=median(data.skb3)
	avgskb4=median(data.skb4)
		
	pn1=std1/sqrt(mean1/gain)
	pn2=std2/sqrt(mean2/gain)
	pn3=std3/sqrt(mean3/gain)
	pn4=std4/sqrt(mean4/gain)
	
	sn1=(data.d1-mean1)/std1
	sn2=(data.d2-mean2)/std2
	sn3=(data.d3-mean3)/std3
	sn4=(data.d4-mean4)/std4
	
	histo1=fltarr(12)
	histo2=fltarr(12)
	histo3=fltarr(12)
	histo4=fltarr(12)
	
	; Put histogram into arrays.  The sqeuence is 
	;    1. > -5 sigma
	;    2. -4 - -5 sigma
	;    3. -3 - -4 sigma
	;    4. -2 - -3 sigma
	;    5. -1 - -4 sigma
	;    6.  0 - -1 sigma
	;    7.  1 -  0 sigma
	;    8.  2 -  1 sigma
	;    9.  3 -  2 sigma
	;    10. 4 -  3 sigma
	;    11. 5 -  5 sigma
	;    12.  >   5 sigma
	 
	n=0
	for i=-5,0 do begin
		ind1=where(sn1 le i,count1)
		ind2=where(sn2 le i,count2)
		ind3=where(sn3 le i,count3)
		ind4=where(sn4 le i,count4)
		
		if i eq -5 then begin 
			c1=count1
			c2=count2
			c3=count3
			c4=count4
			
			histo1[n]=count1
			histo2[n]=count2
			histo3[n]=count3
			histo4[n]=count4
			
		endif else begin
			histo1[n]=count1-c1
			histo2[n]=count2-c2
			histo3[n]=count3-c3
			histo4[n]=count4-c4
			
			c1=count1
			c2=count2
			c3=count3
			c4=count4
		endelse
		n=n+1
	endfor
	
	n=n_elements(histo1)-1
	for i=5,0,-1 do begin
		ind1=where(sn1 ge i,count1)
		ind2=where(sn2 ge i,count2)
		ind3=where(sn3 ge i,count3)
		ind4=where(sn4 ge i,count4)
		
		if i eq 5 then begin 
			c1=count1
			c2=count2
			c3=count3
			c4=count4
			
			histo1[n]=count1
			histo2[n]=count2
			histo3[n]=count3
			histo4[n]=count4
		endif else begin
			histo1[n]=count1-c1
			histo2[n]=count2-c2
			histo3[n]=count3-c3
			histo4[n]=count4-c4
			
			c1=count1
			c2=count2
			c3=count3
			c4=count4
		endelse
		
		n=n-1
	endfor
		
	stats={id:indgen(4),mean:[mean1,mean2,mean3,mean4],std:[std1,std2,std3,std4],pn:[pn1,pn2,pn3,pn4],$
		hist:[histo1,histo2,histo3,histo4],avgskb:[avgskb1,avgskb2,avgskb3,avgskb4]} 
	
END

PRO DPSTATS, DATA, STATS
	
	gain=3.8
	
	std1=median(abs(data.d1-median(data.d1)))
	std2=median(abs(data.d2-median(data.d2)))
	std3=median(abs(data.d3-median(data.d3)))
	
	mean1=median(data.d1)
	mean2=median(data.d2)
	mean3=median(data.d3)
	
	pn1=std1/sqrt(mean1/gain)
	pn2=std2/sqrt(mean2/gain)
	pn3=std3/sqrt(mean3/gain)
	
	sn1=(data.d1-mean1)/std1
	sn2=(data.d2-mean2)/std2
	sn3=(data.d3-mean3)/std3
	
	histo1=fltarr(12)
	histo2=fltarr(12)
	histo3=fltarr(12)
	
	n=0
	for i=-5,0 do begin
		ind1=where(sn1 le i,count1)
		ind2=where(sn2 le i,count2)
		ind3=where(sn3 le i,count3)
		
		if i eq -5 then begin 
			c1=count1
			c2=count2
			c3=count3
			
			histo1[n]=count1
			histo2[n]=count2
			histo3[n]=count3
			
		endif else begin
			histo1[n]=count1-c1
			histo2[n]=count2-c2
			histo3[n]=count3-c3
			
			c1=count1
			c2=count2
			c3=count3
		endelse
		n=n+1
	endfor
	
	n=n_elements(histo1)-1
	for i=5,0,-1 do begin
		ind1=where(sn1 ge i,count1)
		ind2=where(sn2 ge i,count2)
		ind3=where(sn3 ge i,count3)
		
		if i eq 5 then begin 
			c1=count1
			c2=count2
			c3=count3
			
			histo1[n]=count1
			histo2[n]=count2
			histo3[n]=count3
		endif else begin
			histo1[n]=count1-c1
			histo2[n]=count2-c2
			histo3[n]=count3-c3
			
			c1=count1
			c2=count2
			c3=count3
		endelse
		
		n=n-1
	endfor
		
	stats={stats,id:indgen(4),mean:[mean1,mean2,mean3],std:[std1,std2,std3],pn:[pn1,pn2,pn3],$
		hist:[histo1,histo2,histo3]} 
	
END

PRO DUMPLCTOFILE, DATA, FILE
	if file_test(file) then spawn,'rm -rf '+file

	n=[n_elements(data.d1),n_elements(data.d2),n_elements(data.d3),n_elements(data.d4)]
	all=max(n)
	
	close,1
	openw,1,file
	for i=0,all-1 do begin
		ind1=where(data.id1 eq i,c1)
		ind2=where(data.id2 eq i,c2)
		ind3=where(data.id3 eq i,c3)
		ind4=where(data.id4 eq i,c4)
		
		d1=!VALUES.F_NAN
		d2=!VALUES.F_NAN
		d3=!VALUES.F_NAN
		d4=!VALUES.F_NAN
		
		skb1=!VALUES.F_NAN
		skb2=!VALUES.F_NAN
		skb3=!VALUES.F_NAN
		skb4=!VALUES.F_NAN
		
		if c1 ne 0 then begin 
			d1=data.d1[ind1]
			skb1=data.skb1[ind1]
		endif
		
		if c2 ne 0 then begin
			d2=data.d2[ind2]
			skb2=data.skb2[ind2]
		endif
		
		if c3 ne 0 then begin
			d3=data.d3[ind3]
			skb3=data.skb3[ind3]
		endif
		
		if c4 ne 0 then begin 
			d4=data.d4[ind4]
			skb4=data.skb4[ind4]
		endif	  
		
		printf,1,i,d1,d2,d3,d4,skb1,skb2,skb3,skb4,$
			format='(i4,2x,f9.3,2x,f9.3,2x,f9.3,2x,f9.3,2x,f9.3,2x,f9.3,2x,f9.3,2x,f9.3)'
	endfor
	close,1
END



; This subroutine is used to loop through all guide cube for light curves.
PRO GOGCUBE
	COMMON share,cubepath,calibpath,datapath,redpath
	loadconfig
	
	
	histofile=datapath+'LightCurve/histofile.txt'
	statsfile=datapath+'LightCurve/stats.txt'
	
	if file_test(histofile) then spawn,'rm -rf '+histofile
	if file_test(statsfile) then spawn,'rm -rf '+statsfile
		
	spawn,'ls '+cubepath+'1*g.fits',result
	
	skiplist =['901677g','901688g','901695g','902088g','902151g','902156g','902388g',$
					'903261g']	
	for i=0,n_elements(result)-1 do begin
	;for i=0,10 do begin	
		print,'processing..',result[i]	
	
		pos=stregex(result[i],'[0-9]*g.fits',length=len)
		path=strmid(result[i],0,pos)
		basename=strmid(result[i], pos, len-5)
		
		id=where(basename eq skiplist,count)
		if count ne 0 then begin
			print, '	Bad guid cube skip...'
			goto,here
		endif
		
		plotpath=datapath+'Plots/'
		lcpath=datapath+'LightCurve/'
                
                if file_test(plotpath) eq 0 then spawn,'mkdir '+plotpath                
                if file_test(lcpath) eq 0 then spawn,'mkdir '+lcpath                


		lcname=lcpath+basename+'.lc'
		psfile=basename+'.ps'
		; first check if there is .lc file exsit then quit this loop
		if file_test(lcname) then goto,here
		
		; check if this guide contains position information for 
		;	do flat field
		flat=0	
		hdr=headfits(result[i])
		if check_gpos(hdr) then flat=1
		
		gophoto,result[i],data
		if n_elements(data) ge 1 then begin
			nlc=datafilter(data)
			dumplctofile,nlc,lcname
			
			getstats,nlc,stats
			
			close,1
			openw,1,statsfile,/append
			printf,1,basename,'77',stats.mean[0],stats.std[0],stats.pn[0],stats.avgskb[0],flat,$
				format='(a7,2x,a2,2x,f9.3,2x,f9.3,2x,f9.3,2x,f12.3,2x,a2)'
			printf,1,basename,'52',stats.mean[1],stats.std[1],stats.pn[1],stats.avgskb[1],flat,$
				format='(a7,2x,a2,2x,f9.3,2x,f9.3,2x,f9.3,2x,f12.3,2x,a2)'
			printf,1,basename,'54',stats.mean[2],stats.std[2],stats.pn[2],stats.avgskb[2],flat,$
				format='(a7,2x,a2,2x,f9.3,2x,f9.3,2x,f9.3,2x,f12.3,2x,a2)'
			printf,1,basename,'60',stats.mean[3],stats.std[3],stats.pn[3],stats.avgskb[3],flat,$
				format='(a7,2x,a2,2x,f9.3,2x,f9.3,2x,f9.3,2x,f12.3,2x,a2)'
			
			close,1
			openw,1,histofile,/append
			printf,1,basename,'77',stats.hist[0],stats.hist[1],stats.hist[2],stats.hist[3],$
				stats.hist[4],stats.hist[5],stats.hist[6],stats.hist[7],$
				stats.hist[8],stats.hist[9],stats.hist[10],stats.hist[11],$
				format='(a7,2x,a2,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4)'
				
			printf,1,basename,'52',stats.hist[12],stats.hist[13],stats.hist[14],stats.hist[15],$
				stats.hist[16],stats.hist[17],stats.hist[18],stats.hist[19],$
				stats.hist[20],stats.hist[21],stats.hist[22],stats.hist[23],$
				format='(a7,2x,a2,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4)'
			
			printf,1,basename,'54',stats.hist[24],stats.hist[25],stats.hist[26],stats.hist[27],$
				stats.hist[28],stats.hist[29],stats.hist[30],stats.hist[31],$
				stats.hist[32],stats.hist[33],stats.hist[34],stats.hist[35],$
				format='(a7,2x,a2,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4)'
			
			printf,1,basename,'60',stats.hist[36],stats.hist[37],stats.hist[38],stats.hist[39],$
				stats.hist[40],stats.hist[41],stats.hist[42],stats.hist[43],$
				stats.hist[44],stats.hist[45],stats.hist[46],stats.hist[47],$
				format='(a7,2x,a2,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4)'
			
			close,1
			
			set_plot,'ps'
			device,filename=plotpath+psfile,$
			/color,xsize=20,ysize=20,xoffset=0,yoffset=2
			plotlightcurve,nlc,basename
			
			device,/close
		endif else begin
			print,'	Data point is less than 1, this is not a good dataset'
			goto,here
		endelse
	; copy image to Reduced
		if (file_test(redpath+result[i])) then begin
			goto,here
		endif else begin 
			spawn,'cp -f '+result[i]+' '+redpath
		endelse
		
		here:wait,0.005
	;spawn,'convert '+plotpath+psfile+' '+plotpath+jpegname
	endfor 	
	set_plot,'x'
	

END


PRO LCSTATS
	COMMON share,cubepath,calibpath,datapath,redpath
	loadconfig

	lcpath=datapath+'LightCurve/'
	
	spawn,'ls '+lcpath+'*.lc',result	
	print,result

END




PRO DODIFPHOTO
	COMMON share,cubepath,calibpath,datapath,redpath
	loadconfig
	
	path=datapath+'LightCurve/'
	
	;result=path+'873145g.lc'
	spawn,'ls '+path+'876*.lc',result
	
	; go through each lightcurve file
	for i=0,n_elements(result)-1 do begin
		pos=stregex(result[i],'[0-9]+.g',length=len)     	
		basename=strmid(result[i], pos, len)
		diffname=path+basename+'.dp'
		
		readcol,result[i],id,d1,d2,d3,d4,format='(i,f,f,f,f)'	
		ind=where(d1 ge 0 and d2 ge 0 and d3 ge 0 and d4 ge 0,count)
		if count eq 0 then goto,next
		nid=id[ind]
		data=[[d1[ind]],[d2[ind]],[d3[ind]],[d4[ind]]]
		
		m=[median(data[*,0]),median(data[*,1]),median(data[*,2]),median(data[*,3])]
		pid=where(m eq max(m),count,complement=xpid)
		
		for j=0,n_elements(data[*,0])-1 do begin
			
			data[j,pid]=data[j,pid]/m[pid]
			base=data[j,pid]
			for k=0,3 do data[j,k]=data[j,k]/base
		endfor
		

		; Out put to file
		if file_test(diffname) then spawn,'rm -rf '+diffname
		close,1
		openw,1,diffname
		for j=0,n_elements(data[*,0])-1 do begin
			printf,1,nid[j],data[j,xpid[0]],data[j,xpid[1]],data[j,xpid[2]],format='(i,f,f,f)'	
		endfor
		close,1
		next:wait,0.05
	endfor
	
END

PRO DODPSTATS
	COMMON share,cubepath,calibpath,datapath,redpath
	loadconfig
	
	path='/arrays/cfht_3/chyan/guidecube/LightCurve/'
	
	path=datapath+'LightCurve/'	
	
	dphisto=datapath+'LightCurve/dp_histofile.txt'
	dpstats=datapath+'LightCurve/dp_stats.txt'
	
	if file_test(dphisto) then spawn,'rm -rf '+dphisto
	if file_test(dpstats) then spawn,'rm -rf '+dpstats
		
	spawn,'ls '+path+'*.dp',result
	

		
	for i=0,n_elements(result)-1 do begin
		pos=stregex(result[i],'[0-9]+.g',length=len)
		path=strmid(result[i],0,pos)
		basename=strmid(result[i], pos, len)

		readcol,result[i],id,d1,d2,d3	
		
		data={d1:[d1],d2:[d2],d3:[d3]}
		
		
		dpstats,data,stats
		
		close,1
		openw,1,dpstats,/append
		printf,1,basename,'77',stats.mean[0],stats.std[0],stats.pn[0],$
			format='(a7,2x,a2,2x,f9.3,2x,f7.3,2x,f7.3,2x,a1)'
		printf,1,basename,'52',stats.mean[1],stats.std[1],stats.pn[1],$
			format='(a7,2x,a2,2x,f9.3,2x,f7.3,2x,f7.3,2x,a1)'
		printf,1,basename,'74',stats.mean[2],stats.std[2],stats.pn[2],$
			format='(a7,2x,a2,2x,f9.3,2x,f7.3,2x,f7.3,2x,a1)'
		
		close,1
		openw,1,dphisto,/append
		printf,1,basename,stats.hist[0],stats.hist[1],stats.hist[2],stats.hist[3],$
			stats.hist[4],stats.hist[5],stats.hist[6],stats.hist[7],$
			stats.hist[8],stats.hist[9],stats.hist[10],stats.hist[11],$
			format='(a7,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4)'
			
		printf,1,basename,stats.hist[12],stats.hist[13],stats.hist[14],stats.hist[15],$
			stats.hist[16],stats.hist[17],stats.hist[18],stats.hist[19],$
			stats.hist[20],stats.hist[21],stats.hist[22],stats.hist[23],$
			format='(a7,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4)'
		
		printf,1,basename,stats.hist[24],stats.hist[25],stats.hist[26],stats.hist[27],$
			stats.hist[28],stats.hist[29],stats.hist[30],stats.hist[31],$
			stats.hist[32],stats.hist[33],stats.hist[34],stats.hist[35],$
			format='(a7,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4)'
		
		
		close,1
		
	endfor 	
	

END


PRO PLOTDATA
	COMMON share,cubepath,calibpath,datapath,redpath
	loadconfig

	statfile=datapath+'LightCurve/stats.txt'
	histofile=datapath+'LightCurve/histofile.txt'	
	
	;dpstat='/arrays/cfht_3/chyan/Gcube/LightCurve/dp_stats.txt'
	;dphisto='/arrays/cfht_3/chyan/Gcube/LightCurve/dp_histofile.txt'	

	readcol,statfile,cube,chip,mean,std,pn,skb,format='(a7,a2,f8.3,f7.3,f7.3,f10.3)'
		
	ind=where(pn ge 1 and skb ge 1)
	
	set_plot,'ps'
	device,filename=datapath+'/Plots/pn_plots.ps',$
		/color,xsize=20,ysize=20,xoffset=0,yoffset=2
	
	plot,skb[ind],pn[ind],psym=3,xtitle='Sky background',ytitle='PN ratio',yrange=[0,50],xrange=[0,100]
	
	plot,mean[ind]/std[ind],pn[ind],psym=3,xtitle='S/N ratio',ytitle='PN ratio',yrange=[0,50]
	device,/close	
	set_plot,'x'

	
	;readcol,dpstat,cube,chip,mean,std,pn,format='(a7,a2,f8.3,f7.3,f7.3)'
	;ind=where(pn ge 1)
	;set_plot,'ps'
	;device,filename='/arrays/cfht_3/chyan/Gcube/Plots/dp_plots.ps',$
	;	/color,xsize=20,ysize=20,xoffset=0,yoffset=2
	
	;plot,mean[ind],std[ind],psym=4,xtitle='Mean flux',ytitle='PN ratio'
	;plot,mean[ind]/std[ind],pn[ind],psym=4,xtitle='S/N ratio',ytitle='PN ratio'
	;device,/close
	set_plot,'x'
	

END


PRO SELECTEVENT
	COMMON share,cubepath,calibpath,datapath,redpath
	loadconfig

	statfile=datapath+'LightCurve/stats.txt'
	histofile=datapath+'LightCurve/histofile.txt'	

	readcol,statfile,cube,chip,mean,std,pn,skb;,format='(a7,a2,f8.3,f7.3,f7.3,f10.3)'
	readcol,histofile,id,cid,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12
	
	ind=where((pn ge 0) and (skb gt 1) and (pn ge 2) and (pn le 2.5),count)
	
	hh1=0
	hh2=0
	hh3=0
	hh4=0
	hh5=0
	hh6=0
	hh7=0
	hh8=0
	hh9=0
	hh10=0
	hh11=0
	hh12=0
	
	for i=0,n_elements(ind)-1 do begin
		idx=where(cube[ind[i]] eq id and chip[ind[i]] eq cid,c)

 		if c ne 0 then begin
 			print,id[idx],cid[idx],h1[idx],h2[idx],h3[idx],h4[idx],h5[idx],h6[idx],h7[idx]$
 				,h8[idx],h9[idx],h10[idx],h11[idx],h12[idx],$
				format='(i8,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4,2x,i4)'
 			hh1=hh1+h1[idx]
 			hh2=hh2+h2[idx]
 			hh3=hh3+h3[idx]
 			hh4=hh4+h4[idx]
 			hh5=hh5+h5[idx]
 			hh6=hh6+h6[idx]
 			hh7=hh7+h7[idx]
 			hh8=hh8+h8[idx]
 			hh9=hh9+h9[idx]
 			hh10=hh10+h10[idx]
 			hh11=hh11+h11[idx]
 			hh12=hh12+h12[idx]
		
		endif
	endfor
	
	h=[hh1,hh2,hh3,hh4,hh5,hh6,hh7,hh8,hh9,hh10,hh11,hh12]
	
	set_plot,'ps'
	device,filename=datapath+'/Plots/selectevent.ps',$
		/color,xsize=20,ysize=20,xoffset=0,yoffset=2

	plot,findgen(n_elements(h))-5.5,h,psym=10
	
	device,/close
;	print,count
END


PRO GCUBE
	;cubepath='/arrays/cfht_3/chyan/Gcube/'
        cubepath='/Users/chyan/idl_script/Projects/KBO/'
	
	;spawn,'ls '+cubepath+'90[0-9]*g.fits',result
	;print,result
	;file='873109g.fits'
	;file='866653g.fits'
	;file='872949g.fits'
	file=cubepath+'1044275g.fits'
	;pos=stregex(file,'900[0-9]*g',length=len)     	

	;for i=0,n_elements(result)-1 do begin
	;	file=result(i)
		pos=stregex(file,'[0-9]*g.fits',length=len)     	
		basename=strmid(file, pos, len)
	
		print,file
	
 		gophoto,file,data
; 		;dumplctofile,datafilter(data),'/arrays/cfht_3/chyan/Gcube/LightCurve/'+basename+'.lc'
 		dumplctofile,datafilter(data),'/Users/chyan/idl_script/Projects/KBO/'+basename+'.lc'
 		plotlightcurve,datafilter(data),basename
; 		print,n

		print,n_elements(data)
 		newdata=datafilter(data)
 		print,n_elements(newdata.d1),stddev(newdata.d1),stddev(newdata.d2),$
 			stddev(newdata.d3),stddev(newdata.d4)
	;endfor
END