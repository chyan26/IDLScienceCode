PRO LOADCONFIG
   COMMON share,config
   
   ;Settings for HOME computer
   ;imgpath = '/Volumes/disk1s1/oph_region34/'
   ;mappath = '/Volumes/disk1s1/oph_region34/'
   
   ;Settings for ASIAA computer
   ;imgpath='/data/chyan/ScienceImages/RhoOph/WIRCam/'
   ;mappath='/arrays/cfht/cfht_2/chyan/home/Science/RhoOph/'
   
   catpath='/data/chyan/Projects/RhoOphData/'
   ;catpath='/Volumes/disk1s1/OphData/'
    
   config={catpath:catpath}
    
END

PRO REPLACEHEADER, hd
   sxaddpar, hd, 'TTYPE1  ', 'project '
   sxaddpar, hd, 'TTYPE2  ', 'c2did'
   sxaddpar, hd, 'TTYPE3  ', 'RA'
   sxaddpar, hd, 'TTYPE4  ', 'D_RA'
   sxaddpar, hd, 'TTYPE5  ', 'dec'
   sxaddpar, hd, 'TTYPE6  ', 'D_dec'
   sxaddpar, hd, 'TTYPE7  ', 'Q_pos'
   sxaddpar, hd, 'TTYPE8  ', 'Q_merge'
   sxaddpar, hd, 'TTYPE9  ', 'id2mass'
   sxaddpar, hd, 'TTYPE10 ', 'Prob_Galc'
   sxaddpar, hd, 'TTYPE11 ', 'alpha'
   sxaddpar, hd, 'TTYPE12 ', 'D_alpha'
   sxaddpar, hd, 'TTYPE13 ', 'alpha_chi2'
   sxaddpar, hd, 'TTYPE14 ', 'alpha_nfit'
   sxaddpar, hd, 'TTYPE15 ', 'object_type'
   sxaddpar, hd, 'TTYPE16 ', 'Av'
   sxaddpar, hd, 'TTYPE17 ', 'D_Av'
   sxaddpar, hd, 'TTYPE18 ', 'mag_IR1'
   sxaddpar, hd, 'TTYPE19 ', 'D_mag_IR1'
   sxaddpar, hd, 'TTYPE20 ', 'Av_chi2'
   sxaddpar, hd, 'TTYPE21 ', 'Av_nfit'
   sxaddpar, hd, 'TTYPE22 ', 'J_flux_c'
   sxaddpar, hd, 'TTYPE23 ','J_D_flux_c'
   sxaddpar, hd, 'TTYPE24 ','J_date_c'
   sxaddpar, hd, 'TTYPE25 ','J_Q_det_c'
   sxaddpar, hd, 'TTYPE26 ','H_flux_c'
   sxaddpar, hd, 'TTYPE27 ','H_D_flux_c'
   sxaddpar, hd, 'TTYPE28 ','H_date_c'
   sxaddpar, hd, 'TTYPE29 ','H_Q_det_c'
   sxaddpar, hd, 'TTYPE30 ','Ks_flux_c'
   sxaddpar, hd, 'TTYPE31 ','Ks_D_flux_c'
   sxaddpar, hd, 'TTYPE32 ','Ks_date_c'
   sxaddpar, hd, 'TTYPE33 ','Ks_Q_det_c'
   sxaddpar, hd, 'TTYPE34 ','IR1_flux_1'
   sxaddpar, hd, 'TTYPE35 ','IR1_D_flux_1'
   sxaddpar, hd, 'TTYPE36 ','IR1_date_1'
   sxaddpar, hd, 'TTYPE37 ','IR1_Q_det_1'
   sxaddpar, hd, 'TTYPE38 ','IR1_flux_2'
   sxaddpar, hd, 'TTYPE39 ','IR1_D_flux_2'
   sxaddpar, hd, 'TTYPE40 ','IR1_date_2'
   sxaddpar, hd, 'TTYPE41 ','IR1_Q_det_2'
   sxaddpar, hd, 'TTYPE42 ','IR1_flux_c'
   sxaddpar, hd, 'TTYPE43 ','IR1_D_flux_c'
   sxaddpar, hd, 'TTYPE44 ','IR1_date_c'
   sxaddpar, hd, 'TTYPE45 ','IR1_Q_det_c'
   sxaddpar, hd, 'TTYPE46 ','IR1_Q_flux_m'
   sxaddpar, hd, 'TTYPE47 ','IR1_imtype'
   sxaddpar, hd, 'TTYPE48 ','IR1_src_area'
   sxaddpar, hd, 'TTYPE49 ','IR1_amajor'
   sxaddpar, hd, 'TTYPE50 ','IR1_aminor'
   sxaddpar, hd, 'TTYPE51 ','IR1_tilt'
   sxaddpar, hd, 'TTYPE52 ','IR2_flux_1'
   sxaddpar, hd, 'TTYPE53 ','IR2_D_flux_1'
   sxaddpar, hd, 'TTYPE54 ','IR2_date_1'
   sxaddpar, hd, 'TTYPE55 ','IR2_Q_det_1'
   sxaddpar, hd, 'TTYPE56 ','IR2_flux_2'
   sxaddpar, hd, 'TTYPE57 ','IR2_D_flux_2'
   sxaddpar, hd, 'TTYPE58 ','IR2_date_2'
   sxaddpar, hd, 'TTYPE59 ','IR2_Q_det_2'
   sxaddpar, hd, 'TTYPE60 ','IR2_flux_c'
   sxaddpar, hd, 'TTYPE61 ','IR2_D_flux_c'
   sxaddpar, hd, 'TTYPE62 ','IR2_date_c'
   sxaddpar, hd, 'TTYPE63 ','IR2_Q_det_c'
   sxaddpar, hd, 'TTYPE64 ','IR2_Q_flux_m'
   sxaddpar, hd, 'TTYPE65 ','IR2_imtype'
   sxaddpar, hd, 'TTYPE66 ','IR2_src_area'
   sxaddpar, hd, 'TTYPE67 ','IR2_amajor'
   sxaddpar, hd, 'TTYPE68 ','IR2_aminor'
   sxaddpar, hd, 'TTYPE69 ','IR2_tilt'
   sxaddpar, hd, 'TTYPE70 ','IR3_flux_1'
   sxaddpar, hd, 'TTYPE71 ','IR3_D_flux_1'
   sxaddpar, hd, 'TTYPE72 ','IR3_date_1'
   sxaddpar, hd, 'TTYPE73 ','IR3_Q_det_1'
   sxaddpar, hd, 'TTYPE74 ','IR3_flux_2'
   sxaddpar, hd, 'TTYPE75 ','IR3_D_flux_2'
   sxaddpar, hd, 'TTYPE76 ','IR3_date_2'
   sxaddpar, hd, 'TTYPE77 ','IR3_Q_det_2'
   sxaddpar, hd, 'TTYPE78 ','IR3_flux_c'
   sxaddpar, hd, 'TTYPE79 ','IR3_D_flux_c'
   sxaddpar, hd, 'TTYPE80 ','IR3_date_c'
   sxaddpar, hd, 'TTYPE81 ','IR3_Q_det_c'
   sxaddpar, hd, 'TTYPE82 ','IR3_Q_flux_m'
   sxaddpar, hd, 'TTYPE83 ','IR3_imtype'
   sxaddpar, hd, 'TTYPE84 ','IR3_src_area'
   sxaddpar, hd, 'TTYPE85 ','IR3_amajor'
   sxaddpar, hd, 'TTYPE86 ','IR3_aminor'
   sxaddpar, hd, 'TTYPE87 ','IR3_tilt'
   sxaddpar, hd, 'TTYPE88 ','IR4_flux_1'
   sxaddpar, hd, 'TTYPE89 ','IR4_D_flux_1'
   sxaddpar, hd, 'TTYPE90 ','IR4_date_1'
   sxaddpar, hd, 'TTYPE91 ','IR4_Q_det_1'
   sxaddpar, hd, 'TTYPE92 ','IR4_flux_2'
   sxaddpar, hd, 'TTYPE93 ','IR4_D_flux_2'      
   sxaddpar, hd, 'TTYPE94 ','IR4_date_2'          
   sxaddpar, hd, 'TTYPE95 ','IR4_Q_det_2'          
   sxaddpar, hd, 'TTYPE96 ','IR4_flux_c'          
   sxaddpar, hd, 'TTYPE97 ','IR4_D_flux_c'          
   sxaddpar, hd, 'TTYPE98 ','IR4_date_c'          
   sxaddpar, hd, 'TTYPE99 ','IR4_Q_det_c'          
   sxaddpar, hd, 'TTYPE100','IR4_Q_flux_m'          
   sxaddpar, hd, 'TTYPE101','IR4_imtype'          
   sxaddpar, hd, 'TTYPE102','IR4_src_area'          
   sxaddpar, hd, 'TTYPE103','IR4_amajor'          
   sxaddpar, hd, 'TTYPE104','IR4_aminor'          
   sxaddpar, hd, 'TTYPE105','IR4_tilt'          
   sxaddpar, hd, 'TTYPE106','MP1_flux_1'          
   sxaddpar, hd, 'TTYPE107','MP1_D_flux_1'          
   sxaddpar, hd, 'TTYPE108','MP1_date_1'          
   sxaddpar, hd, 'TTYPE109','MP1_Q_det_1'          
   sxaddpar, hd, 'TTYPE110','MP1_flux_2'          
   sxaddpar, hd, 'TTYPE111','MP1_D_flux_2'          
   sxaddpar, hd, 'TTYPE112','MP1_date_2'          
   sxaddpar, hd, 'TTYPE113','MP1_Q_det_2'          
   sxaddpar, hd, 'TTYPE114','MP1_flux_c'          
   sxaddpar, hd, 'TTYPE115','MP1_D_flux_c'          
   sxaddpar, hd, 'TTYPE116','MP1_date_c'          
   sxaddpar, hd, 'TTYPE117','MP1_Q_det_c'          
   sxaddpar, hd, 'TTYPE118','MP1_Q_flux_m'          
   sxaddpar, hd, 'TTYPE119','MP1_imtype'          
   sxaddpar, hd, 'TTYPE120','MP1_src_area'          
   sxaddpar, hd, 'TTYPE121','MP1_amajor'          
   sxaddpar, hd, 'TTYPE122','MP1_aminor'          
   sxaddpar, hd, 'TTYPE123','MP1_tilt'          
   sxaddpar, hd, 'TTYPE124','MP2_flux_1'          
   sxaddpar, hd, 'TTYPE125','MP2_D_flux_1'          
   sxaddpar, hd, 'TTYPE126','MP2_date_1'          
   sxaddpar, hd, 'TTYPE127','MP2_Q_det_1'          
   sxaddpar, hd, 'TTYPE128','MP2_flux_2'          
   sxaddpar, hd, 'TTYPE129','MP2_D_flux_2'          
   sxaddpar, hd, 'TTYPE130','MP2_date_2'          
   sxaddpar, hd, 'TTYPE131','MP2_Q_det_2'          
   sxaddpar, hd, 'TTYPE132','MP2_flux_c'          
   sxaddpar, hd, 'TTYPE133','MP2_D_flux_c'          
   sxaddpar, hd, 'TTYPE134','MP2_date_c'          
   sxaddpar, hd, 'TTYPE135','MP2_Q_det_c'          
   sxaddpar, hd, 'TTYPE136','MP2_Q_flux_m'          
   sxaddpar, hd, 'TTYPE137','MP2_imtype'          
   sxaddpar, hd, 'TTYPE138','MP2_src_area'          
   sxaddpar, hd, 'TTYPE139','MP2_amajor'          
   sxaddpar, hd, 'TTYPE140','MP2_aminor'          
   sxaddpar, hd, 'TTYPE141','MP2_tilt' 
   
   return
