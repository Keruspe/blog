BLOG=./dist/build/blog/blog
SBF=./.sandbox.ok

all: build

build: $(BLOG)
	@$(BLOG) build

$(SBF):
	@cabal sandbox init
	@cabal update || true
	@cabal install --only-dependencies
	@touch $@

$(BLOG): $(SBF) src/Main.hs
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

clean-all: clean clean-sandbox

clean-sandbox:
	@cabal sandbox delete
	@rm -f $(SBF)

regen-sandbox: clean-sandbox $(SBF)

.PHONY: all build new publish watch check clean clean-all clean-sandbox regen-sandbox clean-all
