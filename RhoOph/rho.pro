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
@kslaw

PRO LOADCONFIG
  COMMON share,conf
  
  ;Settings for HOME computer
  ;imgpath = '/Volumes/disk1s1/Projects/S233IR/'
  ;mappath = '/Volumes/disk1s1/Projects/S233IR/'
  
  ;Settings for ASIAA computer
  if strcmp(!VERSION.OS,'linux') then begin 
     path='/data/procyon/Projects/Ophiuchus/'
     modelpath='/data/capella/chyan/Models/models_r06/seds/'
     ;sedpath='/data/disk/chyan/Projects/Ophiuchus/'
  endif else begin
     path='/Volumes/Science/Projects/Ophiuchus/'
     modelpath='/Volumes/Science/Models/models_r06/seds/'
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
   figpath=path+'Figures/'
   ds9path=path+'DS9/'
   conf={path:path,wircampath:wircampath,fitspath:fitspath,pspath:pspath,$
      imagepath:imagepath,iracpath:iracpath,catpath:catpath,regpath:regpath,$
      confpath:confpath,sedpath:sedplot,extpath:extpath,tnpath:tnpath,mipspath:mipspath,$
      swirepath:swirepath,modelpath:modelpath,figpath:figpath,ds9path:ds9path}  
END


PRO SYNCPROJECTDATA
   COMMON share,conf 
   loadconfig

   if (file_test(conf.path) and strcmp(!VERSION.OS,'darwin')) then begin
       print,'Backing up data to Procyon.'
       spawn,'rsync -arvu --delete '+conf.path+'* -e ssh chyan@procyon:/data/procyon/Projects/Ophiuchus/  --progress'
   
   	   ;print,'Pull data from Procyon.'
   	   ;spawn,'rsync -arvzu -e ssh chyan@procyon:/data/procyon/Projects/Ophiuchus/* '+conf.path+'/ --progress'
   endif

end


PRO SYNCSEDDATA
   COMMON share,conf 
   loadconfig

   if (file_test(conf.path) and strcmp(!VERSION.OS,'darwin')) then begin
       print,'Backing up data to Procyon.'
       spawn,'rsync -arvzu '+conf.path+'* -e ssh chyan@procyon:/data/procyon/Projects/SEDProject/  --progress'
   
   	   print,'Pull data from Procyon.'
   	   spawn,'rsync -arvzu -e ssh chyan@procyon:/data/procyon/Projects/Ophiuchus/* '+conf.path+'/ --progress'
   endif

end


;  The SWIRE data is used to exam the detection ability of SED fitter
PRO SWIREDATA
   COMMON share,conf 
   loadconfig

   spawn,'ssh chyan@capella swirecat --flux > '+conf.catpath+'swire_n1_flux.cat'
   getswireflux,conf.catpath+'swire_n1_flux.cats',cat
   swiresedcat,cat,file=conf.catpath+'swire_sed.cat'

   spawn,'rsync -arvz  -e ssh chyan@capella:/data/local/chyan/SEDProject/SWIRE/sedfitter/output_*.fits '+$
      conf.swirepath+'/'
      
   fluxfilter, fit=conf.swirepath+'output_yso_good.fits',newfits=conf.swirepath+'swire_fluxfilter.fits'
   examysocandidate,fits=conf.swirepath+'swire_fluxfilter.fits',sedfitspath='/data/local/chyan/SEDProject/SWIRE/sedfitter'
   
   ysocmd, file=conf.swirepath+'output_yso_good.fits',outfile='swireysocmd.eps',/ps
   
   cmdfilterplot,file=conf.swirepath+'swire_fluxfilter.fits',ps='swire_cmdfilter.eps'   
   cmdfilter, fits=conf.swirepath+'output_yso_good.fits',$
      newfits=conf.swirepath+'output_yso_cmdfilter.fits'
END

PRO PUSHCODETOIAA

  spawn,'rsync -arvzu --delete /Users/chyan/IDLSourceCode/Science/RhoOph/*.pro -e ssh chyan@procyon:~chyan/IDLSourceCode/Science/RhoOph/ '
  spawn,'rsync -arvzu --delete /Volumes/Data/SEDProject/L1689YSO/L1689_sedfitting.bash '+$
    '-e ssh chyan@capella:/data/local/chyan/SEDProject/L1689YSO/ '
  spawn,'rsync -arvzu --delete /Volumes/Data/SEDProject/L1688YSO/L1688_sedfitting.bash '+$
    '-e ssh chyan@capella:/data/local/chyan/SEDProject/L1688YSO/ '
  spawn,'rsync -arvzu --delete /Volumes/Data/SEDProject/L1709YSO/L1709_sedfitting.bash '+$
    '-e ssh chyan@capella:/data/local/chyan/SEDProject/L1709YSO/ '
  spawn,'rsync -arvzu --delete /Volumes/Data/SEDProject/L1712YSO/L1712_sedfitting.bash '+$
    '-e ssh chyan@capella:/data/local/chyan/SEDProject/L1712YSO/ '
  spawn,'rsync -arvzu --delete /Volumes/Data/SEDProject/rho_ophYSO/rho_oph_sedfitting.bash '+$
    '-e ssh chyan@capella:/data/local/chyan/SEDProject/rho_ophYSO/ '

end

