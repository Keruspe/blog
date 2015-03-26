all: build

build: hakyll
	./hakyll build

hakyll: hakyll.hs
	ghc --make hakyll.hs
	./hakyll clean

new:
	@./new_post.sh

publish: hakyll
	./hakyll deploy

watch: build
	./hakyll watch -p 9000

check: build
	./hakyll check

clean: hakyll
	rm -f hakyll

.PHONY: all build new publish preview clean check
