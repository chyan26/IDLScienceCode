

FUNCTION phertz2pmicron, micron
   
   ;c=double(299792458.00)
   c=double(2.9979245800e10)
   con=(c/(micron*1e-4))

   return,con
END