PRO GETCODEFROMIAA

  spawn,'rsync -arvzu --delete -e ssh chyan@procyon:~chyan/IDLSourceCode/Science/RhoOph/*.pro /Users/chyan/IDLSourceCode/Science/RhoOph/  '

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
   ;lon=248.056453, lat=-24.683862
   
   ;--------------------------------------------------
   ; Clibration of the photometry
   ;--------------------------------------------------
   runsextractor_l1689
   getstar_l1689,cat,zero=[0.155956,0.0715663,0.0901451]
   find2mass_l1689,ref
   ;fluxcalib,cat, ref, /ps, filename='L1689_fluxcalib.ps'
   fluxcalib,cat, ref, ps='L1689_new_fluxcalib.eps', region='L1689'

   ; Exam the limiting magnitude 
   ;complimit,fits=conf.wircampath+'L1689_remap_J.fits',comp=0.90,psfile='L1689_remap_J_limitmag.eps',/newsky
   ;complimit,fits=conf.wircampath+'L1689_remap_H.fits',comp=0.90,psfile='L1689_remap_H_limitmag.eps',/newsky
   ;complimit,fits=conf.wircampath+'L1689_remap_Ks.fits',comp=0.90,psfile='L1689_remap_Ks_limitmag.eps',/newsky
   complimit,fits=conf.wircampath+'L1689_J_new.fits',comp=0.90,psfile='L1689_J_new_limitmag.eps',/newsky
   complimit,fits=conf.wircampath+'L1689_H_new.fits',comp=0.90,psfile='L1689_H_new_limitmag.eps',/newsky
   complimit,fits=conf.wircampath+'L1689_Ks_new.fits',comp=0.90,psfile='L1689_Ks_new_limitmag.eps',/newsky


   ; Get all spitzer stars with detection quality A, B and C
   spawn,'ssh chyan@capella findmir --ra=248.056453 --dec=-24.683862 --dra=0.46 --ddec=0.70 --full >'$
      +conf.catpath+'L1689_new_c2dsource.cat'

   ; Building ASSOC catalog for SExtractor
   asoc_mipscat_l1689,'L1689_new_c2dsource.cat'


   ; Run SExtractor for extracting ASSOC sources
   runsexassoc_l1689
   
   ; Combinning the JHK photometry with Spitzer data
   combinecatalog_l1689,cat,catfile='L1689_new_c2dsource.cat',file='L1689_new_source.cat',zero=[0.155956,0.0715663,0.0901451]
   
   ; Send this catalog file to SED fitting directory
   spawn,'rsync -arvz '+conf.catpath+'L1689_new_source.cat -e ssh '+$
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
      
   spawn,'mv '+conf.fitspath+'output_yso_good.fits '+conf.fitspath+'L1689_new_yso_good.fits'
   spawn,'mv '+conf.fitspath+'output_yso_bad.fits '+conf.fitspath+'L1689_new_yso_bad.fits'
   spawn,'mv '+conf.fitspath+'output_stellar_good.fits '+conf.fitspath+'L1689_new_star.fits'
   
   spawn,'rsync -arvzu --delete -e ssh chyan@capella:/data/local/chyan/SEDProject/L1689YSO/plots_* '+conf.sedpath+'L1689/'

   examysocandidate,fits=conf.fitspath+'L1689_new_yso_good.fits',$
      sedpath=conf.sedpath+'L1689/',pos=[248.056453,-24.683862],dpos=[0.46,0.70]

    ;----------------------- SG Filtering ------------------------------------
    ;  Test the YSO SG Class in this region before using SG filter.
    mkysoassoc,region='L1689'
    runsgysosex,region='L1689'
    sgysoplot,title='L1689 All Sources',ps=conf.pspath+'L1689_ysosgtest.eps'


   ; Make region files for SG class <= 0.02
   sgfilter_l1689, fits='L1689_new_yso_good.fits',newfits='L1689_new_yso_sgfilter.fits',/runsex
   examysocandidate,fits=conf.fitspath+'L1689_new_yso_sgfilter.fits',$
      sedpath=conf.sedpath+'L1689/',pos=[248.056453,-24.683862],dpos=[0.46,0.70]
   
   ;  Giving the NIR detection threshold for WIRCam datection.  These values are lambda*F_lambda
   ;   Values come from 90% completeness.   
   nirlim=[5.8e-14,2.78e-14,3.3e-14]
   fluxfilter,nirlim=nirlim, fit=conf.fitspath+'L1689_new_yso_sgfilter.fits',$
      newfits=conf.fitspath+'L1689_new_yso_fluxfilter.fits'
     
   examysocandidate,fits=conf.fitspath+'L1689_new_yso_fluxfilter.fits',$
      sedpath=conf.sedpath+'L1689/',pos=[248.056453,-24.683862],dpos=[0.46,0.70]
	  ;c2d YSO: SSTc2d J163134.1-240060 missing. Reason: filtered out.
	  ;c2d YSO: SSTc2d J163301.6-240356 missing. Reason: in bad yso.
	  ;c2d YSO: SSTc2d J163346.2-242753 missing. Reason: fitted with star.

   
   getmipsexcess,fits=conf.fitspath+'L1689_new_star.fits',newfits=conf.fitspath+'L1689_new_mipsexcess.fits',$
      ps='L1689_new_mipsexcess.ps'
      ;SSTc2d J163102.8-243948       Selected: MIPS flux is larger than stellar SED.
      ;SSTc2d J163302.6-242241       Selected: MIPS flux is larger than stellar SED.
      ;SSTc2d J163346.2-242753       Selected: MIPS flux is larger than stellar SED.      
      
   mkthumbnail_l1689,file='L1689_new_yso_fluxfilter.fits',/clean  
   extractimage,file='L1689_new_yso_fluxfilter.fits', ps='L1689_new_yso_sed_image.ps',$
      sedpath=conf.sedpath+'L1689/'
 
   ; Checking SED and image by human eyes
   ;  The filtered FITS catalog is save as L1689_yso_final_110916-1.fits
   sedimageinspect,fits=conf.fitspath+'L1689_new_yso_fluxfilter.fits'
   ; Use this saved name for better management 
   sedimageinspect,fits=conf.fitspath+'L1689_new_yso_sedinspect_savetemp.fits'
   
   ; Check the YSO classifications.
   yso_classify,file=conf.fitspath+'L1689_new_yso_final_130121.fits'
      ;Class I   =           22
      ;Flat      =           14
      ;Class II  =           24
      ;Class III =            1
    
   yso_classify,file=conf.fitspath+'L1689_new_yso_final_130513.fits'
      ;Class I   =           22
      ;Flat      =           19
      ;Class II  =           26
      ;Class III =            1
      
   examysocandidate,fits=conf.fitspath+'L1689_new_yso_final_130513.fits',$
      sedpath=conf.sedpath+'L1689/',pos=[248.056453,-24.683862],dpos=[0.46,0.705]
        ;c2d YSO: SSTc2d J163301.6-240356 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J163346.2-242753 missing. Reason: fitted with star.

   cmdfilterplot, file=conf.fitspath+'L1689_yso_final_110916-1.fits'

   
   examysocandidate,fits=conf.fitspath+'L1689_new_yso_final_130121.fits',$
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

   ;Region Center: 246.321350 -24.443980 size: 2.28 1.25	
   ; Check how many YSOs in c2d catalog for this region
   spawn,'ssh chyan@capella findyso --ra=246.31989 --dec=-24.446552 --dra=1.24 --ddec=0.618 --ds9 --cat=oph >'$
      +conf.regpath+'L1688_c2d_yso.reg'
   
   ; Starting making photometry corrections.
   runsextractor_l1688
   ;getstar_l1688,cat,zero=[0.129305,0.179904,0.191360]
   getstar_l1688,cat,zero=[0.109135,0.0830246,0.0759849]
   find2mass_l1688,ref
   fluxcalib,cat, ref, ps='L1688_new_fluxcalib.ps',region='L1688'

   ; Exam the limiting magnitude 
   ;complimit,fits=conf.wircampath+'L1688_J_coadd.fits',comp=0.90,psfile='L1688_J_coadd_limitmag.eps',/newsky
   ;complimit,fits=conf.wircampath+'L1688_H_coadd.fits',comp=0.90,psfile='L1688_H_coadd_limitmag.eps',/newsky
   ;complimit,fits=conf.wircampath+'L1688_Ks_coadd.fits',comp=0.90,psfile='L1688_Ks_coadd_limitmag.eps',/newsky
   complimit,fits=conf.wircampath+'L1688_J_new.fits',comp=0.90,psfile='L1689_J_new_limitmag.eps',/newsky
   complimit,fits=conf.wircampath+'L1688_H_new.fits',comp=0.90,psfile='L1689_H_new_limitmag.eps',/newsky
   complimit,fits=conf.wircampath+'L1688_Ks_new.fits',comp=0.90,psfile='L1689_Ks_new_limitmag.eps',/newsky


   ; Get all spitzer stars with detection quality A, B and C
   spawn,'ssh chyan@capella findmir --ra=246.31989 --dec=-24.446552 --dra=1.24 --ddec=0.618 --full --ds9 >'$
      +conf.regpath+'L1688_new_c2d_source.reg'
   spawn,'ssh chyan@capella findmir --ra=246.31989 --dec=-24.446552 --dra=1.24 --ddec=0.618 --full >'$
      +conf.catpath+'L1688_new_c2dsource.cat'

   ; Building ASSOC catalog for SExtractor
   asoc_mipscat_l1688,'L1688_new_c2dsource.cat'


   ; Run SExtractor for extracting ASSOC sources
   runsexassoc_l1688
   
   ; Combinning the JHK photometry with Spitzer data
   ;combinecatalog_l1688,cat,catfile='L1688_c2dsource.cat',file='L1688_source.cat',zero=[0.129305,0.179904,0.191360]
   combinecatalog_l1688,cat,catfile='L1688_new_c2dsource.cat',file='L1688_new_source.cat',zero=[0.109135,0.0830246,0.0759849]

    ; Send this catalog file to SED fitting directory
   spawn,'rsync -arvz '+conf.catpath+'L1688_new_source.cat -e ssh '+$
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
   
   spawn,'rsync -arvz  /Volumes/Science/SEDProject/L1688YSO/output_yso_*.fits '+$
      conf.fitspath+'/'
   spawn,'rsync -arvz  /Volumes/Science/SEDProject/L1688YSO/output_stellar_good.fits '+$
      conf.fitspath+'/'
      
   spawn,'mv '+conf.fitspath+'output_yso_good.fits '+conf.fitspath+'L1688_new_yso_good.fits'
   spawn,'mv '+conf.fitspath+'output_yso_bad.fits '+conf.fitspath+'L1688_new_yso_bad.fits'
   spawn,'mv '+conf.fitspath+'output_stellar_good.fits '+conf.fitspath+'L1688_new_star.fits'
   
   spawn,'rsync -arvzu --delete -e ssh chyan@capella:/data/local/chyan/SEDProject/L1688YSO/plots_* '+conf.sedpath+'L1688/'
   
   ; First of all checking how many C2D YSO missing in SED fitting.
   examysocandidate,fits=conf.fitspath+'L1688_new_yso_good.fits',$
      sedpath=conf.sedpath+'L1688/',pos=[246.31989,-24.446552],dpos=[1.24,0.618]
        ;c2d YSO: SSTc2d J162225.2-240514 missing. Reason: Not in catalog.
        ;c2d YSO: SSTc2d J162527.6-243648 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J162605.8-244255 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J162610.3-242055 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J162711.7-243832 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J162713.3-244133 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J162716.4-243114 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J162717.6-240514 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J162743.8-244308 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J162954.6-245846 missing. Reason: in bad yso.   
   
   ; Making the thumbnail images and SED images for future inspection.
   mkthumbnail_l1688,file='L1688_new_yso_good.fits',/clean  
   extractimage,file='L1688_new_yso_good.fits', ps='L1688_new_yso_sed_image.ps',$
      sedpath=conf.sedpath+'L1688/'


   ;----------------------- SG Filtering ------------------------------------
   ;  Test the YSO SG Class in this region before using SG filter.
   mkysoassoc,region='L1688'
   runsgysosex,region='L1688'
   sgysoplot,title='L1688 All Sources',ps=conf.pspath+'L1688_ysosgtest.eps'
    
   ; Make region files for SG class <= 0.03
   ;  In this region, the SG filter setting is [0.0,0.03,0.03] for J, H and K
   sgfilter_l1688, fits='L1688_new_yso_good.fits',newfits='L1688_new_yso_sgfilter.fits',/runsex

   examysocandidate,fits=conf.fitspath+'L1688_new_yso_sgfilter.fits',$
      sedpath=conf.sedpath+'L1688/',pos=[246.31989,-24.446552],dpos=[1.24,0.618]
        ;c2d YSO: SSTc2d J162225.2-240514 missing. Reason: Not in catalog. (Not in HREL Catalog)
        ;c2d YSO: SSTc2d J162527.6-243648 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J162605.8-244255 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J162610.3-242055 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J162711.7-243832 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J162713.3-244133 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J162716.4-243114 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J162717.6-240514 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J162743.8-244308 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J162954.6-245846 missing. Reason: in bad yso.
   
   sedregion,file='L1688_yso_good.fits', reg='L1688_yso_good.reg',color='white'
   sedregion,file='L1688_yso_sgfilter.fits', reg='L1688_yso_sgfilter.reg',color='white'
  
  ;-------------------------  Flux Filtering ------------------------------- 
   nirlim=[5.8e-14,2.78e-14,3.3e-14]
   fluxfilter,nirlim=nirlim, fit=conf.fitspath+'L1688_new_yso_sgfilter.fits',$
      newfits=conf.fitspath+'L1688_new_yso_fluxfilter.fits'
 
   examysocandidate,fits=conf.fitspath+'L1688_new_yso_fluxfilter.fits',$
      sedpath=conf.sedpath+'L1688/',pos=[246.31989,-24.446552],dpos=[1.24,0.618]


 
   getmipsexcess,fits=conf.fitspath+'L1688_new_star.fits',newfits=conf.fitspath+'L1688_new_mipsexcess.fits',$
      ps='L1688_new_mipsexcess.ps'
 
   mkthumbnail_l1688,file='L1688_yso_good.fits',/clean  
   extractimage,file='L1688_new_yso_good.fits', ps='L1688_yso_sed_image.ps',$
      sedpath=conf.sedpath+'L1688/'

   ; First read-in filtered data and save it to another name.
   sedimageinspect,fits=conf.fitspath+'L1688_new_yso_fluxfilter.fits'
   ; Use this saved name for better management 
   sedimageinspect,fits=conf.fitspath+'L1688_new_yso_sedinspect_savetemp.fits'
   sedimageinspect,fits=conf.fitspath+'L1688_new_yso_final_130423.fits'

   yso_classify,file=conf.fitspath+'L1688_new_yso_final_130423.fits'
          ;Class I   =           48
          ;Flat      =           65
          ;Class II  =          130
          ;Class III =           15

   examysocandidate,fits=conf.fitspath+'L1688_new_yso_final_130423.fits',$
      sedpath=conf.sedpath+'L1688/',pos=[246.31989,-24.446552],dpos=[1.24,0.618]
          ;c2d YSO: SSTc2d J162225.2-240514 missing. Reason: Not in catalog.
          ;c2d YSO: SSTc2d J162527.6-243648 missing. Reason: in bad yso.
          ;c2d YSO: SSTc2d J162605.8-244255 missing. Reason: in bad yso.
          ;c2d YSO: SSTc2d J162610.3-242055 missing. Reason: in bad yso.
          ;c2d YSO: SSTc2d J162617.5-242315 missing. Reason: filtered out.
          ;c2d YSO: SSTc2d J162636.5-242317 missing. Reason: filtered out.
          ;c2d YSO: SSTc2d J162711.7-243832 missing. Reason: in bad yso.
          ;c2d YSO: SSTc2d J162713.3-244133 missing. Reason: in bad yso.
          ;c2d YSO: SSTc2d J162716.4-243114 missing. Reason: in bad yso.
          ;c2d YSO: SSTc2d J162717.6-240514 missing. Reason: in bad yso.
          ;c2d YSO: SSTc2d J162743.8-244308 missing. Reason: in bad yso.
          ;c2d YSO: SSTc2d J162954.6-245846 missing. Reason: in bad yso.
