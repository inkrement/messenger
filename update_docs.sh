#!/bin/bash
#
# TODO: autodetect current git branch and switch back

GIT_WDIR="--git-dir=messenger/.git --work-tree=messenger"

cd ..
git $GIT_WDIR checkout dev
docgen --compile messenger

git $GIT_WDIR checkout gh-pages
mv dartdoc-viewer/client/out/web/* messenger
rm -rf dartdoc-viewer

git $GIT_WDIR add -A messenger
git $GIT_WDIR commit -m "docs updated by update_docs.sh"
#git $GIT_WDIR push

git $GIT_WDIR checkout dev
