;  Usage:
;	1. First, define all the INPUT fields.
;	2. Run idl
;	3. Run this program under idl prompt.
;	Note: if you change the inputs, you have to run ".rnew <this_program>"
;		  to re-compile this program.

pro dobashi
	;-------------------- Set enviroment variables-------------------
	spawn,'pwd',result
	!path=!path+':'+result+'/functions'
	;----------------------------------------------------------------
	
	;-------------------Begin of user definition--------------------
	
	; Path and file name for the dobashi region file.
	;INPUT:
	path='/Users/chyan/Documents/HandBook/dobashi/'  	
	
	;INPUT:
	file='region5.fits'
	
	; Define the path and name of the PS file 
	;INPUT"
	eps='/Users/chyan/Documents/HandBook/gemini/region5.eps'
	
	; Define the number of total objects
	;INPUT:
	obj_number=13
	reg_number=3
	
	;--------do not modify----------------
	obj={name:'',l:0.0,b:0.0}
	obj=replicate(obj,obj_number+1)
	
	reg={name:'',l:0.0,b:0.0,w:0.0,h:0.0}
	reg=replicate(reg,reg_number+1)
	;--------end of do not modify---------
	
	; Define the object information
	;INPUT:
	obj[1]={name:'CB 34',l:186.955,b:-3.840}
	obj[2]={name:'GGD 4',l:183.722,b:-3.662}
;	obj[3]={name:'GEM OB1',l:189.100,b:+1.04}
;	obj[4]={name:'AUR OB1',l:173.4643,b:+03.2435}
;	obj[5]={name:'AUR OB2',l:173.0,b:1.00}
	obj[3]={name:'NGC 2129',l:186.60,b:+00.14}
	obj[4]={name:'IC 2144',l:184.90,b:-01.73}
	obj[5]={name:'AFGL 5157',l:176.5167,b:+00.1819}
	obj[6]={name:'AFGL 5142',l:174.1964,b:-00.0765}
	obj[7]={name:'CB 39',l:192.623,b:-3.038}
	obj[8]={name:'Sh 2-235',l:173.7224,b:+2.6945}
	obj[9]={name:'RR Tau',l:181.5,b:-02.5}
	obj[10]={name:'AFGL 5144',l:173.8970,b:+00.2883} 
	obj[11]={name:'NGC 1931',l:173.8970,b:+00.2883 } 
	obj[12]={name:'LkHa 208',l:191.4341,b:-00.7807 } 
	obj[13]={name:'SH 2-234',l:173.32,b:-00.28 } 
	
	reg[1]={name:'GEM OB1',l:189.1,b:+1.0,w:4.0,h:6.0}
	reg[2]={name:'AUR OB2',l:173.0,b:+1.0,w:2.0,h:4.0}
	reg[3]={name:'AUR OB1',l:174.0,b:-1.5,w:7.8,h:11.0}
	; Define the ploting region
	; INPUT
	pt1=[170,-10]
	pt2=[195,10]
	
	; Define the color contrast
	;INPUT:
	crange=[-14,5.5]
	
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
	
	hd=headfits(path+file)
	im=readfits(path+file)
	extast,hd,astro
		
	
	ad2xy,pt2[0],pt1[1],astro,x0,y0
	ad2xy,pt2[0],pt2[1],astro,x1,y1
	ad2xy,pt1[0],pt1[1],astro,x2,y2
	ad2xy,pt1[0],pt2[1],astro,x3,y3
	
	print,max(im),min(im)
	set_plot,'ps'
	device,/color,filename=eps,/encapsulated,$
	xsize=abs(pt1[0]-pt2[0]),ysize=abs(pt1[1]-pt2[1]),$
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
	
	for i=1,reg_number do begin
		oplotbox,reg[i].l-reg[i].w/2,reg[i].l+reg[i].w/2,$
			reg[i].b-reg[i].h/2,reg[i].b+reg[i].h/2,color=reg_color,$
			line=reg_line, thick=5
	endfor
	
	device,/close
	set_plot,'x'

END
