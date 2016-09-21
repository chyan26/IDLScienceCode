@imaging
@photometry
@radio
@calibassoc
@diagrams
@cmdclean
@complimit
@registercatalog
@extinction
@getklf
@modelklf
@simklf
@stellarmass
@lineimage
@cloudmass
@pvdiagram

PRO LOADCONFIG
   COMMON share,conf
   
   !path=!path+':'+'~chyan/IDLSourceCode/Library/textoidl/'
   
   if strcmp(!VERSION.OS,'linux') then begin 
     path='/data/disk/chyan/Projects/G173/'
   endif else begin
     path='/Volumes/Science/Projects/G173/'
   endelse
  
   wircampath=path+'WIRCam/'
   fitspath=path+'FITS/'
   pspath=path+'PS/'
   aropath=path+'ARO/'
   catpath=path+'Catalog/'
   regpath=path+'Regions/'
   imagepath=path+'Image/'
   confpath=path+'Config/'
   ds9path=path+'DS9/'
   sraopath=path+'SRAO/'
   bimapath=path+'BIMA/'
   paperfigpath='~/Documents/Paper/G173/Figures/'
   paperpath='~/Documents/Paper/G173/'
   conf={path:path,wircampath:wircampath,fitspath:fitspath,pspath:pspath,$
      imagepath:imagepath,aropath:aropath,catpath:catpath,regpath:regpath,$
      confpath:confpath,ds9path:ds9path,sraopath:sraopath,bimapath:bimapath,$
      paperfigpath:paperfigpath,paperpath:paperpath}
END



