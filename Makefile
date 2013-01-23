all: build

build: hakyll
	./hakyll clean
	./hakyll build

hakyll: hakyll.hs
	ghc --make hakyll.hs

new:
	@./new_post.sh

publish: build
	git add .
	git stash save
	git checkout publish
	find . -maxdepth 1 ! -name '.' ! -name '.git*' ! -name '_site' -exec rm -rf {} +
	find _site -maxdepth 1 -exec mv {} . \;
	rmdir _site
	git add -A && git co "Publish" || true
	git push
	git push clever publish:master
	git checkout master
	git clean -fdx
	git stash pop || true

preview: hakyll
	./hakyll clean
	./hakyll preview -p 9000

clean: hakyll
	./hakyll clean
	rm -f hakyll

check: hakyll
	./hakyll check
