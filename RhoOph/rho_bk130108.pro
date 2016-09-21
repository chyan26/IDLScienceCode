;
;  This is the main program for running all the analysis.
@imaging
@obsregion
@photometry
@fluxcalib
@catalog
@diagrams
@stat
@stellaranalysis
@swire
@getseries
@sgc2dysotest
@sgfilter
@cmdfilter
@ysoanalysis
@fluxfilter
@complimit
@fluxestimator
@sedimageinspect
@removeyso
@wircam12a

PRO LOADCONFIG
  COMMON share,conf
  
  ;Settings for HOME computer
  ;imgpath = '/Volumes/disk1s1/Projects/S233IR/'
  ;mappath = '/Volumes/disk1s1/Projects/S233IR/'
  
  ;Settings for ASIAA computer
  if strcmp(!VERSION.OS,'linux') then begin 
     path='/data/disk/chyan/Projects/Ophiuchus/'
     modelpath='/data/capella/chyan/Models/models_r06/seds/'
     ;sedpath='/data/disk/chyan/Projects/Ophiuchus/'
  endif else begin
     path='/Volumes/Data/Projects/Ophiuchus/'
     modelpath='/Volumes/Data/Models/models_r06/seds/'
     ;sedpath='/Volumes/Data/Projects/SEDProject/'
     
  endelse
   
   wircampath=path+'WIRCam/'
   fitspath=path+'FITS/'
   pspath=path+'PS/'
   iracpath=path+'IRAC/'
   mipspath=path+'MIPS/'
   catpath=path+'Catalog/'
   regpath=path+'Regions/'
   imagepath=path+'Image/'
   confpath=path+'Config/'
   extpath=path+'ExtinctionMap/'
   tnpath=path+'Thumbnail/'
   swirepath=path+'SWIRE/'
   sedplot=path+'SEDPlot/'
   conf={path:path,wircampath:wircampath,fitspath:fitspath,pspath:pspath,$
      imagepath:imagepath,iracpath:iracpath,catpath:catpath,regpath:regpath,$
      confpath:confpath,sedpath:sedplot,extpath:extpath,tnpath:tnpath,mipspath:mipspath,$
      swirepath:swirepath,modelpath:modelpath}  
END


PRO SYNCPROJECTDATA
   COMMON share,conf 
   loadconfig

   if (file_test(conf.path) and strcmp(!VERSION.OS,'darwin')) then begin
       print,'Backing up data to Procyon.'
       spawn,'rsync -arvzu '+conf.path+'* -e ssh chyan@procyon:/data/procyon/Projects/Ophiuchus/  --progress'
   endif

end

;  The SWIRE data is used to exam the detection ability of SED fitter
PRO SWIREDATA
   COMMON share,conf 
   loadconfig

   spawn,'ssh chyan@capella swirecat --flux > '+conf.catpath+'swire_n1_flux.cat'
   getswireflux,conf.catpath+'swire_n1_flux.cats',cat
   swiresedcat,cat,file=conf.catpath+'swire_sed.cat'

   spawn,'rsync -arvz  -e ssh chyan@capella:/data/local/chyan/SEDProject/SWIRE/sedfitter/output_yso_*.fits '+$
      conf.swirepath+'/'
      
   fluxfilter, fit=conf.swirepath+'output_yso_good.fits',newfits=conf.swirepath+'swire_fluxfilter.fits'
   examysocandidate,fits=conf.swirepath+'swire_fluxfilter.fits',sedfitspath='/data/local/chyan/SEDProject/SWIRE/sedfitter'
   
   ysocmd, file=conf.swirepath+'output_yso_good.fits',outfile='swireysocmd.eps',/ps
   
   cmdfilterplot,file=conf.swirepath+'output_yso_good.fits',ps='swire_cmdfilter.eps'   
   cmdfilter, fits=conf.swirepath+'output_yso_good.fits',$
      newfits=conf.swirepath+'output_yso_cmdfilter.fits'
END

PRO PUSHCODETOIAA

  spawn,'rsync -arvz --delete /Users/chyan/idl_script/Projects/RhoOph/*.pro -e ssh chyan@procyon '

