; This program is used to processing the Sirius image from Satako
@buildmask
@flatfield
@ut2julday
@masksource
@subsky
@correctwcs
PRO LOADCONFIG
  COMMON share,config
   
   ; Path for Capella
   path='/data/chyan/Projects/OMCIR/'
   
   ; Path for MacBook Pro  
   ;path='/Volumes/disk1s1/Projects/OMCIR/'
   
   rawpath=path+'raw/'
   detpath=path+'detrend/'
   redpath=path+'processed/'
   calibpath=path+'calib/'
   config=path+'config/'
   
   config={path:path,rawpath:rawpath,detpath:detpath,redpath:redpath,calibpath:calibpath,config:config}
END



PRO PROCESSIMG
  
  buildmask
  flatfield
  masksource

END