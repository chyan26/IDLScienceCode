@stat

COMMON share,conf
loadconfig

file=conf.fitspath+'rho_new_yso_final_130515.fits'
newfits=conf.fitspath+'rho_new_yso_final_slop_131219.fits'


;PRO WRITESLOPEINFITS,fits=fits,newfits=newfits
;
;    data=mrdfits(fits,1)
;    data2=mrdfits(fits,2)
;    
;    ; Check how many flux points are loaded
;    ndata=n_elements(data[0].flux)
;    nu=fltarr(ndata)
;    
;    ; Go through the header to get the flux
;    mhd=headfits(file,ext=1)
;    for i=0,ndata-1 do begin
;      string='WAV'+strcompress(string(i+1),/remove)
;      nu[i]=sxpar(mhd,string)
;    endfor
;    
;    
;    A = {SOURCE_NAME:'', X:0.0, Y:30., SOURE_ID:40., FIRST_ROW:0,NUMBER_FITS: 1,VALID: fltarr(8), $
;         FLUX:  fltarr(8),FLUX_ERROR:  fltarr(8),LOG10FLUX:  fltarr(8),LOG10FLUX_ERROR:  fltarr(8), alpha:0.0}
;    
;    newdata = REPLICATE(A, n_elements(data.(0)))
;    
;    for i=0,n_elements(data.(0))-1 do begin
;        
;        for j=0,n_tags(data)-1 do begin
;            newdata[i].(j)=data[i].(j)     
;        endfor
;        
;        nu_fnu=data[i].flux*1e-26*phertz2pmicron(nu)
;        error=data[i].flux_error*1e-26*phertz2pmicron(nu)
;        ind=where(data[i].flux ge 0 and nu ge 2.0 and nu lt 25)
;        bands=nu[ind]
;        fluxdensity=nu_fnu[ind]
;        
;        coef=linfit(alog10(bands),alog10(fluxdensity),sigma=sigma,yfit=yfit)
;        ;
;        ;plot,bands,fluxdensity,/xlog,/ylog,psym=4
;        ;       oplot,bands,10^yfit,color=255
;        ;print,yfit
;        ;
;        
;        newdata[i].(11)=coef[1]
;        print,'------------------'
;        ;       ;print,table[i].flux
;        ;       ;print,table[i].flux[ind]*1e-26*phertz2pmicron(v[ind])
;        ;       print,nu,nu_fnu
;        
;        ;print,ysoid[i],ysoalpha[i]
;        print,strcompress(string(data[i].source_name),/remove),coef[1]
;    endfor
;    
;    mwrfits,newdata, newfits,mhd,/Silent
;    mwrfits,data2,newfits,/Silent
;
;end