;  Usage:
;	1. First, define all the INPUT fields.
;	2. Run idl
;	3. Run this program under idl prompt.
;	Note: if you change the inputs, you have to run ".rnew <this_program>"
;		  to re-compile this program.

pro sfregions
	;-------------------- Set enviroment variables-------------------
  COMMON share,conf
  loadconfig
 
	;----------------------------------------------------------------
	
	;-------------------Begin of user definition--------------------
	
	; Path and file name for the dobashi region file.
	;INPUT:
	path=conf.fitspath  	
	
	;INPUT:
	file='region5.fits'
	
	; Define the path and name of the PS file 
	;INPUT"
	eps=conf.pspath+'region5.eps'
	
	; Define the number of total objects
	;INPUT:
	obj_number=8
	hd_number=2
	
	;--------do not modify----------------
	obj={name:'',l:0.0,b:0.0}
	obj=replicate(obj,obj_number+1)
	
	hd={name:'',l:0.0,b:0.0}
	hd=replicate(hd,hd_number+1)
	;--------end of do not modify---------
	
	; Define the object information
	;INPUT:
	obj[1]={name:'Sh 2-231',l:173.48,b:+02.45}
	obj[2]={name:'Sh 2-232',l:173.48,b:+03.23}
	obj[3]={name:'Sh 2-233',l:173.55,b:+02.71}
	obj[4]={name:'SH 2-234',l:173.32,b:-00.28 }
	obj[5]={name:'Sh 2-235',l:173.72,b:+02.69}
	obj[6]={name:'NGC 1960',l:174.523,b:+01.055}
	obj[7]={name:'AFGL 5142',l:174.1964,b:-00.0765}
	obj[8]={name:'NGC 1931',l:173.8970,b:+00.2883 } 
	;obj[12]={name:'LkHa 208',l:191.4341,b:-00.7807 } 

  hd[1]={name:'HD 036483',l:172.29,b:+01.88 } 
	hd[2]={name:'HD 035619',l:173.04,b:-00.09 } 
	;hd[2]={name:'HD 037737',l:173.46,b:+03.24 } 
	 
	
	;reg[1]={name:'GEM OB1',l:189.1,b:+1.0,w:4.0,h:6.0}
	;reg[2]={name:'AUR OB2',l:173.0,b:+1.0,w:2.0,h:4.0}
	;reg[3]={name:'AUR OB1',l:174.0,b:-1.5,w:7.8,h:11.0}
	; Define the ploting region
	; INPUT
	pt1=[170,-1.5]
	pt2=[176,4.5]
	
	; Define the color contrast
	;INPUT:
	crange=[0,4.5]
	
	; Define the color of text
	;  options: 0:black, 1:red, 2:green and 3:blue
	;INPUT:
	text_color=1

	; Define the color of symbol and region
	;  options: 0:black, 1:red, 2:green and 3:blue
	;INPUT:
	psym_color=1
	reg_color=1
	
	; Define the size of text as percentage of figure width.
	;INPUT:
	text_size=0.045
	
	; Define the line style of regions
	; 0:line, 1:doted, 2:dashed, 3: dot-dashed, 4. dot-dot-dashed
	; 5:long-dashed  
	;INPUT:
	reg_line=2
	
	;---------------------End of user definition---------------------



	;!p.multi=[0,1,2]
	
	hdr=headfits(path+file)
	im=readfits(path+file)
	extast,hdr,astro
		
	
	ad2xy,pt2[0],pt1[1],astro,x0,y0
	ad2xy,pt2[0],pt2[1],astro,x1,y1
	ad2xy,pt1[0],pt1[1],astro,x2,y2
	ad2xy,pt1[0],pt2[1],astro,x3,y3
	
	print,max(im),min(im)
	set_plot,'ps'
	device,/color,filename=eps,/encapsulated,$
	xsize=20,ysize=20,$
	xoffset=0,SET_FONT='Helvetica Bold Italic', /TT_FONT,$
	Bits_Per_Pixel = 8, language_level=2
	
	!x.charsize=1.3
	!y.charsize=1.3
	!p.charthick=5.0
	!x.thick=8
	!y.thick=8
	!x.range=[pt2[0],pt1[0]]
	!y.range=[pt1[1],pt2[1]]
	;th_image_cont,im[x1:x2,y0:y1],/nocont,/nobar,crange=[-1,3],/inverse	
	;tvlct,[0,255,0,0],[0,0,255,0],[0,0,0,255]
	!x.range=[pt2[0],pt1[0]]
	!y.range=[pt1[1],pt2[1]]
	th_image_cont,im[x1:x2,y0:y1],/nocont,/nobar,ct=39,crange=crange
	
	;make a circle symbol as psym=8 to be used later
    a=findgen(17)*(!pi*2/16.)
    usersym,cos(a),sin(a),/fill,color=255
	
	for i=1,obj_number do begin
		a=findgen(17)*(!pi*2/16.)
		usersym,cos(a),sin(a),/fill,color=255
		plots,obj[i].l,obj[i].b,psym=8,color=psym_color
		a=findgen(17)*(!pi*2/16.)
		usersym,cos(a),sin(a),thick=2
		plots,obj[i].l,obj[i].b,psym=8,color=psym_color
		;xyouts,obj[i].l+0.5,obj[i].b-0.8,obj[i].name,font=6,$
		;	size=text_size*abs(pt1[0]-pt2[0]),color=text_color
	endfor 
	
	for i=1,hd_number do begin
    plotsym,3,/fill
    plots,hd[i].l,hd[i].b,psym=8,color=psym_color
 	endfor
	
	device,/close
	set_plot,'x'

END
