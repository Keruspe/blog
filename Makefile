all: build

build: hakyll
	./hakyll clean
	./hakyll build

hakyll: hakyll.hs
	ghc --make hakyll.hs

new:
	@./new_post.sh

publish: build
	git stash save
	git checkout publish
	cp -r _site/* ./
	git add . &&  git co "Publish" || true
	git push clever publish:master
	git checkout master
	git stash pop || true

preview: hakyll
	./hakyll clean
	./hakyll preview 9000

clean: hakyll
	./hakyll clean
	rm -f hakyll
