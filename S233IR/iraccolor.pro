PRO IRACCOLOR, PS=ps
   common share, conf
   loadconfig
   
   
   
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=conf.pspath+'iras_iraccolor.ps',$
         /color,xsize=20,ysize=20,xoffset=0,yoffset=2,SET_FONT='Times', /TT_FONT  
         ;SET_FONT='Helvetica',/TT_FONT
      
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      !p.font =1
      !x.charsize=1.3
      !y.charsize=1.3
      !x.thick=5
      !y.thick=5 
   endif else begin
      red=255
      green=32768    
   endelse
   i1=readfits(conf.iracpath+'S233IR_I1.fits',hd1)
   i2=readfits(conf.iracpath+'S233IR_I2.fits',hd2)
   i3=readfits(conf.iracpath+'S233IR_I3.fits',hd3)
   i4=readfits(conf.iracpath+'S233IR_I4.fits',hd4)
    
   hrot, i1, hd1, ti1, thd1, -90, -1, -1, 1
   
   hextract, ti1, thd1,ni1,nhd1,426,708,100,388   
   hastrom,i2,hd2,ni2,nhd2,nhd1
   hastrom,i3,hd3,ni3,nhd3,nhd1
   hastrom,i4,hd4,ni4,nhd4,nhd1
   
   dimension=size(ni2)
   xsize=dimension[1]
   ysize=dimension[2]

   ind=where(finite(ni1,/nan))
   ;ni1[ind]=0
   ind=where(finite(ni2,/nan))
   ;ni2[ind]=0
   ind=where(finite(ni3,/nan))
   ;ni3[ind]=0
   ind=where(finite(ni4,/nan))
   ;ni4[ind]=0
   
   image=fltarr(3,xsize,ysize)
   
   image[0,*,*]=gmascl(ni4, gamma=0.9, MIN=0, MAX=0.3*max(ni4))
   image[1,*,*]=GmaScl(ni2, gamma=0.7, MIN=0, MAX=0.1*max(ni2))
   image[2,*,*]=GmaScl(ni1, gamma=0.7, MIN=0, MAX=0.1*max(ni1))
   
   
   imdisp,image,/axis
   
   ;th_image_cont,ni1,crange=[0,10],/nocont,/nobar,/inverse
   oplotbox,95,121,125,151,color=red
   oplotbox,174,201,98,128,color=red
   oplotbox,128,169,130,153,color=red
   oplotbox,168,203,136,174,color=red
   
   
   hextract, ni1, nhd1,ni1g1,nhd1g1,95,121,125,151
   hastrom,ni2,nhd2,ni2g1,nhd2g1,nhd1g1
   hastrom,ni3,nhd3,ni3g1,nhd3g1,nhd1g1
   hastrom,ni4,nhd4,ni4g1,nhd4g1,nhd1g1
   
   ; For region 1   
   !p.multi=[0,2,2]
   th_image_cont,ni1,crange=[0,10],/nocont,/nobar,/inverse
   oplotbox,95,121,125,151,color=red
   
   coeff=linfit(reform(ni2g1),reform(ni1g1),yfit=yfit)
   plot,reform(ni2g1),reform(ni1g1),psym=3,title='R= '+strcompress(string(coeff[1],format='(f5.2)'),/remove),$
      xtitle='I2',ytitle='I1',charsize=1.2,font=1
   oplot,reform(ni2g1),yfit,color=red
   
   coeff=linfit(reform(ni3g1),reform(ni2g1),yfit=yfit)
   plot,reform(ni3g1),reform(ni2g1),psym=3,title='R= '+strcompress(string(coeff[1],format='(f5.2)'),/remove),$
      xtitle='I3',ytitle='I2',charsize=1.2
   oplot,reform(ni3g1),yfit,color=red
   
   coeff=linfit(reform(ni4g1),reform(ni3g1),yfit=yfit)
   plot,reform(ni4g1),reform(ni3g1),psym=3,title='R= '+strcompress(string(coeff[1],format='(f5.2)'),/remove),$
      xtitle='I4',ytitle='I3',charsize=1.2
   oplot,reform(ni4g1),yfit,color=red
   
   
   hextract, ni1, nhd1,ni1g2,nhd1g2,174,201,98,128
   hastrom,ni2,nhd2,ni2g2,nhd2g2,nhd1g2
   hastrom,ni3,nhd3,ni3g2,nhd3g2,nhd1g2
   hastrom,ni4,nhd4,ni4g2,nhd4g2,nhd1g2
   th_image_cont,ni1,crange=[0,10],/nocont,/nobar,/inverse
   oplotbox,174,201,98,128,color=red
   
   ind=where(ni4g2 ge 0 and ni1g2 ge 0)
   coeff=linfit(reform(ni2g2[ind]),reform(ni1g2[ind]),yfit=yfit)
   plot,reform(ni2g2),reform(ni1g2),psym=3,title='R= '+strcompress(string(coeff[1],format='(f5.2)'),/remove),$
      xtitle='I2',ytitle='I1',charsize=1.2,yrange=[0,100],xrange=[0,100]
   oplot,reform(ni2g2[ind]),yfit,color=red
   
   coeff=linfit(reform(ni3g2[ind]),reform(ni2g2[ind]),yfit=yfit)
   plot,reform(ni3g2),reform(ni2g2),psym=3,title='R= '+strcompress(string(coeff[1],format='(f5.2)'),/remove),$
      xtitle='I3',ytitle='I2',charsize=1.2,yrange=[0,100],xrange=[0,600]
   oplot,reform(ni3g2[ind]),yfit,color=red
   
   coeff=linfit(reform(ni4g2[ind]),reform(ni3g2[ind]),yfit=yfit)
   plot,reform(ni4g2),reform(ni3g2),psym=3,title='R= '+strcompress(string(coeff[1],format='(f5.2)'),/remove),$
      xtitle='I4',ytitle='I3',charsize=1.2,yrange=[0,400]
   oplot,reform(ni4g2[ind]),yfit,color=red

   hextract, ni1, nhd1,ni1g3,nhd1g3,128,169,130,153
   hastrom,ni2,nhd2,ni2g3,nhd2g3,nhd1g3
   hastrom,ni3,nhd3,ni3g3,nhd3g3,nhd1g3
   hastrom,ni4,nhd4,ni4g3,nhd4g3,nhd1g3
   th_image_cont,ni1,crange=[0,10],/nocont,/nobar,/inverse
   oplotbox,128,169,130,153,color=red
   
   ind=where(ni1g3 ge 0 and ni2g3 ge 0 and ni3g3 ge 0 and ni4g3 ge 0 and ni4g3 le 100)
   coeff=linfit(reform(ni2g3[ind]),reform(ni1g3[ind]),yfit=yfit)
   plot,reform(ni2g3),reform(ni1g3),psym=3,title='R= '+strcompress(string(coeff[1],format='(f5.2)'),/remove),$
      xtitle='I2',ytitle='I1',charsize=1.2,xrange=[0,50],yrange=[0,50]
   oplot,reform(ni2g3[ind]),yfit,color=red
   
   coeff=linfit(reform(ni3g3[ind]),reform(ni2g3[ind]),yfit=yfit)
   plot,reform(ni3g3),reform(ni2g3),psym=3,title='R= '+strcompress(string(coeff[1],format='(f5.2)'),/remove),$
      xtitle='I3',ytitle='I2',charsize=1.2,xrange=[0,100],yrange=[0,100]
   oplot,reform(ni3g3[ind]),yfit,color=red
   
   coeff=linfit(reform(ni4g3[ind]),reform(ni3g3[ind]),yfit=yfit)
   plot,reform(ni4g3),reform(ni3g3),psym=3,title='R= '+strcompress(string(coeff[1],format='(f5.2)'),/remove),$
      xtitle='I4',ytitle='I3',charsize=1.2,xrange=[0,100],yrange=[0,100]
   oplot,reform(ni4g3[ind]),yfit,color=red
   
   hextract, ni1, nhd1,ni1g4,nhd1g4,168,203,136,174
   hastrom,ni2,nhd2,ni2g4,nhd2g4,nhd1g4
   hastrom,ni3,nhd3,ni3g4,nhd3g4,nhd1g4
   hastrom,ni4,nhd4,ni4g4,nhd4g4,nhd1g4
   th_image_cont,ni1,crange=[0,10],/nocont,/nobar,/inverse
   oplotbox,168,203,136,174,color=red
   
   ind=where(ni1g4 ge 0 and ni2g4 ge 0 and ni3g4 ge 0 and ni4g4 ge 0 and ni4g4 le 100)
   coeff=linfit(reform(ni2g4[ind]),reform(ni1g4[ind]),yfit=yfit)
   plot,reform(ni2g4),reform(ni1g4),psym=3,title='R= '+strcompress(string(coeff[1],format='(f5.2)'),/remove),$
      xtitle='I2',ytitle='I1',charsize=1.2
   oplot,reform(ni2g4[ind]),yfit,color=red
   
   coeff=linfit(reform(ni3g4[ind]),reform(ni2g4[ind]),yfit=yfit)
   plot,reform(ni3g4),reform(ni2g4),psym=3,title='R= '+strcompress(string(coeff[1],format='(f5.2)'),/remove),$
      xtitle='I3',ytitle='I2',charsize=1.2
   oplot,reform(ni3g4[ind]),yfit,color=red
   
   coeff=linfit(reform(ni4g4[ind]),reform(ni3g4[ind]),yfit=yfit)
   plot,reform(ni4g4),reform(ni3g4),psym=3,title='R= '+strcompress(string(coeff[1],format='(f5.2)'),/remove),$
      xtitle='I4',ytitle='I3',charsize=1.2
   oplot,reform(ni4g4[ind]),yfit,color=red

   hextract, ni1, nhd1,ni1g5,nhd1g5,0,20,0,20
   hastrom,ni2,nhd2,ni2g5,nhd2g5,nhd1g5
   hastrom,ni3,nhd3,ni3g5,nhd3g5,nhd1g5
   hastrom,ni4,nhd4,ni4g5,nhd4g5,nhd1g5
   th_image_cont,ni1,crange=[0,10],/nocont,/nobar,/inverse
   oplotbox,0,50,00,50,color=red
   
   ind=where(ni1g5 ge 0 and ni2g5 ge 0 and ni3g5 ge 0 and ni4g5 ge 0 and ni4g5 le 100)
   coeff=linfit(reform(ni2g5[ind]),reform(ni1g5[ind]),yfit=yfit)
   plot,reform(ni2g5),reform(ni1g5),psym=3,title='R= '+strcompress(string(coeff[1],format='(f5.2)'),/remove),$
      xtitle='I2',ytitle='I1',charsize=1.2
   oplot,reform(ni2g5[ind]),yfit,color=red
   
   coeff=linfit(reform(ni3g5[ind]),reform(ni2g5[ind]),yfit=yfit)
   plot,reform(ni3g5),reform(ni2g5),psym=3,title='R= '+strcompress(string(coeff[1],format='(f5.2)'),/remove),$
      xtitle='I3',ytitle='I2',charsize=1.2
   oplot,reform(ni3g5[ind]),yfit,color=red
   
   coeff=linfit(reform(ni4g5[ind]),reform(ni3g5[ind]),yfit=yfit)
   plot,reform(ni4g5),reform(ni3g5),psym=3,title='R= '+strcompress(string(coeff[1],format='(f5.2)'),/remove),$
      xtitle='I4',ytitle='I3',charsize=1.2,xrange=[15,20],yrange=[2,5]
   oplot,reform(ni4g5[ind]),yfit,color=red
  
   !p.multi=0
   resetplt,/all
   
   ;plot,reform(ni2g1),reform(ni1g1),psym=3
   ;oplot,reform(ni3g1),reform(ni2g1)
   ;oplot,reform(ni4g1),reform(ni3g1)
   
   ;oplot,reform(ni2)
   
   if keyword_set(PS) then begin
      device,/close
      set_plot,'x'
   endif

END
