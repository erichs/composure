#!/bin/sh
. ./wvtest.sh
. ../composure.sh

export COMPOSURE_DIR="$(pwd)/composure_test"
export GIT_AUTHOR_NAME="test user"
export GIT_AUTHOR_EMAIL="me@privacy.net"
export GIT_COMMITTER_NAME="test user"
export GIT_COMMITTER_EMAIL="me@privacy.net"

WVSTART "initialize test env"
mkdir -p $COMPOSURE_DIR
WVPASS [ -d $COMPOSURE_DIR ]
cd $COMPOSURE_DIR
git init
echo "initialize test repo" > README.txt
git add README.txt
git commit -m "Initial commit"
cd -
WVPASS [ -d "$COMPOSURE_DIR/.git" ]

WVSTART "_composure_keywords"
WVPASS [ $(_composure_keywords | wc -w) -ge 6 ]

WVSTART "_letterpress"
WVPASSEQ "$(_letterpress foo)" "                    foo"
WVPASSEQ "$(_letterpress foo bar)" "bar                 foo"
WVPASSEQ "$(_letterpress foo bar 10)" "bar       foo"
WVPASSEQ "$(_letterpress foo bar)" "bar                 foo"

WVSTART "_typeset_functions"
typeset count
count=$(_typeset_functions | wc -l)
WVPASS [ $count -gt 1 ]
___test_typeset_functions () { :; }
WVPASS [ $(_typeset_functions | wc -l) -gt $count ]
unset -f ___test_typeset_functions

WVSTART "_longest_function_name_length"
WVPASS [ $(_longest_function_name_length) -gt 0 ]

# fake out _get_composure_dir
_get_composure_dir() { echo $COMPOSURE_DIR; }

WVSTART "_get_author_name"
cd $(_get_composure_dir) && git config --local user.name 'local user' && cd -
unset GIT_AUTHOR_NAME  # use local git config if ENV var is unset
WVPASSEQ "$(_get_author_name)" "local user"
export GIT_AUTHOR_NAME="test user"
WVPASSEQ "$(_get_author_name)" "test user"

WVSTART "_temp_filename_for"
WVPASS [ -n "$(_temp_filename_for test)" ]
WVPASS [ ! -f "$(_temp_filename_for test)" ]

WVSTART "_add_composure_file"
_add_composure_file one "$(pwd)/fixtures/one.inc" Add "first test function"
(
  cd $COMPOSURE_DIR
  WVPASSEQ "$(git log --format=%B -n 1 HEAD)" "Add one: first test function"
)
WVPASSRC $?

echo "second test function" | _add_composure_file two "$(pwd)/fixtures/two.inc" Add
(
  cd $COMPOSURE_DIR
  WVPASSEQ "$(git log --format=%B -n 1 HEAD)" "Add two: second test function"
)
WVPASSRC $?

WVSTART "_transcribe"
_transcribe three "$(pwd)/fixtures/three.inc" Add "third test function"
(
  cd $COMPOSURE_DIR
  WVPASSEQ "$(git log --format=%B -n 1 HEAD)" "Add three: third test function"
)
WVPASSRC $?

rm -rf $COMPOSURE_DIR
USE_COMPOSURE_REPO=0
WVPASSEQ "$(_transcribe)" ""
unset USE_COMPOSURE_REPO
echo "n" | _transcribe | grep -q USE_COMPOSURE_REPO=0
WVPASSRC $?
echo "y" | _transcribe four "$(pwd)/fixtures/four.inc" Add "fourth" #| grep -q 'creating git repository'
WVPASSRC $?
(
  cd $COMPOSURE_DIR
  WVPASSEQ "$(git log --format=%B -n 1 HEAD)" "Add four: fourth"
)
WVPASSRC $?

WVSTART "cleanup test env"
rm -rf $COMPOSURE_DIR
WVPASS [ ! -d $COMPOSURE_DIR ]
