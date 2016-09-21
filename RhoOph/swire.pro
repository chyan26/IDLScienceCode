;--------------------------------------------------
;  This file contains all the subroutine used for
;    running a control data testing with SWIRE 
;    ELAIS N1 data.
;

PRO READSWIRE
   
   path='/data/disk/chyan/Projects/SWIRE/Catalog/'
   
   spawn,'cat '+path+'elais-n1.2mass |sed -e "s/|/ /g"|sed -e "s/---/-999.9/g"'+$
      '> /tmp/2mass_aclient.dat'

   readcol,'/tmp/2mass_aclient.dat',ra,dec,name,mj,mjerr,mh,mherr,mk,mkerr,flag,$
    format='f10.7,f10.7,a,f,f,f,f,f,f,a',/silent

   readcol,path+'swire_n1_pos_only.cat',cntr,nra,ndec
   
   close,1
   openw,1,path+'swire-2mass.cat'
   for i=0L,n_elements(nra)-1 do begin
   
      dist=sqrt((ra-nra[i])^2+(dec-ndec[i])^2)*3600.0
      ind=where(dist eq min(dist) and min(dist) le 2.5, count)
      if (count ge 1) then begin 
         if (strcmp('AAA',flag[ind]) eq 1) then begin
            printf,1,format='(i ,f8.4,f7.4,f8.4,f7.4,f8.4,f7.4)',$
               cntr[i],mj[ind],mjerr[ind],mh[ind],mherr[ind],mk[ind],mkerr[ind]
         endif else begin
            printf,1,format='(i,a)',cntr[i],' -999.9 -999.9 -999.9 -999.9 -999.9 -999.9' 
         endelse
      endif else begin
         printf,1,format='(i,a)',cntr[i],' -999.9 -999.9 -999.9 -999.9 -999.9 -999.9' 
      endelse
   endfor

   close,1

END

; Before run this program, use command line "ssh chyan@capella swirecat --mag > swire_n1_mag.cat"
;   to produce the SWIRE catalog with 2MASS photometry 
PRO GETSWIREMAG, cat
   COMMON share,conf
   loadconfig
   
   readcol,conf.catpath+'swire_n1_mag.cat',$
      format='(i4,a26,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f)',$
      id,name,ra,dec,mj,mjerr,mh,mherr,mk,mkerr,i1,i1err,i2,i2err,i3,i3err,i4,i4err,m1,m1err

   cat={id:id,ra:ra,dec:dec,mj:mj,mjerr:mjerr,mh:mh,mherr:mherr,mk:mk,mkerr:mkerr,$
      i1:i1,i1err:i1err,i2:i2,i2err:i2err,i3:i3,i3err:i3err,i4:i4,i4err:i4err,m1:m1,m1err:m1err}
   
END

; Before run this program, use command line "ssh chyan@capella swirecat --flux > swire_n1_flux.cat"
;   to produce the SWIRE catalog with 2MASS photometry 
PRO GETSWIREFLUX, file, cat
   COMMON share,conf
   loadconfig
   
   readcol,file,$
      format='(i4,a26,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f)',$
      id,name,ra,dec,mj,mjerr,mh,mherr,mk,mkerr,i1,i1err,i2,i2err,i3,i3err,i4,i4err,m1,m1err

   cat={id:id,ra:ra,dec:dec,mj:mj,mjerr:mjerr,mh:mh,mherr:mherr,mk:mk,mkerr:mkerr,$
      i1:i1,i1err:i1err,i2:i2,i2err:i2err,i3:i3,i3err:i3err,i4:i4,i4err:i4err,m1:m1,m1err:m1err}
   
END


PRO GETSWIRESTARFLUX,file, cat
   COMMON share,conf
   loadconfig
   
   readcol,file,$
      format='(i4,a26,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f)',$
      id,name,ra,dec,mj,mjerr,mh,mherr,mk,mkerr,i1,i1err,i2,i2err,i3,i3err,i4,i4err,m1,m1err

   
   cat={id:id,ra:ra,dec:dec,mj:mj,mjerr:mjerr,mh:mh,mherr:mherr,mk:mk,mkerr:mkerr,$
      i1:i1,i1err:i1err,i2:i2,i2err:i2err,i3:i3,i3err:i3err,i4:i4,i4err:i4err,m1:m1,m1err:m1err}
   
