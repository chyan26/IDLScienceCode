


	tar_fits='hcn-0.fits'
	ref_fits='cs76-sum.fits'
	
	tar_im=readfits(tar_fits,tar_hd)
	ref_im=readfits(ref_fits,ref_hd)
	
	hastrom, tar_im,tar_hd, new_im, new_hd, ref_hd
	
	writefits,'newfits.fits',new_im/ref_im,new_hd
	
	
END