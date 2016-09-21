
; cd /Users/ronny/Work/PRO_SD+M36/M36/combined_data/analysis
; idl
; .compile analysis_pv.pro
; anamovie

; to do:
; - fit keplerian disk or infall?



PRO ANAMOVIE

  ;=====================================================
  ; user input
  
  ;which plots to plot:
  ;=> 0 ... no channel maps + contour maps are plotted
  ;=> 1 ... all channel maps + contour maps are plotted
  ;=> 2 ... only channel maps are plotted
  ;=> 3 ... only contour maps are plotted
  ;=> 4 ... make movie of channel maps or contour maps
  plot_im = 1

  ;A: channel maps (if plot_im = 1 or 2)
  ;start channel for channel maps (first channel is 0):
  channel_start = 60
  
  ;B: contour maps (if plot_im = 1, 3 or 4)
  ;kind of plot:
  cplot_kind = 1
  ;=> 0 ... plot channel
  ;=> 1 ... plot pv-diagram
  
  ;channel to plot if cplot_kind = 0:
  channel_pl = 80

  ;position angle to plot if cplot_kind = 1:
  pos_angle = 90
  
  ;input file used (see procedure 'PV')
  ;=> 1 ... 'channel_CO.fits'
  xfile = 1

  ;color tables and intensity ranges:
  n_colTable_chan_map = 3  ;default: 3
  n_colTable_cont_map = 16 ;default: 15 or 16
  intensity_min = -1       ;default: -9999 (automatic) otherwise in Jy/beam (do not use 0.0)
  intensity_max = -9999    ;default: -9999 (automatic) otherwise in Jy/beam 

  ;color of contour lines
  contour_col  = [128,128,128] 
  ;contour_col = [0,0,0]       
  ;contour_col = [255,255,255] 
  
  IF intensity_min EQ 0.0 THEN intensity_min = 0.00001
  
  ;=====================================================
  ; make maps

  IF plot_im NE 4 THEN PV, pos_angle, plot_im, channel_start, xfile, cplot_kind, channel_pl, n_colTable_chan_map, n_colTable_cont_map, intensity_min, intensity_max, contour_col
  

  ;=====================================================
  ; make maps for gif animation:
  
  ; make map of one channel for different channels
  IF plot_im EQ 4 AND cplot_kind EQ 0 THEN BEGIN
     FOR ii=0,51-1,1 DO BEGIN
        pos_angle  = 0
        channel_pl = ii ; deg (integer value)
        PRINT, 'ANA> rot (deg) = ', pos_angle
        PV, pos_angle, plot_im, channel_start, xfile, cplot_kind, channel_pl, n_colTable_chan_map, n_colTable_cont_map, intensity_min, intensity_max, contour_col
     ENDFOR

     command1 = 'convert -delay 20 images/ch_channel_CO_plotA_ch*.gif images/ch_movie_d20.gif'
     PRINT, 'ANA> making ch movie 1'
     SPAWN, command1

     ;command2 = 'convert -delay  5 images/ch_channel_CO_plotA_ch*.gif images/ch_movie_d05.gif'
     ;PRINT, 'ANA> making ch movie 2'
     ;SPAWN, command2

     PRINT, 'ANA> movies finished!'
  ENDIF

  ; make pv maps for different pa
  IF plot_im EQ 4 AND cplot_kind EQ 1 THEN BEGIN
     FOR ii=0,180,1 DO BEGIN
        channel_pl = 0
        pos_angle  = ii ; deg (integer value)
        PRINT, 'ANA> rot (deg) = ', pos_angle
        PV, pos_angle, plot_im, channel_start, xfile, cplot_kind, channel_pl, n_colTable_chan_map, n_colTable_cont_map, intensity_min, intensity_max, contour_col
     ENDFOR

     command1 = 'convert -delay 20 images/pv_channel_CO_plotA_pa*.gif images/pv_movie_d20.gif'
     PRINT, 'ANA> making pv movie 1'
     SPAWN, command1

     ;command2 = 'convert -delay  5 images/pv_channel_CO_plotA_pa*.gif images/pv_movie_d05.gif'
     ;PRINT, 'ANA> making pv movie 2'
     ;SPAWN, command2

     PRINT, 'ANA> movies finished!'
  ENDIF

  ;=====================================================

END


;#######################################################################
;#######################################################################



PRO PV, pos_angle, plot_im, channel_start, xfile, cplot_kind, channel_pl, n_colTable_chan_map, n_colTable_cont_map, intensity_min, intensity_max, contour_col


  ;user input:
  IF NOT KEYWORD_SET(fitsname) THEN BEGIN
    IF xfile EQ 1 THEN BEGIN
      fitsname = '/Volumes/Data/Projects/G173/ARO/CO_g173_otf.fits'         ;fits input file
      file_out = 'channel_CO'              ;file out name
  	  object = 'IRAS 05327+3404 (CO 3-2)'  ;object name
      sigmat = 0.468                       ;Jy/beam one sigma value of image ;1.12
      levels = 1                           ;contour levels to draw
    ENDIF
  ENDIF

  ;CO: slev     = a,0.468
  ;CO: levs1    = 2,4,6,8,10,12,14,16
  ;CO: range    = 0,6,lin,2


  ;=====================================================

  image=REFORM(readfits(fitsname,header))


  GETVAL,header,'CRPIX1',ix    ;reference pixel
  GETVAL,header,'CRPIX2',iy    ;reference pixel
  GETVAL,header,'CRPIX3',iz    ;reference pixel

  GETVAL,header,'CDELT1',dx    ;deg/pixel
  GETVAL,header,'CDELT2',dy    ;deg/pixel
  GETVAL,header,'CDELT3',dz    ;m/s/pixel
  dx_arcsec = ABS(dx*3600.0)   ;arcsec/pixel
  dy_arcsec = ABS(dy*3600.0)   ;arcsec/pixel

  GETVAL,header,'CRVAL1',ra    ;deg
  GETVAL,header,'CRVAL2',dec   ;deg
  GETVAL,header,'CRVAL3',vel0  ;m/s


  GETVAL,header,'OBSRA',ra_px
  GETVAL,header,'OBSDEC',dec_px

  GETVAL,header,'BMAJ',beam1   ;deg
  GETVAL,header,'BMIN',beam2   ;deg
  GETVAL,header,'BPA',bpa      ;deg
  beam1 = beam1*3600.0         ;arcsec
  beam2 = beam2*3600.0         ;arcsec

  GETVAL,header,'RESTFREQ',fc  ;Hz
  GETVAL,header,'VOBS',vobs    ;m/s
  funit = SXPAR(header,'BUNIT')

  ;get correct velocity axis:
  ;iz   ... reference pixel
  ;dz   ... velocity interval
  ;vel0 ... velocity at reference pixel
  ;vobs ... velocity of observatory at time of observation
  ;=> velocity at first channel:
  vel_start = vel0 - dz*(iz-1)

  PRINT, '=================================='
  ;ADXY,header,ra,dec,xc,yc,/PRINT

