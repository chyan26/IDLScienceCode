
; This function is used to remove YSO from list without eye-inspection.
PRO REMOVEYSO, fits=fits,list=list, newfits=newfits

	COMMON share,conf 
	loadconfig
	
	if file_test(fits) eq 0 then begin
		print,'File: '+fits+' is not existed.'
		return
	endif
	

	; Read information in SED produced FITS files
	tab1=mrdfits(fits,1,mhd,/Silent)
	tab2=mrdfits(fits,2,/Silent)

	; Go through all the target in FITS file and mark them as flagged
	;   if it is listed in list
	flag=intarr(n_elements(tab1.source_name))
	
	;print,tab1[0].source_name
	for i=0,n_elements(list)-1 do begin
		ind=where(strmatch(tab1.source_name,list[i]+'*') eq 1,count)
		if count ge 1 then flag[ind]=1
	endfor

	nind=where(flag eq 0)
	
	newtab1=tab1[nind]
   k=0
   
   for i=0,n_elements(newtab1.source_name)-1 do begin
      ind=where(tab2[*].source_id eq newtab1[i].soure_id, count)
      if count ne 0 then begin 
      
         if k eq 0 then begin
            newtab2=tab2[ind]
            k=1      
         endif else begin
            newtab2=[newtab2,tab2[ind]]
         endelse
      endif    
   endfor

	if file_test(newfits) then spawn,'rm -rf '+newfits
	mwrfits,newtab1, newfits,mhd,/Silent
	mwrfits,newtab2,newfits,/Silent

	;print,ss
















end