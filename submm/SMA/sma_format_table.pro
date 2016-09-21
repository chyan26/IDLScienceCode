PRO sma_format_table

dataset='SMA_sky1_100hr'
config=['SMA_A','SMA_B','SMA_C','SMA_D']



in_file='/scr1/'+dataset+'/Detect/'+config(0)+'/count_table'
tt=read_ascii(in_file)
data=reform(tt.field1)		

in_file='/scr1/'+dataset+'/Detect/'+config(1)+'/count_table'
tt=read_ascii(in_file)
data1=reform(tt.field1)		

in_file='/scr1/'+dataset+'/Detect/'+config(2)+'/count_table'
tt=read_ascii(in_file)
data2=reform(tt.field1)		

in_file='/scr1/'+dataset+'/Detect/'+config(3)+'/count_table'
tt=read_ascii(in_file)
data3=reform(tt.field1)		



out_file='/home/chyan/Thesis/Latex/'+strlowcase(dataset)+'_tab.tex'
close,1
openw,1,out_file
printf,1,'\begin{deluxetable}{rrrrrrrrrrrrrrrrr}'
printf,1,'\label{'+strlowcase(dataset)+'_tab}'
printf,1,'\tablecolumns{16}'
printf,1,'\tabletypesize{\small}'
printf,1,'\tablecaption{Results of SMA '+strmid(dataset,9,5)+' mock observations of Sky '+strmid(dataset,7,1)
printf,1,'($N_{total}$= '+strcompress(string(fix(data(1,0))),/remov)+').}'
printf,1,'\tablehead{'
printf,1,'\colhead{}  &\multicolumn{3}{c}{A Config.} &   \colhead{}   &'
printf,1,'\multicolumn{3}{c}{B Config.} &\colhead{}& \multicolumn{3}{c}{C Config.}'
printf,1,'&\colhead{}& \multicolumn{3}{c}{D Config.}\\'
printf,1,'\cline{2-4} \cline{6-8} \cline{10-12}\cline{14-16}\\'
printf,1,'\colhead{$\sigma$} &   \colhead{$N_{th}$}'
printf,1,'& \colhead{$N_d$} & \colhead{$N_{good}$} & \colhead{}  &\colhead{$N_{th}$}'
printf,1,'&\colhead{$N_d$} & \colhead{$N_{good}$} & \colhead{}  &\colhead{$N_{th}$}'
printf,1,'&\colhead{$N_d$} &\colhead{$N_{good}$} & \colhead{}  & \colhead{$N_{th}$}'
printf,1,'&\colhead{$N_d$} &\colhead{$N_{good}}$}'
printf,1,'\startdata'
for i=0,n_elements(data(0,*))-1 do begin
	printf,1,format='(f4.1,a2,i4,a2,i4,a2,i4,a4,i4,a2,i4,a2,i4,a4,i4,a2,i4,a2,i4,a4,i4,a2,i4,a2,i4,a3)'$
		,data(0,i),' &',data(2,i),' &'$
		,data(3,i),' &',data(4,i),' &&',data1(2,i),' &'$
		,data1(3,i),' &',data1(4,i),' &&',data2(2,i),' &'$
		,data2(3,i),' &',data2(4,i),'&&',data3(2,i),' &'$
		,data3(3,i),' &',data3(4,i),'\\'
endfor

printf,1,'\enddata'
printf,1,'\end{deluxetable}'

close,1

end
