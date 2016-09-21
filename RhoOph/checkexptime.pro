
COMMON share,conf
loadconfig

runid_array=['06AT08','06AF01','07AT08','07AT97','08AH14','12AT09','12AT99']

for rr=0, n_elements(runid_array)-1 do begin

runid=runid_array[rr]
path='/arrays/spica/wircam/processed/'


spawn,'ls '+path+runid,result

print,runid

for i=0,n_elements(result)-1 do begin
  spawn,'ls '+path+runid+'/'+result[i]+'/*p.fits', plist
  
  for p=0,n_elements(plist)-1 do begin
    ;print,plist[p]
    hd=headfits(plist[p])
    etime=sxpar(hd,'EXPTIME')
    if p eq 0 then obst=etime else obst=obst+etime
  endfor
  print,result[i],obst/60.0

endfor

endfor





END