xc=105/2
yc=105/2

  nx=(SIZE(image))[1]  &  x=(-FINDGEN(nx)+xc)*dx_arcsec            ;arcsec
  ny=(SIZE(image))[2]  &  y=(+FINDGEN(ny)-yc)*dy_arcsec            ;arcsec
  nz=(SIZE(image))[3]  &  z=((+FINDGEN(nz))*dz+vel_start) / 1000.0 ;km/s

  
  ;=====================================================

  PRINT, '=================================='
  PRINT, 'GETIM: OBJECT = ', object
  PRINT, 'GETIM: OBSRA  = ', ra,  ' deg'
  PRINT, 'GETIM: OBSDEC = ', dec, ' deg'
  PRINT, 'GETIM: BMAJ   = ', beam1, ' arcsec'
  PRINT, 'GETIM: BMIN   = ', beam2, ' arcsec'
  PRINT, 'GETIM: BPA    = ', bpa, ' deg'
  PRINT, 'GETIM: CDELT1 = ', dx_arcsec, ' arcsec/pixel'
  PRINT, 'GETIM: CDELT2 = ', dy_arcsec, ' arcsec/pixel'
  PRINT, 'GETIM: CDELT3 = ', dz, ' m/s/pixel'
  PRINT, 'GETIM: CRVAL1 = ', ra,  ' deg'
  PRINT, 'GETIM: CRVAL2 = ', dec, ' deg'
  PRINT, 'GETIM: CRVAL3 = ', vel0,' m/s'
  PRINT, 'GETIM: CRPIX1 = ', ix, '(ref pixel)'
  PRINT, 'GETIM: CRPIX2 = ', iy, '(ref pixel)'
  PRINT, 'GETIM: CRPIX3 = ', iz, '(ref pixel)'
  PRINT, 'GETIM: RESTFQ = ', fc,     ' Hz'
  PRINT, 'GETIM:        = ', fc/1e9, ' GHz'
  PRINT, 'GETIM: BUNIT  = ', funit

  IF nx NE ny THEN PRINT, 'ERROR: x and y dimension are not the same'
  IF dx_arcsec NE dy_arcsec THEN STOP
  IF nx NE ny THEN STOP


  ;=====================================================
  ;plot original images (28 channels can be plotted at most):
  
  IF plot_im EQ 1 OR plot_im EQ 2 THEN BEGIN
  
     IF nz-channel_start GT 28 THEN n_images = 28 ELSE n_images = nz-channel_start
     PRINT, 'GETIM: ', STRCOMPRESS(STRING(n_images),/REMOVE_ALL), ' channels plotted starting from channel ',$
            STRCOMPRESS(STRING(channel_start),/REMOVE_ALL)
  

     xy_size     = nx          ;size of image
     pixelsize   = dx_arcsec   ;arcsec
     xy_size_new = xy_size/2   ;inner pixel to use (at one side)
  
 
     ;prepare images for plot routine:
     image_array = MAKE_ARRAY(n_images,xy_size,xy_size,/DOUBLE)
     wavelengths = MAKE_ARRAY(n_images,VALUE=1.0,/DOUBLE)
     channel_nr  = MAKE_ARRAY(n_images,VALUE=1.0,/INTEGER)
     FOR i=0, n_images-1 DO BEGIN
        channel_nr[i] = channel_start+i
        wavelengths[i] = z[channel_start+i]
	    image_array[i,*,*] = image[*,*,channel_start+i]
     ENDFOR

     wave_string = STRCOMPRESS(STRING(wavelengths,FORMAT='(D7.2)'),/REMOVE_ALL)+' km/s';' GHz';+' '+mu+'m'
     chan_string = STRCOMPRESS(STRING(channel_nr),/REMOVE_ALL)


     ;scale image to fit within the color table:
     IF ROUND(intensity_max) EQ -9999 THEN max_image = MAX(image_array) ELSE max_image = intensity_max
     IF ROUND(intensity_min) EQ -9999 THEN min_image = MIN(image_array) ELSE min_image = intensity_min
     PRINT, 'GETIM: maximum image value = ', max_image
     PRINT, 'GETIM: minimum image value = ', min_image
     
     FOR i=0, nx*nx*n_images-1 DO BEGIN
        IF image_array[i] LT min_image THEN image_array[i] = min_image
        IF image_array[i] GT max_image THEN image_array[i] = max_image
     ENDFOR

     image_array = (image_array-min_image) / (max_image-min_image) * 255
  
     ;make channel map:
     ;(plot images in chosen channel range)
     PLOTIMAGE, image_array, wave_string, chan_string, file_out, n_images, xy_size, pixelsize, xy_size_new, n_colTable_chan_map, N_RESET=n_reset, ROT_DEG=rot_deg

  ENDIF

  ;=====================================================
  ;make pv cut:
  
  ;rotate cube first (channel by channel)
  image_rot = image
  z_vel = z

  ;rotate image in clockwise direction (pos_angle is in deg)
  FOR i=0, nz-1 DO image_rot[*,*,i] = ROT(image[*,*,i], pos_angle, CUBIC=-0.5)
  

  ;cut along from [0,+y] to [0,-y] (basically from N to S of the image is not rotated)
  ;if the image is rotated by 10 deg then the cut corresponds to a cut along a PA of 10 deg!
  image_pv = MAKE_ARRAY(nz,ny,/DOUBLE)
  
  FOR i=0, nz-1 DO BEGIN
    FOR j=0, ny-1 DO image_pv[i,j] = image_rot[nx/2,j,i]
  ENDFOR

  IF pos_angle GE 0   AND pos_angle LT  10 THEN string_pa = '00'+STRCOMPRESS(STRING(ROUND(pos_angle)),/REMOVE_ALL)
  IF pos_angle GE 10  AND pos_angle LT 100 THEN string_pa = '0' +STRCOMPRESS(STRING(ROUND(pos_angle)),/REMOVE_ALL)
  IF pos_angle GE 100 AND pos_angle LE 360 THEN string_pa =     +STRCOMPRESS(STRING(ROUND(pos_angle)),/REMOVE_ALL)

  IF channel_pl GE 0   AND channel_pl LT  10 THEN string_ch = '00'+STRCOMPRESS(STRING(ROUND(channel_pl)),/REMOVE_ALL)
  IF channel_pl GE 10  AND channel_pl LT 100 THEN string_ch = '0' +STRCOMPRESS(STRING(ROUND(channel_pl)),/REMOVE_ALL)
  IF channel_pl GE 100 AND channel_pl LE 360 THEN string_ch =     +STRCOMPRESS(STRING(ROUND(channel_pl)),/REMOVE_ALL)
    
  wave_str = STRCOMPRESS(STRING(z[channel_pl],FORMAT='(D7.2)'),/REMOVE_ALL)+' km/s'
  

  ;=====================================================

  PRINT, '=================================='
  PRINT, 'GETIM: image all max = ', MAX(image),' Jy/beam'
  PRINT, 'GETIM: image all min = ', MIN(image),' Jy/beam'
  PRINT, 'GETIM: image rot max = ', MAX(image_rot),' Jy/beam'
  PRINT, 'GETIM: image rot min = ', MIN(image_rot),' Jy/beam'
  PRINT, 'GETIM: image pv max  = ', MAX(image_pv),' Jy/beam'
  PRINT, 'GETIM: image pv min  = ', MIN(image_pv),' Jy/beam'

  IF cplot_kind EQ 1 THEN BEGIN
     ;setup for plotting pv contour map
     image_plot = image_pv
     xaxis_val  = z_vel
     yaxis_val  = y
     xtitle = 'velocity (km/s)'
     ytitle = 'position (arcsec)'
     title = '(pv-diagram at position angle '+string_pa+'!9'+String("260B)+'!X'+')'
  ENDIF ELSE BEGIN
     ;setup for plotting contour map of one channel
     image_plot = image[*,*,channel_pl]
     xaxis_val  = x
     yaxis_val  = y
     xtitle = 'RA (rel arcsec)'
     ytitle = 'DEC (rel arcsec)'
     title = ' !C'+object+'!C'+'(channel '+string_ch+', '+wave_str+')'
  ENDELSE


  IF ROUND(intensity_max) EQ -9999 THEN aZ = MAX(image) ELSE aZ = intensity_max
  IF ROUND(intensity_min) EQ -9999 THEN iZ = MIN(image) ELSE iZ = intensity_min

  FOR i=0, N_ELEMENTS(image_plot)-1 DO BEGIN
     IF image_plot[i] LT iZ THEN image_plot[i] = iZ
     IF image_plot[i] GT aZ THEN image_plot[i] = aZ
  ENDFOR

  c_number = CEIL((aZ-iZ)/(sigmat*levels))+1         ;number of levels
  dZ = c_number * (sigmat*levels)                    ;number of levels + sigma
  iZ_min = FLOOR(iZ/(sigmat*levels)) * sigmat*levels ;min level (makes sure that it goes through 0.0)

  c_value = MAKE_ARRAY(c_number,/DOUBLE)
  rgb_indicies = MAKE_ARRAY(c_number,/INTEGER)
  
  FOR g=0, c_number-1 DO c_value[g] = iZ_min + g * 1.0/(c_number) * dZ
  IF n_colTable_cont_map EQ 15 THEN FOR g=0, c_number-1 DO rgb_indicies[g] = ROUND(80.0+g*(240-80.0)/(c_number-1.0))
  IF n_colTable_cont_map NE 15 THEN FOR g=0, c_number-1 DO rgb_indicies[g] = ROUND((g*255.0)/(c_number-1.0))


  PRINT, '=================================='
  PRINT, 'GETIM: RGB indices and contour levels (Jy/beam)'
  PRINT, 'GETIM: (derived from original image)'
  FOR i=0, N_ELEMENTS(c_value)-1 DO BEGIN
    PRINT, 'GETIM: ', rgb_indicies[i], c_value[i]
  ENDFOR
  PRINT, 'GETIM: n contours = ', c_number

  ;=====================================================
  ;make pv contour map or contour map of one channel according to cplot_kind:
  ;(1 or 3 all three contour maps, 4 only the best contour map)

  resolution = 100
  file_exten = '.gif'
  ;file_exten = '.tiff'
  
  ;A: contour plot with filled contours + contour lines
  IF plot_im EQ 1 OR plot_im EQ 3 OR plot_im EQ 4 THEN BEGIN
	dist_c = MAX(c_value) - MIN(c_value) ;=255, for n_colTable_cont_map15: =240-80=160 of 255
    IF cplot_kind EQ 1 THEN BEGIN ;for pv plot
       iCONTOUR, image_plot, xaxis_val, yaxis_val, XRANGE=[MAX(xaxis_val),MIN(xaxis_val)],YRANGE=[MIN(yaxis_val),MAX(yaxis_val)],$
                 ANISOTROPY=[1,1,1],XTICKFONT_SIZE=11,YTICKFONT_SIZE=11,XTICKFONT_STYLE=1,YTICKFONT_STYLE=1,XTITLE=xtitle,YTITLE=ytitle,$
                 TITLE=title,VIEW_TITLE=object,RGB_TABLE=n_colTable_cont_map,TRANSPARENCY=0,RGB_INDICES=rgb_indicies,C_VALUE=c_value,$
                 /NO_SAVEPROMPT,LOCATION=[100,0],DIMENSIONS=[1000,850],NAME=name,/FILL,VIEW_ZOOM=1.0,SHADING=1,IDENTIFIER=idTool_2
       iCONTOUR, image_plot,xaxis_val,yaxis_val,C_THICK=1.0,TRANSPARENCY=70,RGB_INDICES=contour_col,C_VALUE=c_value,$
                 /NO_SAVEPROMPT,/OVERPLOT,SHADING=1
	   IF n_colTable_cont_map NE 15 THEN iPLOT, [MAX(xaxis_val),MAX(xaxis_val)],[MIN(c_value),MAX(c_value)],/OVERPLOT,RGB_TABLE=n_colTable_cont_map,INSERT_COLORBAR=[-0.5,-0.9]
	   IF n_colTable_cont_map EQ 15 THEN iPLOT, [MAX(xaxis_val),MAX(xaxis_val)],[MIN(c_value)-80./255.*dist_c,MAX(c_value)+15./255.*dist_c],/OVERPLOT,RGB_TABLE=n_colTable_cont_map,INSERT_COLORBAR=[-0.5,-0.9]
       file_write = 'images/pv_'+file_out+'_plotA_pa'+string_pa+file_exten
    ENDIF ELSE BEGIN ;for one channel
       iCONTOUR, image_plot, xaxis_val, yaxis_val, XRANGE=[MAX(xaxis_val),MIN(xaxis_val)],YRANGE=[MIN(yaxis_val),MAX(yaxis_val)],$
                 ANISOTROPY=[1,1,1],XTICKFONT_SIZE=11,YTICKFONT_SIZE=11,XTICKFONT_STYLE=1,YTICKFONT_STYLE=1,XTITLE=' ',YTITLE=' ',$
                 TITLE=' ',VIEW_TITLE=title,RGB_TABLE=n_colTable_cont_map,TRANSPARENCY=0,RGB_INDICES=rgb_indicies,C_VALUE=c_value,$
                 /NO_SAVEPROMPT,LOCATION=[100,0],DIMENSIONS=[620,620],NAME=name,/FILL,VIEW_ZOOM=1.0,SHADING=1,/isotropic,IDENTIFIER=idTool_2
       iCONTOUR, image_plot,xaxis_val,yaxis_val,C_THICK=1.0,TRANSPARENCY=70,RGB_INDICES=contour_col,C_VALUE=c_value,$
                 /NO_SAVEPROMPT,/OVERPLOT,SHADING=1
	   IF n_colTable_cont_map NE 15 THEN iPLOT, [MAX(xaxis_val),MAX(xaxis_val)],[MIN(c_value),MAX(c_value)],/OVERPLOT,RGB_TABLE=n_colTable_cont_map,INSERT_COLORBAR=[-0.5,-0.7]
	   IF n_colTable_cont_map EQ 15 THEN iPLOT, [MAX(xaxis_val),MAX(xaxis_val)],[MIN(c_value)-80./255.*dist_c,MAX(c_value)+15./255.*dist_c],/OVERPLOT,RGB_TABLE=n_colTable_cont_map,INSERT_COLORBAR=[-0.5,-0.7]
       file_write = 'images/ch_'+file_out+'_plotA_ch'+string_ch+file_exten
    ENDELSE
    ISAVE, file_write, RESOLUTION=resolution, TARGET_IDENTIFIER=idTool_2
    IF plot_im EQ 4 THEN idTool_2 = ITGETCURRENT(TOOL=oTool_2)
    IF plot_im EQ 4 THEN void2 = oTool_2->DoAction('Operations/File/Exit')
  ENDIF

  ;B: 3D plot
  IF plot_im EQ 1 OR plot_im EQ 3 THEN BEGIN
    iCONTOUR, image_plot, xaxis_val, yaxis_val, XRANGE=[MAX(xaxis_val),MIN(xaxis_val)],YRANGE=[MIN(yaxis_val),MAX(yaxis_val)],XTITLE=xtitle,YTITLE=ytitle,$
            ANISOTROPY=[1,1,1],XTICKFONT_SIZE=11,YTICKFONT_SIZE=11,XTICKFONT_STYLE=1,YTICKFONT_STYLE=1,$
            TITLE=object,VIEW_TITLE='Contour Plot',RGB_TABLE=n_colTable_cont_map,TRANSPARENCY=0,RGB_INDICES=rgb_indicies,C_VALUE=c_value,$
            /NO_SAVEPROMPT,LOCATION=[100,0],DIMENSIONS=[1000,620],NAME=name,/FILL,VIEW_ZOOM=1.15,SHADING=1,$
            ZVALUE=10,PLANAR=0,ZTICKFONT_SIZE=11,ZTICKFONT_STYLE=1,ZTITLE='value ('+funit+')',IDENTIFIER=idTool_1
    IF cplot_kind EQ 0 THEN file_write = 'images/3D_'+file_out+'_plotB_pa'+string_pa+file_exten
    IF cplot_kind EQ 1 THEN file_write = 'images/3D_'+file_out+'_plotB_ch'+string_ch+file_exten
    ISAVE, file_write, RESOLUTION=resolution, TARGET_IDENTIFIER=idTool_1
  ENDIF

;  ;C: contour plot with contour lines only
;  IF plot_im EQ 1 OR plot_im EQ 3 THEN BEGIN
;    IF cplot_kind EQ 1 THEN BEGIN ;for pv plot
;       iCONTOUR, image_plot, xaxis_val, yaxis_val, XRANGE=[MAX(xaxis_val),MIN(xaxis_val)],YRANGE=[MIN(yaxis_val),MAX(yaxis_val)],$
;                 XTICKFONT_SIZE=11,YTICKFONT_SIZE=11,XTICKFONT_STYLE=1,YTICKFONT_STYLE=1,XTITLE=xtitle,YTITLE=ytitle,$
;                 TITLE=title,VIEW_TITLE=object,RGB_TABLE=n_colTable_cont_map,TRANSPARENCY=0,RGB_INDICES=rgb_indicies,C_VALUE=c_value,$
;                 /NO_SAVEPROMPT,LOCATION=[100,0],DIMENSIONS=[620,620],NAME=name,VIEW_ZOOM=1.0,SHADING=1,IDENTIFIER=idTool_3
;      file_write = 'images/pv_'+file_out+'_plotC_pa'+string_pa+file_exten
;    ENDIF ELSE BEGIN ;for one channel
;       iCONTOUR, image_plot, xaxis_val, yaxis_val, XRANGE=[MAX(xaxis_val),MIN(xaxis_val)],YRANGE=[MIN(yaxis_val),MAX(yaxis_val)],$
;                 XTICKFONT_SIZE=11,YTICKFONT_SIZE=11,XTICKFONT_STYLE=1,YTICKFONT_STYLE=1,XTITLE=' ',YTITLE=' ',$
;                 TITLE=' ',VIEW_TITLE=' ',RGB_TABLE=n_colTable_cont_map,TRANSPARENCY=0,RGB_INDICES=rgb_indicies,C_VALUE=c_value,$
;                 /NO_SAVEPROMPT,LOCATION=[100,0],DIMENSIONS=[620,620],NAME=name,VIEW_ZOOM=1.0,SHADING=1,/isotropic,IDENTIFIER=idTool_3
;      file_write = 'images/ch_'+file_out+'_plotC_ch'+string_ch+file_exten
;    ENDELSE
;    ISAVE, file_write, RESOLUTION=resolution, TARGET_IDENTIFIER=idTool_3
;  ENDIF


END

;#######################################################################
;#######################################################################

PRO GETVAL,header,keys,values

  keyword = strtrim(strmid(header, 0, 8), 2)
  space = strpos( header, ' ', 10) + 1
  slash = strpos( header, '/', 10)  > space

  N = N_elements(header)
  len = (slash -10) > 20
  len = reform(len,1,N)
  lvalue = strtrim(strmid(header, 10, len),2)

  nkey = n_elements(keys)
  values = dblarr(nkey)
  for i=0,nkey-1 do values[i] = lvalue[where(keyword eq keys[i])]
  if nkey eq 1 then values=values[0]
  
END

;#######################################################################
;#######################################################################


PRO PLOTIMAGE, image_array, wave_string, chan_string, file_out, n_images, xy_size, pixelsize, xy_size_new, n_colTable_chan_map, N_RESET=n_reset, ROT_DEG=rot_deg

   starttime = SYSTIME(1)
   DEVICE, DECOMPOSED = 0
   !EXCEPT=0
   
   ;defaults are n_reset=0 (widget is not destroyed) and rot_deg=0 (images are not rotated)
   IF KEYWORD_SET(n_reset) THEN n_reset=n_reset ELSE n_reset=0
   IF KEYWORD_SET(rot_deg) THEN rot_deg=rot_deg ELSE rot_deg=0.d0

   ;-------------------------------------------------------------------------
   ; general setup


   file_images = 'images/images_'+file_out

   CD, CURRENT=current_dir
   FILE_MKDIR, current_dir+'/images'

   mu      = '!9'+String("155B)+'!X'
   font_axis = OBJ_NEW('IDLgrFont', 'Helvetica*Bold', SIZE=10.0)
   font_wave = OBJ_NEW('IDLgrFont', 'Helvetica*Bold', SIZE=10.0)
   font_pa   = OBJ_NEW('IDLgrFont', 'Helvetica*Bold', SIZE=14.0)


   ;-------------------------------------------------------------------------
   ; zoom images
   
   image_array_zoom = MAKE_ARRAY(n_images,xy_size_new,xy_size_new,/DOUBLE)
   image_array_zoom = image_array[*,xy_size/2-xy_size_new/2:xy_size/2+xy_size_new/2,xy_size/2-xy_size_new/2:xy_size/2+xy_size_new/2]


   ;-------------------------------------------------------------------------
   ; create image objects + text

   ; setup color
   LOADCT, n_colTable_chan_map
   TVLCT, savedR, savedG, savedB, /GET
   my_palette = OBJ_NEW('IDLgrPalette', savedR, savedG, savedB) 

   
   ; create image objects
   obj_images = OBJARR(n_images)
   FOR i=0, n_images-1 DO obj_images[i] = OBJ_NEW('IDLgrImage', image_array_zoom[i,*,*], PALETTE=my_palette)

   ; create text objects
   obj_text = OBJARR(n_images)
   font_wave = OBJ_NEW('IDLgrFont', 'Helvetica*Bold', SIZE=10.0)
   FOR i=0, n_images-1 DO BEGIN
      string_name = chan_string[i]+'              '+wave_string[i]
      obj_text[i] = OBJ_NEW('IDLgrText',string_name,LOCATIONS=location,COLOR=[255,255,255],FONT=font_wave,ONGLASS=1,ALIGNMENT=-0.1,/ENABLE_FORMATTING,HIDE=0)
   ENDFOR

   ; create axis objects
   x_axis_obj_images  = OBJARR(n_images)
   y_axis_obj_images  = OBJARR(n_images)
   x_axis_obj2_images = OBJARR(n_images)
   y_axis_obj2_images = OBJARR(n_images)

   x_value_image = (-FINDGEN(xy_size_new+1)+xy_size_new/2) * pixelsize
   y_value_image = (-FINDGEN(xy_size_new+1)+xy_size_new/2) * pixelsize

   xrange = [MIN(x_value_image),MAX(x_value_image)]
   yrange = [MIN(y_value_image),MAX(y_value_image)]

   FOR i=0, n_images-1 DO BEGIN
   
    	notext2 = 1
    	IF i EQ 21 THEN notext1 = 0 ELSE notext1 = 1
    	
    	color = [255,255,255]
    	xticklen = 0.05*(yrange[1]-yrange[0])
    	yticklen = 0.05*(xrange[1]-xrange[0])
    	
        x_axis_label1  = OBJ_NEW('IDLgrText',"relative RA (arcsec)",COLOR=[0,0,0],/ENABLE_FORMATTING,FONT=font_axis)
        y_axis_label1  = OBJ_NEW('IDLgrText',"relative DEC (arcsec)",COLOR=[0,0,0],/ENABLE_FORMATTING,FONT=font_axis)
        x_axis_label2  = OBJ_NEW('IDLgrText',"relative RA (arcsec)",COLOR=[0,0,0],/ENABLE_FORMATTING,FONT=font_axis)
        y_axis_label2  = OBJ_NEW('IDLgrText',"relative DEC (arcsec)",COLOR=[0,0,0],/ENABLE_FORMATTING,FONT=font_axis)
    	x_axis_obj_images[i]  = OBJ_NEW('IDLgrAxis', DIRECTION=0, GRIDSTYLE=0, COLOR=color,THICK=2, TICKLEN=xticklen, RANGE=xrange,$
    	                        TITLE=x_axis_label1, EXACT=1, NOTEXT=notext1, LOCATION=[0,yrange[0],0], TICKDIR=0, USE_TEXT_COLOR=1)
    	y_axis_obj_images[i]  = OBJ_NEW('IDLgrAxis', DIRECTION=1, GRIDSTYLE=0, COLOR=color,THICK=2, TICKLEN=yticklen, RANGE=yrange,$
    				            TITLE=y_axis_label1, EXACT=1, NOTEXT=notext1, LOCATION=[xrange[0],0,0], TICKDIR=0, USE_TEXT_COLOR=1)
    	x_axis_obj2_images[i] = OBJ_NEW('IDLgrAxis', DIRECTION=0, GRIDSTYLE=0, COLOR=color,THICK=2, TICKLEN=xticklen, RANGE=xrange,$
    	                        TITLE=x_axis_label2, EXACT=1, NOTEXT=notext2, LOCATION=[0,yrange[1],0], TICKDIR=1, USE_TEXT_COLOR=1)
    	y_axis_obj2_images[i] = OBJ_NEW('IDLgrAxis', DIRECTION=1, GRIDSTYLE=0, COLOR=color,THICK=2, TICKLEN=yticklen, RANGE=yrange,$
    				            TITLE=y_axis_label2, EXACT=1, NOTEXT=notext2, LOCATION=[xrange[1],0,0], TICKDIR=1, USE_TEXT_COLOR=1)
   ENDFOR


        
  
   ;-------------------------------------------------------------------------
   ; create view for the images and add objects to the appropriate model

   n_objects_images = 3*n_images
   
   obj_model_images = OBJARR(n_objects_images)
   
   FOR i=0, n_objects_images-1 DO obj_model_images[i] = OBJ_NEW('IDLgrModel')


   ;view 1: add pictures+text to the image models
   FOR i=0*n_images, 1*n_images-1 DO obj_model_images[i] ->Add, obj_images[i]
   FOR i=1*n_images, 2*n_images-1 DO obj_model_images[i] ->Add, obj_text[i-n_images]
   FOR i=2*n_images, 3*n_images-1 DO obj_model_images[i] ->Add, x_axis_obj_images[i-2*n_images]
   FOR i=2*n_images, 3*n_images-1 DO obj_model_images[i] ->Add, y_axis_obj_images[i-2*n_images]
   FOR i=2*n_images, 3*n_images-1 DO obj_model_images[i] ->Add, x_axis_obj2_images[i-2*n_images]
   FOR i=2*n_images, 3*n_images-1 DO obj_model_images[i] ->Add, y_axis_obj2_images[i-2*n_images]

   
   ;-------------------------------------------------------------------------
   ;setup model (basically the position in the view)

   MODEL_SETUP_IMAGE, obj_model_images, xy_size_new, n_images, pixelsize


   ;-------------------------------------------------------------------------
   ; create view and add models to the view

   myview_images = OBJ_NEW('IDLgrView',VIEWPLANE_RECT=[0,0,1.5,1],DEPTH_CUE=[0.0,0.0],ZCLIP=[1.1,-1.1],PROJECTION=1,EYE=(4*1),COLOR=[255,255,255])

   FOR i=0, n_objects_images-1 DO myview_images ->Add, obj_model_images[i]


   ;-------------------------------------------------------------------------
   ; create GUI 
  
   ;create top draw widget with file menu
   wTopBase_images = WIDGET_BASE(COLUMN=2, TITLE='title', XPAD=1, YPAD=1, /TLB_KILL_REQUEST_EVENTS,$ 
                     UNAME='View_Object_images', MBAR=wMenuBase)
  
   ;create menu
   menu_file   = WIDGET_BUTTON(wMenuBase, VALUE='File', /MENU) 
   menu_file_a = WIDGET_BUTTON(menu_file, VALUE='Quit', UVALUE='button_quit') 
   menu_file_b = WIDGET_BUTTON(menu_file, VALUE='Save as tiff', UVALUE='button_save_tiff') 
   menu_file_b = WIDGET_BUTTON(menu_file, VALUE='Save as gif',  UVALUE='button_save_gif') 
   menu_file_b = WIDGET_BUTTON(menu_file, VALUE='Save as bmp',  UVALUE='button_save_bmp') 
   menu_file_b = WIDGET_BUTTON(menu_file, VALUE='Save as png',  UVALUE='button_save_png') 
   menu_file_b = WIDGET_BUTTON(menu_file, VALUE='Save as jpg',  UVALUE='button_save_jpg') 
   menu_file_b = WIDGET_BUTTON(menu_file, VALUE='Save as ppm',  UVALUE='button_save_ppm') 
   menu_file_b = WIDGET_BUTTON(menu_file, VALUE='Save as srf',  UVALUE='button_save_srf') 
  
   ;set up the main drawing panel
   wDraw_images = WIDGET_DRAW(wTopBase_images, XSIZE=1300, YSIZE=900,UVALUE='draw', RETAIN=0, /EXPOSE_EVENTS, $
                              /MOTION_EVENTS, /BUTTON_EVENTS, GRAPHICS_LEVEL=2, UNAME='ViewObj_Draw_images')
  
   ;create button widget
   button_x_size = 100
   wButtonBase_images = WIDGET_BASE(wTopBase_images,ROW=20) 
  
   button_save_tiff = WIDGET_BUTTON(wButtonBase_images, VALUE='save as tiff',$
                      UVALUE='button_save_tiff',XSIZE=button_x_size,YSIZE=25)
   button_save_gif  = WIDGET_BUTTON(wButtonBase_images, VALUE='save as gif',$
                      UVALUE='button_save_gif',XSIZE=button_x_size,YSIZE=25)
   button_save_bmp  = WIDGET_BUTTON(wButtonBase_images, VALUE='save as bmp',$
                      UVALUE='button_save_bmp',XSIZE=button_x_size,YSIZE=25)
   button_save_png  = WIDGET_BUTTON(wButtonBase_images, VALUE='save as png',$
                      UVALUE='button_save_png',XSIZE=button_x_size,YSIZE=25)
   button_save_jpg  = WIDGET_BUTTON(wButtonBase_images, VALUE='save as jpg',$
                      UVALUE='button_save_jpg',XSIZE=button_x_size,YSIZE=25)
   button_save_ppm  = WIDGET_BUTTON(wButtonBase_images, VALUE='save as ppm',$
                      UVALUE='button_save_ppm',XSIZE=button_x_size,YSIZE=25)
   button_save_srf  = WIDGET_BUTTON(wButtonBase_images, VALUE='save as srf',$
                      UVALUE='button_save_srf',XSIZE=button_x_size,YSIZE=25)
   button_quit      = WIDGET_BUTTON(wButtonBase_images,VALUE='exit',$  
                      UVALUE='button_quit',XSIZE=button_x_size,YSIZE=25) 


   ;create choose widget
   wButtonChoose0 = CW_BGROUP(wButtonBase_images,['style 1','style 2'],XOFFSET=10,$   
                    COLUMN=1,/EXCLUSIVE,XSIZE=button_x_size,LABEL_TOP='x-Axis',$
                    BUTTON_UVALUE=['button_style1','button_style2'],/NO_RELEASE,$
                    UVALUE='wButtonChoose0',SET_VALUE=n_xaxis)
   wButtonChoose1 = CW_BGROUP(wButtonBase_images,['text','info'],XOFFSET=10,$   
                    COLUMN=1,/NONEXCLUSIVE,XSIZE=button_x_size,LABEL_TOP='Plots',$
                    BUTTON_UVALUE=['button_text','button_info'],$
                    UVALUE='wButtonChoose1',SET_VALUE=[1,1])

   ;-------------------------------------------------------------------------
   ; realize the base widget.

   WIDGET_CONTROL, wTopBase_images, /REALIZE
  
   ;Get the window id of the drawable
   WIDGET_CONTROL, wDraw_images, GET_VALUE=oWindow_images
     
   ;Create a holder object for easy destruction.
   oHolder_images = OBJ_NEW('IDL_Container')
   oHolder_images ->Add, myview_images
  

   ;-------------------------------------------------------------------------
   ; create structure for values needed to change interactively

   ;structure
   sState_images = {file          :file_images,          $
                    obj_text      :obj_text,             $
                    obj_model     :obj_model_images,     $
                    oHolder       :oHolder_images,       $
                    oWindow       :oWindow_images,       $
                    myview        :myview_images         }
  
   ;add structure to the main widget
   WIDGET_CONTROL, wTopBase_images, SET_UVALUE=sState_images, /NO_COPY


   ;-------------------------------------------------------------------------
   ; draw widget

   oWindow_images->Draw, myview_images

  
   ;-------------------------------------------------------------------------
   ; blow life into the whole thing

   XMANAGER, 'Image Viewer',  wTopBase_images,EVENT_HANDLER='viewobj_event_images',/NO_BLOCK

   ;-------------------------------------------------------------------------
   ; save images as gif file

   oWindow_images->GetProperty, IMAGE_DATA=image_images

   image_name = file_images+'.gif'
   WRITE_IMAGE, image_name, 'gif', image_images, /APPEND

   ;image_name = file_images+'.tiff'
   ;ndim = SIZE(image, /N_DIMENSIONS)
   ;WRITE_TIFF, image_name, REVERSE(image_images, ndim)


   IF n_reset EQ 1 THEN WIDGET_CONTROL, /RESET

   PRINT, "PIM>  "
   PRINT, "PIM> profile cut:   ", STRING(rot_deg)
   PRINT, "PIM> creation time: ", SYSTIME(1)-starttime, " s"
   PRINT, "PIM> do not forget to save the figure!"
   PRINT, "PIM>  "

END


;#######################################################################
;#######################################################################


PRO VIEWOBJ_EVENT_IMAGES, sEvent
  
   ;-------------------------------------------------------------------------
   ;MAIN EVENT HANDLER
  
   ;Get the data
   WIDGET_CONTROL, sEvent.top, GET_UVALUE=sState_images, /NO_COPY
   WIDGET_CONTROL, sEvent.id,  GET_UVALUE=uState_images
  
   ;If event is a kill request...
   IF TAG_NAMES(sEvent, /STRUCTURE_NAME) EQ 'WIDGET_KILL_REQUEST' THEN BEGIN
     WIDGET_CONTROL, sEvent.top, SET_UVALUE=sState_images, /NO_COPY
     WIDGET_CONTROL, sEvent.top, /DESTROY
     RETURN
   ENDIF
  
  
   ;-------------------------------------------------------------------------
   ; parse event

   CASE uState_images OF
     ;----------------------------------------------------------
     'draw': BEGIN
     
     END
     ;----------------------------------------------------------
     'button_quit':BEGIN 
        PRINT, " "
        PRINT, "program finished"
        PRINT, " "
        WIDGET_CONTROL,sEvent.top,/destroy
        !except=1
        RETURN
     END
     ;----------------------------------------------------------
     'button_save_tiff':BEGIN
        ;get image data
        sState_images.oWindow->GetProperty, IMAGE_DATA=image
  
        image_name = sState_images.file+'.tiff'
        ndim = SIZE(image, /N_DIMENSIONS)
        WRITE_TIFF, image_name, REVERSE(image, ndim)

        PRINT, "PLO:  "
        PRINT, "PLO: successfully saved as: ", image_name
     END
     ;----------------------------------------------------------
     'button_save_gif':BEGIN
        ;get image data
        sState_images.oWindow->GetProperty, IMAGE_DATA=image
  
        image_name = sState_images.file+'.gif'
        ndim = SIZE(image, /N_DIMENSIONS)
        WRITE_IMAGE, image_name, 'gif', image, /APPEND

        PRINT, "PLO:  "
        PRINT, "PLO: successfully saved as: ", image_name
     END
     ;----------------------------------------------------------
     'button_save_bmp':BEGIN
        ;get image data
        sState_images.oWindow->GetProperty, IMAGE_DATA=image
        ;sState.oWindow->GetProperty, IMAGE_DATA=image
  
        image_name = sState_images.file+'.bmp'
        ndim = SIZE(image, /N_DIMENSIONS)
        WRITE_IMAGE, image_name, 'bmp', image, /APPEND

        PRINT, "PLO:  "
        PRINT, "PLO: successfully saved as: ", image_name
     END
     ;----------------------------------------------------------
     'button_save_png':BEGIN
        ;get image data
        sState_images.oWindow->GetProperty, IMAGE_DATA=image
  
        image_name = sState_images.file+'.png'
        ndim = SIZE(image, /N_DIMENSIONS)
        WRITE_IMAGE, image_name, 'png', image, /APPEND

        PRINT, "PLO:  "
        PRINT, "PLO: successfully saved as: ", image_name
     END
     ;----------------------------------------------------------
     'button_save_jpg':BEGIN
        ;get image data
        sState_images.oWindow->GetProperty, IMAGE_DATA=image
  
        image_name = sState_images.file+'.jpg'
        ndim = SIZE(image, /N_DIMENSIONS)
        WRITE_JPEG, image_name, image , QUALITY=100, TRUE=1

        PRINT, "PLO:  "
        PRINT, "PLO: successfully saved as: ", image_name
     END
     ;----------------------------------------------------------
     'button_save_ppm':BEGIN
        ;get image data
        sState_images.oWindow->GetProperty, IMAGE_DATA=image
  
        image_name = sState_images.file+'.ppm'
        ndim = SIZE(image, /N_DIMENSIONS)
        WRITE_IMAGE, image_name, 'ppm', image, /APPEND

        PRINT, "PLO:  "
        PRINT, "PLO: successfully saved as: ", image_name
     END
     ;----------------------------------------------------------
     'button_save_srf':BEGIN
        ;get image data
        sState_images.oWindow->GetProperty, IMAGE_DATA=image
  
        image_name = sState_images.file+'.srf'
        ndim = SIZE(image, /N_DIMENSIONS)
        WRITE_IMAGE, image_name, 'srf', image, /APPEND

        PRINT, "PLO:  "
        PRINT, "PLO: successfully saved as: ", image_name
     END
     ;----------------------------------------------------------
     'wButtonChoose0':BEGIN

     END
     ;----------------------------------------------------------
     'wButtonChoose1':BEGIN

     END
     ;----------------------------------------------------------
  ENDCASE
  
  WIDGET_CONTROL, sEvent.top, SET_UVALUE=sState_images, /NO_COPY

END


;#######################################################################
;#######################################################################

   ;image is 0.0 to 1.5 in x and 0.0 to 1.0 in y
   ;image reference is lower left corner


PRO MODEL_SETUP_IMAGE, obj_model_images, xy_size_new, n_images, pixelsize

   ;scale models
   FOR i=0*n_images, 1*n_images-1 DO obj_model_images[i] ->SCALE, 1.d0/(xy_size_new+1)/5.d0, 1.d0/(xy_size_new+1)/5.d0, 1 ;image
   FOR i=1*n_images, 2*n_images-1 DO obj_model_images[i] ->SCALE, 1.d0/(xy_size_new+1)/5.d0, 1.d0/(xy_size_new+1)/5.d0, 1 ;text
   FOR i=2*n_images, 3*n_images-1 DO obj_model_images[i] ->SCALE, 1.d0/(xy_size_new)/5.d0/pixelsize, 1.d0/(xy_size_new)/5.d0/pixelsize, 1 ;axis
   
   ;translate models
   FOR i=0,   7-1 DO obj_model_images[i] ->TRANSLATE, 0.08+0.2*i,      0.70, 0
   FOR i=7,  14-1 DO obj_model_images[i] ->TRANSLATE, 0.08+0.2*(i-7),  0.50, 0
   FOR i=14, 21-1 DO obj_model_images[i] ->TRANSLATE, 0.08+0.2*(i-14), 0.30, 0
   FOR i=21, 28-1 DO obj_model_images[i] ->TRANSLATE, 0.08+0.2*(i-21), 0.10, 0

   e_shift = 0.1
   FOR i=n_images+0,  n_images+7-1  DO obj_model_images[i] ->TRANSLATE, -0.02+0.2*(i-n_images)+e_shift,    0.87, 0.1
   FOR i=n_images+7,  n_images+14-1 DO obj_model_images[i] ->TRANSLATE, -0.02+0.2*(i-n_images-7)+e_shift,  0.67, 0.1
   FOR i=n_images+14, n_images+21-1 DO obj_model_images[i] ->TRANSLATE, -0.02+0.2*(i-n_images-14)+e_shift, 0.47, 0.1
   FOR i=n_images+21, n_images+28-1 DO obj_model_images[i] ->TRANSLATE, -0.02+0.2*(i-n_images-21)+e_shift, 0.27, 0.1

   FOR i=2*n_images+0,  2*n_images+7-1  DO obj_model_images[i] ->TRANSLATE, 0.08+0.2*(i-2*n_images)+e_shift,    0.70+e_shift, 1
   FOR i=2*n_images+7,  2*n_images+14-1 DO obj_model_images[i] ->TRANSLATE, 0.08+0.2*(i-2*n_images-7)+e_shift,  0.50+e_shift, 1
   FOR i=2*n_images+14, 2*n_images+21-1 DO obj_model_images[i] ->TRANSLATE, 0.08+0.2*(i-2*n_images-14)+e_shift, 0.30+e_shift, 1
   FOR i=2*n_images+21, 2*n_images+28-1 DO obj_model_images[i] ->TRANSLATE, 0.08+0.2*(i-2*n_images-21)+e_shift, 0.10+e_shift, 1

END


;#######################################################################
;#######################################################################
 

 
 