END

PRO UPDATEFITS, im
   COMMON share,config
   loadconfig
   
   file=['catalog-c2d-yso.fits','catalog-c2d-hrel.fits']
   
   for i=0,1 do begin
     hd=headfits(config.catpath+file[i],/ext)
     replaceheader,hd
     ;print,hd
     modfits,config.catpath+file[i],0,hd,/ext
   endfor
   return
END

PRO EXTRACTPHOT,cat, filename
  COMMON share,config
  loadconfig
  
  close,1
  openw,1,config.catpath+filename
  for i=0, n_elements(cat.ra)-1 do begin
    dj=1  & dh=1  &  dk=1
    dir1=1 & dir2=1 & dir3=1 & dir4=1
    dmp1=1 & dmp2=1
 
    if (cat.j_flux_c[i] gt 0) then dj1=1 else dj=0
    if (cat.h_flux_c[i] gt 0) then dh=1 else dh=0
    if (cat.ks_flux_c[i] gt 0) then dk=1 else dk=0
    if (cat.ir1_flux_c[i] gt 0) then dir1=1 else dir1=0
    if (cat.ir2_flux_c[i] gt 0) then dir2=1 else dir2=0
    if (cat.ir3_flux_c[i] gt 0) then dir3=1 else dir3=0
    if (cat.ir4_flux_c[i] gt 0) then dir4=1 else dir4=0    
    if (cat.mp1_flux_c[i] gt 0) then dmp1=1 else dmp1=0
    if (cat.mp2_flux_c[i] gt 0) then dmp2=1 else dmp2=0
    
    ;print,cat.mp2_flux_c[i],dmp2
    printf,1,format='(A30,2(1X,F9.5),9(1X,I1),18(1X,E11.4))',$
      cat.c2did[i],cat.ra[i],cat.dec[i],$
      dj,dh,dk,dir1,dir2,dir3,dir4,dmp1,dmp2,$
      cat.j_flux_c[i],cat.j_d_flux_c[i],$
      cat.h_flux_c[i],cat.h_d_flux_c[i],$
      cat.ks_flux_c[i],cat.ks_d_flux_c[i],$
      cat.ir1_flux_c[i],cat.ir1_d_flux_c[i],$
      cat.ir2_flux_c[i],cat.ir2_d_flux_c[i],$
      cat.ir3_flux_c[i],cat.ir3_d_flux_c[i],$
      cat.ir4_flux_c[i],cat.ir4_d_flux_c[i],$
      cat.mp1_flux_c[i],cat.mp1_d_flux_c[i],$
      cat.mp2_flux_c[i],cat.mp2_d_flux_c[i]      
  
  endfor
  close,1
END

PRO  C2DCATALOG 
  COMMON share,config
  loadconfig
  
  file=['catalog-c2d-yso.fits'];,'catalog-c2d-hrel.fits']
  sedcat=['yso_source.cat'];,'star_source.cat']
  
  for i=0,n_elements(file)-1 do begin
    tab=mrdfits(config.catpath+file[i],1)
    extractphot,tab,sedcat[i]
  endfor
END


