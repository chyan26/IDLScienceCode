FUNCTION LOADFITSTABLE, fits

   COMMON share,conf
   loadconfig
   
   if strcmp(!VERSION.OS,'linux') then begin 
      modelpath='/data/capella/chyan/Models/models_r06/seds/'
   endif else begin
      modelpath='/Volumes/Data/Models/models_r06/seds/'
   endelse

   ; Read information in SED produced FITS files
   tab1=mrdfits(fits,1,mhd,/Silent)
   tab2=mrdfits(fits,2,/Silent)
   tab3=mrdfits(fits,3,/Silent,status=status)
   if status ne 0 then begin
      thres=fltarr(n_elements(tab1.source_name))
      thres[*]=-1
      data={hd:mhd,yso:tab1,ysop:tab2, thres:thres}
   endif else begin
      data={hd:mhd,yso:tab1,ysop:tab2, thres:tab3}
   endelse
   
   
   return,data
END

PRO GOFILTERING
   COMMON sed,sedinfo,data
   COMMON share,conf
   loadconfig

   newfits=sedinfo.outfile 
   ii=where(sedinfo.thres ge 0.5)
   newtab1=data.yso[ii]
   
   k=0
   for i=0,n_elements(newtab1.source_name)-1 do begin
      ind=where(data.ysop[*].source_id eq newtab1[i].soure_id, count)
      if count ne 0 then begin 
      
         if k eq 0 then begin
            newtab2=data.ysop[ind]
            k=1      
         endif else begin
            newtab2=[newtab2,data.ysop[ind]]
         endelse
      endif    
   end

   if file_test(newfits) then spawn,'rm -rf '+newfits
   mwrfits,newtab1, newfits,data.hd,/Silent
   mwrfits,newtab2,newfits,/Silent
    

END

PRO DUMPBINARY, FILENAME=filename
   COMMON sed,sedinfo,data
   COMMON share,conf
   loadconfig

   newfits=filename 
   ii=where(sedinfo.binary eq 1)
   newtab1=data.yso[ii]
   
   k=0
   for i=0,n_elements(newtab1.source_name)-1 do begin
      ind=where(data.ysop[*].source_id eq newtab1[i].soure_id, count)
      if count ne 0 then begin 
      
         if k eq 0 then begin
            newtab2=data.ysop[ind]
            k=1      
         endif else begin
            newtab2=[newtab2,data.ysop[ind]]
         endelse
      endif    
   end

   if file_test(newfits) then spawn,'rm -rf '+newfits
   mwrfits,newtab1, newfits,data.hd,/Silent
   mwrfits,newtab2,newfits,/Silent
    

END

PRO SAVESED
   COMMON sed,sedinfo,data
   COMMON share,conf
   loadconfig

   newfits=sedinfo.outfile 
   
   data.thres = sedinfo.thres
   
   if file_test(newfits) then begin
      spawn,'rm -rf '+newfits
   
   endif
   mwrfits,data.yso, newfits,data.hd,/Silent
   mwrfits,data.ysop,newfits,/Silent
   mwrfits,data.thres,newfits,/Silent
    

END


PRO warning_event, event
   WIDGET_CONTROL, event.id, GET_UVALUE = eventval
 
  CASE eventval OF
     'OK_button'  : WIDGET_CONTROL, event.top, /DESTROY ;The 'Done' button has been
                ;selected, so destroy the widget.
  ENDCASE


END


