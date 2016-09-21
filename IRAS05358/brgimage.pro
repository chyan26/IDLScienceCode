

PRO BRGIMAGE
  COMMON share,imgpath, mappath
  loadconfig
  
  im1=readfits(imgpath+'s233ir_brg.fits',hd1)
  im2=readfits(imgpath+'s233ir_kcont.fits',hd2)
  
  
  hastrom, im2,hd2,tim2,thd2,hd1
  print,median(im1),median(im2),median(im1)/median(tim2)
  
  f1=median(im1)
  f2=median(tim2)
  print,f1/f2
  im=(im1/f1)-(tim2/f2)
  writefits,imgpath+'linebrg.fits',im

END