END



PRO L1709_YSO
   COMMON share,conf 
   loadconfig
   
   remapl1709
   
   ; Check how many YSOs in c2d catalog for this region
   spawn,'ssh chyan@capella findyso --ra=248.139466 --dec=-23.648925 --ds9 --dra=0.9 --ddec=0.3 --cat=oph>'$
      +conf.regpath+'L1709_new_c2d_yso.reg'
   
   ; Starting making photometry corrections.
   runsextractor_l1709
   ;getstar_l1709,cat,zero=[0.0850808,0.166054,0.186529]
   getstar_l1709,cat,zero=[0.000490762,0.0808809,0.100707]
   find2mass_l1709,ref
   fluxcalib,cat, ref, ps='L1709_new_fluxcalib.eps',region='L1709'

;
;   ; Exam the limiting magnitude 
   complimit,fits=conf.wircampath+'L1709_J_new.fits',comp=0.90,psfile='L1709_J_limitmag.eps',/newsky
   complimit,fits=conf.wircampath+'L1709_H_new.fits',comp=0.90,psfile='L1709_H_limitmag.eps',/newsky
   complimit,fits=conf.wircampath+'L1709_Ks_new.fits',comp=0.90,psfile='L1709_Ks_limitmag.eps',/newsky
      ;Limiting magnitude is 19.3106 for L1709_J_new.fits
      ;Limiting magnitude is 18.8673 for L1709_H_new.fits
      ;Limiting magnitude is 18.4891 for L1709_Ks_new.fits

   ; Get all spitzer stars with detection quality A, B and C
   spawn,'ssh chyan@capella findmir --ra=248.139466 --dec=-23.648925 --ds9 --dra=0.9 --ddec=0.3 --full >'$
      +conf.regpath+'L1709_new_c2d_source.reg'
   spawn,'ssh chyan@capella findmir --ra=248.139466 --dec=-23.648925 --dra=0.9 --ddec=0.3 --full >'$
      +conf.catpath+'L1709_new_c2dsource.cat'

   ; Building ASSOC catalog for SExtractor
   asoc_mipscat_l1709,'L1709_new_c2dsource.cat'


   ; Run SExtractor for extracting ASSOC sources
   runsexassoc_l1709
   
   ; Combinning the JHK photometry with Spitzer data
   ;combinecatalog_l1709,cat,catfile='L1709_c2dsource.cat',file='L1709_source.cat',zero=[0.0850808,0.166054,0.186529]
   combinecatalog_l1709,cat,catfile='L1709_new_c2dsource.cat',file='L1709_new_source.cat',zero=[0.000490762,0.0808809,0.100707]

    ; Send this catalog file to SED fitting directory
   spawn,'rsync -arvz '+conf.catpath+'L1709_new_source.cat -e ssh '+$
    'chyan@capella:/data/local/chyan/SEDProject/L1709YSO/'
   spawn,'rsync -arvz '+conf.catpath+'L1709_new_source.cat /Volumes/Data/SEDProject/L1709YSO/'
   

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
      
   spawn,'mv '+conf.fitspath+'output_yso_good.fits '+conf.fitspath+'L1709_new_yso_good.fits'
   spawn,'mv '+conf.fitspath+'output_yso_bad.fits '+conf.fitspath+'L1709_new_yso_bad.fits'
   spawn,'mv '+conf.fitspath+'output_stellar_good.fits '+conf.fitspath+'L1709_new_star.fits'
   
   spawn,'rsync -arvz -e ssh chyan@capella:/data/local/chyan/SEDProject/L1709YSO/plots_* '+conf.sedpath+'L1709/'

   ;  Test the YSO SG Class in this region.
   mkysoassoc,region='L1709'
   runsgysosex,region='L1709'
   sgysoplot,title='L1709 All Sources',ps=conf.pspath+'L1689_new_ysosgtest.eps'
   
   
   ; Make region files for SG class <= 0.03
   ;  In this region, the SG filter setting is [0.0,0.03,0.03] for J, H and K
   sgfilter_l1709, fits='L1709_new_yso_good.fits',newfits='L1709_new_yso_sgfilter.fits',/runsex
   
   examysocandidate,fits=conf.fitspath+'L1709_new_yso_sgfilter.fits',$
      sedpath=conf.sedpath+'L1709/',pos=[248.139466,-23.648925],dpos=[0.9,0.3]
   
   
   sedregion,file='L1709_yso_good.fits', reg='L1709_yso_good.reg',color='white'
   sedregion,file='L1709_yso_sgfilter.fits', reg='L1709_yso_sgfilter.reg',color='white'
   
   nirlim=[5.8e-14,2.78e-14,3.3e-14]
   fluxfilter,nirlim=nirlim, fit=conf.fitspath+'L1709_new_yso_sgfilter.fits',$
      newfits=conf.fitspath+'L1709_new_yso_fluxfilter.fits'
    
   getmipsexcess,fits=conf.fitspath+'L1709_star.fits',newfits=conf.fitspath+'L1709_mipsexcess.fits',$
      ps='L1709_mipsexcess.ps'

   mkthumbnail_l1709,file='L1709_new_yso_fluxfilter.fits',/clean  
   extractimage,file='L1709_new_yso_fluxfilter.fits', ps='L1709_yso_sed_image.ps',$
      sedpath=conf.sedpath+'L1709/'

   ; First read-in filtered data and save it to another name.
   sedimageinspect,fits=conf.fitspath+'L1709_new_yso_fluxfilter.fits'
   
   ; Use this saved name for better management 
   sedimageinspect,fits=conf.fitspath+'L1709_new_yso_sedinspect_savetemp.fits'
   sedimageinspect,fits=conf.fitspath+'L1709_yso_final_130428.fits'

   examysocandidate,fits=conf.fitspath+'L1709_new_yso_final_130428.fits',$
      sedpath=conf.sedpath+'L1709/',pos=[248.139466,-23.648925],dpos=[0.9,0.3]

   yso_classify,file=conf.fitspath+'L1709_new_yso_final_130428.fits'
        ;Class I   =            6
        ;Flat      =            6
        ;Class II  =            1
        ;Class III =            1
