



PRO KSLAW, ps=ps
    COMMON share,conf
    loadconfig

    if keyword_set(PS) then begin
      PS_Start, FILENAME=ps,/encapsulated
      device,/color,xsize=20,ysize=20,xoffset=0.4,yoffset=0,$
        SET_FONT='Times',/TT_FONT;,/encapsulated
        
    endif
    
    
    m_gas=[426,816,4818,2016,2181]
    area=[10,28.4,73.6,17.5,31.4]
    
    sfr=[65,24,96,57,73]
    
    sig_gas=m_gas/area
    sig_sfr=sfr/(area)
    
    logsig_gas=alog10(sig_gas)
    logsig_sfr=alog10(sig_sfr)
    
    plotsym,0,1,/fill
    cgplot,logsig_gas,logsig_sfr,psym=8,yrange=[-3,2],xrange=[1,4.5],xstyle=1,$
      ytitle='log $\Sigma$$\downSFR$ (M$\sun$ yr$\up-1$ kpc$\up-2$)',$
      xtitle='log $\Sigma$$\downgas$ (M$\sun$ pc$\up-2$)',thick=6.0,xthick=5.0,ythick=5.0,$
      charsize=2.0,font=1
    
    ; Plot our result
    plotsym,3,1.5,/fill
    cgoplot,[alog10(69.5)],[alog10(1.7)],psym=8,color=cgcolor('red')
    
    
    cgoplot,[1,4.05],[-2.2,2.0]
    
    cgoplot,[1,1.71],[-2.1,-1.4],thick=5.0
    cgoplot,[1.71,4.5],[-1.4,1.4],line=2,thick=5.0
    
    cgoplot,[1,2.5],[-0.9,0.59],line=2,thick=5.0
    cgoplot,[2.5,4.0],[0.59,2],thick=5.0
    
    xyouts,2,-1.6, 'Bigiel98',charsize=1.5
    xyouts,2.5,1.0, 'Wu05',charsize=1.5
    xyouts,2.1,-0.2, 'K98',charsize=1.5


    xyouts,3.7,-2.5, 'This work',charsize=1.5;,color=cgcolor('red')
    xyouts,3.7,-2.3, 'c2D project',charsize=1.5;,color=cgcolor('red')
    plotsym,0,1,/fill
    cgoplot,[3.65],[-2.25],psym=8
    plotsym,3,1.5,/fill
    cgoplot,[3.65],[-2.45],psym=8,color=cgcolor('red') 

    if keyword_set(PS) then begin
      ps_end,/png
      pdfname=file_basename(ps,'.eps')
      spawn,'ps2pdf '+ps+' '+conf.pspath+pdfname+'.pdf'
    endif
    resetplt,/all
    !p.multi=0

END