end


PRO RHO
   COMMON share,conf 
   loadconfig
   
   resizeimage
   loadregion2,im
   
   ;--------------------------------------------------
   ; Clibration the photometry
   ;--------------------------------------------------
	 runsextractor
   getstar,cat
   find2mass,ref
   fluxcalib,cat, ref, /ps, filename='fluxcalib.ps'
   ;--------------------------------------------------
   
   ; Get MIPS selected stars with detection quality A and B
   spawn,'ssh chyan@capella findmir --ra=247.97944 --dec=-24.52919 >'$
      +conf.catpath+'/source_mips_AB.cat'
   
	
	; Gettng MIPS selected stars and plot DS9 region file
   spawn,'ssh chyan@capella findmir --ra=247.97944 --dec=-24.52919 --ds9>'$
      +conf.regpath+'/source_mips_AB.reg'
   
   ; Plotting c2d YSOs in this region  
   spawn,'ssh chyan@capella findmir --ra=247.97944 --dec=-24.52919 --cat=yso --ds9>'$
      +conf.regpath+'/c2d_yso.reg'

  
   ; Making a bad pixel mask for identifing 
   makemask,conf.wircampath+'1633-2410_Ks_coadd.fits',conf.wircampath+'1633-2410_Ks_mask.fits'
   
   ; Building ASSOC catalog for SExtractor
	 asoc_mipscat,'c2dsource.cat'
   
   ; Run SExtractor for extracting ASSOC sources
   runsexassoc	

   ; Combinning the JHK photometry with Spitzer data
   combinecatalog,cat,catfile='c2dsource.cat',file='source.cat'
   
   ; Make thumbnaill FITS images and plot image in Ps format
   mkthumbnail,file='output_stellar_good.fits'	
   extractimage,file='output_stellar_good.fits' ,ps='stellar.ps' 
   sedregion,file='output_stellar_good.fits',reg='stellar.reg',color='green'
   ; 
   mkthumbnail,file='output_yso_good.fits'  
   extractimage,file='output_yso_good.fits', ps='yso.ps'
   sedregion,file='output_yso_good.fits',reg='mips_yso.reg',color='red'
   
   ;
   mkthumbnail,file='c2d_reg2_yso_good.fits'  
   extractimage,file='c2d_reg2_yso_good.fits', ps='yso_reg2_good.ps'
   sedregion,file='c2d_reg2_yso_good.fits', reg='yso_bad.reg',color='white'
   
   
   yso_parameter,file='output_yso_good.fits',final  
   
   yso_classify,file='c2d_reg2_yso_good.fits'
   
   yso_classify,file='swire_yso.fits'
END

PRO RHO_C2D_YSO
   COMMON share,conf 
   loadconfig
	
   ; Make a  C2D YSO file
   spawn,'ssh chyan@capella findmir --ra=247.97944 --dec=-24.52919 --rad=100 --cat=yso >'+conf.catpath+'c2d_yso.cat '
   
   ; Generate the catalog for SED fitting with C2D data only
   c2dtofittercat,c2dcat='c2d_yso.cat',file='c2d_yso_source.cat'
   
   yso_classify,file='c2d_cat_yso_good.fits'
   yso_classify_cat,file='c2d_yso_source.cat' 
END