END


PRO L1712_YSO
   COMMON share,conf 
   loadconfig
   
   
   ; Check how many YSOs in c2d catalog for this region
   spawn,'ssh chyan@capella findyso --ra=248.139466 --dec=-23.648925 --ds9 --dra=0.9 --ddec=0.3 --cat=oph>'$
      +conf.regpath+'L1712_new_c2d_yso.reg'
   
   ; Starting making photometry corrections.
   runsextractor_l1712
   ;getstar_l1712,cat,zero=[0.0850808,0.166054,0.186529]
   getstar_l1712,cat,zero=[0.184683,0.165742,0.219936]
   find2mass_l1712,ref
   fluxcalib,cat, ref, ps='L1712_new_fluxcalib.eps',region='L1712'

;
;   ; Exam the limiting magnitude 
   complimit,fits=conf.wircampath+'L1712_J_new.fits',comp=0.90,psfile='L1712_J_limitmag.eps',/newsky
   complimit,fits=conf.wircampath+'L1712_H_new.fits',comp=0.90,psfile='L1712_H_limitmag.eps',/newsky
   complimit,fits=conf.wircampath+'L1712_Ks_new.fits',comp=0.90,psfile='L1712_Ks_limitmag.eps',/newsky
      ;Limiting magnitude is 19.4093 for L1712_J_new.fits
      ;Limiting magnitude is 18.4115 for L1712_H_new.fits
      ;Limiting magnitude is 18.4400 for L1712_Ks_new.fits

   ; Get all spitzer stars with detection quality A, B and C
   spawn,'ssh chyan@capella findmir --ra=250.000445 --dec=-24.292101 --ds9 --dra=1.45 --ddec=0.5 --full >'$
      +conf.regpath+'L1712_new_c2d_source.reg'
   spawn,'ssh chyan@capella findmir --ra=250.000445 --dec=-24.292101 --dra=1.45 --ddec=0.5 --full >'$
      +conf.catpath+'L1712_new_c2dsource.cat'

   ; Building ASSOC catalog for SExtractor
   asoc_mipscat_l1712,'L1712_new_c2dsource.cat'


   ; Run SExtractor for extracting ASSOC sources
   runsexassoc_l1712
   
   ; Combinning the JHK photometry with Spitzer data
   combinecatalog_l1712,cat,catfile='L1712_new_c2dsource.cat',file='L1712_new_source.cat',zero=[0.184683,0.165742,0.219936]

    ; Send this catalog file to SED fitting directory
   spawn,'rsync -arvz '+conf.catpath+'L1712_new_source.cat -e ssh '+$
    'chyan@capella:/data/local/chyan/SEDProject/L1712YSO/'
   spawn,'rsync -arvz '+conf.catpath+'L1712_new_source.cat /Volumes/Data/SEDProject/L1712YSO/'
   

   ;-----------------------------------------------------------
   ; After sending file to SED working directory, switch to SED 
   ;   directory for fitting.
   ;-----------------------------------------------------------
   
   ; Download all the output YSO catalog in FITS format to local disk
   spawn,'rsync -arvz  -e ssh chyan@capella:/data/local/chyan/SEDProject/L1712YSO/output_yso_*.fits '+$
      conf.fitspath+'/'
   spawn,'rsync -arvz  -e ssh chyan@capella:/data/local/chyan/SEDProject/L1712YSO/output_stellar_good.fits '+$
      conf.fitspath+'/'
   
   spawn,'rsync -arvz  /Volumes/Data/SEDProject/L1712YSO/output_yso_*.fits '+$
      conf.fitspath+'/'
   spawn,'rsync -arvz  /Volumes/Data/SEDProject/L1712YSO/output_stellar_good.fits '+$
      conf.fitspath+'/'
      
   spawn,'mv '+conf.fitspath+'output_yso_good.fits '+conf.fitspath+'L1712_new_yso_good.fits'
   spawn,'mv '+conf.fitspath+'output_yso_bad.fits '+conf.fitspath+'L1712_new_yso_bad.fits'
   spawn,'mv '+conf.fitspath+'output_stellar_good.fits '+conf.fitspath+'L1712_new_star.fits'
   
   spawn,'rsync -arvz -e ssh chyan@capella:/data/local/chyan/SEDProject/L1712YSO/plots_* '+conf.sedpath+'L1712/'

   ;  Test the YSO SG Class in this region.
   mkysoassoc,region='L1712'
   runsgysosex,region='L1712'
   sgysoplot,title='L1712 All Sources',ps=conf.pspath+'L1712_new_ysosgtest.eps'
   
   
   ; Make region files for SG class <= 0.03
   ;  In this region, the SG filter setting is [0.0,0.03,0.03] for J, H and K
   sgfilter_l1712, fits='L1712_new_yso_good.fits',newfits='L1712_new_yso_sgfilter.fits',/runsex
   
   examysocandidate,fits=conf.fitspath+'L1712_new_yso_sgfilter.fits',$
      sedpath=conf.sedpath+'L1712/',pos=[250.000445,-24.292101],dpos=[1.45,0.5]
   
      
   nirlim=[5.4e-14,4.81e-14,1.81e-14]
   fluxfilter,nirlim=nirlim, fit=conf.fitspath+'L1712_new_yso_sgfilter.fits',$
      newfits=conf.fitspath+'L1712_new_yso_fluxfilter.fits'

   examysocandidate,fits=conf.fitspath+'L1712_new_yso_fluxfilter.fits',$
      sedpath=conf.sedpath+'L1712/',pos=[250.000445,-24.292101],dpos=[1.45,0.5]

    
   getmipsexcess,fits=conf.fitspath+'L1712_new_star.fits',newfits=conf.fitspath+'L1712_mipsexcess.fits',$
      ps='L1712_new_mipsexcess.ps'

   mkthumbnail_l1712,file='L1712_new_yso_fluxfilter.fits',/clean  
   extractimage,file='L1712_new_yso_fluxfilter.fits', ps='L1712_yso_sed_image.ps',$
      sedpath=conf.sedpath+'L1712/'

   ; First read-in filtered data and save it to another name.
   sedimageinspect,fits=conf.fitspath+'L1712_new_yso_fluxfilter.fits'
   
   ; Use this saved name for better management 
   sedimageinspect,fits=conf.fitspath+'L1712_new_yso_sedinspect_savetemp.fits'
   sedimageinspect,fits=conf.fitspath+'L1712_new_yso_final_130430.fits'

   examysocandidate,fits=conf.fitspath+'L1712_new_yso_final_130430.fits',$
      sedpath=conf.sedpath+'L1712/',pos=[250.000445,-24.292101],dpos=[1.45,0.5]
        ;c2d YSO: SSTc2d J163524.3-243359 missing. Reason: filtered out. (galaxy)
        ;c2d YSO: SSTc2d J164424.3-240125 missing. Reason: in bad yso.
        
   yso_classify,file=conf.fitspath+'L1712_new_yso_final_130430.fits'
 
 