PRO simple_gui_event, event 
   COMMON sed,sedinfo,data
   COMMON share,conf
   loadconfig
   
   widget_control, event.id, get_uvalue=eventval
   CASE eventval OF
      'Multiplicity':$
      	case event.value of
      		0: begin
      			;print,'Multiple'
      			xyouts,400,720,'Binary',color=0,/device,font=1,charsize=2.0
      			sedinfo.binary[sedinfo.current]=1
      			;print,sedinfo.binary[sedinfo.current]
      		end
      		1: begin
      			displaysed,sedinfo.current  
					sedinfo.binary[sedinfo.current]=0
      		end
      		2: begin
      			;print,'Dump'
      			filename = DIALOG_PICKFILE(PATH=conf.fitspath,TITLE="Select or specify a PS file for output.")
      			dumpbinary, filename=filename
      		end
      	endcase	
      'Selection': $
         case event.value of
            0:  begin
                sedinfo.thres[sedinfo.current]=1.0
                if sedinfo.current lt sedinfo.maxi then begin
                   sedinfo.current=sedinfo.current+1
                   displaysed,sedinfo.current   
                                    
                endif else begin
                   warnbox = widget_base(title='Warning',XSIZE = 200,/column)
                   label1 = WIDGET_LABEL(warnbox, $    ;This widget belongs to 'base'.
                      VALUE = 'This is the end of SED')
                   bbase = widget_base(warnbox)
                   OK_button = widget_button(bbase, $
                                       value = 'OK', $
                                       uvalue = 'OK_button',xsize=50,xoffset=90,unit=0)
                   widget_control, warnbox, /realize 
                   xmanager, 'warning', warnbox 
                   print,"No more SED."
                endelse
            end
            1:  begin
                ;print,'Possible'
                sedinfo.thres[sedinfo.current]=0.75
                if sedinfo.current lt sedinfo.maxi then begin
                   sedinfo.current=sedinfo.current+1
                   displaysed,sedinfo.current   
                    
                endif else begin
                   warnbox = widget_base(title='Warning',XSIZE = 200,/column)
                   label1 = WIDGET_LABEL(warnbox, $    ;This widget belongs to 'base'.
                      VALUE = 'This is the end of SED')
                   bbase = widget_base(warnbox)
                   OK_button = widget_button(bbase, $
                                       value = 'OK', $
                                       uvalue = 'OK_button',xsize=50,xoffset=90,unit=0)
                    widget_control, warnbox, /realize 
                    xmanager, 'warning', warnbox 
                     print,"No more SED."
                endelse
            end
            2:  begin
                ;print,'Neutral'
                sedinfo.thres[sedinfo.current]=0.5
                if sedinfo.current lt sedinfo.maxi then begin
                   sedinfo.current=sedinfo.current+1
                   displaysed,sedinfo.current      
                    
                endif else begin
                   warnbox = widget_base(title='Warning',XSIZE = 200,/column)
                   label1 = WIDGET_LABEL(warnbox, $    ;This widget belongs to 'base'.
                      VALUE = 'This is the end of SED')
                   bbase = widget_base(warnbox)
                   OK_button = widget_button(bbase, $
                                       value = 'OK', $
                                       uvalue = 'OK_button',xsize=50,xoffset=90,unit=0)
                    widget_control, warnbox, /realize 
                    xmanager, 'warning', warnbox 
                     print,"No more SED."
                endelse
            end
            3:  begin
                ;print,'Maybe Not'
                sedinfo.thres[sedinfo.current]=0.25
               if sedinfo.current lt sedinfo.maxi then begin
                   sedinfo.current=sedinfo.current+1
                   displaysed,sedinfo.current   
                    
                endif else begin
                   warnbox = widget_base(title='Warning',XSIZE = 200,/column)
                   label1 = WIDGET_LABEL(warnbox, $    ;This widget belongs to 'base'.
                      VALUE = 'This is the end of SED')
                   bbase = widget_base(warnbox)
                   OK_button = widget_button(bbase, $
                                       value = 'OK', $
                                       uvalue = 'OK_button',xsize=50,xoffset=90,unit=0)
                   widget_control, warnbox, /realize 
                   xmanager, 'warning', warnbox 
                   print,"No more SED."
                endelse
            end
            4:  begin
                ;print,'Definitely Not'
                sedinfo.thres[sedinfo.current]=0.0
                if sedinfo.current lt sedinfo.maxi then begin
                   sedinfo.current=sedinfo.current+1
                   displaysed,sedinfo.current   
                    
                endif else begin
                   warnbox = widget_base(title='Warning',XSIZE = 200,/column)
                   label1 = WIDGET_LABEL(warnbox, $    ;This widget belongs to 'base'.
                      VALUE = 'This is the end of SED')
                   bbase = widget_base(warnbox)
                   OK_button = widget_button(bbase, $
                                       value = 'OK', $
                                       uvalue = 'OK_button',xsize=50,xoffset=80,unit=0)
                    widget_control, warnbox, /realize 
                    xmanager, 'warning', warnbox 
                     print,"No more SED."
                endelse
            end  
         endcase
      'Previous_button' : begin
         if sedinfo.current ne 0 then begin
             sedinfo.current=sedinfo.current-1
             displaysed,sedinfo.current   
           
         endif else begin
             warnbox = widget_base(title='Warning',XSIZE = 200,/column)
             label1 = WIDGET_LABEL(warnbox, $    ;This widget belongs to 'base'.
                VALUE = 'This is the beggin of SED')
             bbase = widget_base(warnbox)
             OK_button = widget_button(bbase, $
                                 value = 'OK', $
                                 uvalue = 'OK_button',xsize=50,xoffset=80,unit=0)
              widget_control, warnbox, /realize 
              xmanager, 'warning', warnbox 
             print,"No more SED."
         endelse
         
                  
      end
      'Next_button' : begin              
         if sedinfo.current lt sedinfo.maxi then begin
             sedinfo.current=sedinfo.current+1
             displaysed,sedinfo.current   
              
          endif else begin
             warnbox = widget_base(title='Warning',XSIZE = 200,/column)
             label1 = WIDGET_LABEL(warnbox, $    ;This widget belongs to 'base'.
                VALUE = 'This is the end of SED')
             bbase = widget_base(warnbox)
             OK_button = widget_button(bbase, $
                                 value = 'OK', $
                                 uvalue = 'OK_button',xsize=50,xoffset=80,unit=0)
              widget_control, warnbox, /realize 
              xmanager, 'warning', warnbox 
              print,"No more SED."
          endelse
                  
      end
              
      'Reset_button' : begin 
          sedinfo.current=0
          displaysed,sedinfo.current
              
      end
      'Filter_button' : begin 
          ;print,sedinfo.thres
          file = DIALOG_PICKFILE(PATH=conf.fitspath,TITLE="Select or specify a FITS file for output.")        
          if file ne '' then begin
              sedinfo.outfile=file
              GOFILTERING
          endif
      end
      'Save_button' : begin 
          file = DIALOG_PICKFILE(PATH=conf.path,TITLE="Select or specify a FITS file for saving.")
          if file ne '' then begin
              sedinfo.outfile=file
              savesed
          endif
      end
      'Exit_button'  : WIDGET_CONTROL, event.top, /DESTROY ;The 'Done' button has been
                  ;selected, so destroy the widget.
   ENDCASE

