#!/bin/sh
. ./wvtest.sh
. ../composure.sh

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
