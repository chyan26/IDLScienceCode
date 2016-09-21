@stat

PRO IMGEXTRACT, cra, cdec, imsize, oim, ohd, nim, nhd
  Compile_opt idl2
  On_error,2

  npar = N_params()

  if ( npar EQ 0 ) then begin
        print,'Syntax - IMGEXTRACT, cra, cdec, oim, ohd, nim, nhd'
        print,'CRA and CDEC must be in decimal DEGREES'
        return
  endif                                                                  
  
  adxy,ohd,cra,cdec,x,y
  rad=fix(imsize/2.0)  
  hextract,oim,ohd,nim,nhd,fix(x-rad+1),fix(x+rad),fix(y-rad+1), fix(y+rad)
  ;print,fix(x-rad+1),fix(x+rad),fix(y-rad+1), fix(y+rad)
  
  return 
END


PRO RESIZEIMAGE
  COMMON share,conf
  loadconfig
  ; Load images
  
  ; Get coordinate for L1688
  spawn,'mPix2Coord '+conf.wircampath+'J_small.fits 5758 1189'
  
  ; Cut L1688 subimage lon=246.321350, lat=-24.443980
  spawn,'mSubimage  '+conf.wircampath+'12AT99_KS_coadd.fits '+$
  	conf.wircampath+'L1688_Ks_new.fits 246.321350 -24.443980 2.28 1.25'
  spawn,'mSubimage  '+conf.wircampath+'12AT99_KS_coadd.weight.fits '+$
  	conf.wircampath+'L1688_Ks_new.weight.fits 246.321350 -24.443980 2.28 1.25'

  spawn,'mSubimage  '+conf.wircampath+'12AT99_H_coadd.fits '+$
  	conf.wircampath+'L1688_H_new.fits 246.321350 -24.443980 2.28 1.25'
  spawn,'mSubimage  '+conf.wircampath+'12AT99_H_coadd.weight.fits '+$
  	conf.wircampath+'L1688_H_new.weight.fits 246.321350 -24.443980 2.28 1.25'

  spawn,'mSubimage  '+conf.wircampath+'12AT99_J_coadd.fits '+$
  	conf.wircampath+'L1688_J_new.fits 246.321350 -24.443980 2.28 1.25'
  spawn,'mSubimage  '+conf.wircampath+'12AT99_J_coadd.weight.fits '+$
  	conf.wircampath+'L1688_J_new.weight.fits 246.321350 -24.443980 2.28 1.25'
  
  ; Get coordinate for L1689
  spawn,'mPix2Coord '+conf.wircampath+'J_small.fits 3889 920'
  
  ; Cut L1689 subimage lon=248.056453, lat=-24.683862
  spawn,'mSubimage  '+conf.wircampath+'12AT99_KS_coadd.fits '+$
  	conf.wircampath+'L1689_Ks_new.fits 248.056453 -24.683862 0.85 1.41'
  spawn,'mSubimage  '+conf.wircampath+'12AT99_KS_coadd.weight.fits '+$
  	conf.wircampath+'L1689_Ks_new.weight.fits 248.056453 -24.683862 0.85 1.41'


  spawn,'mSubimage  '+conf.wircampath+'12AT99_H_coadd.fits '+$
  	conf.wircampath+'L1689_H_new.fits 248.056453 -24.683862 0.85 1.41'
  spawn,'mSubimage  '+conf.wircampath+'12AT99_H_coadd.weight.fits '+$
  	conf.wircampath+'L1689_H_new.weight.fits 248.056453 -24.683862 0.85 1.41'


  spawn,'mSubimage  '+conf.wircampath+'12AT99_J_coadd.fits '+$
  	conf.wircampath+'L1689_J_new.fits 248.056453 -24.683862 0.85 1.41'
  spawn,'mSubimage  '+conf.wircampath+'12AT99_J_coadd.weight.fits '+$
  	conf.wircampath+'L1689_J_new.weight.fits 248.056453 -24.683862 0.85 1.41'

  ; Get coordinate for L1709
  spawn,'mPix2Coord '+conf.wircampath+'J_small.fits 3801 2144'
  
  ; Cut L1709 subimage lon=248.139466, lat=-23.648925
  spawn,'mSubimage  '+conf.wircampath+'12AT99_KS_coadd.fits '+$
  	conf.wircampath+'L1709_Ks_new.fits 248.139466 -23.648925 1.79 0.66'
  spawn,'mSubimage  '+conf.wircampath+'12AT99_KS_coadd.weight.fits '+$
  	conf.wircampath+'L1709_Ks_new.weight.fits 248.139466 -23.648925 1.79 0.66'

  spawn,'mSubimage  '+conf.wircampath+'12AT99_H_coadd.fits '+$
  	conf.wircampath+'L1709_H_new.fits 248.139466 -23.648925 1.79 0.66'
  spawn,'mSubimage  '+conf.wircampath+'12AT99_H_coadd.weight.fits '+$
  	conf.wircampath+'L1709_H_new.weight.fits 248.139466 -23.648925 1.79 0.66'

  spawn,'mSubimage  '+conf.wircampath+'12AT99_J_coadd.fits '+$
  	conf.wircampath+'L1709_J_new.fits 248.139466 -23.648925 1.79 0.66'
  spawn,'mSubimage  '+conf.wircampath+'12AT99_J_coadd.weight.fits '+$
  	conf.wircampath+'L1709_J_new.weight.fits 248.139466 -23.648925 1.79 0.66'


  ; Get coordinate for L1712
  spawn,'mPix2Coord '+conf.wircampath+'J_small.fits 1794 1372'
  
  ; Cut L1712 subimage lon=250.000445, lat=-24.292101
  spawn,'mSubimage  '+conf.wircampath+'12AT99_KS_coadd.fits '+$
  	conf.wircampath+'L1712_Ks_new.fits 250.000445 -24.292101 2.65 1.08'
  spawn,'mSubimage  '+conf.wircampath+'12AT99_KS_coadd.weight.fits '+$
  	conf.wircampath+'L1712_Ks_new.weight.fits 250.000445 -24.292101 2.65 1.08'

  spawn,'mSubimage  '+conf.wircampath+'12AT99_H_coadd.fits '+$
  	conf.wircampath+'L1712_H_new.fits 250.000445 -24.292101 2.65 1.08'
  spawn,'mSubimage  '+conf.wircampath+'12AT99_H_coadd.weight.fits '+$
  	conf.wircampath+'L1712_H_new.weight.fits 250.000445 -24.292101 2.65 1.08'

  spawn,'mSubimage  '+conf.wircampath+'12AT99_J_coadd.fits '+$
  	conf.wircampath+'L1712_J_new.fits 250.000445 -24.292101 2.65 1.08'
  spawn,'mSubimage  '+conf.wircampath+'12AT99_J_coadd.weight.fits '+$
  	conf.wircampath+'L1712_J_new.weight.fits 250.000445 -24.292101 2.65 1.08'


  ; Get coordinate for Rho Oph
  spawn,'mPix2Coord '+conf.wircampath+'J_small.fits 6277 2459'
  
  ; Cut L1712 subimage lon=245.860179, lat=-23.364055
  spawn,'mSubimage  '+conf.wircampath+'12AT99_KS_coadd.fits '+$
  	conf.wircampath+'rho_oph_Ks_new.fits 245.86154 -23.231563 1.51 1.15'
  spawn,'mSubimage  '+conf.wircampath+'12AT99_KS_coadd.weight.fits '+$
  	conf.wircampath+'rho_oph_Ks_new.weight.fits 245.86154 -23.231563 1.51 1.15'

  spawn,'mSubimage  '+conf.wircampath+'12AT99_H_coadd.fits '+$
  	conf.wircampath+'rho_oph_H_new.fits 245.86154 -23.231563 1.51 1.15'
  spawn,'mSubimage  '+conf.wircampath+'12AT99_H_coadd.weight.fits '+$
  	conf.wircampath+'rho_oph_H_new.weight.fits 245.86154 -23.231563 1.51 1.15'

  spawn,'mSubimage  '+conf.wircampath+'12AT99_J_coadd.fits '+$
  	conf.wircampath+'rho_oph_J_new.fits 245.86154 -23.231563 1.51 1.15'
  spawn,'mSubimage  '+conf.wircampath+'12AT99_J_coadd.weight.fits '+$
  	conf.wircampath+'rho_oph_J_new.weight.fits 245.86154 -23.231563 1.51 1.15'

 
