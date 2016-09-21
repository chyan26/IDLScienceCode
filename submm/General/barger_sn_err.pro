PRO BARGER_SN_ERR


;n0=20428.0
;a=1.033
;alpha=2.25

n0=3d4
a=0
alpha=3.2


dn=4750
da=0.54
dalpha=0.14

s=series(2.0,10,2000)
n=barger_sn(n0,a,alpha,s)

SN_ERR,n0,a,alpha,s,dn,da,dalpha,nerr
plot,s,n,/xlog,/ylog
oplot,s,n+nerr
oplot,s,n-nerr

sma_constrain_sky1,1000,30,cs,cn,cerr,a,err

nn=barger_sn(a[0],a[1],a[2],s)
SN_ERR,a[0],a[1],a[2],s,err[0],err[1],err[2],nnerr

plots,cs,cn,psym=4
errplot,cs,cn+cerr,cn-cerr
 
oplot,s,nn,line=2
oplot,s,nn+nnerr,line=2
oplot,s,nn-nnerr,line=2
 
END
 
PRO SN_ERR,n0,a,alpha,s,dn,da,dalpha,nerr
 
pn=1/(a+s^alpha)
pa=-n0*(pn^2)
palpha=-n0*(s^alpha)*alog(s)*(pn^2)
 
nerr=sqrt(pn^2*dn^2+pa^2*da^2+palpha^2*dalpha^2)
 
end
 
PRO sma_constrain_sky1,total_t,obs_t,ss,no,err,parameter,error
 
        epf=3
        sig=3.0
        obs_t=obs_t
        total_t=total_t
 

        s=series(0.01,10,2000)
        n=barger_sn(20284.0,1.033,2.2486,s)
 
        field=total_t/obs_t
        factor=field*0.36/3600
 
        ds=sma_sen(400,obs_t)
        no=interpol(n,s,sig*ds(1))
 
        nd=no*factor
 
        err=epf*sqrt(nd)/factor
 
        ss=sig*ds(1)
 

        raw=read_ascii('/home/chyan/Scuba_count/scuba_complete_data.old')
        xx=reform(raw.field1(0,*))
        yy=reform(raw.field1(1,*))
        weight=fltarr(n_elements(raw.field1(0,*)))
        weight(*)=(1/((raw.field1(2,*)+raw.field1(3,*))/2))^2
 
        x=fltarr(n_elements(xx)+1)
        x(0:n_elements(x)-2)=xx
        x[n_elements(x)-1]=ss
 
        y=fltarr(n_elements(yy)+1)
        y(0:n_elements(y)-2)=yy
        y[n_elements(y)-1]=no
 
        w=fltarr(n_elements(weight)+1)
        w(0:n_elements(w)-2)=weight
        w[n_elements(w)-1]=1/(err)
 

        ;plot,xx,yy,/xlog,/ylog,psym=4  ;
        ;errplot,xx,yy+raw.field1(2,*),yy-raw.field1(3,*)
        ;plots,ss,no,psym=4
        ;errplot,ss,no+(err/factor),no-(err/factor)
 

        a=[3d4,0.0,2.5]
 


        rr=curvefit(x,y,w,a,sigma,function_name='barger_fit')
 
        parameter=a
        error=sigma
 

end
 

pro barger_fit,x,a,f,pder
        bx=1/(a[1]+x^a[2])
        f=a[0]*(bx)
        if n_params() ge 4 then $
                pder =[[bx],[-a[0]*(bx^2)],[-a[0]*(x^a[2])*alog(x)*(bx^2)]]
end
