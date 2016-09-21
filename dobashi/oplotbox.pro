
PRO OPLOTBOX,x0,x1,y0,y1,COLOR=color, LINESTYLE=linestyle, THICK=thick
	oplot,[x0,x1],[y0,y0],color=color,linestyle=linestyle,thick=thick
	oplot,[x0,x1],[y1,y1],color=color,linestyle=linestyle,thick=thick
	oplot,[x0,x0],[y0,y1],color=color,linestyle=linestyle,thick=thick
	oplot,[x1,x1],[y0,y1],color=color,linestyle=linestyle,thick=thick
	
END
