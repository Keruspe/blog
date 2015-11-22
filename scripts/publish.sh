#!/bin/bash

git add .
git stash save
make clean
git checkout publish
git pull
git checkout master
make
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
