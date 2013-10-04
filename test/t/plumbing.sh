#!/bin/sh
. ./wvtest.sh
. ../composure.sh

COMPOSURE_DIR="$(pwd)/composure_test"

WVSTART "initialize test env"
mkdir -p $COMPOSURE_DIR
WVPASS [ -d $COMPOSURE_DIR ]
cd $COMPOSURE_DIR
git init
git config --local user.name "test user"
git config --local user.email "me@privacy.net"
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
typeset count=$(_typeset_functions | wc -l)
WVPASS [ $count -gt 1 ]
___test_typeset_functions () { :; }
WVPASS [ $(_typeset_functions | wc -l) -gt $count ]
unset -f ___test_typeset_functions

WVSTART "_longest_function_name_length"
WVPASS [ $(_longest_function_name_length) -gt 0 ]
abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz() { :; }
WVPASS [ $(_longest_function_name_length) -eq 52 ]
unset -f abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz

pwd
WVSTART "_add_composure_file"
_add_composure_file one "$(pwd)/fixtures/one.inc" Add "first test function"
(
  cd $COMPOSURE_DIR
  WVPASSEQ "$(git log --format=%B -n 1 HEAD)" "Add one: first test function"
)

echo "second test function" | _add_composure_file two "$(pwd)/fixtures/two.inc" Add
(
  cd $COMPOSURE_DIR
  WVPASSEQ "$(git log --format=%B -n 1 HEAD)" "Add two: second test function"
)


WVSTART "cleanup test env"
rm -rf $COMPOSURE_DIR
WVPASS [ ! -d $COMPOSURE_DIR ]
