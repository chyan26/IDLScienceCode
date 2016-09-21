pushprocyon:
	rsync -arvzu *.pro -e ssh chyan@procyon:~chyan/idl_script/Projects/RhoOph/
	rsync -arvzu *.pro -e ssh chyan@menka:~chyan/idl_script/Projects/RhoOph/		

getprocyon:
	rsync -arvzu -e ssh chyan@procyon:~chyan/idl_script/Projects/RhoOph/*.pro .	

pushiaahome:
	rsync -arvzu *.pro -e ssh chyan@menka:~chyan/idl_script/Projects/RhoOph/	

getiaahome:
	rsync -arvzu -e ssh chyan@menka:~chyan/idl_script/Projects/RhoOph/*.pro .	

pushall:  pushprocyon pushiaahome	
