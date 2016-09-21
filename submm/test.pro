
micron=series(0.01,1000.0,1000)
nu=3d5/micron

sed=newstarburst_sed3(micron,/arp220)
plot,micron,sed,/xlog,/ylog
print,int_tabulated(micron,4.0d45*sed/micron)

l=4d45*sed/nu

end
