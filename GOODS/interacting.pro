PRO LOADCONFIG
   COMMON share, path, hst_path,wircam_path,spitzer_path
   ;Settings for HOME computer
   ;imgpath = '/home/chyan/iras/'
   ;mappath = '/home/chyan/iras/'
   
   ;Settings for ASIAA computer
   path='/asiaa/home/chyan/GOODS/'
   hst_path='/arrays/cfht_3/chyan/GOODSN/HST/'
   wircam_path='/arrays/cfht_3/chyan/GOODSN/WIRCam/'
   spitzer_path='/arrays/cfht_3/chyan/GOODSN/Spitzer/'
   
   return 
END


PRO LOADSCUBALIST, id ,ra, dec
   COMMON share, path, hst_path,wircam_path,spitzer_path
   loadconfig
   
   readcol,path+'data_pair.cat',format='(A5,A2,F,F)'$
      ,id,id1,ra,dec  
   
   ;readcol,path+'merger.cat',format='(A6,A19,A11,A11,F,F,F,F,F,F)'$
   ;   ,id,id2,rah,ram,ras,decd,decm,decs  
   
   ;ra=(rah+(ram/60.0)+(ras/3600.0))*15
   ;dec=decd+(decm/60.0)+(decs/3600.0)
   
END

PRO MKJREG, PS=ps
   COMMON share, path, hst_path,wircam_path,spitzer_path
   loadconfig
   
   resetplt,/all
   if keyword_set(PS) then begin 
      set_plot,'ps'
      filename='wircam_J_pair.ps'
      device,filename=path+filename,$
        /color,xsize=20,ysize=20,xoffset=0,yoffset=3.5
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2   
   endif else begin
      red=255
      green=32768    
   endelse
   !p.multi=[0,4,4]
   
   loadscubalist,id,sra,sdec
   hdr=headfits(wircam_path+'J_GOODS.fits')
   im=readfits(wircam_path+'J_GOODS.fits')
   adxy,hdr,sra,sdec,x,y
   
   close,1
   openw,1,wircam_path+'J_GOODS.reg'
   for i=0,n_elements(x)-1 do begin
      !p.title = "!6"+id[i]
      !x.title = "!6RA offset(arcsec)"  & !y.title = "!6Dec offset(arcsec)"
   
      th_image_cont,im[x[i]-19:x[i]+20,y[i]-19:y[i]+20],/nocont,/nobar,$
         crange=[-50,150],/inverse,xrange=[-6,6],yrange=[-6,6]
      plotsym2,0,2
      plots,0,0,psym=8,color=red
      printf,1,'circle('+strcompress(string(x[i]),/remove)+','+$
         strcompress(string(y[i]),/remove)+',10)'
   endfor
   close,1
   if keyword_set(PS) then begin
      xyouts,0,0,filename,/device
      device,/close
      set_plot,'x'
   endif
   resetplt,/all
   !p.multi=0
END 


PRO MKKREG, PS=ps
   COMMON share, path, hst_path,wircam_path,spitzer_path
   loadconfig
   
   resetplt,/all
   if keyword_set(PS) then begin 
      set_plot,'ps'
      filename='wircam_K_pair.ps'
      device,filename=path+filename,$
         /color,xsize=20,ysize=20,xoffset=0,yoffset=3.5
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2   
   endif else begin
      red=255
      green=32768    
   endelse
   !p.multi=[0,4,4]
   
   loadscubalist,id,sra,sdec
   hdr=headfits(wircam_path+'Ks_GOODS.fits')
   im=readfits(wircam_path+'Ks_GOODS.fits')
   adxy,hdr,sra,sdec,x,y
   
   close,1
   openw,1,wircam_path+'Ks_GOODS.reg'
   for i=0,n_elements(x)-1 do begin
      !p.title = "!6"+id[i]
      !x.title = "!6RA offset(arcsec)"  & !y.title = "!6Dec offset(arcsec)"
      ;!p.charsize = 1.3
     
      th_image_cont,im[x[i]-19:x[i]+20,y[i]-19:y[i]+20],/nocont,/nobar,$
         crange=[-50,250],/inverse,xrange=[-6,6],yrange=[-6,6]
      plotsym2,0,2
      plots,0,0,psym=8,color=red
      printf,1,'circle('+strcompress(string(x[i]),/remove)+','+$
         strcompress(string(y[i]),/remove)+',10)'
   endfor
   close,1
   if keyword_set(PS) then begin
      xyouts,0,0,filename,/device
      device,/close
      set_plot,'x'
   endif
   resetplt,/all
   !p.multi=0