END

PRO INITSEDINFO
   COMMON sed,sedinfo,data 
  
   
   
   maxi=n_elements(data.yso)-1
   binary=intarr(n_elements(data.yso))
   source=data.yso[*].source_name 
   thres=data.thres[*]
   
   ; Determine the beginning SED.
   ind=where(thres le 0, count)
   if (count ge 0) and (count le n_elements(data.yso)) then begin
      current=ind[0]
   endif else begin
      current=0
   endelse
   
   outfile=''
   
   sedinfo={current:current,maxi:maxi,source:source,thres:thres,outfile:outfile,binary:binary}
  
END

PRO DISPLAYSED, N
    COMMON sed,sedinfo,data 
    COMMON share,conf 
    loadconfig
 
    newstring=strmid(data.yso[n].source_name,7,16)
    file=conf.imagepath+'SSTc2d_'+newstring+'.jpg'
    read_jpeg, file, image,/grayscale
 
    device, decomposed=1
    tv,image[40:570,40:841]
    ind=where(data.ysop[*].source_id eq data.yso[n].soure_id, count)
    if count ge 0 then chivalue=min(data.ysop[ind].chi2)/total(data.yso[n].valid) else chivalue=-99.0
    chi = '!9' + String("143B) + '!X'
    xyouts,80,370,chi+'!E2 !N!X (CPD)='+string(chivalue,format='(f7.3)'),$
        color=0,/device,font=1,charsize=2.5
    xyouts,80,720,'N = '+strcompress(string(n+1),/remove)+'/'$
        +strcompress(string(sedinfo.maxi+1),/remove),$
        color=0,/device,font=1,charsize=2.5
    
    if sedinfo.thres[n] eq -1.0 then begin    
        xyouts,300,370,'Selection = Not decided',$
            color=0,/device,font=1,charsize=2.0
    endif    
    if sedinfo.thres[n] eq 0.0 then begin    
        xyouts,300,370,'Selection = Not',$
            color=0,/device,font=1,charsize=2.0
    endif    
    if sedinfo.thres[n] eq 0.25 then begin    
        xyouts,300,370,'Selection = Maybe not',$
            color=0,/device,font=1,charsize=2.0
    endif    
    if sedinfo.thres[n] eq 0.5 then begin    
        xyouts,300,370,'Selection = Neutral',$
            color=0,/device,font=1,charsize=2.0
    endif    
    if sedinfo.thres[n] eq 0.75 then begin    
        xyouts,300,370,'Selection = Possible',$
            color=0,/device,font=1,charsize=2.0
    endif    
    if sedinfo.thres[n] eq 1.0 then begin    
        xyouts,300,370,'Selection = Definitely',$
            color=0,/device,font=1,charsize=2.0
    endif    

END

PRO SEDIMAGEINSPECT, FITS=fits
   COMMON sed,sedinfo,data
   COMMON share,conf 
   loadconfig
   
   if file_test(fits) eq 0 then begin
      print,'File: '+fits+' is not existed.'
      return
   endif
   data=loadfitstable(fits)
   initsedinfo
   
   Widget_Control, DEFAULT_FONT='Helvetica' 
   tlb = widget_base(title='SED Image Inspection GUI',/column)
   
   subbase = widget_base(tlb)
   
   draw = widget_draw(tlb, xsize=530, ysize=780) 
   
   ysovalues=['Definitely','Possible','Neutral','Maybe Not','Definitely Not']
   bgroup_base = widget_base(tlb)
   bgroup = cw_bgroup(bgroup_base, ysovalues,label_left='  Selection '$
   ,/frame,/row,xoffset=20,uvalue = 'Selection')

   binaryvalues=['Binary','Not BS','Dump FITS']
   group_base = widget_base(tlb)
   group = cw_bgroup(group_base, binaryvalues,label_left='Multiplicity'$
   ,/frame,/row,xoffset=20,uvalue = 'Multiplicity')

   
   button_base = widget_base(tlb, column=6)
   previous_button = widget_button(button_base, $
                                 value = 'Previous', $
                                 uvalue = 'Previous_button',xsize=70,unit=0)
   next_button = widget_button(button_base, $
                              value = 'Next', $
                              uvalue = 'Next_button',/align_center,xsize=70)
   reset_button = widget_button(button_base, $
                              value = 'Resest', $
                              uvalue = 'Reset_button',/align_center,xsize=70)
   filter_button = widget_button(button_base, $
                              value = 'Filter', $
                              uvalue = 'Filter_button',/align_center,xoffset=40,xsize=70)
   save_button = widget_button(button_base, $
                              value = 'Save', $
                              uvalue = 'Save_button',/align_center,xoffset=40,xsize=70)
   exit_button = widget_button(button_base, $
                              value = 'Exit', $
                              uvalue = 'Exit_button',/align_center,xsize=70)
   
   widget_control, tlb, /realize 
   
   displaysed,sedinfo.current
   
   xmanager, 'simple_gui', tlb 

END