PRO G173_RADIO
	COMMON share,conf	
	loadconfig
	
	
	resizeimage_s233g173
	
	resizeimage_g173
	
	
	; Producing moment 0 map of entire region.
	integrate_map,fits=conf.aropath+'CO_s233ir_otf_allbackend_130222.fits',$
		vel_range=[-40,0],eta=0.65,outfits=conf.aropath+'CO_integrated_allbackend-2.fits'
	
	; Trim CO moment 0 map to S233IR and G173 region
	resizeimage_co32,fits=conf.aropath+'CO_integrated_allbackend.fits',$
		outfits=conf.aropath+'s233-g173_CO.fits',imagesize=207


	; Producing a contour map 40,250 gap=27.5
	spawn,'ds9 '+conf.aropath+'s233-g173_CO.fits '+'-contour yes -contour limits 40 250 '+$
		'-contour smooth 4 -contour nlevels 13 -contour save '+conf.ds9path+'s233-g173_CO.con'
	
	; Trim CO moment 0 
	resizeimage_g173_radio,fits=conf.aropath+'CO_integrated_allbackend.fits',$
		outfits=conf.aropath+'g173_CO.fits',imagesize=100
	
	spawn,'ds9 '+conf.aropath+'g173_CO.fits '+'-contour yes -contour limits 55 55 '+$
		'-contour smooth 5 -contour nlevels 1 -contour save '+conf.ds9path+'g173_CO.con'

	integrate_map,fits=conf.aropath+'CO_s233ir_otf_allbackend_130222.fits',$
		vel_range=[-16,10],eta=0.65,outfits=conf.aropath+'CO_integrated_red.fits'
	
	resizeimage_g173_radio,fits=conf.aropath+'CO_integrated_red.fits',$
		outfits=conf.aropath+'g173_CO_red.fits',imagesize=100

	spawn,'ds9 '+conf.aropath+'g173_CO_red.fits '+' -smooth yes -smooth radius 7 '+$
	  '-contour yes -contour limits 30 70 '+$
		'-contour smooth 3 -contour nlevels 11 -contour save '+conf.ds9path+'g173_CO_red.con'
	
	integrate_map,fits=conf.aropath+'CO_s233ir_otf_allbackend_130222.fits',$
		vel_range=[-30,-18],eta=0.65,outfits=conf.aropath+'CO_integrated_blue.fits'

	resizeimage_g173_radio,fits=conf.aropath+'CO_integrated_blue.fits',$
		outfits=conf.aropath+'g173_CO_blue.fits',imagesize=100

	spawn,'ds9 '+conf.aropath+'g173_CO_blue.fits '+' -smooth yes -smooth radius 7 '+$
	  '-contour yes -contour limits 30 70 '+$
		'-contour smooth 3 -contour nlevels 11 -contour save '+conf.ds9path+'g173_CO_blue.con'
	
	
	resizeimage_g173_radio,fits=conf.aropath+'CO_integrated_allbackend.fits',$
		outfits=conf.aropath+'g173_CO.fits',imagesize=100

  ; Making the continuum image w
  integrate_map,fits=conf.bimapath+'g173cube.fits',$
    vel_range=[-46,10],outfits=conf.bimapath+'bima_int_0703.fits'
  
  ; Integrate the high velocity components from OVRO observation	
	integrate_map,fits=conf.bimapath+'g173cube.fits',$
    ex_range=[-30,-5],vel_range=[-46,10],outfits=conf.bimapath+'ovro_highvel_0911.fits',/cont

  integrate_map,fits=conf.bimapath+'g173cube.fits',$
    vel_range=[-46,-30],outfits=conf.bimapath+'ovro_red_0911.fits'
  
  integrate_map,fits=conf.bimapath+'g173cube.fits',$
    vel_range=[-5,10],outfits=conf.bimapath+'ovro_blu_0911.fits'


  spawn,'mSubimage  '+conf.bimapath+'bima_int_noline_0703.fits '+$
    conf.fitspath+'g173_bima_int_noline.fits 84.86552 35.678996 0.03 0.03'
  
  spawn,'ds9 '+conf.fitspath+'g173_bima_int_noline.fits -contour yes -contour limits 0.12 0.3 '+$
      '-smooth yes -smooth radius 3 -contour smooth 1 -contour nlevels 10 '+$
      '-contour save '+conf.ds9path+'bima_int_noline.con' 
   
  spawn,'mSubimage  '+conf.fitspath+'sg_g173_kcont_new.fits '+$
    conf.fitspath+'g173_kcont_core.fits 84.86552 35.678996 0.03 0.03'
	
  spawn,'mSubimage  '+conf.bimapath+'g173cont.fits '+$
    conf.fitspath+'sub_g173_bima_cont.fits 84.86552 35.678996 0.01 0.01'
  
  
  ; Cut the sub-regions for radio emission.
  spawn,'mSubimage  '+conf.bimapath+'ovro_red_0911.fits '+$
    conf.fitspath+'sub_g173_ovro_red_0911.fits 84.86552 35.678996 0.03 0.03'

  spawn,'mSubimage  '+conf.bimapath+'ovro_blu_0911.fits '+$
    conf.fitspath+'sub_g173_ovro_blu_0911.fits 84.86552 35.678996 0.03 0.03'
  
  
  ; Red component 1-sigma=0.9 Jy
  ; Blue component 1-sigma=0.7 Jy
  
  
  ; Plot 3mm continuum images, 1sigma=2 mJy/beam.  Plotted from 3.5-sigma with spacing of 1-sigma   
  spawn,'ds9 '+conf.fitspath+'sub_g173_bima_cont.fits -contour yes -contour limits 0.007 0.021 '+$
      '-smooth yes -smooth radius 1 -contour smooth 1 -contour nlevels 8 '+$
      '-contour save '+conf.ds9path+'bima_cont.con' 
  
  ; Plot RED component. 1sigma=0.9 Jy.  Plot from 4-sigma,spacing = 1-sigma 
  spawn,'ds9 '+conf.fitspath+'sub_g173_ovro_red_0911.fits -contour yes -contour limits 3.6 9.0 '+$
      '-smooth yes -smooth radius 1 -contour smooth 1 -contour nlevels 7 '+$
      '-contour save '+conf.ds9path+'sub_g173_ovro_red_0911.con' 
  
  ; Plot BLUE component. 1sigma=0.7 Jy.  Plot from 4-sigma,spacing = 1-sigma 
  spawn,'ds9 '+conf.fitspath+'sub_g173_ovro_blu_0911.fits -contour yes -contour limits 2.8 7.0 '+$
      '-smooth yes -smooth radius 1 -contour smooth 1 -contour nlevels 7 '+$
      '-contour save '+conf.ds9path+'sub_g173_ovro_blu_0911.con' 
    
	
  ; Plotted with high-velocity CO and continuum in 112GHz (3mm). 
  spawn,'ds9 '+conf.fitspath+'g173_kcont_core.fits -colorbar no -grid yes -grid load '+$
    conf.ds9path+'ds9.grd -grid grid gap1 0.008 -grid grid gap2 0.008 '+$
    '-scale limits 0 4000 -cmap value 8.5 0.014 -zoom 1.2 1.2 '+$
    '-geometry 900x1000 -zoom to fit '+$
    '-contour load '+conf.ds9path+'bima_cont.con wcs fk5 green 1 '+$
    '-contour load '+conf.ds9path+'sub_g173_ovro_red_0911.con wcs fk5 red 1 '+$
    '-contour load '+conf.ds9path+'sub_g173_ovro_blu_0911.con wcs fk5 blue 1 '+$
    '-psprint filename '+conf.pspath+'g173_CO_highvel_kcont.ps -psprint destination file '+$
    '-psprint &'
    
  ;------------------------------------------------------------------
  ;  Making four velocity components
  ; 
  ;------------------------------------------------------------------
  integrate_map,fits=conf.bimapath+'g173cube.fits',$
    vel_range=[-45.9,-33.0],outfits=conf.bimapath+'ovro_blu_2_1124.fits'
  integrate_map,fits=conf.bimapath+'g173cube.fits',$
    vel_range=[-32.0,-18.7],outfits=conf.bimapath+'ovro_blu_1_1124.fits'
  integrate_map,fits=conf.bimapath+'g173cube.fits',$
    vel_range=[-17.8,-4.3],outfits=conf.bimapath+'ovro_red_1_1124.fits'
  integrate_map,fits=conf.bimapath+'g173cube.fits',$
    vel_range=[-4.0,10],outfits=conf.bimapath+'ovro_red_2_1124.fits'

   
  spawn,'mSubimage  '+conf.bimapath+'ovro_blu_2_1124.fits '+$
    conf.fitspath+'sub_g173_ovro_blu_2_1124.fits 84.86552 35.678996 0.03 0.03'
    
  spawn,'mSubimage  '+conf.bimapath+'ovro_blu_1_1124.fits '+$
    conf.fitspath+'sub_g173_ovro_blu_1_1124.fits 84.86552 35.678996 0.03 0.03'
    
  spawn,'mSubimage  '+conf.bimapath+'ovro_red_1_1124.fits '+$
    conf.fitspath+'sub_g173_ovro_red_1_1124.fits 84.86552 35.678996 0.03 0.03'
    
  spawn,'mSubimage  '+conf.bimapath+'ovro_red_2_1124.fits '+$
    conf.fitspath+'sub_g173_ovro_red_2_1124.fits 84.86552 35.678996 0.03 0.03'

  spawn,'ds9 '+conf.fitspath+'sub_g173_ovro_blu_2_1124.fits -contour yes -contour limits 1.8 9.0 '+$
    '-smooth yes -smooth radius 1 -contour smooth 1 -contour nlevels 13 '+$
    '-contour save '+conf.ds9path+'sub_g173_ovro_blu_2_1124.con'

  spawn,'ds9 '+conf.fitspath+'sub_g173_ovro_blu_1_1124.fits -contour yes -contour limits 12 40 '+$
    '-smooth yes -smooth radius 1 -contour smooth 1 -contour nlevels 8 '+$
    '-contour save '+conf.ds9path+'sub_g173_ovro_blu_1_1124.con'
 
  spawn,'ds9 '+conf.fitspath+'sub_g173_ovro_red_1_1124.fits -contour yes -contour limits 12 40 '+$
    '-smooth yes -smooth radius 1 -contour smooth 1 -contour nlevels 8 '+$
    '-contour save '+conf.ds9path+'sub_g173_ovro_red_1_1124.con'

  spawn,'ds9 '+conf.fitspath+'sub_g173_ovro_red_2_1124.fits -contour yes -contour limits 2.1 7.0 '+$
    '-smooth yes -smooth radius 1 -contour smooth 1 -contour nlevels 8 '+$
    '-contour save '+conf.ds9path+'sub_g173_ovro_red_2_1124.con'

  
  integrate_map,fits=conf.bimapath+'g173cube.fits',$
    vel_range=[-45.9,-17.8],outfits=conf.bimapath+'ovro_blu_1125.fits'
  integrate_map,fits=conf.bimapath+'g173cube.fits',$
    vel_range=[-17.8,10],outfits=conf.bimapath+'ovro_red_1125.fits'

  spawn,'mSubimage  '+conf.bimapath+'ovro_blu_1125.fits '+$
    conf.fitspath+'sub_g173_ovro_blu_1125.fits 84.861309 35.678889 0.061 0.033'
  spawn,'mSubimage  '+conf.bimapath+'ovro_red_1125.fits '+$
    conf.fitspath+'sub_g173_ovro_red_1125.fits 84.861309 35.678889 0.061 0.033'
  spawn,'mSubimage  '+conf.fitspath+'sg_g173_kcont_new.fits '+$
    conf.fitspath+'g173_kcont_core.fits 84.861309 35.678889 0.061 0.033'
  
  ;1-sigma =4 Jy  
  spawn,'ds9 '+conf.fitspath+'sub_g173_ovro_blu_1125.fits -contour yes -contour limits 12 40 '+$
    '-smooth yes -smooth radius 1 -contour smooth 1 -contour nlevels 8 '+$
    '-contour save '+conf.ds9path+'sub_g173_ovro_blu_1125.con'  
   ;1-sigma =5 Jy  
  spawn,'ds9 '+conf.fitspath+'sub_g173_ovro_red_1125.fits -contour yes -contour limits 15 40 '+$
    '-smooth yes -smooth radius 1 -contour smooth 1 -contour nlevels 6 '+$
    '-contour save '+conf.ds9path+'sub_g173_ovro_red_1125.con'

   
  spawn,'ds9 '+conf.fitspath+'g173_kcont_core.fits -colorbar no -grid yes -grid load '+$
    conf.ds9path+'ds9.grd -grid grid gap1 0.008 -grid grid gap2 0.008 '+$
    '-scale limits 0 4000 -cmap value 8.5 0.014 -zoom 1.2 1.2 '+$
    '-geometry 1200x1000 '+$
    '-contour load '+conf.ds9path+'bima_cont.con wcs fk5 yellow 1 '+$
    '-contour load '+conf.ds9path+'sub_g173_ovro_blu_1125.con wcs fk5 blue 1 yes '+$
    '-contour load '+conf.ds9path+'sub_g173_ovro_red_1125.con wcs fk5 red 1 yes '+$
    '-contour load '+conf.ds9path+'sub_g173_h2_nocont_ovro_20131023.con wcs fk5 green 1 '+$   
    '-regions load '+conf.regpath+'g173_ovro_pv_line_1125.reg -regions select all -regions color white  '+$
    '-psprint filename '+conf.pspath+'g173_CO_highvel_kcont.ps -psprint destination file '+$
    '-psprint &'


  ;making OVRO integrted map
  spawn,'ds9 '+conf.bimapath+'bima_int_0703.fits[28:314,27:170] -colorbar no -grid yes -grid load '+$
    conf.ds9path+'ds9-offset.grd  '+$
    '-geometry 900x900 -cmap Heat -cmap value 1.34 0.4 -zoom 1.8 1.8 '+$
    '-colorbar yes -colorbar vertical -colorbar font times '+$
    '-colorbar size 30 -colorbar fontsize 20 -colorbar space value '+$
    '-regions load '+conf.regpath+'g173_ovro_pv_line_1206.reg '+$
    '-psprint filename '+conf.pspath+'g173_ovro_int.ps -psprint destination file '+$
    '-psprint &'

  
  
	; Making ARO channel map 
	makechanelmap
	
	; Making BIMA channel map with H2 emission and 
  makeovrochannelmap, ps='ovro_chan_h2_120912.ps'
  makeovrochannelmap, ps='ovro_chan_h2_131023.ps'
  makeovrochannelmap, ps='ovro_chan_h2_131122.ps'
	
  plotcospec,ps=conf.pspath+'co_spec_130621.ps'
  plotcospec,ps=conf.pspath+'co_spec_130910.ps'
  plotcospec,ps=conf.pspath+'co_spec_130911.ps'
  plotcospec,ps=conf.pspath+'co_spec_131122.ps'
	
	
	;--------------------------------------------------------
	;  making OVRO integrted map with HH objects
	;    also put a white box
	;--------------------------------------------------------
  spawn,'ds9 '+conf.bimapath+'bima_int_0703.fits[82:300,33:149] -colorbar no -grid yes -grid load '+$
    conf.ds9path+'ds9-degree.grd -geometry 1200x900 -cmap Heat -cmap value 1.34 0.4 -zoom 3.8 3.8 '+$
    '-colorbar yes -colorbar vertical -colorbar font times '+$
    '-colorbar size 30 -colorbar fontsize 14 -colorbar space value '+$
    '-contour load '+conf.ds9path+'sub_g173_h2_nocont_new_20131014.con wcs fk5 green 1 '+$   
    '-regions load '+conf.regpath+'h2bowshock_id_relocate_20131126.reg  '+$
    '-psprint filename '+conf.pspath+'g173_ovro_int.ps -psprint destination file '+$
    '-psprint &'
 
  spawn,'ds9 '+conf.bimapath+'bima_int_0703.fits[82:300,33:149] -grid yes -grid load '+$
    conf.ds9path+'ds9-degree.grd -geometry 1200x900 -cmap grey -cmap value 1.44 0.23 -zoom 3.8 3.8 '+$
    '-cmap invert yes -colorbar yes -colorbar vertical -colorbar font times '+$
    '-colorbar size 30 -colorbar fontsize 14 -colorbar space value '+$
    '-contour load '+conf.ds9path+'sub_g173_h2_nocont_new_20131014.con wcs fk5 green 1 '+$
    '-contour load '+conf.ds9path+'bima_cont.con wcs fk5 yellow 1 '+$
    '-contour load '+conf.ds9path+'sub_g173_ovro_blu_1125.con wcs fk5 blue 1 yes '+$
    '-contour load '+conf.ds9path+'sub_g173_ovro_red_1125.con wcs fk5 red 1 yes '+$
    '-contour load '+conf.ds9path+'sub_g173_h2_nocont_ovro_20131023.con wcs fk5 green 1 '+$   
    '-regions load '+conf.regpath+'g173_ovro_pv_line_1206.reg -regions select all -regions color white  '+$
    '-psprint filename '+conf.pspath+'g173_CO_highvel.ps -psprint destination file '+$
    '-psprint &'
  
  ;------------------------------------
  ;  Plotting PV Diagrams
  ;------------------------------------
  ; PV-1
  pvdiagram,fits=conf.bimapath+'g173cube.fits',vel_range=[-46,10],scale=3.0,xystart=[ 84,103],xyend=[252,67],punit=3
  pvdiagram,fits=conf.bimapath+'g173cube.fits',vel_range=[-46,10],scale=3.0,xystart=[198,141],xyend=[155,60],punit=4

   
  pvdiagram,fits=conf.bimapath+'g173cube.fits',vel_range=[-46,10],scale=3.0,xystart=[ 35,112],xyend=[308,57],punit=1
  pvdiagram,fits=conf.bimapath+'g173cube.fits',vel_range=[-46,10],scale=3.0,xystart=[203,148],xyend=[148,48],punit=2
  pvdiagram,fits=conf.bimapath+'g173cube.fits',vel_range=[-46,10],scale=3.0,xystart=[ 35,112],xyend=[308,57],punit=3

  
  pvdiagram,fits=conf.bimapath+'g173cube.fits',vel_range=[-46,10],scale=3.0,xystart=[233,110],xyend=[200,44]
  
  pvdiagram,fits=conf.bimapath+'g173cube.fits',vel_range=[-46,10],scale=3.0,xystart=[117,145],xyend=[217,35]
  
	pvdiagram,fits=conf.bimapath+'g173cube.fits',vel_range=[-46,10],scale=3.0,xystart=[233,110],xyend=[200,44]
	
  pvdiagram,fits=conf.aropath+'CO_g173_otf_casa_0620.fits',vel_range=[-40,10],scale=3.0

  pvdiagram,fits=conf.bimapath+'g173cube.fits',vel_range=[-40,10],scale=3.0
	
	pvdiagram,fits=conf.bimapath+'g173cube.fits',vel_range=[-40,10],scale=3.0,xystart=[144,60],xyend=[200,114]
	
	
	
