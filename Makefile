BLF=./.blog.ok
SBF=./.sandbox.ok

all: build

build: $(BLF)
	@cabal run -- blog build

$(SBF):
	@cabal sandbox init
	@cabal update || true
	@cabal install --only-dependencies
	@touch $@

$(BLF): $(SBF) src/Main.hs
	@cabal build
	@cabal run -- blog clean
	@touch $@

new:
	@./scripts/new_post.sh

update-sha1:
	@./scripts/update-sha1.sh

publish: build update-sha1
	@cabal run -- blog deploy

watch: build
	@cabal run -- blog watch -p 9000

check: build
	@cabal run -- blog check

clean: $(BLF)
	@cabal run -- blog clean
	@cabal clean
	@rm -f $(BLF)

clean-all: clean clean-sandbox

clean-sandbox:
	@cabal sandbox delete
	@rm -f $(SBF)

regen-sandbox: clean-sandbox $(SBF)

.PHONY: all build new update-sha1 publish watch check clean clean-all clean-sandbox regen-sandbox clean-all
