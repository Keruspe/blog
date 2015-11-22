BLOG=./dist/build/blog/blog

all: build

build: $(BLOG)
	@$(BLOG) build

sandbox:
	@cabal sandbox init
	@cabal update || true
	@cabal install --only-dependencies

$(BLOG): sandbox src/Main.hs
	@cabal build
	@$(BLOG) clean

new:
	@./scripts/new_post.sh

publish: $(BLOG)
	@$(BLOG) deploy

watch: build
	@$(BLOG) watch -p 9000

check: build
	@$(BLOG) check

clean: $(BLOG)
	@$(BLOG) clean
	@cabal clean

clean-sandbox:
	@cabal sandbox delete

clean-all: clean clean-sandbox

.PHONY: all build sandbox new publish watch check clean clean-sandbox clean-all