END


PRO  C18ODATA

  COMMON share,conf 
  loadconfig
 
  vel_range=[-30,-5]
  
  ; read C18O spectrum data
  c18o=mrdfits(conf.sraopath+'g173_spec.fits',0,hd)
  ;BZERO + BSCALE × array_value
  bzero=sxpar(hd,'BZERO')
  bscale=sxpar(hd,'BSCALE')
  
  del_v=sxpar(hd,'DELTAV')/1000.0
  ref_v=sxpar(hd,'VELO-LSR')/1000.0
  ref_c=sxpar(hd,'CRPIX1')
  v0=(ref_v-ref_c*del_v)

  channel=sxpar(hd,'NAXIS1')
  array_vel=findgen(channel)*del_v+(ref_v-ref_c*del_v)
  ; 0.61 is the beam efficiency of SRAO
  c18o=(c18o*bscale+bzero)/0.61
  
  tauc18o=fltarr(n_elements(c18o))
  
  for i=0,n_elements(c18o)-1 do begin
    tauc18o[i]=tauc18o(c18o[i])
  endfor
  
  chl_range=round((vel_range-v0)/del_v)-1
  
  plot,array_vel,c18o,psym=10,xrange=vel_range

  int_tau=0
  int_tb=0
  for i=chl_range[0],chl_range[1] do begin
    int_tau=int_tau+tauc18o[i]*del_v;*mask
    int_tb=int_tb+c18o[i]*del_v
  endfor
  print,int_tau,int_tb