END

PRO MKHSTBREG, PS = ps
   COMMON share, path, hst_path,wircam_path,spitzer_path
   loadconfig

   resetplt,/all
   if keyword_set(PS) then begin 
      set_plot,'ps'
      filename='hst_B_scuba.ps'
      device,filename=path+filename,$
        /color,xsize=20,ysize=20,xoffset=0,yoffset=3.5
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2   
   endif else begin
      red=255
      green=32768    
   endelse
   !p.multi=[0,4,4]
   
   loadscubalist,id,sra,sdec

   files=['h_nb_sect13_v1.0_drz_img.fits',$
      'h_nb_sect14_v1.0_drz_img.fits',$
      'h_nb_sect22_v1.0_drz_img.fits',$
      'h_nb_sect23_v1.0_drz_img.fits',$
      'h_nb_sect24_v1.0_drz_img.fits',$
      'h_nb_sect25_v1.0_drz_img.fits',$
      'h_nb_sect31_v1.0_drz_img.fits',$
      'h_nb_sect32_v1.0_drz_img.fits',$
      'h_nb_sect33_v1.0_drz_img.fits',$
      'h_nb_sect34_v1.0_drz_img.fits',$
      'h_nb_sect35_v1.0_drz_img.fits',$
      'h_nb_sect41_v1.0_drz_img.fits',$
      'h_nb_sect42_v1.0_drz_img.fits',$
      'h_nb_sect43_v1.0_drz_img.fits',$
      'h_nb_sect44_v1.0_drz_img.fits',$
      'h_nb_sect52_v1.0_drz_img.fits',$
      'h_nb_sect53_v1.0_drz_img.fits']

      
   for i=0, n_elements(sra)-1 do begin
      for j=0,n_elements(files)-1 do begin
         hdr=headfits(hst_path+files[j])
         adxy,hdr,sra[i],sdec[i],x,y
         naxis1=sxpar(hdr,'NAXIS1')
         naxis2=sxpar(hdr,'NAXIS2')
         if (x ge 0 and x le naxis1 and y ge 0 and y le naxis2) then begin
            !p.title = "!6"+id[i]
            !x.title = "!6RA offset(arcsec)"  & !y.title = "!6Dec offset(arcsec)"

            im=readfits(hst_path+files[j])
            
            x1=x-199
            x2=x+200
            y1=y-199
            y2=y+200
            print,x1,x2,y1,y2,naxis1
            
            if x-199 lt 0      then begin 
               x1=0
               x2=299 
            endif
            
            if x+200 gt naxis1 then begin 
               x1=naxis1-400
               x2=naxis1-1 
            endif
            
            if y-199 lt 0      then begin 
               y1=0
               y2=299 
            endif
            
            if y+200 gt naxis2 then begin 
               y1=naxis1-400
               y2=naxis1-1 
            endif
            
            hextract,im,hdr,nim,hd1,x1,x2,y1,y2
            adxy,hd1,sra[i],sdec[i],x,y
            th_image_cont,nim,/nocont,/nobar,$
               crange=[0,0.01],/inverse;,xrange=[-1.2,1.2],yrange=[-1.2,1.2]    
            plotsym2,0,2
            plots,x,y,psym=8,color=red
                       
         endif 
           
      endfor
   endfor

   if keyword_set(PS) then begin
      xyouts,0,0,filename,/device
      device,/close
      set_plot,'x'
   endif
   resetplt,/all
   !p.multi=0

END

