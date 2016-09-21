function ut2julday, datestring, to_ut=to_ut

; May 2006 - Loic Albert
;  First version
; January 5 2007 - Loic Albert
;  Added the possibility to convert from HST time to julday
; March 16 2007 - Loic Albert
;  Bug fixed. Add a 10 hour offset from HST to UT before computing julian date.
;  Doubled checked that julday behaves correctly if hour > 24.
; May 15 2007 - Loic Albert
;  Allow deciding to output in real UT julian days with to_ut keyword even if input is HST
; July 26 2007 - Loic Albert
;  Added a check for NULL entries.

nstrings = n_elements(datestring)
jd = dblarr(nstrings)

for i=0, nstrings-1 do begin
   ;Check for a NULL entry
   if stregex(datestring[i],'(NULL)',/boolean,/fold_case) eq 1 then begin
      ;print, 'NULL entry'
      jd[i] = !values.f_nan
      continue
   endif
   ;Test whether the string represents a UT or HST date/time
   if stregex(datestring[i],'(HST)',/boolean,/fold_case) eq 1 then begin
      ;print, 'HST'
      bits = strsplit(datestring[i],'HST',/extract)
      hours_to_ut = 10.0
   endif else begin
      ;print, 'T'
      bits = strsplit(datestring[i],'T',/extract)
      hours_to_ut = 0.0
   endelse
   datebit = bits[0]
   timebit = bits[1]
   bits = strsplit(datebit,'-',/extract)
   year = bits[0]
   month = bits[1]
   day = bits[2]
   bits = strsplit(timebit,':',/extract)
   hour = bits[0] 
   minute = bits[1]
   second = bits[2]
   ;Apply hour offset
   if keyword_set(to_ut) then begin
      hour = hour + hours_to_ut
   endif else begin
      ;don't do it, cause some prog need it to behave as if there 
      ;was such a thing as a HST julian day
   endelse
   jd[i] = julday(month,day,year,hour,minute,second)  ;returns a double
endfor

if nstrings eq 1 then begin
   return , jd[0]
endif else begin
   return , jd
endelse


end