END


PRO RHOOPH_YSO
   COMMON share,conf 
   loadconfig
   
   
   ; Check how many YSOs in c2d catalog for this region
   spawn,'ssh chyan@capella findyso --ra=248.139466 --dec=-23.648925 --ds9 --dra=0.9 --ddec=0.3 --cat=oph>'$
      +conf.regpath+'rho_oph_new_c2d_yso.reg'
   
   ; Starting making photometry corrections.
   runsextractor_rho_oph
   ;getstar_rho_oph,cat,zero=[0.0850808,0.166054,0.186529]
   getstar_rho_oph,cat,zero=[0.100512,0.169380,0.0907915]
   find2mass_rho_oph,ref
   fluxcalib,cat, ref, ps='rho_oph_new_fluxcalib.eps'

;
;   ; Exam the limiting magnitude 
   complimit,fits=conf.wircampath+'rho_oph_J_new.fits',comp=0.90,psfile='rho_oph_J_limitmag.eps',/newsky
   complimit,fits=conf.wircampath+'rho_oph_H_new.fits',comp=0.90,psfile='rho_oph_H_limitmag.eps',/newsky
   complimit,fits=conf.wircampath+'rho_oph_Ks_new.fits',comp=0.90,psfile='rho_oph_Ks_limitmag.eps',/newsky
        ;Limiting magnitude is 19.3547 for rho_oph_J_new.fits
        ;Limiting magnitude is 18.3221 for rho_oph_H_new.fits
        ;Limiting magnitude is 18.1926 for rho_oph_Ks_new.fits


   ; Get all spitzer stars with detection quality A, B and C
   spawn,'ssh chyan@capella findmir --ra=245.86154 --dec=-23.191563 --dra=0.8 --ddec=0.6 --ds9 --full >'$
      +conf.regpath+'rho_oph_new_c2d_source.reg'
   spawn,'ssh chyan@capella findmir --ra=245.86154 --dec=-23.191563 --dra=0.8 --ddec=0.6 --full >'$
      +conf.catpath+'rho_oph_new_c2dsource.cat'

   ; Building ASSOC catalog for SExtractor
   asoc_mipscat_rho_oph,'rho_oph_new_c2dsource.cat'


   ; Run SExtractor for extracting ASSOC sources
   runsexassoc_rho_oph
   
   ; Combinning the JHK photometry with Spitzer data
   combinecatalog_rho_oph,cat,catfile='rho_oph_new_c2dsource.cat',file='rho_oph_new_source.cat',zero=[0.100512,0.169380,0.0907915]

    ; Send this catalog file to SED fitting directory
   spawn,'rsync -arvz '+conf.catpath+'rho_oph_new_source.cat -e ssh '+$
    'chyan@capella:/data/local/chyan/SEDProject/rho_ophYSO/'
   spawn,'rsync -arvz '+conf.catpath+'rho_oph_new_source.cat /Volumes/Data/SEDProject/rho_ophYSO/'
   

   ;-----------------------------------------------------------
   ; After sending file to SED working directory, switch to SED 
   ;   directory for fitting.
   ;-----------------------------------------------------------
   
   ; Download all the output YSO catalog in FITS format to local disk
   spawn,'rsync -arvz  -e ssh chyan@capella:/data/local/chyan/SEDProject/rho_ophYSO/output_yso_*.fits '+$
      conf.fitspath+'/'
   spawn,'rsync -arvz  -e ssh chyan@capella:/data/local/chyan/SEDProject/rho_ophYSO/output_stellar_good.fits '+$
      conf.fitspath+'/'
   
   spawn,'rsync -arvz  /Volumes/Data/SEDProject/rho_ophYSO/output_yso_*.fits '+$
      conf.fitspath+'/'
   spawn,'rsync -arvz  /Volumes/Data/SEDProject/rho_ophYSO/output_stellar_good.fits '+$
      conf.fitspath+'/'
      
   spawn,'mv '+conf.fitspath+'output_yso_good.fits '+conf.fitspath+'rho_oph_new_yso_good.fits'
   spawn,'mv '+conf.fitspath+'output_yso_bad.fits '+conf.fitspath+'rho_oph_new_yso_bad.fits'
   spawn,'mv '+conf.fitspath+'output_stellar_good.fits '+conf.fitspath+'rho_oph_new_star.fits'
   
   spawn,'rsync -arvz -e ssh chyan@capella:/data/local/chyan/SEDProject/rho_ophYSO/plots_* '+conf.sedpath+'rho_oph/'

   ;  Test the YSO SG Class in this region.
   mkysoassoc,region='rho_oph'
   runsgysosex,region='rho_oph'
   sgysoplot, region='rho_oph',title='rho_oph All Sources',ps=conf.pspath+'rho_oph_new_ysosgtest.eps'
   
   
   ; Make region files for SG class <= 0.03
   ;  In this region, the SG filter setting is [0.0,0.03,0.03] for J, H and K
   sgfilter_rho_oph, fits='rho_oph_new_yso_good.fits',newfits='rho_oph_new_yso_sgfilter.fits',/runsex
   
   examysocandidate,fits=conf.fitspath+'rho_oph_new_yso_sgfilter.fits',$
      sedpath=conf.sedpath+'rho_oph/',pos=[245.86154,-23.191563],dpos=[0.8,0.6]
        ;c2d YSO: SSTc2d J162110.9-234329 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J162119.2-234229 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J162221.0-230402 missing. Reason: in bad yso.  
      
   nirlim=[5.71e-14,5.231e-14,2.27e-14]
   fluxfilter,nirlim=nirlim, fit=conf.fitspath+'rho_oph_new_yso_sgfilter.fits',$
      newfits=conf.fitspath+'rho_oph_new_yso_fluxfilter.fits'

   examysocandidate,fits=conf.fitspath+'rho_oph_new_yso_fluxfilter.fits',$
      sedpath=conf.sedpath+'rho_oph/',pos=[245.86154,-23.191563],dpos=[0.8,0.6]

    
   getmipsexcess,fits=conf.fitspath+'rho_oph_new_star.fits',newfits=conf.fitspath+'rho_oph_mipsexcess.fits',$
      ps='rho_oph_new_mipsexcess.ps'

   mkthumbnail_rho_oph,file='rho_oph_new_yso_fluxfilter.fits',/clean  
   extractimage,file='rho_oph_new_yso_fluxfilter.fits', ps='rho_oph_yso_sed_image.ps',$
      sedpath=conf.sedpath+'rho_oph/'

   ; First read-in filtered data and save it to another name.
   sedimageinspect,fits=conf.fitspath+'rho_oph_new_yso_fluxfilter.fits'
   
   ; Use this saved name for better management 
   sedimageinspect,fits=conf.fitspath+'rho_oph_new_yso_sedinspect_savetemp.fits'
   sedimageinspect,fits=conf.fitspath+'rho_oph_new_yso_final_130509.fits'

   examysocandidate,fits=conf.fitspath+'rho_oph_new_yso_final_130509.fits',$
      sedpath=conf.sedpath+'rho_oph/',pos=[245.86154,-23.191563],dpos=[0.8,0.6]
        ;c2d YSO: SSTc2d J162110.9-234329 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J162119.2-234229 missing. Reason: in bad yso.
        ;c2d YSO: SSTc2d J162221.0-230402 missing. Reason: in bad yso.        
   
   yso_classify,file=conf.fitspath+'rho_oph_new_yso_final_130509.fits'
 
 
 END


