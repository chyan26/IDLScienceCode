

;PRO WIRCAM12A
   ;COMMON share,conf 
   ;loadconfig


  ;regfile=conf.regpath+'wircamobs2012A-obs.reg'
  regfile='/Volumes/Science/Projects/RCrA/ds9-rcra.reg'



	spawn,'cat '+regfile+' | sed "s/box(//"| sed "s/)..*//" | sed "s/\"//g" |sed "s/,/  /g"> /tmp/obsdata.txt'	
	
	table=read_ascii('/tmp/obsdata.txt',data_start=3)

	raw_ra=float(table.field1[0,*])
	raw_dec=float(table.field1[1,*])
	
	print, raw_ra
	ind=sort(raw_ra)
	ra=raw_ra[ind]
	dec=raw_dec[ind]
	
	for i=0,n_elements(ra)-1 do begin
		dist=60*sqrt(15*((ra[i]-ra))^2+(dec[i]-dec)^2)
		inx=where(dist le 10,count)
		if count gt 1 then print,'this is not identical.'
		pos_string=adstring(ra[i],dec[i],1)
		substr = strsplit(pos_string,' ',/EXTRACT,/REGEX)
		ra_dec=substr[0]+':'+substr[1]+':'+substr[2]+'|'+substr[3]+':'+substr[4]+':'+substr[5]
	
		target='RCrA-'+string(i+1,format='(I02)')+'          |'
		surfix='|2000.0|1    |'
		print,target+ra_dec+surfix
	endfor
END