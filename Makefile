BLOG=./dist/build/blog/blog

all: build

build: $(BLOG)
	@$(BLOG) build

$(BLOG): src/Main.hs
	@cabal sandbox init
	@cabal update
	@cabal install --only-dependencies
	@cabal build
	@$(BLOG) clean

new:
	@./new_post.sh

publish: $(BLOG)
	@$(BLOG) deploy

watch: build
	@$(BLOG) watch -p 9000

check: build
	@$(BLOG) check

clean: $(BLOG)
	@$(BLOG) clean
	@cabal clean
	@cabal sandbox delete

.PHONY: all build new publish preview clean check
