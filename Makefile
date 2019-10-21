
scripts/mappings.tmux: mappings mappings.txt
	./mappings < mappings.txt > scripts/mappings.tmux
	
mappings: mappings.cc
	$(CXX) -g -o mappings mappings.cc