PRO POSTANALYSIS

   COMMON share,conf 
   loadconfig
   
;   ysocat=['L1689_yso_final_111028.fits',$
;          'L1688_yso_final_111112.fits',$
;          'L1709_yso_final_111104.fits']

   badysocat=['L1689_new_yso_bad.fits',$
              'L1688_new_yso_bad.fits',$  
              'L1709_new_yso_bad.fits',$  
              'L1712_new_yso_bad.fits',$  
              'rho_oph_new_yso_bad.fits']
              
   combineysocatalog,fits=conf.fitspath+badysocat,newfits=conf.fitspath+'rho_new_badyso_final_130509.fits'
   
        ;L1689
        ;c2d YSO: SSTc2d J163301.6-240356 missing. Reason: in bad yso.*
        ;c2d YSO: SSTc2d J163346.2-242753 missing. Reason: fitted with star.
        
        ;L1688
        ;c2d YSO: SSTc2d J162225.2-240514 missing. Reason: Not in catalog.
        ;c2d YSO: SSTc2d J162527.6-243648 missing. Reason: in bad yso.*
        ;c2d YSO: SSTc2d J162605.8-244255 missing. Reason: in bad yso.*
        ;c2d YSO: SSTc2d J162610.3-242055 missing. Reason: in bad yso.*
        ;c2d YSO: SSTc2d J162617.5-242315 missing. Reason: filtered out.*
        ;c2d YSO: SSTc2d J162636.5-242317 missing. Reason: filtered out.*
        ;c2d YSO: SSTc2d J162711.7-243832 missing. Reason: in bad yso.*
        ;c2d YSO: SSTc2d J162713.3-244133 missing. Reason: in bad yso.*
        ;c2d YSO: SSTc2d J162716.4-243114 missing. Reason: in bad yso.*
        ;c2d YSO: SSTc2d J162717.6-240514 missing. Reason: in bad yso.*
        ;c2d YSO: SSTc2d J162743.8-244308 missing. Reason: in bad yso.*
        ;c2d YSO: SSTc2d J162954.6-245846 missing. Reason: in bad yso.*
        ;c2d YSO: SSTc2d J163524.3-243359 missing. Reason: filtered out. (galaxy)*
        ;c2d YSO: SSTc2d J164424.3-240125 missing. Reason: in bad yso.*
        ;c2d YSO: SSTc2d J162110.9-234329 missing. Reason: in bad yso.*
        ;c2d YSO: SSTc2d J162119.2-234229 missing. Reason: in bad yso.*
        ;c2d YSO: SSTc2d J162221.0-230402 missing. Reason: in bad yso.*        

        ;c2d YSO: SSTc2d J162453.0-250556 missing. Reason: Not in catalog.
        ;c2d YSO: SSTc2d J162602.9-243948 missing. Reason: filtered out.*
        ;c2d YSO: SSTc2d J162856.0-233107 missing. Reason: Not in catalog.
        ;c2d YSO: SSTc2d J163019.8-240256 missing. Reason: filtered out.
        ;c2d YSO: SSTc2d J163227.9-252502 missing. Reason: Not in catalog.
      
   list=['SSTc2d J163301.6-240356','SSTc2d J163019.8-240256','SSTc2d J162527.6-243648',$
         'SSTc2d J162605.8-244255','SSTc2d J162610.3-242055','SSTc2d J162636.5-242317',$
         'SSTc2d J162711.7-243832','SSTc2d J162713.3-244133','SSTc2d J162716.4-243114',$
         'SSTc2d J162717.6-240514','SSTc2d J162743.8-244308','SSTc2d J162954.6-245846',$
         'SSTc2d J163524.3-243359','SSTc2d J164424.3-240125','SSTc2d J162110.9-234329',$
         'SSTc2d J162119.2-234229','SSTc2d J162221.0-230402','SSTc2d J162617.5-242315',$
         'SSTc2d J162602.9-243948','SSTc2d J162453.0-250556','SSTc2d J162856.0-233107',$
         'SSTc2d J163227.9-252502','SSTc2d J162225.2-240514']  
   
   
   
   ;list=['SSTc2d J163301.6-240356','SSTc2d J163346.2-242753']
   getysosedimage,fits=conf.fitspath+'rho_new_badyso_final_130509.fits', list=list,path=conf.path+'ImageSED/C2DMissing'
   getysosedimage,fits=conf.fitspath+'L1688_new_yso_good.fits', list=list,path=conf.path+'ImageSED/C2DMissing'
   getysosedimage,fits=conf.fitspath+'L1712_new_yso_good.fits', list=list,path=conf.path+'ImageSED/C2DMissing'
   getysosedimage,fits=conf.fitspath+'L1709_new_yso_good.fits', list=list,path=conf.path+'ImageSED/C2DMissing'
   getysosedimage,fits=conf.fitspath+'L1712_new_yso_good.fits', list=list,path=conf.path+'ImageSED/C2DMissing'
   getysosedimage,fits=conf.fitspath+'rho_oph_new_yso_good.fits', list=list,path=conf.path+'ImageSED/C2DMissing'
   
   
   getysosedimage,fits=conf.fitspath+'L1688_new_yso_good.fits', list=list,path=conf.path+'ImageSED/C2DMissing'
   list='SSTc2d J163019.8-240256'
   getysosedimage,fits=conf.fitspath+'L1688_yso_good.fits', list=list,path=conf.path+'ImageSED/C2DMissing'
   
   
   getradec,fits=conf.fitspath+'rho_new_badyso_final_130509.fits',list=list
   getradec,fits=conf.fitspath+'L1688_new_yso_good.fits',list=list
   getradec,fits=conf.fitspath+'L1712_new_yso_good.fits',list=list
   
   starlist=['SSTc2d J163346.2-242753']
   getstarsedimage,fits=conf.fitspath+'L1689_new_star.fits', list=starlist,path=conf.path+'ImageSED/C2DMissing'
   
   list='SSTc2d J162157.7-242943'
   getysosedimage,fits=conf.fitspath+'rho_new_yso_final_slope_131219.fits', list=list,path=conf.path+'ImageSED/YSO'
   
   ; Making SED+image for all YSOs
   getysosedimage,fits=conf.fitspath+'rho_new_yso_final_slope_131219.fits', /all,path=conf.path+'ImageSED/YSO'

              
   ysocat=['L1689_new_yso_final_130513.fits',$
           'L1688_new_yso_final_130423.fits',$
           'L1709_new_yso_final_130428.fits',$
           'L1712_new_yso_final_130430.fits',$
           'L1688_missed_YSO.fits',$
           'rho_oph_new_yso_final_130509.fits']

   combineysocatalog,fits=conf.fitspath+ysocat,newfits=conf.fitspath+'rho_new_yso_final_130515.fits'
   combineysocatalog,fits=conf.fitspath+ysocat,newfits=conf.fitspath+'rho_new_yso_final_131226.fits'
   
   ;-------------------------------------------------
   ; Write important information into FITS file
   ;
   writeinfotofits,fits=conf.fitspath+'rho_new_yso_final_130515.fits',newfits=conf.fitspath+'rho_new_yso_final_slope_131219.fits'
   writeinfotofits,fits=conf.fitspath+'rho_new_yso_final_131226.fits',newfits=conf.fitspath+'rho_new_yso_final_slope_131227.fits'
   writeinfotofits,fits=conf.fitspath+'rho_new_yso_final_131226.fits',newfits=conf.fitspath+'rho_new_yso_final_slope_140108.fits'

   ;---------------------
   ; Plot luminosity function
   ;-----------------------
   ysolf,fits=conf.fitspath+'rho_new_yso_final_slope_131227.fits',ps=conf.pspath+'ysolf.eps',mbin=0.2
   
   
   cmdfilterplotbyclass,file=conf.fitspath+'rho_new_yso_final_slope_131227.fits'

   
   for i=0,n_elements(ysocat)-1 do yso_classify,file=conf.fitspath+ysocat[i]
   
   
   sedimageinspect,fits=conf.fitspath+'rho_new_yso_final_130509.fits'
   sedimageinspect,fits=conf.fitspath+'rho_new_yso_final_130515.fits'
   
   yso_classify,file=conf.fitspath+'L1688_new_yso_final_130423.fits'
   yso_classify,file=conf.fitspath+'L1689_new_yso_final_130513.fits'
   yso_classify,file=conf.fitspath+'L1709_new_yso_final_130428.fits'
   yso_classify,file=conf.fitspath+'L1712_new_yso_final_130430.fits'
   yso_classify,file=conf.fitspath+'rho_oph_new_yso_final_130509.fits'
   
   yso_classify,file=conf.fitspath+'rho_new_yso_final_131226.fits'
   
   
   yso_classify,file=conf.fitspath+'rho_new_yso_final_130515.fits',$
   	ps=conf.pspath+'rho_new_yso_slope.eps',alpha=[0.3,-0.3,-1.6],/withc2d
   
   yso_classify,file=conf.fitspath+'rho_new_yso_final_130515.fits',$
   	ps=conf.pspath+'rho_yso_slope_130613.eps',alpha=[-0.5],/withc2d,mbin=0.2

   writeinfotofits,fits=conf.fitspath+'rho_new_yso_final_130515.fits',newfits=conf.fitspath+'rho_new_yso_final_slope_131219.fits'
   
   makelatextable,fits=conf.fitspath+'rho_new_yso_final_slope_131219.fits'
   makeparametertable,fits=conf.fitspath+'rho_new_yso_final_slope_131219.fits'
   
   
   examysocandidate,fits=conf.fitspath+'L1688_new_yso_final_130423.fits',$
     sedpath=conf.sedpath,pos=[248.39013,-24.088804],dpos=[6.0,6.0],/nops
   examysocandidate,fits=conf.fitspath+'L1688_new_yso_final_130423.fits',$
     sedpath=conf.sedpath,pos=[248.39013,-24.088804],dpos=[6.0,6.0],/nops

   examysocandidate,fits=conf.fitspath+'rho_new_yso_final_slope_131219.fits',$
     sedpath=conf.sedpath,pos=[248.39013,-24.088804],dpos=[6.0,6.0],/nops
     
   
   ; Selecting VeLLos
   selectvello,fits=conf.fitspath+'rho_new_yso_final_slope_131219.fits'
   
   ; Checking why there is a gap in CMD plot
   cmdfilterplot,file=conf.fitspath+'L1688_yso_good.fits'
   cmdfilterplot,file=conf.fitspath+'L1688_yso_sgfilter.fits'
   cmdfilterplot,file=conf.fitspath+'L1688_yso_fluxfilter.fits'
   cmdfilterplot,file=conf.fitspath+'L1688_yso_final_111112.fits'

   cmdfilterplot,file=conf.fitspath+'L1689_yso_sgfilter.fits'
   cmdfilterplot,file=conf.fitspath+'L1689_yso_sgfilter.fits'
   
   cmdfilterplot,file=conf.swirepath+'output_yso_good.fits'
   cmdfilterplot,file=conf.swirepath+'output_yso.fits'
   cmdfilterplot,file=conf.swirepath+'output_stellar.fits',ps='swire_allsource_cmdplot.eps',sym=4,sizesym=0.4
   cmdfilterplot,file=conf.swirepath+'output_yso_good.fits',ps='swire_ysogood_cmdplot.eps',sym=4,sizesym=0.4


   
   cmdfilterplot,file=conf.fitspath+'L1689_new_yso_final_130513.fits',ps='L1689_yso_cmdplot.eps',/markc2d
   cmdfilterplot,file=conf.fitspath+'L1688_new_yso_final_130423.fits',ps='L1688_yso_cmdplot.eps',/markc2d
   cmdfilterplot,file=conf.fitspath+'L1709_new_yso_final_130428.fits',ps='L1709_yso_cmdplot.eps',/markc2d
   cmdfilterplot,file=conf.fitspath+'L1712_new_yso_final_130430.fits',ps='L1712_yso_cmdplot.eps',/markc2d
   cmdfilterplot,file=conf.fitspath+'rho_oph_new_yso_final_130509.fits',ps='rho_yso_cmdplot.eps',/markc2d,/dumpgalaxyzone
   
   cmdfilterplot,file=conf.fitspath+'rho_new_yso_final_130515.fits',ps='rho_new_yso_cmdplot.eps',/markc2d
   cmdfilterplot,file=conf.fitspath+'rho_new_yso_final_slope_131219.fits',/dumpgalaxyzone

   
   cmdfilterplot,file=conf.fitspath+'c2d_cat_yso_good.fits'
   
   yso_parameter,fits=conf.fitspath+'rho_new_yso_final_slope_131219.fits',final
   

   cmdplot,file=conf.fitspath+'rho_new_yso_final_slope_131219.fits',ps='ysocmds.eps' 
   
   
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