PRO RHO_REG2_C2D_ONLY
   COMMON share,conf 
   loadconfig

   ; Get all spitzer stars with detection quality A, B and C
   spawn,'ssh chyan@capella findmir --ra=247.97944 --dec=-24.52919 >'$
      +conf.catpath+'c2dsource_reg2.cat'
   
   ; Generate the catalog for SED fitting with C2D data only
   c2dtofittercat,c2dcat='c2dsource_reg2.cat',file='c2d_photometry_reg2.cat'
   
   ;Send this catalog (WITHOUT WIRCAM) file to SED fitting directory
   spawn,'rsync -arvz '+conf.catpath+'c2d_photometry_reg2.cat -e ssh '+$
    'chyan@capella:/data/local/chyan/SEDProject/RhoReg2NoJHK/'
   
   spawn,'rsync -arvz  -e ssh chyan@capella:/data/local/chyan/SEDProject/RhoReg2NoJHK/yso_c2d_nowircam.fits '+$
      conf.fitspath+'/'

   ; Filter galaxies using Hess diagram
   cmdfilter, fits=conf.fitspath+'yso_c2d_nowircam_sgfilter.fits',$
      newfits=conf.fitspath+'yso_c2d_nowircam_cmdfilter.fits',$
      region=conf.regpath+'nowircam_cmdfilter.reg'
   
   cmdfilterplot, file=conf.fitspath+'yso_c2d_nowircam.fits'
   
   sedregion,file='yso_c2d_nowircam_cmdfilter.fits', reg='yso_c2d_nowircam_cmdfilter.reg',color='white'
   sedregion,file='yso_reg2_cmdfilter.fits', reg='yso_reg2_cmdfilter.reg',color='red'
END


;  Start from here for defferent regions.
PRO L1689_YSO
   COMMON share,conf 
   loadconfig
   
   ;remapl1689
   ;--------------------------------------------------
   ; Clibration of the photometry
   ;--------------------------------------------------
   runsextractor_l1689
   getstar_l1689,cat,zero=[0.173936,0.176660,0.167671]
   find2mass_l1689,ref
   fluxcalib,cat, ref, /ps, filename='L1689_fluxcalib.ps'

   ; Exam the limiting magnitude 
   complimit,fits=conf.wircampath+'L1689_remap_J.fits',comp=0.90,psfile='L1689_remap_J_limitmag.eps',/newsky
   complimit,fits=conf.wircampath+'L1689_remap_H.fits',comp=0.90,psfile='L1689_remap_H_limitmag.eps',/newsky
   complimit,fits=conf.wircampath+'L1689_remap_Ks.fits',comp=0.90,psfile='L1689_remap_Ks_limitmag.eps',/newsky


   ; Get all spitzer stars with detection quality A, B and C
   spawn,'ssh chyan@capella findmir --ra=247.98543 --dec=-24.514508 --full >'$
      +conf.catpath+'L1689_c2dsource.cat'

   ; Building ASSOC catalog for SExtractor
   asoc_mipscat_l1689,'L1689_c2dsource.cat'


   ; Run SExtractor for extracting ASSOC sources
   runsexassoc_l1689
   
   ; Combinning the JHK photometry with Spitzer data
   combinecatalog_l1689,cat,catfile='L1689_c2dsource.cat',file='L1689_source.cat',zero=[0.173936,0.176660,0.167671]
   
   ; Send this catalog file to SED fitting directory
   spawn,'rsync -arvz '+conf.catpath+'L1689_source.cat -e ssh '+$
    'chyan@capella:/data/local/chyan/SEDProject/L1689YSO/'
 

   ;-----------------------------------------------------------
   ; After sending file to SED working directory, switch to SED 
   ;   directory for fitting.
   ;-----------------------------------------------------------
   
   ; Download all the output YSO catalog in FITS format to local disk
   spawn,'rsync -arvz  -e ssh chyan@capella:/data/local/chyan/SEDProject/L1689YSO/output_yso_*.fits '+$
      conf.fitspath+'/'
   spawn,'rsync -arvz  -e ssh chyan@capella:/data/local/chyan/SEDProject/L1689YSO/output_stellar_good.fits '+$
      conf.fitspath+'/'
      
   spawn,'mv '+conf.fitspath+'output_yso_good.fits '+conf.fitspath+'L1689_yso_good.fits'
   spawn,'mv '+conf.fitspath+'output_yso_bad.fits '+conf.fitspath+'L1689_yso_bad.fits'
   spawn,'mv '+conf.fitspath+'output_stellar_good.fits '+conf.fitspath+'L1689_star.fits'
   
   spawn,'rsync -arvzu -e ssh chyan@capella:/data/local/chyan/SEDProject/L1689YSO/plots_* '+conf.sedpath+'L1689/'

   ; Make region files for SG class <= 0.02
   sgfilter_l1689, fits='L1689_yso_good.fits',newfits='L1689_yso_sgfilter.fits',/runsex
   examysocandidate,fits=conf.fitspath+'L1689_yso_sgfilter.fits',$
      sedpath=conf.sedpath+'L1689/',pos=[247.98543,-24.514508],dpos=[0.5,0.5]
   
   ;  Giving the NIR detection threshold for WIRCam datection.  These values are lambda*F_lambda
   ;   Values come from 90% completeness.   
   nirlim=[5.8e-14,2.78e-14,3.3e-14]
   fluxfilter,nirlim=nirlim, fit=conf.fitspath+'L1689_yso_sgfilter.fits',$
      newfits=conf.fitspath+'L1689_yso_fluxfilter.fits'
     
   examysocandidate,fits=conf.fitspath+'L1689_yso_fluxfilter.fits',$
      sedpath=conf.sedpath+'L1689/',pos=[247.98543,-24.514508],dpos=[0.5,0.5]
   
   getmipsexcess,fits=conf.fitspath+'L1689_star.fits',newfits=conf.fitspath+'L1689_mipsexcess.fits',$
      ps='L1689_mipsexcess.ps'
      ;SSTc2d J163102.8-243948       Selected: MIPS flux is larger than stellar SED.
      ;SSTc2d J163302.6-242241       Selected: MIPS flux is larger than stellar SED.
      ;SSTc2d J163346.2-242753       Selected: MIPS flux is larger than stellar SED.      
      
   mkthumbnail_l1689,file='L1689_yso_fluxfilter.fits',/clean  
   extractimage,file='L1689_yso_fluxfilter.fits', ps='L1689_yso_sed_image.ps',$
      sedpath=conf.sedpath+'L1689/'
 
   ; Checking SED and image by human eyes
   ;  The filtered FITS catalog is save as L1689_yso_final_110916-1.fits
   sedimageinspect,fits=conf.fitspath+'L1689_yso_fluxfilter.fits'
   ; Use this saved name for better management 
   sedimageinspect,fits=conf.fitspath+'L1689_yso_sedinspect_savetemp.fits'
   
   ; Check the YSO classifications.
   yso_classify,file=conf.fitspath+'L1689_yso_final_111028.fits'
      ;Class I=        23
      ;Flat=           18
      ;Class II =      21
      ;Class III=       2   
   examysocandidate,fits=conf.fitspath+'L1689_yso_final_111012-1.fits',$
      sedpath=conf.sedpath+'L1689/'
   
   
   yso_parameter,fits=conf.fitspath+'L1689_yso_fluxfilter.fits',final
   
 
   sedregion,file='L1689_yso_good.fits', reg='L1689_yso_good.reg',color='yellow'
   sedregion,file='L1689_yso_sgfilter.fits', reg='L1689_yso_sgfilter.reg',color='red'
   sedregion,file='L1689_yso_fluxfilter.fits', reg='L1689_yso_fluxfilter.reg',color='white'

   cmdfilterplot, file=conf.fitspath+'L1689_yso_final_110916-1.fits'
   cmdfilterplot, file=conf.fitspath+'c2d_cat_yso_good.fits'
