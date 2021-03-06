all: build

build:
	@stack upgrade
	@stack update
	@stack build
	@stack exec -- blog build

new:
	@./scripts/new_post.sh

update-checksums:
	@./scripts/update-checksums.sh

publish: build update-checksums
	@stack exec -- blog deploy

watch: build
	@stack exec -- blog watch -p 9000

check: build
	@stack exec -- blog check

clean:
	@stack exec -- blog clean
	@stack clean

.PHONY: all build new update-checksums publish watch check clean