END

PRO GETSWIREMAG,file, cat
   COMMON share,conf
   loadconfig
   
   readcol,file,$
      format='(i4,a26,f,f,f,f,f,f,f,f,f,f,f,f)',$
      id,name,ra,dec,i1,i1err,i2,i2err,i3,i3err,i4,i4err,m1,m1err

   
   cat={id:id,ra:ra,dec:dec,$
      i1:i1,i1err:i1err,i2:i2,i2err:i2err,i3:i3,i3err:i3err,i4:i4,i4err:i4err,m1:m1,m1err:m1err}
   
END

PRO MKSWIREPLOT, CAT
   COMMON share,conf
   loadconfig
      
   plot,cat.mk-cat.m1,cat.mk,psym=3,yrange=[16,2],xrange=[-1,14],xstyle=1,ystyle=1


END



; This program is used to produce the catalog file for SED fitter 
PRO SWIRESEDCAT, cat, file=file, onlyspitzer=onlyspitzer
   COMMON share,conf
   loadconfig
  
   mj_valid=intarr(n_elements(cat.m1))
   mh_valid=intarr(n_elements(cat.m1))
   mk_valid=intarr(n_elements(cat.m1))
   i1_valid=intarr(n_elements(cat.m1))
   i2_valid=intarr(n_elements(cat.m1))
   i3_valid=intarr(n_elements(cat.m1))
   i4_valid=intarr(n_elements(cat.m1))
   m1_valid=intarr(n_elements(cat.m1))

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
   
   ind=where(cat.mj le 0, count)
   if count gt 0 then mj_valid[ind]=0
   ind=where(cat.mh le 0, count)
   if count gt 0 then mh_valid[ind]=0
   ind=where(cat.mk le 0, count)
   if count gt 0 then mk_valid[ind]=0
   ind=where(cat.i1 le 0, count)
   if count gt 0 then i1_valid[ind]=0
   ind=where(cat.i2 le 0, count)
   if count gt 0 then i2_valid[ind]=0
   ind=where(cat.i3 le 0, count)
   if count gt 0 then i3_valid[ind]=0
   ind=where(cat.i4 le 0, count)
   if count gt 0 then i4_valid[ind]=0
   ind=where(cat.m1 le 0, count)
   if count gt 0 then m1_valid[ind]=0

   if keyword_set(file) then begin
      dumpfile=file
      print,file
      close,1
      openw,1,dumpfile
      for i=0,n_elements(cat.id)-1 do begin
         printf,1,format='(A30,2(1X,F9.5),8(1X,I1),16(1X,E11.4))',$
            string(cat.id[i]),cat.ra[i],cat.dec[i],$
            mj_valid[i],mh_valid[i],mk_valid[i],i1_valid[i],$
            i2_valid[i],i3_valid[i],i4_valid[i],m1_valid[i],$
            cat.mj[i],cat.mjerr[i],cat.mh[i],cat.mherr[i],$
            cat.mk[i],cat.mkerr[i],cat.i1[i],cat.i1err[i],$
            cat.i2[i],cat.i2err[i],cat.i3[i],cat.i3err[i],$
            cat.i4[i],cat.i4err[i],cat.m1[i],cat.m1err[i]
      endfor
      
      close,1
   
   endif


END



;  The SWIRE data is used to exam the detection ability of SED fitter
PRO PLOTSWIRECMD
   COMMON share,conf 
   loadconfig
   

   ;spawn,'ssh chyan@capella findswire --mag > '+conf.catpath+'swire_all_mag.cat'
   
   getswiremag,conf.catpath+'swire_all_mag.cat',cat
   
   plot,cat.i2-cat.i4,cat.i4,psym=3,xrange=[-1,5],yrange=[15,5],$
   xstyle=1,ystyle=1,$
   xtitle='[4.5] - [8.0]',ytitle='[8.0]',charsize=1.5,$
   xthick=5,ythick=5
   
   oplot,[-1,5],[15,9],line=2,thick=5
   oplot,[2,2],[0,100],line=2,thick=5

   ;plot,cat.i4-cat.m1,cat.i4,psym=3,xrange=[-1,6],yrange=[14,0] 

END










