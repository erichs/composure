#!/bin/sh
. ./wvtest.sh
. ../composure.sh

export COMPOSURE_DIR="$(pwd)/composure_test"
export GIT_AUTHOR_NAME="test user"
export GIT_AUTHOR_EMAIL="me@privacy.net"
export GIT_COMMITTER_NAME="test user"
export GIT_COMMITTER_EMAIL="me@privacy.net"

mkdir -p $COMPOSURE_DIR
cd $COMPOSURE_DIR
git init
echo "initialize test repo" > README.txt
git add README.txt
git commit -m "Initial commit"
cd -

WVSTART "write command"
hello() {
  echo 'test'
}

write hello | egrep -q 'hello ?()'
WVPASSRC $?

rm -rf $COMPOSURE_DIR
