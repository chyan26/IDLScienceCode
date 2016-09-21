fits='/asiaa/home/chyan/RhoOph/OphA_ExtnCambR_F.fits'
file='/asiaa/home/chyan/RhoOph/rho_oph.txt'

readcol,file,id,pi,sra,sdec,filter,format='(a,a,a,a,a)',comment='#'

im=readfits(fits)
hd=headfits(fits)
im=max(im)-im
hextract, im, hd, newim, newhd, 150, 314, 150, 290, SILENT = silent

xim=sxpar(newhd,'NAXIS1')
yim=sxpar(newhd,'NAXIS2')
xyad,newhd,0,0,a0,d0
xyad,newhd,xim,yim,a1,d1

set_plot,'ps'
device,filename='/asiaa/home/chyan/RhoOph/rhoOph.eps',/color
tvlct,[0,255,0,0,255,255],[0,0,255,0,255,255],[0,0,0,255,255,0]


resetplt,/all
print,!D.n_colors-2
!x.range=[a0,a1]
!y.range=[d0,d1]
th_image_cont,newim,/nocont,/nobar,crange=[1,8]
;resetplt,/all
; window,1
;
ra=fltarr(n_elements(sra))
dec=fltarr(n_elements(sra))


for i=0,n_elements(sra)-1 do begin
	ra[i]=stringad(sra[i])*15
	dec[i]=stringad(sdec[i])
; 	;result=strcmp(pi[i],'Lyo',3,/fold_case)
; 	if strcmp(id[i],'06AT08',6,/fold_case) eq 1 then  begin 
; 		bcolor=3 
; 		oplotbox,ra[i]-0.2,ra[i]+0.2,dec[i]-0.2,dec[i]+0.2,color=bcolor
; 	endif 
; 
; 	if strcmp(id[i],'07AT08',6,/fold_case) eq 1 then  begin 
; 		bcolor=2 
; 		oplotbox,ra[i]-0.2,ra[i]+0.2,dec[i]-0.2,dec[i]+0.2,color=bcolor
; 	endif 
; 	
; ; 	if 
; ; 		bcolor=2
; ; 		oplotbox,ra[i]-0.2,ra[i]+0.2,dec[i]-0.2,dec[i]+0.2,color=bcolor

endfor

oplotbox,min(ra)-0.2,max(ra)+0.2,min(dec)-0.2,max(dec)+0.2,color=3



reg1=[stringad('16:27:01')*15,stringad('-24:26:47')]
reg2=[stringad('16:30:41')*15,stringad('-23:48:27')]
reg3=[stringad('16:34:31')*15,stringad('-23:31:11')]
reg4=[stringad('16:31:32')*15,stringad('-24:26:33')]

oplotbox,reg1[0]-0.5,reg1[0]+0.5,reg1[1]-0.5,reg1[1]+0.5,color=1
oplotbox,reg2[0]-0.5,reg2[0]+0.5,reg2[1]-0.5,reg2[1]+0.5,color=1
oplotbox,reg3[0]-0.5,reg3[0]+0.5,reg3[1]-0.5,reg3[1]+0.5,color=1
oplotbox,reg4[0]-0.5,reg4[0]+0.5,reg4[1]-0.5,reg4[1]+0.5,color=1
xyouts,reg1[0],reg1[1],'Rho Oph1',color=1
xyouts,reg2[0],reg2[1],'Rho Oph2',color=1
xyouts,reg3[0],reg3[1],'Rho Oph3',color=1
xyouts,reg4[0],reg4[1],'Rho Oph4',color=1

device,/close
end
