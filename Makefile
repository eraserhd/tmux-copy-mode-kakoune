
mappings.tmux: mappings
	./mappings < mappings.txt > mappings.tmux
	
mappings: mappings.c
	$(CC) -std=c99 -o mappings mappings.c
