PRO format_table

dataset='SMA_sky2_50hr'
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
printf,1,'\documentclass{aastex}'
printf,1,'\begin{document}'
printf,1,'\begin{deluxetable}{rrrrrrrrrrrrrrrrr}'
printf,1,'\tablecolumns{17}'
printf,1,'\tabletypesize{\small}'
printf,1,'\tablecaption{Results of'+dataset+'}'
printf,1,'\tablehead{'
printf,1,'\colhead{}    &  &\multicolumn{3}{c}{A Conf.} &   \colhead{}   &'
printf,1,'\multicolumn{3}{c}{B Conf.} &\colhead{}& \multicolumn{3}{c}{C Conf.}'
printf,1,'&\colhead{}& \multicolumn{3}{c}{D Conf.}\\'
printf,1,'\cline{3-5} \cline{7-9} \cline{11-13}\cline{15-17}\\'
printf,1,'\colhead{$\sigma$} & \colhead{$N_{total}$}   & \colhead{$N_{th}$}'
printf,1,'& \colhead{$N_d$} & \colhead{$N_{good}$} & \colhead{}  &\colhead{$N_{th}$}'
printf,1,'&\colhead{$N_d$} & \colhead{$N_{good}$} & \colhead{}  &\colhead{$N_{th}$}'
printf,1,'&\colhead{$N_d$} &\colhead{$N_{good}$} & \colhead{}  & \colhead{$N_{th}$}'
printf,1,'&\colhead{$N_d$} &\colhead{$N_{good}}$}'
printf,1,'\startdata'
for i=0,n_elements(data(0,*))-1 do begin
	printf,1,format='(f4.1,A2,i4,a2,i4,a2,i4,a2,i4,a4,i4,a2,i4,a2,i4,a4,i4,a2,i4,a2,i4,a4,i4,a2,i4,a2,i4,a3)'$
		,data(0,i),' &',data(1,i),' &',data(2,i),' &'$
		,data(3,i),' &',data(4,i),' &&',data1(2,i),' &'$
		,data1(3,i),' &',data1(4,i),' &&',data2(2,i),' &'$
		,data2(3,i),' &',data2(4,i),'&&',data3(2,i),' &'$
		,data3(3,i),' &',data3(4,i),'\\'
endfor

printf,1,'\enddata'
printf,1,'\end{deluxetable}'

printf,1,'\end{document}'
close,1

end
