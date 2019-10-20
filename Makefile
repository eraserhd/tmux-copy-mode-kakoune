
mappings.tmux: mappings
	./mappings < mappings.txt > mappings.tmux
	
mappings: mappings.c
	$(CC) -o mappings mappings.c
