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

# _transcribe ()
#{
#  typeset func="$1"
#  typeset file="$2"
#  typeset operation="$3"
#  typeset comment="${4:-}"
#
#  if git --version >/dev/null 2>&1; then
#    if [ -d "$COMPOSURE_DIR" ]; then
#      _add_composure_file "$func" "$file" "$operation" "$comment"
#    else
#      if [ "$USE_COMPOSURE_REPO" = "0" ]; then
#        return  # if you say so...
#      fi
#      printf "%s\n" "I see you don't have a $COMPOSURE_DIR repo..."
#      typeset input=''
#      typeset valid=0
#      while [ $valid != 1 ]; do
#        printf "\n%s" 'would you like to create one? y/n: '
#        read input
#        case $input in
#          y|yes|Y|Yes|YES)
#            (
#              echo 'creating git repository for your functions...'
#              mkdir "$COMPOSURE_DIR"
#              cd "$COMPOSURE_DIR"
#              git init
#              echo "composure stores your function definitions here" > README.txt
#              git add README.txt
#              git commit -m 'initial commit'
#            )
#            # if at first you don't succeed...
#            _transcribe "$func" "$file" "$operation"
#            valid=1
#            ;;
#          n|no|N|No|NO)
#            printf "%s\n" "ok. add 'export USE_COMPOSURE_REPO=0' to your startup script to disable this message."
#            valid=1
#          ;;
#          *)
#            printf "%s\n" "sorry, didn't get that..."
#          ;;
#        esac
#      done
#     fi
#  fi
#}
