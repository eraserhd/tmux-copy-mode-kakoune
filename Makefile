
scripts/mappings.tmux: mappings mappings.txt
	./mappings < mappings.txt > scripts/mappings.tmux
	
mappings: mappings.c
	$(CC) -std=c99 -o mappings mappings.c