END



PRO L1688_YSO
   COMMON share,conf 
   loadconfig

   ; Check how many YSOs in c2d catalog for this region
   spawn,'ssh chyan@capella findyso --ra=246.78681 --dec=-24.510206 --ds9 --dra=1.075 --ddec=0.56 --cat=oph >'$
      +conf.regpath+'L1688_c2d_yso.reg'
   
   ; Starting making photometry corrections.
   runsextractor_l1688
   getstar_l1688,cat,zero=[0.129305,0.179904,0.191360]
   find2mass_l1688,ref
   fluxcalib,cat, ref, /ps, filename='L1688_fluxcalib.ps'

   ; Exam the limiting magnitude 
   complimit,fits=conf.wircampath+'L1688_J_coadd.fits',comp=0.90,psfile='L1688_J_coadd_limitmag.eps',/newsky
   complimit,fits=conf.wircampath+'L1688_H_coadd.fits',comp=0.90,psfile='L1688_H_coadd_limitmag.eps',/newsky
   complimit,fits=conf.wircampath+'L1688_Ks_coadd.fits',comp=0.90,psfile='L1688_Ks_coadd_limitmag.eps',/newsky


   ; Get all spitzer stars with detection quality A, B and C
   spawn,'ssh chyan@capella findmir --ra=246.78681 --dec=-24.510206 --ds9 --dra=1.075 --ddec=0.56 --full >'$
      +conf.regpath+'L1688_c2d_source.reg'
   spawn,'ssh chyan@capella findmir --ra=246.78681 --dec=-24.510206 --dra=1.075 --ddec=0.56 --full >'$
      +conf.catpath+'L1688_c2dsource.cat'

   ; Building ASSOC catalog for SExtractor
   asoc_mipscat_l1688,'L1688_c2dsource.cat'


   ; Run SExtractor for extracting ASSOC sources
   runsexassoc_l1688
   
   ; Combinning the JHK photometry with Spitzer data
   combinecatalog_l1688,cat,catfile='L1688_c2dsource.cat',file='L1688_source.cat',zero=[0.129305,0.179904,0.191360]

    ; Send this catalog file to SED fitting directory
   spawn,'rsync -arvz '+conf.catpath+'L1688_source.cat -e ssh '+$
    'chyan@capella:/data/local/chyan/SEDProject/L1688YSO/'
  

   ;-----------------------------------------------------------
   ; After sending file to SED working directory, switch to SED 
   ;   directory for fitting.
   ;-----------------------------------------------------------
   
   ; Download all the output YSO catalog in FITS format to local disk
   spawn,'rsync -arvz  -e ssh chyan@capella:/data/local/chyan/SEDProject/L1688YSO/output_yso_*.fits '+$
      conf.fitspath+'/'
   spawn,'rsync -arvz  -e ssh chyan@capella:/data/local/chyan/SEDProject/L1688YSO/output_stellar_good.fits '+$
      conf.fitspath+'/'
   
   spawn,'rsync -arvz  /Volumes/Data/SEDProject/L1688YSO/output_yso_*.fits '+$
      conf.fitspath+'/'
   spawn,'rsync -arvz  /Volumes/Data/SEDProject/L1688YSO/output_stellar_good.fits '+$
      conf.fitspath+'/'
      
   spawn,'mv '+conf.fitspath+'output_yso_good.fits '+conf.fitspath+'L1688_yso_good.fits'
   spawn,'mv '+conf.fitspath+'output_yso_bad.fits '+conf.fitspath+'L1688_yso_bad.fits'
   spawn,'mv '+conf.fitspath+'output_stellar_good.fits '+conf.fitspath+'L1688_star.fits'
   
   spawn,'rsync -arvz -e ssh chyan@capella:/data/local/chyan/SEDProject/L1688YSO/plots_* '+conf.sedpath+'L1688/'

   ; Making the thumbnail images and SED images for future inspection.
   mkthumbnail_l1688,file='L1688_yso_good.fits',/clean  
   extractimage,file='L1688_yso_good.fits', ps='L1688_yso_sed_image.ps',$
      sedpath=conf.sedpath+'L1688/'


   ;----------------------- SG Filtering ------------------------------------
   ;  Test the YSO SG Class in this region before using SG filter.
   mkysoassoc,region='L1688'
   runsgysosex,region='L1688'
   sgysoplot,title='L1688 All Sources',file='L1689_ysosgtest.eps',/ps
    
   ; Make region files for SG class <= 0.03
   ;  In this region, the SG filter setting is [0.0,0.03,0.03] for J, H and K
   sgfilter_l1688, fits='L1688_yso_good.fits',newfits='L1688_yso_sgfilter.fits',/runsex
   
   sedregion,file='L1688_yso_good.fits', reg='L1688_yso_good.reg',color='white'
   sedregion,file='L1688_yso_sgfilter.fits', reg='L1688_yso_sgfilter.reg',color='white'
  
  ;-------------------------  Flux Filtering ------------------------------- 
   nirlim=[5.8e-14,2.78e-14,3.3e-14]
   fluxfilter,nirlim=nirlim, fit=conf.fitspath+'L1688_yso_sgfilter.fits',$
      newfits=conf.fitspath+'L1688_yso_fluxfilter.fits'
 
   getmipsexcess,fits=conf.fitspath+'L1688_star.fits',newfits=conf.fitspath+'L1688_mipsexcess.fits',$
      ps='L1688_mipsexcess.ps'
        ;SSTc2d J162741.5-243538       Selected: MIPS flux is larger than stellar SED.
        ;SSTc2d J162804.8-243710       Selected: MIPS flux is larger than stellar SED.
        ;SSTc2d J162821.5-242155       Selected: MIPS flux is larger than stellar SED.
        ;SSTc2d J163102.8-243948       Selected: MIPS flux is larger than stellar SED.

   mkthumbnail_l1688,file='L1688_yso_good.fits',/clean  
   extractimage,file='L1688_yso_good.fits', ps='L1688_yso_sed_image.ps',$
      sedpath=conf.sedpath+'L1688/'

   ; First read-in filtered data and save it to another name.
   sedimageinspect,fits=conf.fitspath+'L1688_yso_fluxfilter.fits'
   ; Use this saved name for better management 
   sedimageinspect,fits=conf.fitspath+'L1688_yso_sedinspect_savetemp.fits'
   sedimageinspect,fits=conf.fitspath+'L1688_yso_final_111112.fits'

   yso_classify,file=conf.fitspath+'L1688_yso_final_111028.fits'
   yso_classify,file=conf.fitspath+'L1688_yso_final_111112.fits'

   examysocandidate,fits=conf.fitspath+'L1688_yso_final_111112.fits',$
      sedpath=conf.sedpath+'L1688/',pos=[246.78681,-24.510206],dpos=[1.075,0.56]

