

PRO ASOC_MIPSCAT, inputcat
   COMMON share,conf
   loadconfig
   
   readcol,conf.catpath+inputcat,$
   format='(i4,a6,a16,f11.8,f11.8,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4)'$
   ,id,sstid,c2did,ra,dec,fj,fjerr,fh,fherr,fk,fkerr,i1,i1err,i2,i2err,i3,i3err,i4,i4err,m1,m1err
   
   hdr=headfits(conf.wircampath+'1633-2410_J_coadd.fits')
   adxy,hdr,ra,dec,x,y

   ; Building the ASSOC file in defferent bands
   ; J band, selecting source without 2MASS dectection
   jind=where(fj le 0, count)
   
   socfile=conf.catpath+'mips_select_J.assoc'
   openw,fileunit, socfile, /get_lun
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[jind[i]]),/remove_all)+' '+$
                    strcompress(string(x[jind[i]]),/remove_all)+' '+$
                    strcompress(string(y[jind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit


   ; H band, selecting source without 2MASS dectection
   hind=where(fh le 0, count)
   
   socfile=conf.catpath+'mips_select_H.assoc'
   openw,fileunit, socfile, /get_lun
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[hind[i]]),/remove_all)+' '+$
                    strcompress(string(x[hind[i]]),/remove_all)+' '+$
                    strcompress(string(y[hind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit


   ; Ks band, selecting source without 2MASS dectection
   kind=where(fk le 0, count)
   
   socfile=conf.catpath+'mips_select_K.assoc'
   openw,fileunit, socfile, /get_lun
   getds9region,ra[kind],dec[kind],file='k.reg',color='red'
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[kind[i]]),/remove_all)+' '+$
                    strcompress(string(x[kind[i]]),/remove_all)+' '+$
                    strcompress(string(y[kind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit
END


PRO ASOC_MIPSCAT_L1689, inputcat
   COMMON share,conf
   loadconfig
   
   readcol,conf.catpath+inputcat,$
   format='(i4,a6,a16,f11.8,f11.8,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4)'$
   ,id,sstid,c2did,ra,dec,fj,fjerr,fh,fherr,fk,fkerr,i1,i1err,i2,i2err,i3,i3err,i4,i4err,m1,m1err
   
   ;hdr=headfits(conf.wircampath+'L1689_remap_J.fits')
   hdr=headfits(conf.wircampath+'L1689_Ks_new.fits')
   adxy,hdr,ra,dec,x,y

   ; Building the ASSOC file in defferent bands
   ; J band, selecting source without 2MASS dectection
   jind=where(fj le 0, count)
   
   socfile=conf.catpath+'L1689_mips_select_J.assoc'
   openw,fileunit, socfile, /get_lun
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[jind[i]]),/remove_all)+' '+$
                    strcompress(string(x[jind[i]]),/remove_all)+' '+$
                    strcompress(string(y[jind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit


   ; H band, selecting source without 2MASS dectection
   hind=where(fh le 0, count)
   
   socfile=conf.catpath+'L1689_mips_select_H.assoc'
   openw,fileunit, socfile, /get_lun
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[hind[i]]),/remove_all)+' '+$
                    strcompress(string(x[hind[i]]),/remove_all)+' '+$
                    strcompress(string(y[hind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit


   ; Ks band, selecting source without 2MASS dectection
   kind=where(fk le 0, count)
   
   socfile=conf.catpath+'L1689_mips_select_K.assoc'
   openw,fileunit, socfile, /get_lun
   getds9region,ra[kind],dec[kind],file='k.reg',color='red'
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[kind[i]]),/remove_all)+' '+$
                    strcompress(string(x[kind[i]]),/remove_all)+' '+$
                    strcompress(string(y[kind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit
END


PRO ASOC_MIPSCAT_L1688, inputcat
   COMMON share,conf
   loadconfig
   
   readcol,conf.catpath+inputcat,$
   format='(i4,a6,a16,f11.8,f11.8,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4)'$
   ,id,sstid,c2did,ra,dec,fj,fjerr,fh,fherr,fk,fkerr,i1,i1err,i2,i2err,i3,i3err,i4,i4err,m1,m1err
   
   hdr=headfits(conf.wircampath+'L1688_Ks_new.fits')
   adxy,hdr,ra,dec,x,y

   ; Building the ASSOC file in defferent bands
   ; J band, selecting source without 2MASS dectection
   jind=where(fj le 0, count)
   socfile=conf.catpath+'L1688_mips_select_J.assoc'
   openw,fileunit, socfile, /get_lun
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[jind[i]]),/remove_all)+' '+$
                    strcompress(string(x[jind[i]]),/remove_all)+' '+$
                    strcompress(string(y[jind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit


   ; H band, selecting source without 2MASS dectection
   hind=where(fh le 0, count)
   
   socfile=conf.catpath+'L1688_mips_select_H.assoc'
   openw,fileunit, socfile, /get_lun
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[hind[i]]),/remove_all)+' '+$
                    strcompress(string(x[hind[i]]),/remove_all)+' '+$
                    strcompress(string(y[hind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit


   ; Ks band, selecting source without 2MASS dectection
   kind=where(fk le 0, count)
   
   socfile=conf.catpath+'L1688_mips_select_K.assoc'
   openw,fileunit, socfile, /get_lun
   getds9region,ra[kind],dec[kind],file='k.reg',color='red'
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[kind[i]]),/remove_all)+' '+$
                    strcompress(string(x[kind[i]]),/remove_all)+' '+$
                    strcompress(string(y[kind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit
END

PRO ASOC_MIPSCAT_L1709, inputcat
   COMMON share,conf
   loadconfig
   
   readcol,conf.catpath+inputcat,$
   format='(i4,a6,a16,f11.8,f11.8,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4)'$
   ,id,sstid,c2did,ra,dec,fj,fjerr,fh,fherr,fk,fkerr,i1,i1err,i2,i2err,i3,i3err,i4,i4err,m1,m1err
   
   hdr=headfits(conf.wircampath+'L1709_Ks_new.fits')
   adxy,hdr,ra,dec,x,y

   ; Building the ASSOC file in defferent bands
   ; J band, selecting source without 2MASS dectection
   jind=where(fj le 0, count)
   socfile=conf.catpath+'L1709_mips_select_J.assoc'
   openw,fileunit, socfile, /get_lun
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[jind[i]]),/remove_all)+' '+$
                    strcompress(string(x[jind[i]]),/remove_all)+' '+$
                    strcompress(string(y[jind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit


   ; H band, selecting source without 2MASS dectection
   hind=where(fh le 0, count)
   
   socfile=conf.catpath+'L1709_mips_select_H.assoc'
   openw,fileunit, socfile, /get_lun
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[hind[i]]),/remove_all)+' '+$
                    strcompress(string(x[hind[i]]),/remove_all)+' '+$
                    strcompress(string(y[hind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit


   ; Ks band, selecting source without 2MASS dectection
   kind=where(fk le 0, count)
   
   socfile=conf.catpath+'L1709_mips_select_K.assoc'
   openw,fileunit, socfile, /get_lun
   getds9region,ra[kind],dec[kind],file='k.reg',color='red'
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[kind[i]]),/remove_all)+' '+$
                    strcompress(string(x[kind[i]]),/remove_all)+' '+$
                    strcompress(string(y[kind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit
END


PRO ASOC_MIPSCAT_L1712, inputcat
   COMMON share,conf
   loadconfig
   
   readcol,conf.catpath+inputcat,$
   format='(i4,a6,a16,f11.8,f11.8,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4)'$
   ,id,sstid,c2did,ra,dec,fj,fjerr,fh,fherr,fk,fkerr,i1,i1err,i2,i2err,i3,i3err,i4,i4err,m1,m1err
   
   hdr=headfits(conf.wircampath+'L1712_Ks_new.fits')
   adxy,hdr,ra,dec,x,y

   ; Building the ASSOC file in defferent bands
   ; J band, selecting source without 2MASS dectection
   jind=where(fj le 0, count)
   socfile=conf.catpath+'L1712_mips_select_J.assoc'
   openw,fileunit, socfile, /get_lun
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[jind[i]]),/remove_all)+' '+$
                    strcompress(string(x[jind[i]]),/remove_all)+' '+$
                    strcompress(string(y[jind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit


   ; H band, selecting source without 2MASS dectection
   hind=where(fh le 0, count)
   
   socfile=conf.catpath+'L1712_mips_select_H.assoc'
   openw,fileunit, socfile, /get_lun
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[hind[i]]),/remove_all)+' '+$
                    strcompress(string(x[hind[i]]),/remove_all)+' '+$
                    strcompress(string(y[hind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit


   ; Ks band, selecting source without 2MASS dectection
   kind=where(fk le 0, count)
   
   socfile=conf.catpath+'L1712_mips_select_K.assoc'
   openw,fileunit, socfile, /get_lun
   getds9region,ra[kind],dec[kind],file='k.reg',color='red'
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[kind[i]]),/remove_all)+' '+$
                    strcompress(string(x[kind[i]]),/remove_all)+' '+$
                    strcompress(string(y[kind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit
END


PRO ASOC_MIPSCAT_RHO_OPH, inputcat
   COMMON share,conf
   loadconfig
   
   readcol,conf.catpath+inputcat,$
   format='(i4,a6,a16,f11.8,f11.8,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4)'$
   ,id,sstid,c2did,ra,dec,fj,fjerr,fh,fherr,fk,fkerr,i1,i1err,i2,i2err,i3,i3err,i4,i4err,m1,m1err
   
   hdr=headfits(conf.wircampath+'rho_oph_Ks_new.fits')
   adxy,hdr,ra,dec,x,y

   ; Building the ASSOC file in defferent bands
   ; J band, selecting source without 2MASS dectection
   jind=where(fj le 0, count)
   socfile=conf.catpath+'rho_oph_mips_select_J.assoc'
   openw,fileunit, socfile, /get_lun
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[jind[i]]),/remove_all)+' '+$
                    strcompress(string(x[jind[i]]),/remove_all)+' '+$
                    strcompress(string(y[jind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit


   ; H band, selecting source without 2MASS dectection
   hind=where(fh le 0, count)
   
   socfile=conf.catpath+'rho_oph_mips_select_H.assoc'
   openw,fileunit, socfile, /get_lun
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[hind[i]]),/remove_all)+' '+$
                    strcompress(string(x[hind[i]]),/remove_all)+' '+$
                    strcompress(string(y[hind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit


   ; Ks band, selecting source without 2MASS dectection
   kind=where(fk le 0, count)
   
   socfile=conf.catpath+'rho_oph_mips_select_K.assoc'
   openw,fileunit, socfile, /get_lun
   getds9region,ra[kind],dec[kind],file='k.reg',color='red'
   for i=0, count-1 do begin
      regstring =   strcompress(string(id[kind[i]]),/remove_all)+' '+$
                    strcompress(string(x[kind[i]]),/remove_all)+' '+$
                    strcompress(string(y[kind[i]]),/remove_all)
      printf, fileunit, format='(A)', regstring              
   endfor 
   
   close, fileunit
   free_lun,fileunit
END


PRO CHECKCLASS
   COMMON share,conf
   loadconfig
   
   readcol,conf.fitspath+'soc_j.sex',n,x,y,f,ferr,m,merr,a,b,t,e,fwhm,flag,class,v
   
   h=histogram(class,bin=0.1,max=1.0,min=0.0)
   xh=getseries(0,1,0.1)
   plot,xh,h,psym=10
END

;
; This function is use to convert c2d catalog to the format of SED fitter
;
PRO C2DTOFITTERCAT,c2dcat=c2dcat,file=file
   COMMON share,conf
   loadconfig
   
   readcol,conf.catpath+c2dcat,$
      format='(i4,a6,a16,f11.8,f11.8,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4)'$
   	,id,sstid,c2did,ra,dec,mj_flux,mj_err,mh_flux,mh_err,mk_flux,mk_err,i1_flux,i1_err,i2_flux,i2_err,i3_flux,i3_err,$
      i4_flux,i4_err,m1_flux,m1_err
   
   hdr=headfits(conf.wircampath+'1633-2410_J_coadd.fits')
   adxy,hdr,ra,dec,xm,ym
   
   mj_valid=intarr(n_elements(m1_flux))
   mh_valid=intarr(n_elements(m1_flux))
   mk_valid=intarr(n_elements(m1_flux))
   i1_valid=intarr(n_elements(m1_flux))
   i2_valid=intarr(n_elements(m1_flux))
   i3_valid=intarr(n_elements(m1_flux))
   i4_valid=intarr(n_elements(m1_flux))
   m1_valid=intarr(n_elements(m1_flux))
	
   mj_valid[*]=1
   mh_valid[*]=1
   mk_valid[*]=1
   i1_valid[*]=1
   i2_valid[*]=1
   i3_valid[*]=1
   i4_valid[*]=1
   m1_valid[*]=1
   
   ; If flux error le 0 then assign it to 10% of flux
   ind=where(mj_err le 0, count)
   if count gt 0 then mj_err[ind]=0.1*mj_flux[ind]
   
   ind=where(mh_err le 0, count)
   if count gt 0 then mh_err[ind]=0.1*mh_flux[ind]
   
   ind=where(mk_err le 0, count)
   if count gt 0 then mk_err[ind]=0.1*mk_flux[ind]
   
   ind=where(mj_flux le 0, count)
   if count gt 0 then mj_valid[ind]=0
   ind=where(mh_flux le 0, count)
   if count gt 0 then mh_valid[ind]=0
   ind=where(mk_flux le 0, count)
   if count gt 0 then mk_valid[ind]=0
   ind=where(i1_flux le 0, count)
   if count gt 0 then i1_valid[ind]=0
   ind=where(i2_flux le 0, count)
   if count gt 0 then i2_valid[ind]=0
   ind=where(i3_flux le 0, count)
   if count gt 0 then i3_valid[ind]=0
   ind=where(i4_flux le 0, count)
   if count gt 0 then i4_valid[ind]=0
   ind=where((m1_flux) le 0 or (m1_flux-m1_err le 0), count)
   if count gt 0 then m1_valid[ind]=0
   ;id=indgen(n_elements(m1))
   
  
   index=where(id ge 0)
   cat={id:id[index],c2did:c2did[index],ra:ra[index],dec:dec[index],$
      mj_flux:mj_flux[index],mh_flux:mh_flux[index],$
      mk_flux:mk_flux[index],i1_flux:i1_flux[index],$
      i2_flux:i2_flux[index],i3_flux:i3_flux[index],$
      i4_flux:i4_flux[index],m1_flux:m1_flux[index],$
      mj_valid:mj_valid[index],mh_valid:mh_valid[index],$
      mk_valid:mk_valid[index],i1_valid:i1_valid[index],$
      i2_valid:i2_valid[index],i3_valid:i3_valid[index],$
      i4_valid:i4_valid[index],m1_valid:m1_valid[index],$
      mj_fluxerr:mj_err[index],mh_fluxerr:mh_err[index],$
      mk_fluxerr:mk_err[index],i1_fluxerr:i1_err[index],$
      i2_fluxerr:i2_err[index],i3_fluxerr:i3_err[index],$
      i4_fluxerr:i4_err[index],m1_fluxerr:m1_err[index]}
   
   if keyword_set(file) then begin
      dumpfile=conf.catpath+file
      close,1
      openw,1,dumpfile
      for i=0,n_elements(cat.id)-1 do begin
      printf,1,format='(A30,2(1X,F9.5),8(1X,I1),16(1X,E11.4))',$
         'SSTc2d '+string(cat.c2did[i]),cat.ra[i],cat.dec[i],$
         cat.mj_valid[i],cat.mh_valid[i],cat.mk_valid[i],cat.i1_valid[i],$
         cat.i2_valid[i],cat.i3_valid[i],cat.i4_valid[i],cat.m1_valid[i],$
         cat.mj_flux[i],cat.mj_fluxerr[i],cat.mh_flux[i],cat.mh_fluxerr[i],$
         cat.mk_flux[i],cat.mk_fluxerr[i],cat.i1_flux[i],cat.i1_fluxerr[i],$
         cat.i2_flux[i],cat.i2_fluxerr[i],cat.i3_flux[i],cat.i3_fluxerr[i],$
         cat.i4_flux[i],cat.i4_fluxerr[i],cat.m1_flux[i],cat.m1_fluxerr[i]
      endfor
      
      
      close,1
   
   endif
   

END


;
;  This function is used to merge Spitzer catalog with WIRCam detection.
;
PRO COMBINECATALOG, cat, targetfits=targetfits, catfile=catfile, file=file, onlyspitzer=onlyspitzer, ZERO=zero
   COMMON share,conf
   loadconfig


    readcol,conf.catpath+catfile,$
      format='(i4,a6,a16,f11.8,f11.8,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4)'$
      ,id,sstid,c2did,ra,dec,mj_flux,mj_err,mh_flux,mh_err,mk_flux,mk_err,i1_flux,i1_err,i2_flux,i2_err,i3_flux,i3_err,$
      i4_flux,i4_err,m1_flux,m1_err
   readcol,conf.catpath+'soc_j.cat',nj,xj,yj,sfj,ferrj,mj,merrj,aj,bj,tj,ej,fwhmj,flagj,classj,vj,nj,/silent
   readcol,conf.catpath+'soc_h.cat',nh,xh,yh,sfh,ferrh,mh,merrh,ah,bh,th,eh,fwhmh,flagh,classh,vh,nh,/silent
   readcol,conf.catpath+'soc_k.cat',nk,xk,yk,sfk,ferrk,mk,merrk,ak,bk,tk,ek,fwhmk,flagk,classk,vk,nk,/silent
   
   
   
   hdr=headfits(conf.wircampath+targetfits)
   adxy,hdr,ra,dec,xm,ym
   
   mj_valid=intarr(n_elements(m1_flux))
   mh_valid=intarr(n_elements(m1_flux))
   mk_valid=intarr(n_elements(m1_flux))
   i1_valid=intarr(n_elements(m1_flux))
   i2_valid=intarr(n_elements(m1_flux))
   i3_valid=intarr(n_elements(m1_flux))
   i4_valid=intarr(n_elements(m1_flux))
   m1_valid=intarr(n_elements(m1_flux))

   
   
   mj_valid[*]=1
   mh_valid[*]=1
   mk_valid[*]=1
   i1_valid[*]=1
   i2_valid[*]=1
   i3_valid[*]=1
   i4_valid[*]=1
   m1_valid[*]=1
   
   if keyword_set(onlyspitzer) then begin
      mj_valid[*]=0
      mh_valid[*]=0
      mk_valid[*]=0
   endif
    
   for i=0,n_elements(m1_flux)-1 do begin
      jind=where(vj eq id[i], count)
      if count eq 1 then begin
         mj_flux[i]=1594000.0/(10^((mj[jind]-zero[0])/2.5))
         meu=1594000.0/(10^((mj[jind]+merrj[jind]-zero[0])/2.5))
         mel=1594000.0/(10^((mj[jind]-merrj[jind]-zero[0])/2.5))
         mj_err[i]=abs(meu-mel)
         mj_valid[i]=1
      endif 
      
      hind=where(vh eq id[i], count)
      if count eq 1 then begin
         mh_flux[i]=1024000.0/(10^((mh[hind]-zero[1])/2.5))
         meu=1024000.0/(10^((mh[hind]+merrh[hind]-zero[1])/2.5))
         mel=1024000.0/(10^((mh[hind]-merrh[hind]-zero[1])/2.5))
         mh_err[i]=abs(meu-mel)
         mh_valid[i]=1
      endif
      
      kind=where(vk eq id[i], count)
      if count eq 1 then begin
         mk_flux[i]=666700.0/(10^((mk[kind]-zero[2])/2.5))
         meu=666700.0/(10^((mk[kind]+merrk[kind]-zero[2])/2.5))
         mel=666700.0/(10^((mk[kind]-merrk[kind]-zero[2])/2.5))
         mk_err[i]=abs(meu-mel)
         mk_valid[i]=1
      endif
   endfor
   
   ; If flux error le 0 then assign it to 10% of flux
   ind=where(mj_err le 0, count)
   if count gt 0 then mj_err[ind]=0.1*mj_flux[ind]
   
   ind=where(mh_err le 0, count)
   if count gt 0 then mh_err[ind]=0.1*mh_flux[ind]
   
   ind=where(mk_err le 0, count)
   if count gt 0 then mk_err[ind]=0.1*mk_flux[ind]
   
   ind=where(mj_flux le 0, count)
   if count gt 0 then mj_valid[ind]=0
   ind=where(mh_flux le 0, count)
   if count gt 0 then mh_valid[ind]=0
   ind=where(mk_flux le 0, count)
   if count gt 0 then mk_valid[ind]=0
   ind=where(i1_flux le 0, count)
   if count gt 0 then i1_valid[ind]=0
   ind=where(i2_flux le 0, count)
   if count gt 0 then i2_valid[ind]=0
   ind=where(i3_flux le 0, count)
   if count gt 0 then i3_valid[ind]=0
   ind=where(i4_flux le 0, count)
   if count gt 0 then i4_valid[ind]=0
   ind=where((m1_flux le 0) or (m1_flux-m1_err le 0), count)
   if count gt 0 then m1_valid[ind]=0
   ;id=indgen(n_elements(m1))
   
   index=where(id ge 0)
   cat={id:id[index],c2did:c2did[index],ra:ra[index],dec:dec[index],$
      mj_flux:mj_flux[index],mh_flux:mh_flux[index],$
      mk_flux:mk_flux[index],i1_flux:i1_flux[index],$
      i2_flux:i2_flux[index],i3_flux:i3_flux[index],$
      i4_flux:i4_flux[index],m1_flux:m1_flux[index],$
      mj_valid:mj_valid[index],mh_valid:mh_valid[index],$
      mk_valid:mk_valid[index],i1_valid:i1_valid[index],$
      i2_valid:i2_valid[index],i3_valid:i3_valid[index],$
      i4_valid:i4_valid[index],m1_valid:m1_valid[index],$
      mj_fluxerr:mj_err[index],mh_fluxerr:mh_err[index],$
      mk_fluxerr:mk_err[index],i1_fluxerr:i1_err[index],$
      i2_fluxerr:i2_err[index],i3_fluxerr:i3_err[index],$
      i4_fluxerr:i4_err[index],m1_fluxerr:m1_err[index]}
  
   if keyword_set(file) then begin
      dumpfile=conf.catpath+file
      close,1
      openw,1,dumpfile
      for i=0,n_elements(cat.id)-1 do begin
      printf,1,format='(A30,2(1X,F9.5),8(1X,I1),16(1X,E11.4))',$
         'SSTc2d '+string(cat.c2did[i]),cat.ra[i],cat.dec[i],$
         cat.mj_valid[i],cat.mh_valid[i],cat.mk_valid[i],cat.i1_valid[i],$
         cat.i2_valid[i],cat.i3_valid[i],cat.i4_valid[i],cat.m1_valid[i],$
         cat.mj_flux[i],cat.mj_fluxerr[i],cat.mh_flux[i],cat.mh_fluxerr[i],$
         cat.mk_flux[i],cat.mk_fluxerr[i],cat.i1_flux[i],cat.i1_fluxerr[i],$
         cat.i2_flux[i],cat.i2_fluxerr[i],cat.i3_flux[i],cat.i3_fluxerr[i],$
         cat.i4_flux[i],cat.i4_fluxerr[i],cat.m1_flux[i],cat.m1_fluxerr[i]
      endfor
      
      
      close,1
   
   endif
   
   
END
;
;  This function is used to merge Spitzer catalog with WIRCam detection.
;
PRO COMBINECATALOG_L1689, cat, catfile=catfile, file=file, onlyspitzer=onlyspitzer, ZERO=zero
   COMMON share,conf
   loadconfig


    readcol,conf.catpath+catfile,$
      format='(i4,a6,a16,f11.8,f11.8,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4)'$
      ,id,sstid,c2did,ra,dec,mj_flux,mj_err,mh_flux,mh_err,mk_flux,mk_err,i1_flux,i1_err,i2_flux,i2_err,i3_flux,i3_err,$
      i4_flux,i4_err,m1_flux,m1_err
   readcol,conf.catpath+'L1689_J_new_soc.cat',nj,xj,yj,sfj,ferrj,mj,merrj,aj,bj,tj,ej,fwhmj,flagj,classj,vj,nj,/silent
   readcol,conf.catpath+'L1689_H_new_soc.cat',nh,xh,yh,sfh,ferrh,mh,merrh,ah,bh,th,eh,fwhmh,flagh,classh,vh,nh,/silent
   readcol,conf.catpath+'L1689_Ks_new_soc.cat',nk,xk,yk,sfk,ferrk,mk,merrk,ak,bk,tk,ek,fwhmk,flagk,classk,vk,nk,/silent
   
   hdr=headfits(conf.wircampath+'L1689_Ks_new.fits')
   adxy,hdr,ra,dec,xm,ym
   
   mj_valid=intarr(n_elements(m1_flux))
   mh_valid=intarr(n_elements(m1_flux))
   mk_valid=intarr(n_elements(m1_flux))
   i1_valid=intarr(n_elements(m1_flux))
   i2_valid=intarr(n_elements(m1_flux))
   i3_valid=intarr(n_elements(m1_flux))
   i4_valid=intarr(n_elements(m1_flux))
   m1_valid=intarr(n_elements(m1_flux))

   
   
   mj_valid[*]=1
   mh_valid[*]=1
   mk_valid[*]=1
   i1_valid[*]=1
   i2_valid[*]=1
   i3_valid[*]=1
   i4_valid[*]=1
   m1_valid[*]=1
   
   if keyword_set(onlyspitzer) then begin
      mj_valid[*]=0
      mh_valid[*]=0
      mk_valid[*]=0
   endif
    
   for i=0,n_elements(m1_flux)-1 do begin
      jind=where(vj eq id[i], count)
      if count eq 1 then begin
         mj_flux[i]=1594000.0/(10^((mj[jind]-zero[0])/2.5))
         meu=1594000.0/(10^((mj[jind]+merrj[jind]-zero[0])/2.5))
         mel=1594000.0/(10^((mj[jind]-merrj[jind]-zero[0])/2.5))
         mj_err[i]=abs(meu-mel)
         mj_valid[i]=1
      endif 
      
      hind=where(vh eq id[i], count)
      if count eq 1 then begin
         mh_flux[i]=1024000.0/(10^((mh[hind]-zero[1])/2.5))
         meu=1024000.0/(10^((mh[hind]+merrh[hind]-zero[1])/2.5))
         mel=1024000.0/(10^((mh[hind]-merrh[hind]-zero[1])/2.5))
         mh_err[i]=abs(meu-mel)
         mh_valid[i]=1
      endif
      
      kind=where(vk eq id[i], count)
      if count eq 1 then begin
         mk_flux[i]=666700.0/(10^((mk[kind]-zero[2])/2.5))
         meu=666700.0/(10^((mk[kind]+merrk[kind]-zero[2])/2.5))
         mel=666700.0/(10^((mk[kind]-merrk[kind]-zero[2])/2.5))
         mk_err[i]=abs(meu-mel)
         mk_valid[i]=1
      endif
   endfor
   
   ; If flux error le 0 then assign it to 10% of flux
   ind=where(mj_err le 0, count)
   if count gt 0 then mj_err[ind]=0.1*mj_flux[ind]
   
   ind=where(mh_err le 0, count)
   if count gt 0 then mh_err[ind]=0.1*mh_flux[ind]
   
   ind=where(mk_err le 0, count)
   if count gt 0 then mk_err[ind]=0.1*mk_flux[ind]
   
   ind=where(mj_flux le 0, count)
   if count gt 0 then mj_valid[ind]=0
   ind=where(mh_flux le 0, count)
   if count gt 0 then mh_valid[ind]=0
   ind=where(mk_flux le 0, count)
   if count gt 0 then mk_valid[ind]=0
   ind=where(i1_flux le 0, count)
   if count gt 0 then i1_valid[ind]=0
   ind=where(i2_flux le 0, count)
   if count gt 0 then i2_valid[ind]=0
   ind=where(i3_flux le 0, count)
   if count gt 0 then i3_valid[ind]=0
   ind=where(i4_flux le 0, count)
   if count gt 0 then i4_valid[ind]=0
   ind=where((m1_flux le 0) or (m1_flux-m1_err le 0), count)
   if count gt 0 then m1_valid[ind]=0
   ;id=indgen(n_elements(m1))
   
   index=where(id ge 0)
   cat={id:id[index],c2did:c2did[index],ra:ra[index],dec:dec[index],$
      mj_flux:mj_flux[index],mh_flux:mh_flux[index],$
      mk_flux:mk_flux[index],i1_flux:i1_flux[index],$
      i2_flux:i2_flux[index],i3_flux:i3_flux[index],$
      i4_flux:i4_flux[index],m1_flux:m1_flux[index],$
      mj_valid:mj_valid[index],mh_valid:mh_valid[index],$
      mk_valid:mk_valid[index],i1_valid:i1_valid[index],$
      i2_valid:i2_valid[index],i3_valid:i3_valid[index],$
      i4_valid:i4_valid[index],m1_valid:m1_valid[index],$
      mj_fluxerr:mj_err[index],mh_fluxerr:mh_err[index],$
      mk_fluxerr:mk_err[index],i1_fluxerr:i1_err[index],$
      i2_fluxerr:i2_err[index],i3_fluxerr:i3_err[index],$
      i4_fluxerr:i4_err[index],m1_fluxerr:m1_err[index]}
  
   if keyword_set(file) then begin
      dumpfile=conf.catpath+file
      close,1
      openw,1,dumpfile
      for i=0,n_elements(cat.id)-1 do begin
      printf,1,format='(A30,2(1X,F9.5),8(1X,I1),16(1X,E11.4))',$
         'SSTc2d '+string(cat.c2did[i]),cat.ra[i],cat.dec[i],$
         cat.mj_valid[i],cat.mh_valid[i],cat.mk_valid[i],cat.i1_valid[i],$
         cat.i2_valid[i],cat.i3_valid[i],cat.i4_valid[i],cat.m1_valid[i],$
         cat.mj_flux[i],cat.mj_fluxerr[i],cat.mh_flux[i],cat.mh_fluxerr[i],$
         cat.mk_flux[i],cat.mk_fluxerr[i],cat.i1_flux[i],cat.i1_fluxerr[i],$
         cat.i2_flux[i],cat.i2_fluxerr[i],cat.i3_flux[i],cat.i3_fluxerr[i],$
         cat.i4_flux[i],cat.i4_fluxerr[i],cat.m1_flux[i],cat.m1_fluxerr[i]
      endfor
      
      
      close,1
   
   endif
   
   
END



PRO COMBINECATALOG_L1688, cat, catfile=catfile, file=file, onlyspitzer=onlyspitzer, ZERO=zero
   COMMON share,conf
   loadconfig


    readcol,conf.catpath+catfile,$
      format='(i4,a6,a16,f11.8,f11.8,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4)'$
      ,id,sstid,c2did,ra,dec,mj_flux,mj_err,mh_flux,mh_err,mk_flux,mk_err,i1_flux,i1_err,i2_flux,i2_err,i3_flux,i3_err,$
      i4_flux,i4_err,m1_flux,m1_err
   readcol,conf.catpath+'L1688_J_new_soc.cat',nj,xj,yj,sfj,ferrj,mj,merrj,aj,bj,tj,ej,fwhmj,flagj,classj,vj,nj,/silent
   readcol,conf.catpath+'L1688_H_new_soc.cat',nh,xh,yh,sfh,ferrh,mh,merrh,ah,bh,th,eh,fwhmh,flagh,classh,vh,nh,/silent
   readcol,conf.catpath+'L1688_Ks_new_soc.cat',nk,xk,yk,sfk,ferrk,mk,merrk,ak,bk,tk,ek,fwhmk,flagk,classk,vk,nk,/silent
   
   hdr=headfits(conf.wircampath+'L1688_Ks_new.fits')
   adxy,hdr,ra,dec,xm,ym
   
   mj_valid=intarr(n_elements(m1_flux))
   mh_valid=intarr(n_elements(m1_flux))
   mk_valid=intarr(n_elements(m1_flux))
   i1_valid=intarr(n_elements(m1_flux))
   i2_valid=intarr(n_elements(m1_flux))
   i3_valid=intarr(n_elements(m1_flux))
   i4_valid=intarr(n_elements(m1_flux))
   m1_valid=intarr(n_elements(m1_flux))

   
   
   mj_valid[*]=1
   mh_valid[*]=1
   mk_valid[*]=1
   i1_valid[*]=1
   i2_valid[*]=1
   i3_valid[*]=1
   i4_valid[*]=1
   m1_valid[*]=1
   
   if keyword_set(onlyspitzer) then begin
      mj_valid[*]=0
      mh_valid[*]=0
      mk_valid[*]=0
   endif
    
   for i=0,n_elements(m1_flux)-1 do begin
      jind=where(vj eq id[i], count)
      if count eq 1 then begin
         mj_flux[i]=1594000.0/(10^((mj[jind]-zero[0])/2.5))
         meu=1594000.0/(10^((mj[jind]+merrj[jind]-zero[0])/2.5))
         mel=1594000.0/(10^((mj[jind]-merrj[jind]-zero[0])/2.5))
         mj_err[i]=abs(meu-mel)
         mj_valid[i]=1
      endif 
      
      hind=where(vh eq id[i], count)
      if count eq 1 then begin
         mh_flux[i]=1024000.0/(10^((mh[hind]-zero[1])/2.5))
         meu=1024000.0/(10^((mh[hind]+merrh[hind]-zero[1])/2.5))
         mel=1024000.0/(10^((mh[hind]-merrh[hind]-zero[1])/2.5))
         mh_err[i]=abs(meu-mel)
         mh_valid[i]=1
      endif
      
      kind=where(vk eq id[i], count)
      if count eq 1 then begin
         mk_flux[i]=666700.0/(10^((mk[kind]-zero[2])/2.5))
         meu=666700.0/(10^((mk[kind]+merrk[kind]-zero[2])/2.5))
         mel=666700.0/(10^((mk[kind]-merrk[kind]-zero[2])/2.5))
         mk_err[i]=abs(meu-mel)
         mk_valid[i]=1
      endif
   endfor
   
   ; If flux error le 0 then assign it to 10% of flux
   ind=where(mj_err le 0, count)
   if count gt 0 then mj_err[ind]=0.1*mj_flux[ind]
   
   ind=where(mh_err le 0, count)
   if count gt 0 then mh_err[ind]=0.1*mh_flux[ind]
   
   ind=where(mk_err le 0, count)
   if count gt 0 then mk_err[ind]=0.1*mk_flux[ind]
   
   ind=where(mj_flux le 0, count)
   if count gt 0 then mj_valid[ind]=0
   ind=where(mh_flux le 0, count)
   if count gt 0 then mh_valid[ind]=0
   ind=where(mk_flux le 0, count)
   if count gt 0 then mk_valid[ind]=0
   ind=where(i1_flux le 0, count)
   if count gt 0 then i1_valid[ind]=0
   ind=where(i2_flux le 0, count)
   if count gt 0 then i2_valid[ind]=0
   ind=where(i3_flux le 0, count)
   if count gt 0 then i3_valid[ind]=0
   ind=where(i4_flux le 0, count)
   if count gt 0 then i4_valid[ind]=0
   ind=where((m1_flux le 0) or (m1_flux-m1_err le 0), count)
   if count gt 0 then m1_valid[ind]=0
   ;id=indgen(n_elements(m1))
   
   index=where(id ge 0)
   cat={id:id[index],c2did:c2did[index],ra:ra[index],dec:dec[index],$
      mj_flux:mj_flux[index],mh_flux:mh_flux[index],$
      mk_flux:mk_flux[index],i1_flux:i1_flux[index],$
      i2_flux:i2_flux[index],i3_flux:i3_flux[index],$
      i4_flux:i4_flux[index],m1_flux:m1_flux[index],$
      mj_valid:mj_valid[index],mh_valid:mh_valid[index],$
      mk_valid:mk_valid[index],i1_valid:i1_valid[index],$
      i2_valid:i2_valid[index],i3_valid:i3_valid[index],$
      i4_valid:i4_valid[index],m1_valid:m1_valid[index],$
      mj_fluxerr:mj_err[index],mh_fluxerr:mh_err[index],$
      mk_fluxerr:mk_err[index],i1_fluxerr:i1_err[index],$
      i2_fluxerr:i2_err[index],i3_fluxerr:i3_err[index],$
      i4_fluxerr:i4_err[index],m1_fluxerr:m1_err[index]}
  
   if keyword_set(file) then begin
      dumpfile=conf.catpath+file
      close,1
      openw,1,dumpfile
      for i=0,n_elements(cat.id)-1 do begin
      printf,1,format='(A30,2(1X,F9.5),8(1X,I1),16(1X,E11.4))',$
         'SSTc2d '+string(cat.c2did[i]),cat.ra[i],cat.dec[i],$
         cat.mj_valid[i],cat.mh_valid[i],cat.mk_valid[i],cat.i1_valid[i],$
         cat.i2_valid[i],cat.i3_valid[i],cat.i4_valid[i],cat.m1_valid[i],$
         cat.mj_flux[i],cat.mj_fluxerr[i],cat.mh_flux[i],cat.mh_fluxerr[i],$
         cat.mk_flux[i],cat.mk_fluxerr[i],cat.i1_flux[i],cat.i1_fluxerr[i],$
         cat.i2_flux[i],cat.i2_fluxerr[i],cat.i3_flux[i],cat.i3_fluxerr[i],$
         cat.i4_flux[i],cat.i4_fluxerr[i],cat.m1_flux[i],cat.m1_fluxerr[i]
      endfor
      
      
      close,1
   
   endif
   
   
END


PRO COMBINECATALOG_L1709, cat, catfile=catfile, file=file, onlyspitzer=onlyspitzer, ZERO=zero
   COMMON share,conf
   loadconfig


    readcol,conf.catpath+catfile,$
      format='(i4,a6,a16,f11.8,f11.8,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4)'$
      ,id,sstid,c2did,ra,dec,mj_flux,mj_err,mh_flux,mh_err,mk_flux,mk_err,i1_flux,i1_err,i2_flux,i2_err,i3_flux,i3_err,$
      i4_flux,i4_err,m1_flux,m1_err
   readcol,conf.catpath+'L1709_J_new_soc.cat',nj,xj,yj,sfj,ferrj,mj,merrj,aj,bj,tj,ej,fwhmj,flagj,classj,vj,nj,/silent
   readcol,conf.catpath+'L1709_H_new_soc.cat',nh,xh,yh,sfh,ferrh,mh,merrh,ah,bh,th,eh,fwhmh,flagh,classh,vh,nh,/silent
   readcol,conf.catpath+'L1709_Ks_new_soc.cat',nk,xk,yk,sfk,ferrk,mk,merrk,ak,bk,tk,ek,fwhmk,flagk,classk,vk,nk,/silent
   
   hdr=headfits(conf.wircampath+'L1709_Ks_new.fits')
   adxy,hdr,ra,dec,xm,ym
   
   mj_valid=intarr(n_elements(m1_flux))
   mh_valid=intarr(n_elements(m1_flux))
   mk_valid=intarr(n_elements(m1_flux))
   i1_valid=intarr(n_elements(m1_flux))
   i2_valid=intarr(n_elements(m1_flux))
   i3_valid=intarr(n_elements(m1_flux))
   i4_valid=intarr(n_elements(m1_flux))
   m1_valid=intarr(n_elements(m1_flux))

   
   
   mj_valid[*]=1
   mh_valid[*]=1
   mk_valid[*]=1
   i1_valid[*]=1
   i2_valid[*]=1
   i3_valid[*]=1
   i4_valid[*]=1
   m1_valid[*]=1
   
   if keyword_set(onlyspitzer) then begin
      mj_valid[*]=0
      mh_valid[*]=0
      mk_valid[*]=0
   endif
    
   for i=0,n_elements(m1_flux)-1 do begin
      jind=where(vj eq id[i], count)
      if count eq 1 then begin
         mj_flux[i]=1594000.0/(10^((mj[jind]-zero[0])/2.5))
         meu=1594000.0/(10^((mj[jind]+merrj[jind]-zero[0])/2.5))
         mel=1594000.0/(10^((mj[jind]-merrj[jind]-zero[0])/2.5))
         mj_err[i]=abs(meu-mel)
         mj_valid[i]=1
      endif 
      
      hind=where(vh eq id[i], count)
      if count eq 1 then begin
         mh_flux[i]=1024000.0/(10^((mh[hind]-zero[1])/2.5))
         meu=1024000.0/(10^((mh[hind]+merrh[hind]-zero[1])/2.5))
         mel=1024000.0/(10^((mh[hind]-merrh[hind]-zero[1])/2.5))
         mh_err[i]=abs(meu-mel)
         mh_valid[i]=1
      endif
      
      kind=where(vk eq id[i], count)
      if count eq 1 then begin
         mk_flux[i]=666700.0/(10^((mk[kind]-zero[2])/2.5))
         meu=666700.0/(10^((mk[kind]+merrk[kind]-zero[2])/2.5))
         mel=666700.0/(10^((mk[kind]-merrk[kind]-zero[2])/2.5))
         mk_err[i]=abs(meu-mel)
         mk_valid[i]=1
      endif
   endfor
   
   ; If flux error le 0 then assign it to 10% of flux
   ind=where(mj_err le 0, count)
   if count gt 0 then mj_err[ind]=0.1*mj_flux[ind]
   
   ind=where(mh_err le 0, count)
   if count gt 0 then mh_err[ind]=0.1*mh_flux[ind]
   
   ind=where(mk_err le 0, count)
   if count gt 0 then mk_err[ind]=0.1*mk_flux[ind]
   
   ind=where(mj_flux le 0, count)
   if count gt 0 then mj_valid[ind]=0
   ind=where(mh_flux le 0, count)
   if count gt 0 then mh_valid[ind]=0
   ind=where(mk_flux le 0, count)
   if count gt 0 then mk_valid[ind]=0
   ind=where(i1_flux le 0, count)
   if count gt 0 then i1_valid[ind]=0
   ind=where(i2_flux le 0, count)
   if count gt 0 then i2_valid[ind]=0
   ind=where(i3_flux le 0, count)
   if count gt 0 then i3_valid[ind]=0
   ind=where(i4_flux le 0, count)
   if count gt 0 then i4_valid[ind]=0
   ind=where((m1_flux le 0) or (m1_flux-m1_err le 0), count)
   if count gt 0 then m1_valid[ind]=0
   ;id=indgen(n_elements(m1))
   
   index=where(id ge 0)
   cat={id:id[index],c2did:c2did[index],ra:ra[index],dec:dec[index],$
      mj_flux:mj_flux[index],mh_flux:mh_flux[index],$
      mk_flux:mk_flux[index],i1_flux:i1_flux[index],$
      i2_flux:i2_flux[index],i3_flux:i3_flux[index],$
      i4_flux:i4_flux[index],m1_flux:m1_flux[index],$
      mj_valid:mj_valid[index],mh_valid:mh_valid[index],$
      mk_valid:mk_valid[index],i1_valid:i1_valid[index],$
      i2_valid:i2_valid[index],i3_valid:i3_valid[index],$
      i4_valid:i4_valid[index],m1_valid:m1_valid[index],$
      mj_fluxerr:mj_err[index],mh_fluxerr:mh_err[index],$
      mk_fluxerr:mk_err[index],i1_fluxerr:i1_err[index],$
      i2_fluxerr:i2_err[index],i3_fluxerr:i3_err[index],$
      i4_fluxerr:i4_err[index],m1_fluxerr:m1_err[index]}
  
   if keyword_set(file) then begin
      dumpfile=conf.catpath+file
      close,1
      openw,1,dumpfile
      for i=0,n_elements(cat.id)-1 do begin
      printf,1,format='(A30,2(1X,F9.5),8(1X,I1),16(1X,E11.4))',$
         'SSTc2d '+string(cat.c2did[i]),cat.ra[i],cat.dec[i],$
         cat.mj_valid[i],cat.mh_valid[i],cat.mk_valid[i],cat.i1_valid[i],$
         cat.i2_valid[i],cat.i3_valid[i],cat.i4_valid[i],cat.m1_valid[i],$
         cat.mj_flux[i],cat.mj_fluxerr[i],cat.mh_flux[i],cat.mh_fluxerr[i],$
         cat.mk_flux[i],cat.mk_fluxerr[i],cat.i1_flux[i],cat.i1_fluxerr[i],$
         cat.i2_flux[i],cat.i2_fluxerr[i],cat.i3_flux[i],cat.i3_fluxerr[i],$
         cat.i4_flux[i],cat.i4_fluxerr[i],cat.m1_flux[i],cat.m1_fluxerr[i]
      endfor
      
      
      close,1
   
   endif
   
   
END


PRO COMBINECATALOG_L1712, cat, catfile=catfile, file=file, onlyspitzer=onlyspitzer, ZERO=zero
   COMMON share,conf
   loadconfig


    readcol,conf.catpath+catfile,$
      format='(i4,a6,a16,f11.8,f11.8,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4)'$
      ,id,sstid,c2did,ra,dec,mj_flux,mj_err,mh_flux,mh_err,mk_flux,mk_err,i1_flux,i1_err,i2_flux,i2_err,i3_flux,i3_err,$
      i4_flux,i4_err,m1_flux,m1_err
   readcol,conf.catpath+'L1712_J_new_soc.cat',nj,xj,yj,sfj,ferrj,mj,merrj,aj,bj,tj,ej,fwhmj,flagj,classj,vj,nj,/silent
   readcol,conf.catpath+'L1712_H_new_soc.cat',nh,xh,yh,sfh,ferrh,mh,merrh,ah,bh,th,eh,fwhmh,flagh,classh,vh,nh,/silent
   readcol,conf.catpath+'L1712_Ks_new_soc.cat',nk,xk,yk,sfk,ferrk,mk,merrk,ak,bk,tk,ek,fwhmk,flagk,classk,vk,nk,/silent
   
   hdr=headfits(conf.wircampath+'L1712_Ks_new.fits')
   adxy,hdr,ra,dec,xm,ym
   
   mj_valid=intarr(n_elements(m1_flux))
   mh_valid=intarr(n_elements(m1_flux))
   mk_valid=intarr(n_elements(m1_flux))
   i1_valid=intarr(n_elements(m1_flux))
   i2_valid=intarr(n_elements(m1_flux))
   i3_valid=intarr(n_elements(m1_flux))
   i4_valid=intarr(n_elements(m1_flux))
   m1_valid=intarr(n_elements(m1_flux))

   
   
   mj_valid[*]=1
   mh_valid[*]=1
   mk_valid[*]=1
   i1_valid[*]=1
   i2_valid[*]=1
   i3_valid[*]=1
   i4_valid[*]=1
   m1_valid[*]=1
   
   if keyword_set(onlyspitzer) then begin
      mj_valid[*]=0
      mh_valid[*]=0
      mk_valid[*]=0
   endif
    
   for i=0,n_elements(m1_flux)-1 do begin
      jind=where(vj eq id[i], count)
      if count eq 1 then begin
         mj_flux[i]=1594000.0/(10^((mj[jind]-zero[0])/2.5))
         meu=1594000.0/(10^((mj[jind]+merrj[jind]-zero[0])/2.5))
         mel=1594000.0/(10^((mj[jind]-merrj[jind]-zero[0])/2.5))
         mj_err[i]=abs(meu-mel)
         mj_valid[i]=1
      endif 
      
      hind=where(vh eq id[i], count)
      if count eq 1 then begin
         mh_flux[i]=1024000.0/(10^((mh[hind]-zero[1])/2.5))
         meu=1024000.0/(10^((mh[hind]+merrh[hind]-zero[1])/2.5))
         mel=1024000.0/(10^((mh[hind]-merrh[hind]-zero[1])/2.5))
         mh_err[i]=abs(meu-mel)
         mh_valid[i]=1
      endif
      
      kind=where(vk eq id[i], count)
      if count eq 1 then begin
         mk_flux[i]=666700.0/(10^((mk[kind]-zero[2])/2.5))
         meu=666700.0/(10^((mk[kind]+merrk[kind]-zero[2])/2.5))
         mel=666700.0/(10^((mk[kind]-merrk[kind]-zero[2])/2.5))
         mk_err[i]=abs(meu-mel)
         mk_valid[i]=1
      endif
   endfor
   
   ; If flux error le 0 then assign it to 10% of flux
   ind=where(mj_err le 0, count)
   if count gt 0 then mj_err[ind]=0.1*mj_flux[ind]
   
   ind=where(mh_err le 0, count)
   if count gt 0 then mh_err[ind]=0.1*mh_flux[ind]
   
   ind=where(mk_err le 0, count)
   if count gt 0 then mk_err[ind]=0.1*mk_flux[ind]
   
   ind=where(mj_flux le 0, count)
   if count gt 0 then mj_valid[ind]=0
   ind=where(mh_flux le 0, count)
   if count gt 0 then mh_valid[ind]=0
   ind=where(mk_flux le 0, count)
   if count gt 0 then mk_valid[ind]=0
   ind=where(i1_flux le 0, count)
   if count gt 0 then i1_valid[ind]=0
   ind=where(i2_flux le 0, count)
   if count gt 0 then i2_valid[ind]=0
   ind=where(i3_flux le 0, count)
   if count gt 0 then i3_valid[ind]=0
   ind=where(i4_flux le 0, count)
   if count gt 0 then i4_valid[ind]=0
   ind=where((m1_flux le 0) or (m1_flux-m1_err le 0), count)
   if count gt 0 then m1_valid[ind]=0
   ;id=indgen(n_elements(m1))
   
   index=where(id ge 0)
   cat={id:id[index],c2did:c2did[index],ra:ra[index],dec:dec[index],$
      mj_flux:mj_flux[index],mh_flux:mh_flux[index],$
      mk_flux:mk_flux[index],i1_flux:i1_flux[index],$
      i2_flux:i2_flux[index],i3_flux:i3_flux[index],$
      i4_flux:i4_flux[index],m1_flux:m1_flux[index],$
      mj_valid:mj_valid[index],mh_valid:mh_valid[index],$
      mk_valid:mk_valid[index],i1_valid:i1_valid[index],$
      i2_valid:i2_valid[index],i3_valid:i3_valid[index],$
      i4_valid:i4_valid[index],m1_valid:m1_valid[index],$
      mj_fluxerr:mj_err[index],mh_fluxerr:mh_err[index],$
      mk_fluxerr:mk_err[index],i1_fluxerr:i1_err[index],$
      i2_fluxerr:i2_err[index],i3_fluxerr:i3_err[index],$
      i4_fluxerr:i4_err[index],m1_fluxerr:m1_err[index]}
  
   if keyword_set(file) then begin
      dumpfile=conf.catpath+file
      close,1
      openw,1,dumpfile
      for i=0,n_elements(cat.id)-1 do begin
      printf,1,format='(A30,2(1X,F9.5),8(1X,I1),16(1X,E11.4))',$
         'SSTc2d '+string(cat.c2did[i]),cat.ra[i],cat.dec[i],$
         cat.mj_valid[i],cat.mh_valid[i],cat.mk_valid[i],cat.i1_valid[i],$
         cat.i2_valid[i],cat.i3_valid[i],cat.i4_valid[i],cat.m1_valid[i],$
         cat.mj_flux[i],cat.mj_fluxerr[i],cat.mh_flux[i],cat.mh_fluxerr[i],$
         cat.mk_flux[i],cat.mk_fluxerr[i],cat.i1_flux[i],cat.i1_fluxerr[i],$
         cat.i2_flux[i],cat.i2_fluxerr[i],cat.i3_flux[i],cat.i3_fluxerr[i],$
         cat.i4_flux[i],cat.i4_fluxerr[i],cat.m1_flux[i],cat.m1_fluxerr[i]
      endfor
      
      
      close,1
   
   endif
   
   
END


PRO COMBINECATALOG_RHO_OPH, cat, catfile=catfile, file=file, onlyspitzer=onlyspitzer, ZERO=zero
   COMMON share,conf
   loadconfig


    readcol,conf.catpath+catfile,$
      format='(i4,a6,a16,f11.8,f11.8,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4,F11.4)'$
      ,id,sstid,c2did,ra,dec,mj_flux,mj_err,mh_flux,mh_err,mk_flux,mk_err,i1_flux,i1_err,i2_flux,i2_err,i3_flux,i3_err,$
      i4_flux,i4_err,m1_flux,m1_err
   readcol,conf.catpath+'rho_oph_J_new_soc.cat',nj,xj,yj,sfj,ferrj,mj,merrj,aj,bj,tj,ej,fwhmj,flagj,classj,vj,nj,/silent
   readcol,conf.catpath+'rho_oph_H_new_soc.cat',nh,xh,yh,sfh,ferrh,mh,merrh,ah,bh,th,eh,fwhmh,flagh,classh,vh,nh,/silent
   readcol,conf.catpath+'rho_oph_Ks_new_soc.cat',nk,xk,yk,sfk,ferrk,mk,merrk,ak,bk,tk,ek,fwhmk,flagk,classk,vk,nk,/silent
   
   hdr=headfits(conf.wircampath+'rho_oph_Ks_new.fits')
   adxy,hdr,ra,dec,xm,ym
   
   mj_valid=intarr(n_elements(m1_flux))
   mh_valid=intarr(n_elements(m1_flux))
   mk_valid=intarr(n_elements(m1_flux))
   i1_valid=intarr(n_elements(m1_flux))
   i2_valid=intarr(n_elements(m1_flux))
   i3_valid=intarr(n_elements(m1_flux))
   i4_valid=intarr(n_elements(m1_flux))
   m1_valid=intarr(n_elements(m1_flux))

   
   
   mj_valid[*]=1
   mh_valid[*]=1
   mk_valid[*]=1
   i1_valid[*]=1
   i2_valid[*]=1
   i3_valid[*]=1
   i4_valid[*]=1
   m1_valid[*]=1
   
   if keyword_set(onlyspitzer) then begin
      mj_valid[*]=0
      mh_valid[*]=0
      mk_valid[*]=0
   endif
    
   for i=0,n_elements(m1_flux)-1 do begin
      jind=where(vj eq id[i], count)
      if count eq 1 then begin
         mj_flux[i]=1594000.0/(10^((mj[jind]-zero[0])/2.5))
         meu=1594000.0/(10^((mj[jind]+merrj[jind]-zero[0])/2.5))
         mel=1594000.0/(10^((mj[jind]-merrj[jind]-zero[0])/2.5))
         mj_err[i]=abs(meu-mel)
         mj_valid[i]=1
      endif 
      
      hind=where(vh eq id[i], count)
      if count eq 1 then begin
         mh_flux[i]=1024000.0/(10^((mh[hind]-zero[1])/2.5))
         meu=1024000.0/(10^((mh[hind]+merrh[hind]-zero[1])/2.5))
         mel=1024000.0/(10^((mh[hind]-merrh[hind]-zero[1])/2.5))
         mh_err[i]=abs(meu-mel)
         mh_valid[i]=1
      endif
      
      kind=where(vk eq id[i], count)
      if count eq 1 then begin
         mk_flux[i]=666700.0/(10^((mk[kind]-zero[2])/2.5))
         meu=666700.0/(10^((mk[kind]+merrk[kind]-zero[2])/2.5))
         mel=666700.0/(10^((mk[kind]-merrk[kind]-zero[2])/2.5))
         mk_err[i]=abs(meu-mel)
         mk_valid[i]=1
      endif
   endfor
   
   ; If flux error le 0 then assign it to 10% of flux
   ind=where(mj_err le 0, count)
   if count gt 0 then mj_err[ind]=0.1*mj_flux[ind]
   
   ind=where(mh_err le 0, count)
   if count gt 0 then mh_err[ind]=0.1*mh_flux[ind]
   
   ind=where(mk_err le 0, count)
   if count gt 0 then mk_err[ind]=0.1*mk_flux[ind]
   
   ind=where(mj_flux le 0, count)
   if count gt 0 then mj_valid[ind]=0
   ind=where(mh_flux le 0, count)
   if count gt 0 then mh_valid[ind]=0
   ind=where(mk_flux le 0, count)
   if count gt 0 then mk_valid[ind]=0
   ind=where(i1_flux le 0, count)
   if count gt 0 then i1_valid[ind]=0
   ind=where(i2_flux le 0, count)
   if count gt 0 then i2_valid[ind]=0
   ind=where(i3_flux le 0, count)
   if count gt 0 then i3_valid[ind]=0
   ind=where(i4_flux le 0, count)
   if count gt 0 then i4_valid[ind]=0
   ind=where((m1_flux le 0) or (m1_flux-m1_err le 0), count)
   if count gt 0 then m1_valid[ind]=0
   ;id=indgen(n_elements(m1))
   
   index=where(id ge 0)
   cat={id:id[index],c2did:c2did[index],ra:ra[index],dec:dec[index],$
      mj_flux:mj_flux[index],mh_flux:mh_flux[index],$
      mk_flux:mk_flux[index],i1_flux:i1_flux[index],$
      i2_flux:i2_flux[index],i3_flux:i3_flux[index],$
      i4_flux:i4_flux[index],m1_flux:m1_flux[index],$
      mj_valid:mj_valid[index],mh_valid:mh_valid[index],$
      mk_valid:mk_valid[index],i1_valid:i1_valid[index],$
      i2_valid:i2_valid[index],i3_valid:i3_valid[index],$
      i4_valid:i4_valid[index],m1_valid:m1_valid[index],$
      mj_fluxerr:mj_err[index],mh_fluxerr:mh_err[index],$
      mk_fluxerr:mk_err[index],i1_fluxerr:i1_err[index],$
      i2_fluxerr:i2_err[index],i3_fluxerr:i3_err[index],$
      i4_fluxerr:i4_err[index],m1_fluxerr:m1_err[index]}
  
   if keyword_set(file) then begin
      dumpfile=conf.catpath+file
      close,1
      openw,1,dumpfile
      for i=0,n_elements(cat.id)-1 do begin
      printf,1,format='(A30,2(1X,F9.5),8(1X,I1),16(1X,E11.4))',$
         'SSTc2d '+string(cat.c2did[i]),cat.ra[i],cat.dec[i],$
         cat.mj_valid[i],cat.mh_valid[i],cat.mk_valid[i],cat.i1_valid[i],$
         cat.i2_valid[i],cat.i3_valid[i],cat.i4_valid[i],cat.m1_valid[i],$
         cat.mj_flux[i],cat.mj_fluxerr[i],cat.mh_flux[i],cat.mh_fluxerr[i],$
         cat.mk_flux[i],cat.mk_fluxerr[i],cat.i1_flux[i],cat.i1_fluxerr[i],$
         cat.i2_flux[i],cat.i2_fluxerr[i],cat.i3_flux[i],cat.i3_fluxerr[i],$
         cat.i4_flux[i],cat.i4_fluxerr[i],cat.m1_flux[i],cat.m1_fluxerr[i]
      endfor
      
      
      close,1
   
   endif
   
   
END



PRO COMBINEYSOCATALOG, FITS=fits, NEWFITS=newfits
   COMMON share,conf
   loadconfig

   offset=0
   for i=0,n_elements(fits)-1 do begin
       file=fits[i]
       
       ; Read YSO information
       tab1=mrdfits(file,1,mhd,/Silent)
       tab2=mrdfits(file,2,/Silent)
       
       offset=offset+max(tab1.soure_id)
       ;print,offset,max(tab1.soure_id),n_elements(tab1.soure_id)

       if i eq 0 then begin
          newtab1=tab1
          newtab2=tab2
          
          
       endif else begin
          tab1[*].soure_id=tab1[*].soure_id+max(newtab1[*].soure_id)
          tab2[*].source_id=tab2[*].source_id+max(newtab2[*].source_id)
                    
          newtab1=[newtab1,tab1]
          newtab2=[newtab2,tab2]
       endelse
   endfor
   
   ; Now, check if there is any duplicated data entry
   namelist=newtab1[*].source_name
   for j=0,n_elements(newtab1[*].soure_id)-1 do begin
      ind=where(strmatch(namelist,newtab1[j].source_name) eq 1,count)
      if count gt 1 then begin
          print,'There are duplicated data entries for '+newtab1[j].source_name
      endif
   endfor
   
   
   if file_test(newfits) then spawn,'rm -rf '+newfits
   mwrfits,newtab1, newfits,mhd,/Silent
   mwrfits,newtab2,newfits,/Silent


END



; This function is used to extract certain entry from 
PRO EXTRACTYSOCATALOG, FITS=fits, NEWFITS=newfits
     COMMON share,conf
     loadconfig
     
     
     c2dnames='J163019.8-240256'
     fits=conf.fitspath+'L1688_yso_good.fits'
     newfits=conf.fitspath+'L1688_missed_YSO.fits'
     
     ; Read YSO information
     tab1=mrdfits(fits,1,mhd,/Silent)
     tab2=mrdfits(fits,2,/Silent)
     
     for i=0,n_elements(tab1.(0))-1 do begin     
        newstring=strmid(tab1[i].source_name,7,16)
        c2dind=where(strmatch(c2dnames,newstring) eq 1,count) 
        
        if count ne 0 then begin
            newtab1=tab1[i]     
            inx=where(tab1[i].soure_id eq tab2.source_id,xcount)
            newtab2=tab2[inx]
            newtab1.first_row=1
        endif
     endfor 
     
     if file_test(newfits) then spawn,'rm -rf '+newfits
     mwrfits,newtab1, newfits,mhd,/Silent
     mwrfits,newtab2,newfits,/Silent
     

END