PRO MAKINGFIGURE
    COMMON share,conf
    loadconfig

    ;
    ;  Plotting SExtractor SG testing result
    ;
    sgysoplot,region='all',title='All Sources',ps=conf.figpath+'all_ysosgtest.eps'
    sgysoplot,region='L1689',title='L1689 Sources',ps=conf.figpath+'L1689_ysosgtest.eps'
    sgysoplot,region='L1688',title='L1689 Sources',ps=conf.figpath+'L1688_ysosgtest.eps'
    sgysoplot,region='L1712',title='L1712 Sources',ps=conf.figpath+'L1712_ysosgtest.eps'
    sgysoplot,region='L1709',title='L1689 Sources',ps=conf.figpath+'L1709_ysosgtest.eps'
    sgysoplot,region='rho_oph',title='Rho Oph Sources',ps=conf.figpath+'rho_oph_ysosgtest.eps'
    
    
    ;
    ;  Makeing color image
    ;         mShrink is not working well on Mac, have to using Linux version
    spawn,'mShrink '+conf.wircampath+'12AT99_KS_coadd.fits '+conf.wircampath+'oph_shrink_K.fits 3'
    spawn,'mShrink '+conf.wircampath+'12AT99_H_coadd.fits '+conf.wircampath+'oph_shrink_H.fits 3'
    spawn,'mShrink '+conf.wircampath+'12AT99_J_coadd.fits '+conf.wircampath+'oph_shrink_J.fits 3'
    
    ; Download from procyon
    spawn,'rsync -arvzu -e ssh chyan@procyon:/data/procyon/Projects/Ophiuchus/WIRCam/oph_shrink*.fits '+conf.wircampath
   
    spawn,'ds9 -rgb -red '+conf.wircampath+'oph_shrink_K.fits -scale limits 0 90 '+$
          '-cmap value 2.10699 0.14069 -smooth '+$
          '-green '+conf.wircampath+'oph_shrink_H.fits -scale limits 0 150 '+$
          '-cmap value 4.31223  0.08181 -smooth '+$
          '-blue '+conf.wircampath+'oph_shrink_J.fits -scale limits 0 120 '+$
          '-cmap value 7.79476 0.0401251 -smooth '+$
          '-view colorbar no -grid load '+conf.ds9path+'wircamcolor_all.grd '+$
          '-grid yes -grid grid gap1 0.35 -grid grid gap2 0.35 '+$
          '-regions load '+conf.regpath+'ophiuchus_regions.reg  -regions select all -regions color white '+$
          '-geometry 2100x1200  -zoom 0.06 0.06 -print level 2 -print resolution 600 '+$
          '-psprint filename '+conf.figpath+'ophiuchus_wircam.ps -psprint destination file '+$
          '-psprint &'

    spawn,'ds9 -rgb -red '+conf.swirepath+'EN1_ch3_small.fits -scale limits 0 20 '+$
          '-cmap value 5.44474 0.0941296 -smooth '+$
          '-green '+conf.swirepath+'EN1_ch2_small.fits -scale limits 0 6 '+$
          '-cmap value 4.74394  0.0941296 -smooth '+$
          '-blue '+conf.swirepath+'EN1_ch1_small.fits -scale limits 0 1 '+$
          '-cmap value 4.1779 0.105263 -smooth '+$
          '-view colorbar no -grid load '+conf.ds9path+'wircamcolor_all.grd '+$
          '-grid yes -grid grid gap1 0.5 -grid grid gap2 0.5 '+$
          '-geometry 900x1200  -zoom 0.4 0.4 -print level 2 -print resolution 600 '+$
          '-psprint filename '+conf.figpath+'en1_spitzer.ps -psprint destination file '+$
          '-psprint &'
    
    ;-----------------------------------
    ; Plot photometry examination
    getstar_l1688,cat,zero=[0.109135,0.0830246,0.0759849]
    find2mass_l1688,ref
    fluxcalib,cat, ref, ps='L1688_new_fluxcalib.ps',region='L1688'
    
    getstar_l1689,cat,zero=[0.155956,0.0715663,0.0901451]
    find2mass_l1689,ref
    fluxcalib,cat, ref, ps='L1689_new_fluxcalib.eps', region='L1689'

    getstar_l1709,cat,zero=[0.000490762,0.0808809,0.100707]
    find2mass_l1709,ref
    fluxcalib,cat, ref, ps='L1709_new_fluxcalib.eps',region='L1709'
    
    getstar_l1712,cat,zero=[0.184683,0.165742,0.219936]
    find2mass_l1712,ref
    fluxcalib,cat, ref, ps='L1712_new_fluxcalib.eps',region='L1712'

    getstar_rho_oph,cat,zero=[0.100512,0.169380,0.0907915]
    find2mass_rho_oph,ref
    fluxcalib,cat, ref, ps='rho_oph_new_fluxcalib.eps'

    makeysoregion,fits=conf.fitspath+'rho_new_yso_final_slope_131219.fits'
    
    ;------------------------------------------------
    ; Making SED+image for all YSOs
    ;----------------------------------------------------
    getysosedimage,fits=conf.fitspath+'rho_new_yso_final_slope_131219.fits', /all,path=conf.path+'ImageSED/YSO'

    ;--------------------------------------------------------
    ; Making averaged SED for newly detected class I source
    ;--------------------------------------------------------
    plotavgsed,fits=conf.fitspath+'rho_new_yso_final_slope_131219.fits',class='I',ps=conf.figpath+'avgsed_newclassi.eps'
    cmdagbcheck,fits=conf.fitspath+'rho_new_yso_final_slope_131227.fits',ps=conf.figpath+'agbcmdcheck_newclassi.eps'
    
    selectvello,fits=conf.fitspath+'rho_new_yso_final_slope_131227.fits',table='vello.tex',c2dflag=0
    selectvello,fits=conf.fitspath+'rho_new_yso_final_slope_131227.fits',table='vello_c2d.tex',c2dflag=1
    ;----------------------------------------------------------------
    ;  Plotting the distributionof YSOs
    ;---------------------------------------------------------------       
    
    spawn,'ds9 '+conf.extpath+'2massav.fits -scale limits 0 30 '+$
          '-cmap value 3.48361 0.187797  '+$
          '-regions load '+conf.regpath+'class_1.reg '+$
          '-regions load '+conf.regpath+'class_f.reg '+$
          '-regions load '+conf.regpath+'class_2.reg '+$
          '-regions load '+conf.regpath+'class_3.reg '+$
          '-regions select all -regions width 4 '+$
          '-view colorbar no -grid load '+conf.ds9path+'yso_distribution.grd '+$
          '-geometry 1200x900  -zoom 2.5 2.5 -print level 2 -print resolution 600 '+$
          '-psprint filename '+conf.figpath+'all_yso_distribution.ps -psprint destination file '+$
          '-psprint &'

        ;
        spawn,'ds9 '+conf.extpath+'2massav.fits -scale limits 0 30 '+$
          '-cmap value 3.48361 0.187797  '+$
          '-regions load '+conf.regpath+'c2d_class_1.reg '+$
          '-regions load '+conf.regpath+'c2d_class_f.reg '+$
          '-regions load '+conf.regpath+'c2d_class_2.reg '+$
          '-regions load '+conf.regpath+'c2d_class_3.reg '+$
          '-regions select all -regions width 4 '+$
          '-view colorbar no -grid load '+conf.ds9path+'yso_distribution.grd '+$
          '-geometry 1200x900  -zoom 2.5 2.5 -print level 2 -print resolution 600 '+$
          '-psprint filename '+conf.figpath+'c2d_yso_distribution.ps -psprint destination file '+$
          '-psprint &'

        spawn,'ds9 '+conf.extpath+'2massav.fits -scale limits 0 30 '+$
          '-cmap value 3.48361 0.187797  '+$
          '-regions load '+conf.regpath+'new_class_1.reg '+$
          '-regions load '+conf.regpath+'new_class_f.reg '+$
          '-regions load '+conf.regpath+'new_class_2.reg '+$
          '-regions load '+conf.regpath+'new_class_3.reg '+$
          '-regions select all -regions width 4 '+$
          '-view colorbar no -grid load '+conf.ds9path+'yso_distribution.grd '+$
          '-geometry 1200x900  -zoom 2.5 2.5 -print level 2 -print resolution 600 '+$
          '-psprint filename '+conf.figpath+'new_yso_distribution.ps -psprint destination file '+$
          '-psprint &'
    ;-------------------------------------
    ;  Plotting the CMD diagram      
    ;-------------------------------------

    cmdfilterplotbyclass,file=conf.fitspath+'rho_new_yso_final_slope_131227.fits',ps=conf.pspath+'yso_cmdplot_all.eps'
    cmdfilterplot,file=conf.fitspath+'L1689_new_yso_final_130513.fits',ps='L1689_yso_cmdplot.eps',/markc2d
    cmdfilterplot,file=conf.fitspath+'L1688_new_yso_final_130423.fits',ps='L1688_yso_cmdplot.eps',/markc2d
    cmdfilterplot,file=conf.fitspath+'L1709_new_yso_final_130428.fits',ps='L1709_yso_cmdplot.eps',/markc2d
    cmdfilterplot,file=conf.fitspath+'L1712_new_yso_final_130430.fits',ps='L1712_yso_cmdplot.eps',/markc2d
    cmdfilterplot,file=conf.fitspath+'rho_oph_new_yso_final_130509.fits',ps='rho_yso_cmdplot.eps',/markc2d

    ;------------------------------------------
    ; Plotting the histogram of SED slopes
    ;-----------------------------------
    yso_classify,file=conf.fitspath+'rho_new_yso_final_slope_131227.fits',mbin=0.2,$
      ps=conf.pspath+'rho_yso_slope_1301229.eps',alpha=[0.3,-0.3,-1.6],/withc2d,/markclass

    kslaw,ps=conf.pspath+'kslaw.eps'
    
    plotalphatbol,fits=conf.fitspath+'rho_new_yso_final_slope_131227.fits',ps=conf.pspath+'slopetbol.eps'
    plotltottbol,fits=conf.fitspath+'rho_new_yso_final_slope_131227.fits',ps=conf.pspath+'slopetbol.eps'

END





  









