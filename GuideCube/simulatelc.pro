
@checkheader
@dpattern
@getseries
@integration
PRO LOADCONFIG
  COMMON share,conf
  
  ;Settings for HOME computer
  ;imgpath = '/Volumes/disk1s1/Projects/S233IR/'
  ;mappath = '/Volumes/disk1s1/Projects/S233IR/'
  
  ;Settings for ASIAA computer
  ;path='/Volumes/Data/Projects/S233IR/'
  
  r     =  0.5  ; km
  a     = 40.0 ; AU
  au2km = 149598000.0d
  nm2km = 1d-12
  ve    = 29.8
  phi   = 0
  ve    = 29.8
  ae    = 1
  vt    = ve*(cos(phi)-sqrt((ae/a)*(1-((ae/a)^2)*sin(phi)^2)))
  gexp  = 50 ; Hz
  b     = 0.25 
  
    
  conf={r:r,a:a,au2km:au2km,nm2km:nm2km,phi:phi,vt:vt,gexp:gexp,b:b}
  
  
END

PRO SIMULATELC, ps=ps
   path='/Users/chyan/idl_script/Projects/KBO/'
   !p.multi=[0,1,2]
   if keyword_set(PS) then begin 
      set_plot,'ps'
      device,filename=path+'figure.eps',$
         /color,xsize=20,ysize=30,xoffset=0.4,yoffset=10,$
         SET_FONT='Helvetica Bold',/TT_FONT,/encapsulated
         
      tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
      red=1
      green=2
      blue=3
   endif else begin
     blue=65535
      red=255
      green=32768    
   endelse

  file='1044275g.fits'
  checkheader,path+file,hd,guide
  filterpass,hd,guide,nm, tr
  int_filterpass,nm,tr,xx,cv
  int_stellardisk,xx,cv,guide[0].theta,newcu               
  sampletime,xx,newcu,xt,data
  addnoise,1200.0,30.0,data,ndata
  plot,xt,data,ytitle='Intensity',xtitle='Time (second)',psym=10,font=1$
    ,charsize=1.5,thick=5,xthick=5,ythick=5
  plot,xt,ndata,ytitle='ADU levels',xtitle='Time (second)',psym=10,font=1$
    ,charsize=1.5,thick=5,xthick=5,ythick=5
  !p.multi=0
  if keyword_set(PS) then begin
    device,/close
    set_plot,'x'
  endif
  
  
END