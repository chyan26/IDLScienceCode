

PRO EXTINCTIONLAW, cat
  ind=where(cat.mj ge -100 and cat.mh ge -100 and cat.mj ge -100 $
    and cat.i1mag ge -100 and cat.i2mag ge -100 and cat.i3mag ge -100 $
    and cat.i4mag ge -100) 

  
  av1=cat.mj[ind]-cat.mh[ind]
  av2=cat.mh[ind]-cat.mk[ind]
  av3=cat.i1mag[ind]-cat.i2mag[ind]
  av4=cat.i2mag[ind]-cat.i3mag[ind]
  av5=cat.i3mag[ind]-cat.i4mag[ind]
  plot,[av1[0],av2[0],av3[0],av4[0],av5[0]],psym=4
  for i=0,n_elements(ind)-1 do begin
    oplot,[av1[i],av2[i],av3[i],av4[i],av5[i]],psym=4
  endfor
END