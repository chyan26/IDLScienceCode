; Give the WCS to each file
PRO CORRECTWCS
   COMMON share,config
   loadconfig
   
   spawn,'ls '+config.redpath+'h041103_09[01]*p.fits',list
   
   for i=0,n_elements(list)-1 do begin
      
      file=list[i]
      pos = stregex(file, '[jhk][0-9]+_[0-9]+', length=len)
      cat=config.redpath+STRMID(file, pos, len)+'.cat'
      
      fileid=STRMID(file, pos+8, 4)
      
      ;print,fileid
      hd=headfits(file)
      im=readfits(file,/silent)
      
      readcol,config.rawpath+'obslog_041103',$
      format='(a,a,f,f,f,a,a,a,a,f,f,a,a,f)',$
      frame,object,itime,raoff,decoff,date_utc,time_utc,date_lt,time_lt,jd,epoch,ra,dec,airmass,/silent
      
      ind=where(frame eq fileid,count)
      
      if count eq 1 then begin
         coord=[stringad(ra[ind]),stringad(dec[ind])]
      endif
      sxaddpar,hd,'CTYPE1','RA---TAN'
      sxaddpar,hd,'CTYPE2','DEC---TAN'
      sxaddpar,hd,'CUNIT1','deg'
      sxaddpar,hd,'CUNIT2','deg'
      
      sxaddpar,hd,'CRVAL1',coord[0]*15
      sxaddpar,hd,'CRVAL2',coord[1]
      sxaddpar,hd,'CRPIX1',512
      sxaddpar,hd,'CRPIX2',512
      sxaddpar,hd,'CD1_1',-0.000125
      sxaddpar,hd,'CD1_2',0.000000345244
      sxaddpar,hd,'CD2_1',0.000000476500
      sxaddpar,hd,'CD2_2',0.000125
      
      ind=where(finite(im,/nan),count) 
      if count ne 0 then repnan,im,0
      modfits,file,im,hd
      ;print,frame[ind]
      ;print,stringad(ra[ind])
      ;print,stringad(dec[ind])
      
      spawn,'sex -c '+config.config+'wcs.sex '+file+$
         ' -CATALOG_NAME '+cat+$
         ' -CHECKIMAGE_TYPE NONE'+$
         ' -PARAMETERS_NAME '+config.config+'wcs.param',result
      
      spawn,' imwcs -v -d '+cat+' -n 8 -w -h 200 -c tmc -q irst -j '+string(coord[0]*15)+' '+string(coord[1])+$
         ' '+file,result
      spawn,' mv *pw.fits '+config.redpath
   endfor
END