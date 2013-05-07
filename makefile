#runs all media-gen plugins

.PHONY: all clean

override OUT_DIR	?= out/
override ERASE_MSG	?= 'DONT PUT ANYTHING IMPORTANT IN THOSE DIRECTORIES SINCE `make clean` ERASES THEM!!!'

all:
	mkdir -p $(OUT_DIR)
	for d in plugins/*; do \
		if [ -d "$$d" ]; then \
			cd "$$d" ;\
				make ;\
			cd - ;\
			cd out ;\
				for out in ../"$$d"/out/*; do \
					ln -fs "$$out" "`basename "$$out"`" ;\
				done ;\
			cd - ;\
		fi ;\
	done
	echo "MADE DIRS: $(OUT_DIR)"
	echo $(ERASE_MSG)

clean:
	for d in plugins/*; do if [ -d "$$d" ]; then cd "$$d" && make clean && cd - ; fi; done
	rm -rf "$(OUT_DIR)"
	echo "REMOVED DIRS: $(OUT_DIR)"
	echo $(ERASE_MSG)