END



PRO L1709_YSO
   COMMON share,conf 
   loadconfig
   
   remapl1709
   
   ; Check how many YSOs in c2d catalog for this region
   spawn,'ssh chyan@capella findyso --ra=248.14652 --dec=-23.662119 --ds9 --dra=0.9 --ddec=0.3 --cat=oph>'$
      +conf.regpath+'L1709_c2d_yso.reg'
   
   ; Starting making photometry corrections.
   runsextractor_l1709
   getstar_l1709,cat,zero=[0.0850808,0.166054,0.186529]
   find2mass_l1709,ref
   fluxcalib,cat, ref, /ps, filename='L1709_fluxcalib.ps'

;
;   ; Exam the limiting magnitude 
   complimit,fits=conf.wircampath+'L1709_remap_J.fits',comp=0.90,psfile='L1709_J_limitmag.eps',/newsky
   complimit,fits=conf.wircampath+'L1709_remap_H.fits',comp=0.90,psfile='L1709_H_limitmag.eps',/newsky
   complimit,fits=conf.wircampath+'L1709_remap_Ks.fits',comp=0.90,psfile='L1709_Ks_limitmag.eps',/newsky


   ; Get all spitzer stars with detection quality A, B and C
   spawn,'ssh chyan@capella findmir --ra=248.14652 --dec=-23.662119 --ds9 --dra=0.9 --ddec=0.3 --full >'$
      +conf.regpath+'L1709_c2d_source.reg'
   spawn,'ssh chyan@capella findmir --ra=248.14652 --dec=-23.662119 --dra=0.9 --ddec=0.3 --full >'$
      +conf.catpath+'L1709_c2dsource.cat'

   ; Building ASSOC catalog for SExtractor
   asoc_mipscat_l1709,'L1709_c2dsource.cat'


   ; Run SExtractor for extracting ASSOC sources
   runsexassoc_l1709
   
   ; Combinning the JHK photometry with Spitzer data
   combinecatalog_l1709,cat,catfile='L1709_c2dsource.cat',file='L1709_source.cat',zero=[0.0850808,0.166054,0.186529]

    ; Send this catalog file to SED fitting directory
   spawn,'rsync -arvz '+conf.catpath+'L1709_source.cat -e ssh '+$
    'chyan@capella:/data/local/chyan/SEDProject/L1709YSO/'
   spawn,'rsync -arvz '+conf.catpath+'L1709_source.cat /Volumes/Data/SEDProject/L1709YSO/'
   

   ;-----------------------------------------------------------
   ; After sending file to SED working directory, switch to SED 
   ;   directory for fitting.
   ;-----------------------------------------------------------
   
   ; Download all the output YSO catalog in FITS format to local disk
   spawn,'rsync -arvz  -e ssh chyan@capella:/data/local/chyan/SEDProject/L1709YSO/output_yso_*.fits '+$
      conf.fitspath+'/'
   spawn,'rsync -arvz  -e ssh chyan@capella:/data/local/chyan/SEDProject/L1709YSO/output_stellar_good.fits '+$
      conf.fitspath+'/'
   
   spawn,'rsync -arvz  /Volumes/Data/SEDProject/L1709YSO/output_yso_*.fits '+$
      conf.fitspath+'/'
   spawn,'rsync -arvz  /Volumes/Data/SEDProject/L1709YSO/output_stellar_good.fits '+$
      conf.fitspath+'/'
      
   spawn,'mv '+conf.fitspath+'output_yso_good.fits '+conf.fitspath+'L1709_yso_good.fits'
   spawn,'mv '+conf.fitspath+'output_yso_bad.fits '+conf.fitspath+'L1709_yso_bad.fits'
   spawn,'mv '+conf.fitspath+'output_stellar_good.fits '+conf.fitspath+'L1709_star.fits'
   
   spawn,'rsync -arvz -e ssh chyan@capella:/data/local/chyan/SEDProject/L1709YSO/plots_* '+conf.sedpath+'L1709/'

   ;  Test the YSO SG Class in this region.
   mkysoassoc,region='L1709'
   runsgysosex,region='L1709'
   sgysoplot,title='L1709 All Sources',file='L1689_ysosgtest.eps',/ps
   
   
   ; Make region files for SG class <= 0.03
   ;  In this region, the SG filter setting is [0.0,0.03,0.03] for J, H and K
   sgfilter_l1709, fits='L1709_yso_good.fits',newfits='L1709_yso_sgfilter.fits',/runsex
   
   sedregion,file='L1709_yso_good.fits', reg='L1709_yso_good.reg',color='white'
   sedregion,file='L1709_yso_sgfilter.fits', reg='L1709_yso_sgfilter.reg',color='white'
   
   nirlim=[5.8e-14,2.78e-14,3.3e-14]
   fluxfilter,nirlim=nirlim, fit=conf.fitspath+'L1709_yso_sgfilter.fits',$
      newfits=conf.fitspath+'L1709_yso_fluxfilter.fits'
   
   examysocandidate,fits=conf.fitspath+'L1709_yso_fluxfilter.fits',$
      sedpath=conf.sedpath+'L1709/',pos=[248.14652,-23.662119],dpos=[0.9,0.2]
 
   getmipsexcess,fits=conf.fitspath+'L1709_star.fits',newfits=conf.fitspath+'L1709_mipsexcess.fits',$
      ps='L1709_mipsexcess.ps'

   mkthumbnail_l1709,file='L1709_yso_fluxfilter.fits',/clean  
   extractimage,file='L1709_yso_fluxfilter.fits', ps='L1709_yso_sed_image.ps',$
      sedpath=conf.sedpath+'L1709/'

   ; First read-in filtered data and save it to another name.
   sedimageinspect,fits=conf.fitspath+'L1709_yso_fluxfilter.fits'
   
   ; Use this saved name for better management 
   sedimageinspect,fits=conf.fitspath+'L1709_yso_sedinspect_savetemp.fits'

   examysocandidate,fits=conf.fitspath+'L1709_yso_final_111104.fits',$
      sedpath=conf.sedpath+'L1709/',pos=[248.14652,-23.662119],dpos=[0.9,0.2]

   yso_classify,file=conf.fitspath+'L1709_yso_final_111104.fits'