END

PRO GETREGIONINFO,ra,dec


  radec, ra, dec, ihr, imin, xsec, ideg, imn, xsc
  rastring=strcompress(string(ihr,format='(I)'),/remove)+':'+$
    strcompress(string(imin,format='(I02)'),/remove)+':'+$
    strcompress(string(xsec,format='(F04.1)'),/remove)
    
  decstring=strcompress(string(ideg,format='(I)'),/remove)+':'+$
    strcompress(string(imn,format='(I02)'),/remove)+':'+$
    strcompress(string(xsc,format='(F04.1)'),/remove)
    
  print,rastring, '  &  ' ,decstring
  
END


PRO GETIMAGE
  COMMON share,conf  
  loadconfig
  
  cra=248.1875
  cdec=-23.876389
  
  image='~/W3A_J_coadd.fits'
  
  
  hd1=headfits(conf.wircampath+'oph_region34_J_coadd.fits')
  
  adxy,hd1,cra,cdec,x,y
  
  print,x,y

  spawn,'getfits -o '+conf.fitspath+'test.fits '+conf.wircampath+'oph_region34_J_coadd.fits '+$
    strcompress(string(x),/remove)+' '+strcompress(string(x),/remove)+' -x 1024 1024'

END


PRO LOADREGION2, image, header
  COMMON share,conf
  loadconfig
  
  ;nim1=readfits(conf.wircampath+'1633-2410_J_coadd.fits',nhd1)
  ;nim2=readfits(conf.wircampath+'1633-2410_H_coadd.fits',nhd2)
  nim3=readfits(conf.wircampath+'1633-2410_Ks_coadd.fits',nhd3)
  
  image={j:nim3,h:nim3,k:nim3}
  header={j:nhd3,h:nhd3,k:nhd3}

END

PRO DEROTATE_SPITZER
   COMMON share,conf
   loadconfig
   
   image=[conf.iracpath+'OPH_ALL_A_IRAC1_mosaic.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC2_mosaic.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC3_mosaic.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC4_mosaic.fits',$
          conf.mipspath+'OPH_ALL_A_MIPS1_mosaic.fits']
   
   spawn,'swarp -c '+conf.iracpath+'swarp.conf '+image[0]+' -IMAGEOUT_NAME '+conf.iracpath+'OPH_ALL_A_IRAC1_mosaic_derot.fits'
   spawn,'swarp -c '+conf.iracpath+'swarp.conf '+image[1]+' -IMAGEOUT_NAME '+conf.iracpath+'OPH_ALL_A_IRAC2_mosaic_derot.fits'  
   spawn,'swarp -c '+conf.iracpath+'swarp.conf '+image[2]+' -IMAGEOUT_NAME '+conf.iracpath+'OPH_ALL_A_IRAC3_mosaic_derot.fits'
   spawn,'swarp -c '+conf.iracpath+'swarp.conf '+image[3]+' -IMAGEOUT_NAME '+conf.iracpath+'OPH_ALL_A_IRAC4_mosaic_derot.fits'
   spawn,'swarp -c '+conf.iracpath+'swarp.conf '+image[4]+' -IMAGEOUT_NAME '+conf.mipspath+'OPH_ALL_A_MIPS1_mosaic_derot.fits'

END


PRO MKTHUMBNAIL_L1689, file=file, clean=clean
   COMMON share,conf
   loadconfig
   
   table=mrdfits(conf.fitspath+file,1)
   pixel=30.0 ; Plot a region 30" in diameter
   
   if keyword_set(clean) then begin
      spawn,'rm -rf '+conf.tnpath+'/*.*'
      ;spawn,'find '+conf.tnpath+' -name "*.*" -print0 | xargs -0 rm'
   endif
   
   ;hd1=headfits(conf.wircampath+'1633-2410_J_coadd.fits')
   ;print,adstring([table[0].x,table[0].y])
   ;adxy,hd1,table[*].x,table[*].y,x,y
   
