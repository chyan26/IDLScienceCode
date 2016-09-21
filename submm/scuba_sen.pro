;FUNCTION SCUBA_SEN, T, ds
	;T is observing time
	
	t=findgen(1000)
	nefd=90
	ds=4*nefd/sqrt(t)
	plot,t,ds,/xlog,/ylog
end