END


PRO POSTANALYSIS

   COMMON share,conf 
   loadconfig
   
   ysocat=['L1689_yso_final_111028.fits',$
          'L1688_yso_final_111112.fits',$
          'L1709_yso_final_111104.fits']
   combineysocatalog,fits=conf.fitspath+ysocat,newfits=conf.fitspath+'rho_yso_final_111112.fits'

   sedimageinspect,fits=conf.fitspath+'rho_yso_final_111112.fits'
   
   yso_classify,file=conf.fitspath+'rho_yso_final_111112.fits',$
   	ps=conf.pspath+'rho_yso_slope.eps',alpha=[0.3,-0.3,-1.6]
   
   yso_classify,file=conf.fitspath+'rho_yso_final_111112.fits',$
   	ps=conf.pspath+'rho_yso_slope_1.eps',alpha=[-0.5]
   
   ; Checking why there is a gap in CMD plot
   cmdfilterplot,file=conf.fitspath+'L1688_yso_good.fits'
   cmdfilterplot,file=conf.fitspath+'L1688_yso_sgfilter.fits'
   cmdfilterplot,file=conf.fitspath+'L1688_yso_fluxfilter.fits'
   cmdfilterplot,file=conf.fitspath+'L1688_yso_final_111112.fits'

   
   cmdfilterplot,file=conf.fitspath+'L1689_yso_final_111028.fits',ps='L1689_yso_cmdplot.eps',/markc2d
   cmdfilterplot,file=conf.fitspath+'L1688_yso_final_111112.fits',ps='L1688_yso_cmdplot.eps',/markc2d
   cmdfilterplot,file=conf.fitspath+'L1709_yso_final_111104.fits',ps='L1709_yso_cmdplot.eps',/markc2d
   cmdfilterplot,file=conf.fitspath+'rho_yso_final_111112.fits',ps='rho_yso_cmdplot.eps',/markc2d
   
   cmdfilterplot,file=conf.fitspath+'rho_yso_final_111112.fits',ps='rho_yso_cmdplot.eps',/markc2d,/dumpnewyso

   
   cmdfilterplot,file=conf.fitspath+'c2d_cat_yso_good.fits'
   
   
   ; Remove source unlikely to be YSO
   list=['SSTc2d J162622.8-242720',$
   		'SSTc2d J162646.1-242154',$
   		'SSTc2d J162732.9-242811',$
   		'SSTc2d J162743.4-240152',$
   		'SSTc2d J162753.2-243127',$
   		'SSTc2d J162758.5-240825',$
   		'SSTc2d J162829.9-245406',$
   		'SSTc2d J162836.2-244634',$
   		'SSTc2d J162917.8-243531']
   
   removeyso,fits=conf.fitspath+'rho_yso_final_111112.fits',newfits=conf.fitspath+'rho_yso_final_120223.fits',list=list
   
   ; Check again
   sedimageinspect,fits=conf.fitspath+'rho_yso_final_120223.fits'
   sedimageinspect,fits=conf.fitspath+'rho_yso_final_120223_dump.fits'

   
   
   yso_classify,file=conf.fitspath+'rho_yso_final_120223_dump.fits',$
   	ps=conf.pspath+'rho_yso_final_120223_dump.eps',alpha=[0.3,-0.3,-1.6]
	
   cmdfilterplot,file=conf.fitspath+'rho_yso_final_120223_dump.fits',ps='rho_yso_cmdplot.eps',/markc2d
   cmdfilterplot,file=conf.fitspath+'rho_yso_final_120223_dump.fits',ps='rho_yso_cmdplot.eps',/markc2d,/dumpnewyso


   examysocandidate,fits=conf.fitspath+'rho_yso_final_120223_dump.fits',$
      sedpath=conf.sedpath,pos=[248.39013,-24.088804],dpos=[3.0,1.8],/nops


   sedimageinspect,fits=conf.fitspath+'test.fits'
	
   
   examysocandidate,fits=conf.fitspath+'rho_yso_final_111112.fits',$
      sedpath=conf.sedpath,pos=[248.39013,-24.088804],dpos=[3.0,1.8],/nops
      
      
END












