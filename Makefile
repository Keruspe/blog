all: build

build: hakyll
	./hakyll build

hakyll: hakyll.hs
	ghc --make hakyll.hs
	./hakyll clean

new:
	@./new_post.sh

publish: build
	@./publish.sh

preview: hakyll
	./hakyll clean
	./hakyll preview -p 9000

clean: hakyll
	./hakyll clean
	rm -f hakyll

check: build
	./hakyll check