;   image=[conf.wircampath+'L1689_remap_J.fits',$
;          conf.wircampath+'L1689_remap_H.fits',$
;          conf.wircampath+'L1689_remap_Ks.fits',$
   image=[conf.wircampath+'L1689_J_new.fits',$
          conf.wircampath+'L1689_H_new.fits',$
          conf.wircampath+'L1689_Ks_new.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC1_mosaic_derot.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC2_mosaic_derot.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC3_mosaic_derot.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC4_mosaic_derot.fits',$
          conf.mipspath+'OPH_ALL_A_MIPS1_mosaic_derot.fits']
          
   filter=['J','H','K','I1','I2','I3','I4','M1']       
   
   for i=0,n_elements(table.(0))-1 do begin
      res=strsplit(adstring([table[i].x,table[i].y]),/extract)
      pos=res[0]+':'+res[1]+':'+res[2]+' '+res[3]+':'+res[4]+':'+res[5]
      for j=0, n_elements(filter)-1 do begin
         hd=headfits(image[j])
         scale=strcompress(string(ceil(pixel/(sxpar(hd,'CD2_2')*3600))),/remove)
         outname=strcompress(string(table[i].source_name),/remove)+'_'+filter[j]+'.fits'
         spawn,'getfits -o '+conf.tnpath+outname+' '+image[j]+' '+$
            pos+' '+scale+' '+scale
         
      endfor   
      
      basename=conf.tnpath+strcompress(string(table[i].source_name),/remove)+'_'
      
      spawn,'stiff -c '+conf.confpath+'stiff.conf -VERBOSE_TYPE QUIET -OUTFILE_NAME '+$
         basename+'1.tif '+$
         basename+filter[2]+'.fits '+$
         basename+filter[1]+'.fits '+$
         basename+filter[0]+'.fits '
      
      spawn,'stiff -c '+conf.confpath+'stiff.conf -VERBOSE_TYPE QUIET -OUTFILE_NAME '+$
         basename+'2.tif '+$
         basename+filter[5]+'.fits '+$
         basename+filter[4]+'.fits '+$
         basename+filter[3]+'.fits '
      
      spawn,'stiff -c '+conf.confpath+'stiff.conf -VERBOSE_TYPE QUIET -OUTFILE_NAME '+$
         basename+'3.tif '+$
         basename+filter[7]+'.fits '+$
         basename+filter[6]+'.fits '+$
         basename+filter[5]+'.fits '
    
    endfor

    spawn,'mv '+conf.tnpath+'*.tif '+conf.imagepath
END


PRO MKTHUMBNAIL_L1688, file=file, clean=clean
   COMMON share,conf
   loadconfig
   
   table=mrdfits(conf.fitspath+file,1)
   pixel=30.0 ; Plot a region 30" in diameter
   
   if keyword_set(clean) then begin
      spawn,'rm -rf '+conf.tnpath+'/*.*'
      ;spawn,'find '+conf.tnpath+' -name "*.*" -print0 | xargs -0 rm'
   endif
   
   ;hd1=headfits(conf.wircampath+'1633-2410_J_coadd.fits')
   ;print,adstring([table[0].x,table[0].y])
   ;adxy,hd1,table[*].x,table[*].y,x,y
   
   image=[conf.wircampath+'L1688_J_new.fits',$
          conf.wircampath+'L1688_H_new.fits',$
          conf.wircampath+'L1688_Ks_new.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC1_mosaic_derot.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC2_mosaic_derot.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC3_mosaic_derot.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC4_mosaic_derot.fits',$
          conf.mipspath+'OPH_ALL_A_MIPS1_mosaic_derot.fits']
          
   filter=['J','H','K','I1','I2','I3','I4','M1']       
   
   for i=0,n_elements(table.(0))-1 do begin
      res=strsplit(adstring([table[i].x,table[i].y]),/extract)
      pos=res[0]+':'+res[1]+':'+res[2]+' '+res[3]+':'+res[4]+':'+res[5]
      for j=0, n_elements(filter)-1 do begin
         hd=headfits(image[j])
         scale=strcompress(string(ceil(pixel/(sxpar(hd,'CD2_2')*3600))),/remove)
         outname=strcompress(string(table[i].source_name),/remove)+'_'+filter[j]+'.fits'
         spawn,'getfits -o '+conf.tnpath+outname+' '+image[j]+' '+$
            pos+' '+scale+' '+scale
         
      endfor   
      
      basename=conf.tnpath+strcompress(string(table[i].source_name),/remove)+'_'
      
      spawn,'stiff -c '+conf.confpath+'stiff.conf -VERBOSE_TYPE QUIET -OUTFILE_NAME '+$
         basename+'1.tif '+$
         basename+filter[2]+'.fits '+$
         basename+filter[1]+'.fits '+$
         basename+filter[0]+'.fits '
      
      spawn,'stiff -c '+conf.confpath+'stiff.conf -VERBOSE_TYPE QUIET -OUTFILE_NAME '+$
         basename+'2.tif '+$
         basename+filter[5]+'.fits '+$
         basename+filter[4]+'.fits '+$
         basename+filter[3]+'.fits '
      
      spawn,'stiff -c '+conf.confpath+'stiff.conf -VERBOSE_TYPE QUIET -OUTFILE_NAME '+$
         basename+'3.tif '+$
         basename+filter[7]+'.fits '+$
         basename+filter[6]+'.fits '+$
         basename+filter[5]+'.fits '
    
    endfor

    spawn,'mv '+conf.tnpath+'*.tif '+conf.imagepath
END


PRO MKTHUMBNAIL_L1709, file=file, clean=clean
   COMMON share,conf
   loadconfig
   
   table=mrdfits(conf.fitspath+file,1)
   pixel=30.0 ; Plot a region 30" in diameter
   
   if keyword_set(clean) then begin
      spawn,'rm -rf '+conf.tnpath+'/*.*'
      ;spawn,'find '+conf.tnpath+' -name "*.*" -print0 | xargs -0 rm'
   endif
   
   ;hd1=headfits(conf.wircampath+'1633-2410_J_coadd.fits')
   ;print,adstring([table[0].x,table[0].y])
   ;adxy,hd1,table[*].x,table[*].y,x,y
   
   image=[conf.wircampath+'L1709_J_new.fits',$
          conf.wircampath+'L1709_H_new.fits',$
          conf.wircampath+'L1709_Ks_new.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC1_mosaic_derot.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC2_mosaic_derot.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC3_mosaic_derot.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC4_mosaic_derot.fits',$
          conf.mipspath+'OPH_ALL_A_MIPS1_mosaic_derot.fits']
          
   filter=['J','H','K','I1','I2','I3','I4','M1']       
   
   for i=0,n_elements(table.(0))-1 do begin
      res=strsplit(adstring([table[i].x,table[i].y]),/extract)
      pos=res[0]+':'+res[1]+':'+res[2]+' '+res[3]+':'+res[4]+':'+res[5]
      for j=0, n_elements(filter)-1 do begin
         hd=headfits(image[j])
         scale=strcompress(string(ceil(pixel/(sxpar(hd,'CD2_2')*3600))),/remove)
         outname=strcompress(string(table[i].source_name),/remove)+'_'+filter[j]+'.fits'
         spawn,'getfits -o '+conf.tnpath+outname+' '+image[j]+' '+$
            pos+' '+scale+' '+scale
         
      endfor   
      
      basename=conf.tnpath+strcompress(string(table[i].source_name),/remove)+'_'
      
      spawn,'stiff -c '+conf.confpath+'stiff.conf -VERBOSE_TYPE QUIET -OUTFILE_NAME '+$
         basename+'1.tif '+$
         basename+filter[2]+'.fits '+$
         basename+filter[1]+'.fits '+$
         basename+filter[0]+'.fits '
      
      spawn,'stiff -c '+conf.confpath+'stiff.conf -VERBOSE_TYPE QUIET -OUTFILE_NAME '+$
         basename+'2.tif '+$
         basename+filter[5]+'.fits '+$
         basename+filter[4]+'.fits '+$
         basename+filter[3]+'.fits '
      
      spawn,'stiff -c '+conf.confpath+'stiff.conf -VERBOSE_TYPE QUIET -OUTFILE_NAME '+$
         basename+'3.tif '+$
         basename+filter[7]+'.fits '+$
         basename+filter[6]+'.fits '+$
         basename+filter[5]+'.fits '
    
    endfor

    spawn,'mv '+conf.tnpath+'*.tif '+conf.imagepath
END

PRO MKTHUMBNAIL_L1712, file=file, clean=clean
   COMMON share,conf
   loadconfig
   
   table=mrdfits(conf.fitspath+file,1)
   pixel=30.0 ; Plot a region 30" in diameter
   
   if keyword_set(clean) then begin
      spawn,'rm -rf '+conf.tnpath+'/*.*'
      ;spawn,'find '+conf.tnpath+' -name "*.*" -print0 | xargs -0 rm'
   endif
   
   ;hd1=headfits(conf.wircampath+'1633-2410_J_coadd.fits')
   ;print,adstring([table[0].x,table[0].y])
   ;adxy,hd1,table[*].x,table[*].y,x,y
   
   image=[conf.wircampath+'L1712_J_new.fits',$
          conf.wircampath+'L1712_H_new.fits',$
          conf.wircampath+'L1712_Ks_new.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC1_mosaic_derot.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC2_mosaic_derot.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC3_mosaic_derot.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC4_mosaic_derot.fits',$
          conf.mipspath+'OPH_ALL_A_MIPS1_mosaic_derot.fits']
          
   filter=['J','H','K','I1','I2','I3','I4','M1']       
   
   for i=0,n_elements(table.(0))-1 do begin
      res=strsplit(adstring([table[i].x,table[i].y]),/extract)
      pos=res[0]+':'+res[1]+':'+res[2]+' '+res[3]+':'+res[4]+':'+res[5]
      for j=0, n_elements(filter)-1 do begin
         hd=headfits(image[j])
         scale=strcompress(string(ceil(pixel/(sxpar(hd,'CD2_2')*3600))),/remove)
         outname=strcompress(string(table[i].source_name),/remove)+'_'+filter[j]+'.fits'
         spawn,'getfits -o '+conf.tnpath+outname+' '+image[j]+' '+$
            pos+' '+scale+' '+scale
         
      endfor   
      
      basename=conf.tnpath+strcompress(string(table[i].source_name),/remove)+'_'
      
      spawn,'stiff -c '+conf.confpath+'stiff.conf -VERBOSE_TYPE QUIET -OUTFILE_NAME '+$
         basename+'1.tif '+$
         basename+filter[2]+'.fits '+$
         basename+filter[1]+'.fits '+$
         basename+filter[0]+'.fits '
      
      spawn,'stiff -c '+conf.confpath+'stiff.conf -VERBOSE_TYPE QUIET -OUTFILE_NAME '+$
         basename+'2.tif '+$
         basename+filter[5]+'.fits '+$
         basename+filter[4]+'.fits '+$
         basename+filter[3]+'.fits '
      
      spawn,'stiff -c '+conf.confpath+'stiff.conf -VERBOSE_TYPE QUIET -OUTFILE_NAME '+$
         basename+'3.tif '+$
         basename+filter[7]+'.fits '+$
         basename+filter[6]+'.fits '+$
         basename+filter[5]+'.fits '
    
    endfor

    spawn,'mv '+conf.tnpath+'*.tif '+conf.imagepath
END


PRO MKTHUMBNAIL_RHO_OPH, file=file, clean=clean
   COMMON share,conf
   loadconfig
   
   table=mrdfits(conf.fitspath+file,1)
   pixel=30.0 ; Plot a region 30" in diameter
   
   if keyword_set(clean) then begin
      spawn,'rm -rf '+conf.tnpath+'/*.*'
      ;spawn,'find '+conf.tnpath+' -name "*.*" -print0 | xargs -0 rm'
   endif
   
   ;hd1=headfits(conf.wircampath+'1633-2410_J_coadd.fits')
   ;print,adstring([table[0].x,table[0].y])
   ;adxy,hd1,table[*].x,table[*].y,x,y
   
   image=[conf.wircampath+'rho_oph_J_new.fits',$
          conf.wircampath+'rho_oph_H_new.fits',$
          conf.wircampath+'rho_oph_Ks_new.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC1_mosaic_derot.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC2_mosaic_derot.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC3_mosaic_derot.fits',$
          conf.iracpath+'OPH_ALL_A_IRAC4_mosaic_derot.fits',$
          conf.mipspath+'OPH_ALL_A_MIPS1_mosaic_derot.fits']
          
   filter=['J','H','K','I1','I2','I3','I4','M1']       
   
   for i=0,n_elements(table.(0))-1 do begin
      res=strsplit(adstring([table[i].x,table[i].y]),/extract)
      pos=res[0]+':'+res[1]+':'+res[2]+' '+res[3]+':'+res[4]+':'+res[5]
      for j=0, n_elements(filter)-1 do begin
         hd=headfits(image[j])
         scale=strcompress(string(ceil(pixel/(sxpar(hd,'CD2_2')*3600))),/remove)
         outname=strcompress(string(table[i].source_name),/remove)+'_'+filter[j]+'.fits'
         spawn,'getfits -o '+conf.tnpath+outname+' '+image[j]+' '+$
            pos+' '+scale+' '+scale
         
      endfor   
      
      basename=conf.tnpath+strcompress(string(table[i].source_name),/remove)+'_'
      
      spawn,'stiff -c '+conf.confpath+'stiff.conf -VERBOSE_TYPE QUIET -OUTFILE_NAME '+$
         basename+'1.tif '+$
         basename+filter[2]+'.fits '+$
         basename+filter[1]+'.fits '+$
         basename+filter[0]+'.fits '
      
      spawn,'stiff -c '+conf.confpath+'stiff.conf -VERBOSE_TYPE QUIET -OUTFILE_NAME '+$
         basename+'2.tif '+$
         basename+filter[5]+'.fits '+$
         basename+filter[4]+'.fits '+$
         basename+filter[3]+'.fits '
      
      spawn,'stiff -c '+conf.confpath+'stiff.conf -VERBOSE_TYPE QUIET -OUTFILE_NAME '+$
         basename+'3.tif '+$
         basename+filter[7]+'.fits '+$
         basename+filter[6]+'.fits '+$
         basename+filter[5]+'.fits '
    
    endfor

    spawn,'mv '+conf.tnpath+'*.tif '+conf.imagepath
END


PRO MAKEMERGEDFIG, SEDFIG=sedfig, IMGFIG=imgfig, FINALFIG=finalfig

    COMMON share,conf
    loadconfig
  
    file='/tmp/test.tex'
    spawn,'rm -rf '+file
    spawn,'touch '+file
    spawn,'echo "\documentclass[11pt,oneside]{report}" >> '+file
    spawn,'echo "\usepackage{color,graphicx}" >> '+file
    spawn,'echo "\usepackage[left=-0.5cm, right=0cm, top=-1.65cm, bottom=0cm,paperwidth=6.6in, paperheight=2.2in]{geometry}" >> '+file
    spawn,'echo "\begin{document}" >> '+file
    spawn,'echo "\begin{figure}" >> '+file
    spawn,'echo "\includegraphics[width=2.5in]{'+sedfig+'} " >> '+file
    spawn,'echo "\includegraphics[scale=0.35]{'+imgfig+'} " >> '+file
    spawn,'echo "\end{figure}" >> '+file
    spawn,'echo "\end{document}" >> '+file
    spawn,'latex  -interaction=nonstopmode '+file+' 1>>/dev/null 2>> /dev/null',result
    spawn,'dvips -o test.ps test.dvi'+' 1>>/dev/null 2>> /dev/null',result
    spawn,'mv test.ps '+finalfig

END



PRO GETYSOSEDIMAGE, FITS=fits, LIST=list, PATH=path, ALL=all

    COMMON share,conf
    loadconfig
    
       
    tab1=mrdfits(fits,1,mhd,/Silent)
    tab2=mrdfits(fits,2,/Silent)
    
    if keyword_set(all) then list=tab1[*].source_name
    
    if strcmp(!VERSION.OS,'linux') then begin 
       modelpath='/data/capella/chyan/Models/models_r06/seds/'
    endif else begin
       modelpath='/Volumes/Science/Models/models_r06/seds/'
    endelse
    
    ; Read extinction law 
    exfile='~/IDLSourceCode/Science/RhoOph/extinction_law.ascii'
    readcol,exfile,wave,kappa,/silent
    k_v=211.4
    
    v=[1.252,1.631,2.146,3.56,4.52,5.73,7.91,24.0]
    
    ; Converting mJy to erg s-1 cm-2 Hz-1
    mjfactor=1d-23*1e-3
    
    
    for xx=0,n_elements(list)-1 do begin
        
        print,list[xx]
        all=tab1[*].source_name
        
        ind=where(strmatch(strcompress(tab1[*].source_name,/remove),strcompress(list[xx],/remove)) eq 1,xcount)
        
        if xcount ne 0 then begin
            obs_flux=tab1[ind].flux*phertz2pmicron(v)*mjfactor
            obs_fluxerr=tab1[ind].flux_error*abs(phertz2pmicron(v)*mjfactor)
            k_lambda=interpol(kappa,wave,v)
            
            micron = '!9' + String("155B) + '!X'
            lambda=  '!9' + String("154B) + '!X' 
             
            
            index=where(tab2.source_id eq tab1[ind].soure_id, count)
             
            minchi=9999.0
             
                       
            ; Looking for best fit SED using chi2 value
            bestsed=where(tab2[index].chi2 eq min(tab2[index].chi2),count)
            subdir=strmid(strcompress(tab2[index[bestsed]].model_name,/remove),0,5)+'/'
            modelname=modelpath+subdir+strcompress(tab2[index[bestsed]].model_name,/remove)+'_sed.fits.gz'
             
            sed=mrdfits(modelname,1,/silent)
            tf=mrdfits(modelname,3,/silent)
             
            k_lambda=interpol(kappa,wave,sed.wavelength)
            a_lambda=tab2[index[bestsed]].av*(k_lambda/k_v) 
            extinc=10^(-0.4*a_lambda)
            scaling=(10^(-tab2[index[bestsed]].scale))^2
                               
            spectrum=tf[4].(0)*extinc*scaling
            photosphere=sed.stellar_flux*scaling*extinc
            
            resetplt,/all 
            set_plot,'ps'
            basename=string(tab1[ind].source_name,format='(A23)')
            pos = STREGEX(basename, ' ', length=len) 
            strput,basename,'_',pos
           
            sedplotname='/tmp/'+basename+'_sed.eps'
            
            device,filename=sedplotname,decomposed=1,$
                 /color,xsize=20,ysize=17,yoffset=0,/encapsulated,$
                 SET_FONT='Helvetica',/TT_FONT
            tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
            red=1
            green=2
            blue=3
            
            chi = '!9' + String("143B) + '!X'
            chistring='(CPD'+chi+'!E2 !N!X ='+string(tab2[index[bestsed]].chi2/total(tab1[ind].valid),format='(f7.3)')+')'
            
            inx=where(tab1[ind].valid gt 0)
            
            if tag_exist(tab1,'c2d') ne 0 then begin
                if tab1[ind].c2d eq 1 then begin
                     sourcetitle=strcompress(tab1[ind].source_name)+' (c2D YSO) '
                endif else begin
                     sourcetitle=strcompress(tab1[ind].source_name)
                endelse
            endif else begin
                sourcetitle=strcompress(tab1[ind].source_name)         
            endelse
            
            
            plot,v[inx],obs_flux[inx],psym=6,xrange=[0.1,100],$
                /xlog,xstyle=1,/ylog,yrange=[min(obs_flux[inx]),1.5*max([obs_flux,photosphere])],charsize=2.0,$
                xtitle='Wavelength (' + micron + 'm)',ytitle=lambda+'F!D'+lambda+'!N!X'+' (ergs cm!E-2!N!Xs!E-1!N!X)',$
                thick=3,xthick=3,ythick=3,font=1,title=sourcetitle
             
            oploterror, v[inx],obs_flux[inx], obs_fluxerr[inx], psym=3, /NOHAT 
            oplot,sed.wavelength, photosphere,line=2, thick=5,color=cgColor("Black")
            oplot,sed.wavelength, spectrum,thick=5,color=cgColor("Red")
            chi = '!9' + String("143B) + '!X'
           
            xyouts,5000,14500,chi+'!E2 !N!X (CPD)='+string(tab2[index[bestsed]].chi2/total(tab1[ind].valid),format='(f7.3)'),$
                 color=0,font=1,charsize=2.0,/device
            
            device,/close
            
            ; Preparing images    
            set_plot,'ps'
            basename=string(tab1[ind].source_name,format='(A23)')
            pos = STREGEX(basename, ' ', length=len) 
            strput,basename,'_',pos
           
            filename='/tmp/'+basename+'_img.eps'
                 
            device,filename=filename,decomposed=0,$
                 /color,xsize=30,ysize=20,yoffset=0,/encapsulated,$
                 SET_FONT='Helvetica',/TT_FONT
            
            multiplot,/default
            multiplot,[0,4,2,0,0],gap=0.0, mTitSize=2.0,/square
            
            pixel=30  ; in the unit of arcsec
            image=[conf.wircampath+'12AT99_J_coadd.fits',$
              conf.wircampath+'12AT99_H_coadd.fits',$
              conf.wircampath+'12AT99_KS_coadd.fits',$
              conf.iracpath+'OPH_ALL_A_IRAC1_mosaic_derot.fits',$
              conf.iracpath+'OPH_ALL_A_IRAC2_mosaic_derot.fits',$
              conf.iracpath+'OPH_ALL_A_IRAC3_mosaic_derot.fits',$
              conf.iracpath+'OPH_ALL_A_IRAC4_mosaic_derot.fits',$
              conf.mipspath+'OPH_ALL_A_MIPS1_mosaic_derot.fits']
            
            res=strsplit(adstring([tab1[ind].x,tab1[ind].y]),/extract) 
            pos=res[0]+':'+res[1]+':'+res[2]+' '+res[3]+':'+res[4]+':'+res[5]
                   
            filter=['J','H','K','I1','I2','I3','I4','M1']       
                  
            for j=0, n_elements(filter)-1 do begin
                pixel=30
                hd=headfits(image[j])
                scale=strcompress(string(ceil(pixel/(sxpar(hd,'CD2_2')*3600))),/remove)
                scale_deg=strcompress(string(ceil(pixel/(sxpar(hd,'CD2_2')))),/remove)
                outname=strcompress(string(tab1[ind].source_name),/remove)+'_'+filter[j]+'.fits'
                
                if j le 2 then begin 
                    spawn,'mSubimage '+image[j]+' /tmp/'+outname+' '+$
                       string(tab1[ind].x,format='(f12.6)')+' '+$
                       string(tab1[ind].y,format='(f12.6)')+' '+$
                       string(pixel/3600.0,format='(f10.6)')+' 1>>/dev/null 2>> /dev/null'
                endif else begin
                    spawn,'getfits -o /tmp/'+outname+' '+image[j]+' '+$
                       pos+' '+scale+' '+scale+' 1>>/dev/null 2>> /dev/null'              
                endelse
                im=readfits('/tmp/'+outname,hd,/silent) 
                pixel=sxpar(hd,'NAXIS1')
                
                xrange=pixel*sxpar(hd,'CD2_2')*3600
                !x.range=[-(xrange/2-1),(xrange/2-1)]
                !y.range=[-(xrange/2-1),(xrange/2-1)]
                !p.font=1 
                !x.charsize = 1.5 & !y.charsize=1.5
                 
                ; Rescale image maximum to 256
                newim=im*(256/max(im))
                med=median(newim)
                meddev=median(abs(newim-med))
                factor=20.0
                loadct,0
                th_image_cont,newim,/nocont,/nobar,crange=[0,med+factor*meddev]
                xyouts,10,11,filter[j],charsize=2.0,font=1  
                multiplot
                 
            endfor
        
            device,/close
            set_plot,'x'
              
            multiplot,/default
            resetplt,/all
            
            makemergedfig,sedfig='/tmp/'+basename+'_sed.eps',imgfig='/tmp/'+basename+'_img.eps',$
                finalfig='/tmp/'+basename+'.eps'
            spawn,'ps2pdf '+'/tmp/'+basename+'.eps'+' /tmp/'+basename+'.pdf'
            
            if keyword_set(path) then begin
                spawn,'mv /tmp/'+basename+'.eps '+path
                spawn,'mv /tmp/'+basename+'.pdf '+path
            endif
        endif
    endfor
    
END


PRO GETSTARSEDIMAGE, FITS=fits, LIST=list, PATH=path, ALL=all

    COMMON share,conf
    loadconfig
    
       
    tab1=mrdfits(fits,1,mhd,/Silent)
    tab2=mrdfits(fits,2,/Silent)
    
     if keyword_set(all) then list=tab1[*].source_name
    
    if strcmp(!VERSION.OS,'linux') then begin 
       modelpath='/data/capella/chyan/Models/models_r06/seds/'
    endif else begin
       modelpath='/Volumes/Science/Models/models_kurucz/seds/'
    endelse
    
    ; Read extinction law 
    exfile='~/IDLSourceCode/Science/RhoOph/extinction_law.ascii'
    readcol,exfile,wave,kappa,/silent
    k_v=211.4
    
    v=[1.252,1.631,2.146,3.56,4.52,5.73,7.91,24.0]
    
    ; Converting mJy to erg s-1 cm-2 Hz-1
    mjfactor=1d-23*1e-3
    
    
    for xx=0,n_elements(list)-1 do begin
        
        print,list[xx]
        all=tab1[*].source_name
        
        ind=where(strmatch(strcompress(tab1[*].source_name,/remove),strcompress(list[xx],/remove)) eq 1,xcount)
        
        if xcount ne 0 then begin
            obs_flux=tab1[ind].flux*phertz2pmicron(v)*mjfactor
            obs_fluxerr=tab1[ind].flux_error*abs(phertz2pmicron(v)*mjfactor)
             
            k_lambda=interpol(kappa,wave,v)
            
            micron = '!9' + String("155B) + '!X'
            lambda=  '!9' + String("154B) + '!X' 
             
            
            index=where(tab2.source_id eq tab1[ind].soure_id, count)
             
            minchi=9999.0
             
                       
            ; Looking for best fit SED using chi2 value
            bestsed=where(tab2[index].chi2 eq min(tab2[index].chi2),count)
            ;subdir=strmid(strcompress(tab2[index[bestsed]].model_name,/remove),0,5)+'/'
            modelname=modelpath+strcompress(tab2[index[bestsed]].model_name,/remove)+'_sed.fits'
             
            sed=mrdfits(modelname,1,/silent)
            tf=mrdfits(modelname,3,/silent)
             
            k_lambda=interpol(kappa,wave,sed.wavelength)
            a_lambda=tab2[index[bestsed]].av*(k_lambda/k_v) 
            extinc=10^(-0.4*a_lambda)
            scaling=(10^(-tab2[index[bestsed]].scale))^2
            spectrum=tf[0].(0)*phertz2pmicron(sed.wavelength)*mjfactor*extinc*scaling
            photosphere=sed.stellar_flux*phertz2pmicron(sed.wavelength)*mjfactor*extinc*scaling
            
            resetplt,/all 
            set_plot,'ps'
            basename=string(tab1[ind].source_name,format='(A23)')
            pos = STREGEX(basename, ' ', length=len) 
            strput,basename,'_',pos
           
            sedplotname='/tmp/'+basename+'_sed.eps'
            
            device,filename=sedplotname,decomposed=1,$
                 /color,xsize=20,ysize=17,yoffset=0,/encapsulated,$
                 SET_FONT='Helvetica',/TT_FONT
            tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
            red=1
            green=2
            blue=3
            
            chi = '!9' + String("143B) + '!X'
            chistring='(CPD'+chi+'!E2 !N!X ='+string(min(tab2[index].chi2),format='(f7.3)')+')'
            
            inx=where(tab1[ind].valid gt 0)
            plot,v[inx],obs_flux[inx],psym=6,xrange=[0.1,100],$
                /xlog,xstyle=1,/ylog,yrange=[min(obs_flux[inx]),1.5*max([obs_flux,spectrum])],charsize=2.0,$
                xtitle='Wavelength (' + micron + 'm)',ytitle=lambda+'F!D'+lambda+'!N!X'+' (ergs cm!E-2!N!Xs!E-1!N!X)',$
                thick=3,xthick=3,ythick=3,font=1,title=strcompress(tab1[ind].source_name)
             
            oploterror, v[inx],obs_flux[inx], obs_fluxerr[inx], psym=3, /NOHAT 
            oplot,sed.wavelength, photosphere,line=2, thick=5,color=cgColor("Black")
            oplot,sed.wavelength, spectrum,thick=5,color=cgColor("Red")
            chi = '!9' + String("143B) + '!X'
           
            xyouts,5000,14500,chi+'!E2 !N!X (CPD)='+string(tab2[index[bestsed]].chi2/total(tab1[ind].valid),format='(f7.3)'),$
                 color=0,font=1,charsize=2.0,/device
            
            device,/close
            
            ; Preparing images    
            set_plot,'ps'
            basename=string(tab1[ind].source_name,format='(A23)')
            pos = STREGEX(basename, ' ', length=len) 
            strput,basename,'_',pos
           
            filename='/tmp/'+basename+'_img.eps'
                 
            device,filename=filename,decomposed=0,$
                 /color,xsize=30,ysize=20,yoffset=0,/encapsulated,$
                 SET_FONT='Helvetica',/TT_FONT
            
            multiplot,/default
            multiplot,[0,4,2,0,0],gap=0.0, mTitSize=2.0,/square
            
            pixel=30  ; in the unit of arcsec
            image=[conf.wircampath+'12AT99_J_coadd.fits',$
              conf.wircampath+'12AT99_H_coadd.fits',$
              conf.wircampath+'12AT99_KS_coadd.fits',$
              conf.iracpath+'OPH_ALL_A_IRAC1_mosaic_derot.fits',$
              conf.iracpath+'OPH_ALL_A_IRAC2_mosaic_derot.fits',$
              conf.iracpath+'OPH_ALL_A_IRAC3_mosaic_derot.fits',$
              conf.iracpath+'OPH_ALL_A_IRAC4_mosaic_derot.fits',$
              conf.mipspath+'OPH_ALL_A_MIPS1_mosaic_derot.fits']
            
            res=strsplit(adstring([tab1[ind].x,tab1[ind].y]),/extract) 
            pos=res[0]+':'+res[1]+':'+res[2]+' '+res[3]+':'+res[4]+':'+res[5]
                   
            filter=['J','H','K','I1','I2','I3','I4','M1']       
                  
            for j=0, n_elements(filter)-1 do begin
                pixel=30
                hd=headfits(image[j])
                scale=strcompress(string(ceil(pixel/(sxpar(hd,'CD2_2')*3600))),/remove)
                scale_deg=strcompress(string(ceil(pixel/(sxpar(hd,'CD2_2')))),/remove)
                outname=strcompress(string(tab1[ind].source_name),/remove)+'_'+filter[j]+'.fits'
                
                if j le 2 then begin 
                    spawn,'mSubimage '+image[j]+' /tmp/'+outname+' '+$
                       string(tab1[ind].x,format='(f12.6)')+' '+$
                       string(tab1[ind].y,format='(f12.6)')+' '+$
                       string(pixel/3600.0,format='(f10.6)')+' 1>>/dev/null 2>> /dev/null'
                endif else begin
                    spawn,'getfits -o /tmp/'+outname+' '+image[j]+' '+$
                       pos+' '+scale+' '+scale+' 1>>/dev/null 2>> /dev/null'              
                endelse
                im=readfits('/tmp/'+outname,hd,/silent) 
                pixel=sxpar(hd,'NAXIS1')
                
                xrange=pixel*sxpar(hd,'CD2_2')*3600
                !x.range=[-(xrange/2-1),(xrange/2-1)]
                !y.range=[-(xrange/2-1),(xrange/2-1)]
                !p.font=1 
                !x.charsize = 1.5 & !y.charsize=1.5
                 
                ; Rescale image maximum to 256
                newim=im*(256/max(im))
                med=median(newim)
                meddev=median(abs(newim-med))
                factor=20.0
                loadct,0
                th_image_cont,newim,/nocont,/nobar,crange=[0,med+factor*meddev]
                xyouts,10,11,filter[j],charsize=2.0,font=1  
                multiplot
                 
            endfor
        
            device,/close
            set_plot,'x'
              
            multiplot,/default
            resetplt,/all
            
            makemergedfig,sedfig='/tmp/'+basename+'_sed.eps',imgfig='/tmp/'+basename+'_img.eps',$
                finalfig='/tmp/'+basename+'.eps'
            spawn,'ps2pdf '+'/tmp/'+basename+'.eps'+' /tmp/'+basename+'.pdf'
            
            if keyword_set(path) then begin
                spawn,'mv /tmp/'+basename+'.eps '+path
                spawn,'mv /tmp/'+basename+'.pdf '+path
            endif
        endif
    endfor




END





PRO EXTRACTIMAGE,SEDPATH=sedpath, file=file, IMAGEPATH=imagepath,PS=ps
   COMMON share,conf
   loadconfig
   
   if keyword_set(SEDPATH) then begin
      plotpath=sedpath+'/plots_yso_good/'
   endif else begin
      plotpath='/data/local/chyan/SEDProject/L1709YSO/plots_yso_good/'
   endelse
  
   if keyword_set(IMAGEPATH) then begin
      
   endif else begin
      imagepath=conf.imagepath
   endelse

   table=mrdfits(conf.fitspath+file,1)
   filter=['J','H','K','I1','I2','I3','I4','M1']  
   resetplt,/all   
   spawn,'rm -rf /tmp/*.eps'
   
   spawn,"rm -rf /tmp/ysoname.txt"
   spawn, "ssh chyan@capella findyso --ra="+strcompress(string(mean(table.x)),/remove)+$
      " --dec="+strcompress(string(mean(table.y)),/remove)+$
      ;" --dra="+strcompress(string(abs(max(tab1.x)-min(tab1.x))/2.0,/remove)+$
      ;" --ddec="+strcompress(string(string(abs(max(tab1.y)-min(tab1.y))/2.0,/remove)+$
      " --cat=oph  --rad=100 > /tmp/ysoname.txt"
   
   readcol,'/tmp/ysoname.txt',format='(f,a,a,f,f,f)',id,sstc2d,c2dnames,ra,dec,slope
   print,c2dnames
   ; Loop through each source
   for i=0,n_elements(table.(0))-1 do begin
   ;for i=0,2 do begin 
      
      ; check if this source is in c2d detection list
      newstring=strmid(table[i].source_name,7,16)
      ind=where(strmatch(c2dnames,newstring) eq 1,count)
      
      if keyword_set(PS) then begin 
         set_plot,'ps'
         basename=string(table[i].source_name,format='(A23)')
         pos = STREGEX(basename, ' ', length=len) 
         strput,basename,'_',pos
   
         ;filename='/tmp/'+basename+'_'+strcompress(string(j),/remove)+'.eps'
         filename='/tmp/'+basename+'.eps'
         
         device,filename=filename,$
         /color,xsize=30,ysize=17,yoffset=20,/encapsulated,$
         SET_FONT='Helvetica',/TT_FONT
         
         ;tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
         
      endif else begin
         basename=string(table[i].source_name,format='(A23)')

      endelse

      multiplot,/default
      if count ne 0 then begin
         multiplot,[0,4,2,0,0],gap=0.0,mTitle=basename+'(c2D)', mTitSize=2.0,/square
      endif else begin
         multiplot,[0,4,2,0,0],gap=0.0,mTitle=basename, mTitSize=2.0,/square
      endelse
      
      
      !p.font = 1
      !p.charsize = 1.0
      
      for j=0, n_elements(filter)-1 do begin
         fits=strcompress(string(table[i].source_name),/remove)+'_'+filter[j]+'.fits' 
           
                  
         im=readfits(conf.tnpath+fits,hd,/silent)
         pixel=sxpar(hd,'NAXIS1')
         xrange=pixel*sxpar(hd,'CD2_2')*3600
         
         !x.range=[-(xrange/2-1),(xrange/2-1)]
         !y.range=[-(xrange/2-1),(xrange/2-1)]
         
         !x.charsize = 1.5 & !y.charsize=1.5
         
         ; Rescale image maximum to 256
         newim=im*(256/max(im))
         med=median(newim)
         meddev=median(abs(newim-med))
         factor=20.0
         ;plot,findgen(10)
         th_image_cont,newim,/nocont,/nobar,crange=[0,med+factor*meddev],ct=0
         xyouts,10,11,filter[j],charsize=2.0,font=1  
         multiplot
      endfor
      
      
      if keyword_set(PS) then begin 
         device,/close
         set_plot,'x'
      endif
      
      multiplot,/default
      resetplt,/all
      
      ; Put image with SED plot
     ; plotpath='/data/local/chyan/SEDProject/RhoReg2/plots_yso_good/'
      ;plotpath=sedplotpath
      newstring=strmid(table[i].source_name,7,16)
      sedplot=plotpath+'SSTc2d_'+newstring+'.eps'
      
      spawn,'epsmerge -o /tmp/sedtmp.eps -cs 0 -prs 1 -p A4 -O landscape -x 1 -y 1 '+sedplot
      spawn,'epsmerge -o /tmp/'+basename+'a.eps -cs 0 -prs 1 -p A4 -x 1 -y 2 -ycs 0 /tmp/sedtmp.eps '+filename
      
      spawn,'convert /tmp/'+basename+'a.eps '+'/tmp/'+basename+'.jpg'
      spawn,'cp /tmp/'+basename+'.jpg '+imagepath
      
   endfor
   resetplt,/all
   spawn,'epsmerge -o '+conf.pspath+ps+' -cs 0 -prs 1 -p A4 -x 1 -y 1 /tmp/*a.eps' 
   spawn,'rm -rf /tmp/*.eps'
   spawn,'rm -rf /tmp/*.jpg'
   ;!p.multi=0
END


PRO REMAPL1689
   COMMON share,conf
   loadconfig
   
   filter=['J','H','Ks']
   
   for i=0,n_elements(filter)-1 do begin
       
       ; cut the a subregion from L1688 image
       spawn,'getfits -o '+conf.wircampath+'L1689_part_'+filter[i]+'.fits'+$
          ' '+conf.wircampath+'L1688_'+filter[i]+'.fits'+' '+$
          '16:30:42 -24:30:03 -x 4864 12624'
       
       ; Making a badpixel mask for this subregion    
       im=readfits(conf.wircampath+'L1689_part_'+filter[i]+'.fits')
       s=size(im)
       mask=fltarr(s[1],s[2])
       mask[*,*]=1
       ind=where(im eq 0)
       mask[ind]=0
       
       writefits,conf.wircampath+'L1689_part_'+filter[i]+'.weight.fits',mask

       ; Also make a badpixel mask for L1689 region   
       im=readfits(conf.wircampath+'L1689_'+filter[i]+'.fits')
       hd=headfits(conf.wircampath+'L1689_'+filter[i]+'.fits')
       scale=3600*sxpar(hd,'CD2_2')
       s=size(im)
       mask=fltarr(s[1],s[2])
       mask[*,*]=1
       ind=where(im eq 0)
       mask[ind]=0
       mask[9328:9560,8873:9200]=0
       writefits,conf.wircampath+'L1689_'+filter[i]+'.weight.fits',mask
       
       ; Change to WIRCam path
       cd,conf.wircampath,current=old_dir
       
       ; Mosaic them with SWARP
       spawn,'swarp -c swarp.conf '+'L1689_'+filter[i]+'.fits '+'L1689_part_'+filter[i]+'.fits '+$
            ' -PIXEL_SCALE 0.305 -PIXELSCALE_TYPE MANUAL -RESAMPLING_TYPE NEAREST -SUBTRACT_BACK N'+$
            ' -WEIGHT_TYPE MAP_WEIGHT -WEIGHT_THRESH 0 -BLANK_BADPIXELS Y'
       spawn,'mv coadd.fits L1689_remap_'+filter[i]+'.fits'
       spawn,'mv coadd.weight.fits L1689_remap_'+filter[i]+'.weight.fits'
       
       cd,old_dir

   endfor


END


PRO REMAPL1709
   COMMON share,conf
   loadconfig
   
   filter=['J','H','Ks']
   
   for i=0,n_elements(filter)-1 do begin
       
       ; cut the a subregion from L1688 image
       spawn,'getfits -o '+conf.wircampath+'L1709_remap_'+filter[i]+'.fits'+$
          ' '+conf.wircampath+'L1709_'+filter[i]+'.fits'+' '+$
          '16:32:35 -23:39:46 -x 21400 8096'
       
       spawn,'getfits -o '+conf.wircampath+'L1709_remap_'+filter[i]+'.weight.fits'+$
          ' '+conf.wircampath+'L1709_'+filter[i]+'.weight.fits'+' '+$
          '16:32:35 -23:39:46 -x 21400 8096'

   endfor


END

