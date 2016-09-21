PRO TEXTABLE, cat
	COMMON share,imgpath, mappath	
	loadconfig

	hdr=headfits(imgpath+'s233ir_j.fits')
	
	xyad,hdr,cat.x,cat.y,ra,dec
	radec,ra,dec,ihr,imin,xsec,ideg,imn,xsc
	
	;ind=where(cat.mj le 0)
	;cat.mj[ind]=!values.f_nan
	;cat.mjerr[ind]=!values.f_nan
	
	;ind=where(cat.mk le 0)
	;cat.mk[ind]=!values.f_nan
	;cat.mkerr[ind]=!values.f_nan
	
	
	openw,fileunit, imgpath+'table.tex', /get_lun	
	
	;printf,fileunit,'\begin{deluxetable}{rrrrrrrrr}'
	printf,fileunit,'\begin{deluxetable}{rrrrrrrrrrrr}'
   printf,fileunit,'\tabletypesize{\tiny}'

	printf,fileunit,'\tablehead{'
	printf,fileunit,'\colhead{ID} & \colhead{RA} & '+$
		'\colhead{Dec} & \colhead{$J$} & \colhead{$H$} &'+$
		'\colhead{$K$} & \colhead{IRAC 3.6}&'+$
		' \colhead{IRAC 4.5} & \colhead{IRAC 5.8}& \colhead{IRAC 8.0}&'+$
      '\colhead{A$_V$} &\colhead{M$_{\odot}$}}'
	printf,fileunit,'\startdata'
	for i=0, n_elements(ra)-1 do begin
	;for i=0,1 do begin
		radec=adstring(ra[i],dec[i])
      strput,radec,':',3
      strput,radec,':',6
      strput,radec,':',16
      strput,radec,':',19
      strput,radec,' & ',11
		string=strcompress(string(i+1),/remove)+' &'+radec+' & '+$
		strcompress(string(cat.omj[i],format='(f5.2)'),/remove)+'$\pm$'+$
		strcompress(string(cat.mjerr[i],format='(f4.2)'),/remove)+' & '+$
		strcompress(string(cat.omh[i],format='(f5.2)'),/remove)+'$\pm$'+$
		strcompress(string(cat.mherr[i],format='(f4.2)'),/remove)+' & '+$
		strcompress(string(cat.omk[i],format='(f5.2)'),/remove)+'$\pm$'+$
		strcompress(string(cat.mkerr[i],format='(f4.2)'),/remove)+' & '+$
      strcompress(string(cat.i1mag[i],format='(f5.2)'),/remove)+'$\pm$'+$
      strcompress(string(cat.i1magerr[i],format='(f5.2)'),/remove)+' &'+$
      strcompress(string(cat.i2mag[i],format='(f5.2)'),/remove)+'$\pm$'+$
      strcompress(string(cat.i2magerr[i],format='(f5.2)'),/remove)+' &'+$
      strcompress(string(cat.i3mag[i],format='(f5.2)'),/remove)+'$\pm$'+$
      strcompress(string(cat.i3magerr[i],format='(f5.2)'),/remove)+' &'+$
      strcompress(string(cat.i4mag[i],format='(f5.2)'),/remove)+'$\pm$'+$
      strcompress(string(cat.i4magerr[i],format='(f5.2)'),/remove)+' &'+$
      strcompress(string(cat.av[i],format='(f5.2)'),/remove)+' &'+$
      strcompress(string(cat.mass[i],format='(f5.2)'),/remove)+' \\'

      ;print,string
		printf, fileunit, format='(A)', string
	endfor
	printf,fileunit,'\enddata'
	printf,fileunit,'\end{deluxetable}'
	close, fileunit
	free_lun,fileunit
	
	
END