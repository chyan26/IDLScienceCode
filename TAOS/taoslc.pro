
set_plot,'ps'
file='/arrays/cfht_2/chyan/TAOS/00022.1274-00316-1.A'

readcol,file,format='(f,f,f,f,d,f,f)',id,ma,mb,mc,flag,x,y
;device,filename='/asiaa/home/chyan/2.ps'
;plot,sn,fc,psym=4,xtitle='S/N ratio',ytitle='Factor',title='060103'
;device,/close

set_plot,'x'

end