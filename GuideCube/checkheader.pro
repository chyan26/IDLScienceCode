

   
PRO CHECKHEADER, guidefile, mainhd, guide
  
  
  a = {guidestar,use:'',id:'', ra:0.0, dec:0.0, mj:0.0, mh:0.0, mk:0.0, t:0.0$
  , Spec:'',theta:0.0} 
  guide=replicate(a,4)
  
  mainhd=headfits(guidefile)


  ; Read the color table for class V main sequence stars
  mstable='~/idl_script/chy_idl/ci_teff_class_5.dat'
  readcol,mstable,s,te,vk,jh,hk,format='(a,f,f,f,f,f)',/silent
  
  for i=0,3 do begin
    wcgduse=sxpar(mainhd,'WCGDUSE'+strcompress(string(i+1),/remove))
    
    if strcmp(wcgduse, 'TRUE',4) then begin
      guide[i].use=wcgduse
      ra=sxpar(mainhd,'WCGDRA'+strcompress(string(i+1),/remove))
      dec=sxpar(mainhd,'WCGDDEC'+strcompress(string(i+1),/remove))
      guide[i].ra =stringra(ra)
      guide[i].dec=stringdec(dec)
      spawn,"scat -c tmc "+strcompress(string(guide[i].ra,format='(F14.9)'),/remove)+$
        " "+strcompress(string(guide[i].dec,format='(F14.9)'),/remove)+$
        " J2000 -r 50 -n 10 -d> /tmp/2mass_idl.dat"
      readcol,'/tmp/2mass_idl.dat',a,ra,dec,mj,mh,mk,d,/silent
      ind=where(d eq min(d) and min(d) le 1.0)
      guide[i].mj=mj[ind]
      guide[i].mh=mh[ind]
      guide[i].mk=mk[ind]
      dhk=mh[ind]-mk[ind]
     
      guide[i].t=interpol(te,hk,dhk)
      ind=where(abs(te-guide[i].t) eq min(abs(te-guide[i].t)))
      guide[i].spec=s[ind]
      ; Calculate the angular size of the star.
      fk=3.942-0.095*(guide[i].mj-guide[i].mk)
      ;print,10^((fk-4.2207+0.1*(guide[i].mk))/(-0.5))
      ;print,10^((0.2787+0.095*(guide[i].mj-guide[i].mk)-0.1*(guide[i].mk))/0.5)
      guide[i].theta=10^((0.2787+0.095*(guide[i].mj-guide[i].mk)-0.1*(guide[i].mk))/0.5)
    endif else begin
      guide[i].use='FALSE'
      guide[i].ra =-999.0
      guide[i].dec=-999.0
      guide[i].mj=-999.0
      guide[i].mh=-999.0
      guide[i].mk=-999.0
      guide[i].t=-999.0    
      guide[i].spec='FALSE'        
    endelse
  endfor
  


END

PRO FILTERPASS,hd,guide, nm, tr
  filterpath='/Users/chyan/idl_script/Projects/GuideCube/'
  wbed=sxpar(hd,'WHEELBDE')
  pos = STREGEX(wbed, '[0-9]+', length=len, /SUBEXPR) 
  file='cfh'+STRMID(wbed, pos, len)+'.dat'
  readcol,filterpath+file,nm,tran,/silent
  percent=tran/100.0
  ;index=[0,n_elements]
   
  a=nm*10.0
  bbflux = planck(a,guide[0].t)  
  flux=double(bbflux*percent)
  
  all=total(flux*0.5)
  tr=flux/all
  
 END


