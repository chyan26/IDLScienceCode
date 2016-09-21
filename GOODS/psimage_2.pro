pro	psimage_2, idlist_in
;;pro	psimage, cat_in, idlist_in
;Main program to generate multiwavelength images for certain objects
;Note: in this special case which is the K-selected catalog, K-band ID are same as the 
;	sequence number of objects in the .fits table => array index = id-1

;DESCRIPTION:
;;	cat_in: the fits table of input catalog	;no longer necessary
;	idlist_in: a list of WIRCAM K-band ID which are desired to be extracted


;Lihwai
;04/10/2008
;11/11/2010
;use 'extractimage_wircamradec_2.pro'

close, /all


openr, 1, idlist_in
num_obj = numlines(idlist_in)
data_list = dblarr(1,num_obj)
readf, 1, data_list
close, 1
print, 'total number of objects in the ID list is ', num_obj


;----------------------------------------------------------------------------------------- 
;no need to do the following steps since the K-object ID = the sequence of the objects 
;----------------------------------------------------------------------------------------- 
;;data_in = mrdfits(cat_in,1,hd) 
;;nl = n_elements(data_in) 
;;print, 'total number of objects in the input catalog is ', nl

;;for i = 0L, num_obj-1L, 1L do begin
;;	w = where(data_in.wircam_k_id eq data_list[i], num_match)
;;	if (num_match ne 1) then begin
;;		print, 'false match for ID = ', data_list[i]
;;	endif
;;	print, 'w = ', w
;;	if (w ne (data_list[i]-1)) then begin
;;		print, 'false match for ID = ', data_list[i]
;;	endif
;;endfor	;end i


extractimage_wircamradec_2, data_list

end