PRO MKHSTZREG, PS = ps
   COMMON share, path, hst_path,wircam_path,spitzer_path
   loadconfig

   resetplt,/all
   if keyword_set(PS) then begin 
      set_plot,'ps'
      filename='hst_Z_pair.ps'
      device,filename=path+filename,$
         /color,xsize=20,ysize=20,xoffset=0,yoffset=3.5
     
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2   
   endif else begin
      red=255
      green=32768    
   endelse
   !p.multi=[0,4,4]
   
   loadscubalist,id,sra,sdec

   files=['h_nz_sect13_v1.0_drz_img.fits',$
      'h_nz_sect14_v1.0_drz_img.fits',$
      'h_nz_sect22_v1.0_drz_img.fits',$
      'h_nz_sect23_v1.0_drz_img.fits',$
      'h_nz_sect24_v1.0_drz_img.fits',$
      'h_nz_sect25_v1.0_drz_img.fits',$
      'h_nz_sect31_v1.0_drz_img.fits',$
      'h_nz_sect32_v1.0_drz_img.fits',$
      'h_nz_sect33_v1.0_drz_img.fits',$
      'h_nz_sect34_v1.0_drz_img.fits',$
      'h_nz_sect35_v1.0_drz_img.fits',$
      'h_nz_sect41_v1.0_drz_img.fits',$
      'h_nz_sect42_v1.0_drz_img.fits',$
      'h_nz_sect43_v1.0_drz_img.fits',$
      'h_nz_sect44_v1.0_drz_img.fits',$
      'h_nz_sect52_v1.0_drz_img.fits',$
      'h_nz_sect53_v1.0_drz_img.fits']

      
   for i=0, n_elements(sra)-1 do begin
      for j=0,n_elements(files)-1 do begin
         hdr=headfits(hst_path+files[j])
         adxy,hdr,sra[i],sdec[i],x,y
         naxis1=sxpar(hdr,'NAXIS1')
         naxis2=sxpar(hdr,'NAXIS2')
         if (x ge 0 and x le naxis1 and y ge 0 and y le naxis2) then begin
            !p.title = "!6"+id[i]
            !x.title = "!6RA offset(arcsec)"  & !y.title = "!6Dec offset(arcsec)"

            im=readfits(hst_path+files[j])
            
            x1=x-199
            x2=x+200
            y1=y-199
            y2=y+200
            print,x1,x2,y1,y2
            
            if x-199 lt 0      then begin 
               x1=0
               x2=299 
            endif
            
            if x+200 gt naxis1 then begin 
               x1=naxis1-400
               x2=naxis1-1 
            endif
            
            if y-199 lt 0      then begin 
               y1=0
               y2=299 
            endif
            
            if y+200 gt naxis2 then begin 
               y1=naxis1-400
               y2=naxis1-1 
            endif
            print,x1,x2,y1,y2
            hextract,im,hdr,nim,hd1,x1,x2,y1,y2
            adxy,hd1,sra[i],sdec[i],x,y
            ;clearplt,/x,/y
            th_image_cont,nim,/nocont,/nobar,$
               crange=[0,0.005],/inverse;,xrange=[-1.2,1.2],yrange=[-1.2,1.2]    

            plotsym2,0,2
            plots,x,y,psym=8,color=red
             
         endif 
           
      endfor
   endfor

   if keyword_set(PS) then begin
      xyouts,0,0,filename,/device
      device,/close
      set_plot,'x'
   endif
   resetplt,/all
   !p.multi=0

END


PRO MKI1REG, PS=ps
   COMMON share, path, hst_path,wircam_path,spitzer_path
   loadconfig
   
   resetplt,/all
   if keyword_set(PS) then begin 
      set_plot,'ps'
      filename='spitzer_I1_scuba.ps'
      device,filename=path+filename,$
         /color,xsize=20,ysize=20,xoffset=0,yoffset=3.5
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2   
   endif else begin
      red=255
      green=32768    
   endelse
   !p.multi=[0,4,4]
   
   loadscubalist,id,sra,sdec
   hdr=headfits(spitzer_path+'n_irac_1_s2_v0.30_sci.fits')
   im=readfits(spitzer_path+'n_irac_1_s2_v0.30_sci.fits')
   adxy,hdr,sra,sdec,x,y
   
   close,1
   openw,1,wircam_path+'n_irac_1_s2_v0.30_sci.reg'
   for i=0,n_elements(x)-1 do begin
      !p.title = "!6"+id[i]
      !x.title = "!6RA offset(arcsec)"  & !y.title = "!6Dec offset(arcsec)"
      ;!p.charsize = 1.3
     
      th_image_cont,im[x[i]-4:x[i]+5,y[i]-4:y[i]+5],/nocont,/nobar,$
         crange=[0,0.1],/inverse,xrange=[-6,6],yrange=[-6,6]
      
      plotsym2,0,2
      plots,0,0,psym=8,color=red
      printf,1,'circle('+strcompress(string(x[i]),/remove)+','+$
         strcompress(string(y[i]),/remove)+',10)'
   endfor
   close,1
   if keyword_set(PS) then begin
      xyouts,0,0,filename,/device
      device,/close
      set_plot,'x'
   endif
   resetplt,/all
   !p.multi=0

END









