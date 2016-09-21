fits='/asiaa/home/chyan/RhoOph/OphA_ExtnCambR_F.fits'
file='/asiaa/home/chyan/RhoOph/rho_oph.txt'

readcol,file,id,pi,sra,sdec,filter,format='(a,a,a,a,a)'

im=readfits(fits)
hd=headfits(fits)
im=max(im)-im
hextract, im, hd, newim, newhd, 150, 314, 150, 290, SILENT = silent

xim=sxpar(newhd,'NAXIS1')
yim=sxpar(newhd,'NAXIS2')
xyad,newhd,0,0,a0,d0
xyad,newhd,xim,yim,a1,d1

set_plot,'ps'
device,filename='/asiaa/home/chyan/RhoOph/rhoOph_spitzer.eps',/color
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

spawn,'ls /arrays/cfht/cfht_3/wircam/MIPS/MIPS24',result

for i=0, n_elements(result)-1 do begin
	shd=headfits('/arrays/cfht/cfht_3/wircam/MIPS/MIPS24/'+result[i])
	ra=sxpar(shd,'CRVAL1')
	dec=sxpar(shd,'CRVAL2')
	size=sxpar(shd,'NAXIS1')*sxpar(shd,'CDELT2')
	oplotbox,ra-size/2,ra+size/2,dec-size/2,dec+size/2,color=3
	xyouts,ra,dec,i+1,color=1
endfor

; for i=0,n_elements(sra)-1 do begin
;         ra[i]=stringad(sra[i])*15
;         dec[i]=stringad(sdec[i])
;         result=strcmp(pi[i],'Lyo',3,/fold_case)
;         if result eq 1 then bcolor=3 else bcolor=2
;         oplotbox,ra[i]-0.2,ra[i]+0.2,dec[i]-0.2,dec[i]+0.2,color=bcolor
;         ;wait,2
; endfor

reg1=[stringad('16:33:01')*15,stringad('-24:26:47')]
reg2=[stringad('16:26:41')*15,stringad('-24:28:27')]
;reg3=[stringad('16:24:31')*15,stringad('-23:31:11')]
;reg4=[stringad('16:31:32')*15,stringad('-24:26:33')]

oplotbox,reg1[0]-0.5,reg1[0]+0.5,reg1[1]-0.5,reg1[1]+0.5,color=1
oplotbox,reg2[0]-0.5,reg2[0]+0.5,reg2[1]-0.5,reg2[1]+0.5,color=1
; oplotbox,reg3[0]-0.5,reg3[0]+0.5,reg3[1]-0.5,reg3[1]+0.5,color=1
; oplotbox,reg4[0]-0.5,reg4[0]+0.5,reg4[1]-0.5,reg4[1]+0.5,color=1
xyouts,reg1[0],reg1[1],'Rho Oph1',color=1
xyouts,reg2[0],reg2[1],'Rho Oph2',color=1
; xyouts,reg3[0],reg3[1],'Rho Oph3',color=1
; xyouts,reg4[0],reg4[1],'Rho Oph4',color=1

device,/close
end