print,del_v
END


PRO G173_IR

  COMMON share,conf 
  loadconfig
  
  complimit,fits=conf.fitspath+'sg_g173_j.fits',comp=0.90,psfile='sg_g173_j_limitmag.eps',/newsky
  complimit,fits=conf.fitspath+'sg_g173_h.fits',comp=0.90,psfile='sg_g173_h_limitmag.eps',/newsky
  complimit,fits=conf.fitspath+'sg_g173_k.fits',comp=0.90,psfile='sg_g173_k_limitmag.eps',/newsky
   
  ;limiting Mag J, H, Ks = 19.24, 18.71,18.20
  
  
  ; First of all, make a ASSOC file for all regions.
  mkassoc

  ; Then, use sextractor to measure the flux of 2Mass stars
  runsexassoc
  
  ; Read catalog
  zero=[0.0616999,0.120399,0.209201]
  calibassoc,zero,ps='calibassoc_20130530.eps'
  
  ; Photometry of target field
  runsextractor
  getstar,cat,zero=[0.0616999,0.120399,0.209201],limitmag=[19.2,18.7,18.2]
  registercatalog,cat,tmp
  groupstar,tmp,final
  
  ; checking the selected member
  spawn,'ds9 '+conf.fitspath+'sg_g173_k.fits '+$
    '-regions load '+conf.regpath+'G173_OVRO_5sigma_boarder-white.reg '+$
    '-regions load '+conf.regpath+'cluster-member.reg'
  
  
  
  ind=where(final.x eq 416.46100 and final.y eq 454.35199)
  print,final.mj[ind],final.mh[ind],final.mk[ind],final.mkerr[ind]
  
  mkccdiagram,final,ps='hrdiagram_20130310.eps'
  mkccdiagram,final,ps='hrdiagram_20130529.eps'
  mkccdiagram,final,ps='hrdiagram_20130812.eps'
  ; Plot the stars in the could
  mkccdiagram,final,ps='hrdiagram_20130921.eps'
  mkccdiagram,final,ps='hrdiagram_20131126.eps'
  
   
  ; Photometry of reference field
  getrefstar,rcat
  registercatalog,rcat,rtab

  cmdclean,final,rtab,ctab,ps='cmdclean_20130316.eps'
  cmdclean,final,rtab,ctab,ps='cmdclean_20130529.eps'
  cmdclean,final,rtab,ctab,ps='cmdclean_20130921.eps'
  cmdclean,final,rtab,ctab,ps='cmdclean_20131126.eps'
  
  ind=where(ctab.mk le 11 and ctab.mk ne -999.0,count)
  getds9region,ctab.x[ind],ctab.y[ind],conf.regpath+'bright-Ks',color='blue'

  
  makecmd,ctab,ps='cmd_20131024.eps'

  absmag=absmag(ctab,1800.0)
  newderedden, absmag, corrcat
  
  ; Checking the IR Excess Stars
  ;  Looking for CCTS in the cloud region
  ind=where(corrcat.group eq 1 and corrcat.ctts eq 1, count1)
  ind=where(corrcat.group eq 1 and corrcat.mj le 0 and corrcat.ctts eq 0, count2)
  ind=where(corrcat.group eq 1 and corrcat.av ge 14 and corrcat.mj le 0 and corrcat.ctts eq 0, count3)
  ind=where(corrcat.group eq 2 and corrcat.ctts eq 1, count4)
  ind=where(corrcat.group eq 2 and corrcat.mj le 0 and corrcat.ctts eq 0, count5)
  ind=where(corrcat.group eq 2 and corrcat.av ge 14 and corrcat.mj le 0 and corrcat.ctts eq 0, count6)
  print,'In cloud CCTS=',count1
  print,'In cloud Non-J =',count2
  print,'In cloud High Av =',count3
  print,'Off cloud CCTS=',count4
  print,'Off cloud Non-J =',count5
  print,'Off cloud High Av =',count6
  
  
  avgext,corrcat
  
  klfagedemo,ps='klfagedemo_20131119.eps'
  
  clusterage,corrcat,ps='clusterage_20130403.eps'
  clusterage,corrcat,ps='clusterage_20130812.eps'
  clusterage,corrcat,ps='clusterage_20130921.eps'
  clusterage,corrcat,ps='clusterage_20131126.eps'

  klfcomp,ps='klmcomp_20131126.eps'
  ; Calculate the mass based on MLR
  stellarmass,corrcat, all 

  ; Plot IMFs of clusters
  clusterimf,all,ps='clusterimf_20130812.eps'

