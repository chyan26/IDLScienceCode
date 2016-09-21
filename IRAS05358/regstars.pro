;  This function is used to register all stars in catalogs based on a given
;     reference catalog.
;
PRO REGSTARS, ref, cat1, cat2, cat3, cat4, final
   
   ; Set the finding limit in the unit of arcsecond   
   dlim=2
   
   rfid=[0.0]
   ra=[0.0]
   dec=[0.0]
   id1=[0.0]
   id2=[0.0]
   id3=[0.0]
   id4=[0.0]
   x=[0.0]
   y=[0.0]
   rfmag=[0.0]
   mag1=[0.0]
   mag2=[0.0]
   mag3=[0.0]
   mag4=[0.0]
   rflux=[0.0]
   
	flux1=[0.0]
   flux2=[0.0]
   flux3=[0.0]
   flux4=[0.0]
   
	rferr=[0.0]
	err1=[0.0]
	err2=[0.0]
	err3=[0.0]
	err4=[0.0]
   
   n=n_elements(ref.id)   

   final={final,id:0,rfid:0,id1:0,id2:0,id3:0,id4:0,$
      x:0.0,y:0.0,ra:0.0,dec:0.0,$
      rfmag:0.0,mag1:0.0,mag2:0.0,mag3:0.0,mag4:0.0,$
      rflux:0.0,flux1:0.0,flux2:0.0,flux3:0.0,flux4:0.0,$
		rferr:0.0,err1:0.0,err2:0.0,err3:0.0,err4:0.0} 
   
   k=0
   for i=0,n-1 do begin
      d1=sqrt((ref[i].ra-cat1.ra)^2+(ref[i].dec-cat1.dec)^2)
      ind1=where(d1 le dlim/3600.0 and d1 eq min(d1), count1)
      
     if count1 gt 0 then begin 
      d2=sqrt((ref[i].ra-cat2.ra)^2+(ref[i].dec-cat2.dec)^2)
      ind2=where(d2 le dlim/3600.0 and d2 eq min(d2), count2)
      if count2 gt 0 then begin
         d3=sqrt((ref[i].ra-cat3.ra)^2+(ref[i].dec-cat3.dec)^2)
         ind3=where(d3 le dlim/3600.0 and d3 eq min(d3), count3)        
         if count3 gt 0 then begin
            d4=sqrt((ref[i].ra-cat4.ra)^2+(ref[i].dec-cat4.dec)^2)
            ind4=where(d4 le dlim/3600.0 and d4 eq min(d4), count4)
            if count4 gt 0 then begin 
               print,i+1,cat1[ind1].id,cat2[ind2].id,cat3[ind3].id,cat4[ind4].id
               if k eq 0 then begin
                  rfid=i+1
                  x=ref[i].x
                  y=ref[i].y
                  ra=ref[i].ra
                  dec=ref[i].dec
                  rfmag=ref[i].mag
                  rflux=ref[i].flux
                  rferr=ref[i].err
						
                  id1=cat1[ind1].id
                  id2=cat2[ind2].id
                  id3=cat3[ind3].id
                  id4=cat4[ind4].id
                  
                  mag1=cat1[ind1].mag
                  mag2=cat2[ind2].mag
                  mag3=cat3[ind3].mag
                  mag4=cat4[ind4].mag
                  
                  flux1=cat1[ind1].flux
                  flux2=cat2[ind2].flux
                  flux3=cat3[ind3].flux
                  flux4=cat4[ind4].flux
                  
						err1=cat1[ind1].err
                  err2=cat2[ind2].err
                  err3=cat3[ind3].err
                  err4=cat4[ind4].err
               endif else begin
                  rfid=[rfid,i+1]
                  x=[x,ref[i].x]
                  y=[y,ref[i].y]
                  ra=[ra,ref[i].ra]
                  dec=[dec,ref[i].dec]
                  rfmag=[rfmag,ref[i].mag]
                  rflux=[rflux,ref[i].flux]
						rferr=[rferr,ref[i].err]
                  
                  id1=[id1,cat1[ind1].id]
                  id2=[id2,cat2[ind2].id]
                  id3=[id3,cat3[ind3].id]
                  id4=[id4,cat4[ind4].id]
                  
                  mag1=[mag1,cat1[ind1].mag]
                  mag2=[mag2,cat2[ind2].mag]
                  mag3=[mag3,cat3[ind3].mag]
                  mag4=[mag4,cat4[ind4].mag]
                  
                  flux1=[flux1,cat1[ind1].flux]
                  flux2=[flux2,cat2[ind2].flux]
                  flux3=[flux3,cat3[ind3].flux]
                  flux4=[flux4,cat4[ind4].flux]
                  
						err1=[err1,cat1[ind1].err]
                  err2=[err2,cat2[ind2].err]
                  err3=[err3,cat3[ind3].err]
                  err4=[err4,cat4[ind4].err]
                 
               endelse
               k=k+1
            endif
         endif 
      endif
     endif
   endfor
      final = replicate(final, k)
      final.id=indgen(k)
      final.rfid=rfid
      final.x=x
      final.y=y
      final.ra=ra
      final.dec=dec
      final.rfmag=rfmag
      final.rflux=rflux
		final.rferr=rferr
      
      final.id1=id1
      final.id2=id2
      final.id3=id3
      final.id4=id4
      
      final.mag1=mag1
      final.mag2=mag2
      final.mag3=mag3
      final.mag4=mag4
      
      final.flux1=flux1
      final.flux2=flux2
      final.flux3=flux3
      final.flux4=flux4

		final.err1=err1
      final.err2=err2
      final.err3=err3
      final.err4=err4
   

END
