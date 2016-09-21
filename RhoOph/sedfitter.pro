PRO CHECKGOODSTAR
   COMMON share,conf
   loadconfig

   path='/Volumes/Data/Projects/SWIRE/Catalog/'
   file='stellar_good.cat'

   readcol,path+file,format='(A30)',sid
   
   readcol,conf.catpath+'swire_n1_mag.cat',$
      format='(i4,a26,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f,f)',$
      id,name,ra,dec,mj,mjerr,mh,mherr,mk,mkerr,i1,i1err,i2,i2err,i3,i3err,i4,i4err,m1,m1err
   
   mmj=mj[sid-1]
   mmh=mh[sid-1]
   mmk=mk[sid-1]
   mi1=i1[sid-1]
   mi2=i2[sid-1]
   mi3=i3[sid-1]
   mi4=i4[sid-1]
   mm1=m1[sid-1]
   mi1=i1[sid-1]
   
   
   plot,mmk-mi2,mmk,psym=3,yrange=[20,8],xrange=[-1,14],xstyle=1,ystyle=1
END