END


PRO G173_LINEIMAGE

  COMMON share,conf 
  loadconfig

  mkassoc_line
  runsexassoc_line
  
  ; Read catalog
  zero=[0.0,0.0,0.0]
  
  ; This calibration is all against 2MASS Ks band
  calibassoc_line,zero,/ps
    ;Photometric calibation of H2 Band
    ;    -0.228000    0.0832262
    ;Photometric calibation of BRG Band
    ;     0.344400     0.111565
    ;Photometric calibation of KCONT Band
    ;     0.107100     0.100294
    
  loadline,im,hd  
  subtract_cont,im,line
  savelineimg,line,hd
  
  spawn,'mSubimage  '+conf.fitspath+'sg_g173_h2_nocont_new.fits '+$
    conf.fitspath+'sub_g173_h2_nocont_new.fits 84.855213 35.678475 0.06 0.06'

  ; Making H2 contours
  spawn,'ds9 '+conf.fitspath+'sub_g173_h2_nocont_new.fits -contour yes -contour limits 25 225 '+$
      '-smooth yes -smooth radius 5 -contour smooth 1 -contour nlevels 21 '+$
      '-contour save '+conf.ds9path+'sub_g173_h2_nocont_new_20131014.con &' 

  ; Making H2 contours for the use of OVRO channel maps
  spawn,'ds9 '+conf.fitspath+'sub_g173_h2_nocont_new.fits -contour yes -contour limits 25 225 '+$
      '-smooth yes -smooth radius 5 -contour smooth 1 -contour nlevels 11 '+$
      '-contour save '+conf.ds9path+'sub_g173_h2_nocont_ovro_20131023.con &'

  ; Smooth H2 image for future analysis 
  im=readfits(conf.fitspath+'sub_g173_h2_nocont_new.fits',hd)
  index=where(finite(im, /nan)) 
  im[index]=-99.0
  nim=smooth(im,5)
  writefits,conf.fitspath+'sub_g173_h2_nocont_new_smooth.fits',nim,hd
  
  ; Run this => .r clfind2d clplot2d clstats2d
  clfind2d,file=conf.fitspath+'sub_g173_h2_nocont_new_smooth',$
    levels=[25,35,45,55,65]
  clstats2d,file=conf.fitspath+'sub_g173_h2_nocont_new_smooth'
  
  ; Making H2 catalog, table and region files based on the CLFIND measurements.
  h2catalog

  ; Checking the H2 clumps
  spawn,'ds9 '+conf.fitspath+'sub_g173_h2_nocont_new.fits '+$
      ' -contour load '+conf.ds9path+'sub_g173_h2_nocont_new_20131014.con '+$
      ' -regions load '+conf.regpath+'h2bowshock_id.reg ' 

  
  ; Cut a K-cont subregion
  spawn,'mSubimage  '+conf.fitspath+'sg_g173_kcont_new.fits '+$
      conf.fitspath+'sg_g173_kcont_new_h2region.fits 84.855422 35.679151 0.05 0.03'

 
  ; Plot K-cont image with H2 contours
  spawn,'ds9 '+conf.fitspath+'sg_g173_kcont_new_h2region.fits -colorbar no -grid yes -grid load '+$
    conf.ds9path+'ds9.grd -grid grid gap1 0.008 -grid grid gap2 0.008 '+$
    '-scale limits 0 4000 -cmap value 8.5 0.014 -zoom 1.2 1.2 '+$
    '-geometry 900x900 -pan to 84.863126 35.678729 wcs fk5 '+$
    '-contour load '+conf.ds9path+'sub_g173_h2_nocont_new_20131014.con wcs fk5 green 1 '+$
    '-regions load '+conf.regpath+'h2bowshock_id_relocate.reg '+$
    '-psprint filename '+conf.pspath+'g173_kcont_h2contour.ps -psprint destination file '+$
    '-psprint &'
  
  populatepdf,ps=conf.pspath+'g173_kcont_h2contour.ps', figpath=conf.paperfigpath
  ;spawn,'ps2pdf -dPDFSETTINGS=/prepress -dEPSCrop '+conf.pspath+'g173_kcont_h2contour.ps '+$
  ;  ' -o '+conf.paperfigpath+'g173_kcont_h2contour.pdf'
 

