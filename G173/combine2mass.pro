
;PRO COMBINE2MASS, fits=fits, cat, ccat
   ccat=cat.j
   spawn,"rm -rf /tmp/2mass_idl.dat"
   spawn,"find2mass -c 84.857847 35.683841 -r 3 -m 30000 -e b > /tmp/2mass_temp.dat"
   spawn,'cat /tmp/2mass_temp.dat |sed -e "s/|/ /g"|sed -e "s/---/-999.9/g"'+$
      '> /tmp/2mass_aclient.dat'
   ;readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
   ; format='f,f,s,f,f,f,f,f,f,s',/silent
   readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
    format='f10.7,f10.7,a,f,f,f,f,f,f,a',/silent

   hdr=headfits(conf.fitspath+'sg_g173_j.fits')

   xpix=sxpar(hdr,'NAXIS1')
   adxy,hdr,ra,dec,tmcx,tmcy
   getds9region,tmcx,tmcy,conf.regpath+'tmc_cat',color='green'
   for i=0,n_elements(tmcx)-1 do begin
      dist=sqrt((tmcx[i]-ccat.x)^2+(tmcy[i]-ccat.y)^2)
      if min(dist) ge 3 and min(dist) le 0.25*xpix then begin
        print,i,min(dist),' USE 2MASS'
        id=[ccat.id,max(ccat.id)+1]
        x=[ccat.x,tmcx[i]]
        y=[ccat.y,tmcy[i]]
        flux=[ccat.flux,-9999]
        mag=[ccat.mag,mj[i]]
        magerr=[ccat.mag,mjerr[i]]
        a=[ccat.a,-999]
        b=[ccat.b,-999]
        i=[ccat.i,-999]
        e=[ccat.e,-999]
        fwhm=[ccat.fwhm,-999]
        flag=[ccat.flag,-999]
        class=[ccat.class,-999]
        j={id:id,x:x,y:y,flux:flux,mag:mag,$
          magerr:magerr,a:a,b:b,i:i,e:e,$
          fwhm:fwhm,flag:flag,class:class}
      endif
      
   
   endfor


END
