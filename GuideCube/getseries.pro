FUNCTION GETSERIES, first, last, step
  total=(last-first)/step+1
  
  return,(findgen(total))*step+first
END