END





PRO PAPERPLOTS

    COMMON share,conf
    loadconfig


    ;--------------------------------------------------------
    ;  making OVRO integrted map with HH objects
    ;    also put a white box
    ;--------------------------------------------------------
    spawn,'ds9 '+conf.bimapath+'bima_int_0703.fits[82:300,33:149] -colorbar no -grid yes -grid load '+$
      conf.ds9path+'ds9-degree.grd -geometry 1200x900 -cmap Heat -cmap value 1.34 0.4 -zoom 3.8 3.8 '+$
      '-colorbar yes -colorbar vertical -colorbar font times '+$
      '-colorbar size 30 -colorbar fontsize 14 -colorbar space value '+$
      '-contour load '+conf.ds9path+'sub_g173_h2_nocont_new_20131014.con wcs fk5 green 1 '+$
      '-regions load '+conf.regpath+'h2bowshock_id_relocate_20131126.reg  '+$
      '-psprint filename '+conf.pspath+'g173_ovro_int.ps -psprint destination file '+$
      '-psprint &'
      
    spawn,'ds9 '+conf.bimapath+'bima_int_0703.fits[82:300,33:149] -grid yes -grid load '+$
      conf.ds9path+'ds9-degree.grd -geometry 1200x900 -cmap grey -cmap value 1.44 0.23 -zoom 3.8 3.8 '+$
      '-cmap invert yes -colorbar yes -colorbar vertical -colorbar font times '+$
      '-colorbar size 30 -colorbar fontsize 14 -colorbar space value '+$
      '-contour load '+conf.ds9path+'sub_g173_h2_nocont_new_20131014.con wcs fk5 green 1 '+$
      '-contour load '+conf.ds9path+'bima_cont.con wcs fk5 yellow 1 '+$
      '-contour load '+conf.ds9path+'sub_g173_ovro_blu_1125.con wcs fk5 blue 1 yes '+$
      '-contour load '+conf.ds9path+'sub_g173_ovro_red_1125.con wcs fk5 red 1 yes '+$
      '-contour load '+conf.ds9path+'sub_g173_h2_nocont_ovro_20131023.con wcs fk5 green 1 '+$
      '-regions load '+conf.regpath+'g173_ovro_pv_line_1206.reg -regions select all -regions color white  '+$
      '-psprint filename '+conf.pspath+'g173_CO_highvel.ps -psprint destination file '+$
      '-psprint &'
      
    ;------------------------------------
    ;  Plotting PV Diagrams
    ;------------------------------------
    ; PV-1
    pvdiagram,fits=conf.bimapath+'g173cube.fits',vel_range=[-46,10],scale=3.0,xystart=[ 84,103],xyend=[252,67],punit=3
    pvdiagram,fits=conf.bimapath+'g173cube.fits',vel_range=[-46,10],scale=3.0,xystart=[198,141],xyend=[155,60],punit=4
    
    
    clusterage,corrcat,ps='clusterage_20131126.eps'



END







