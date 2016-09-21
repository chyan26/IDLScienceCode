pro sn_model,n0,s0,alpha,beta,s,n

s=(findgen(1000)+1)/10
n=(1/(((s/s0)^alpha)+((s/s0)^beta)))*(n0/s0)

;plot,s,n,/xlog,/ylog,xrange=[0.1,30],xstyle=1,yrange=[1,n0],ystyle=1

return

end
