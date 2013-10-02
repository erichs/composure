#!/bin/sh
. ./wvtest.sh
. ../composure.sh

_max_letterpress_width
WVSTART "_composure_keywords"
WVPASS [ $(_composure_keywords | wc -w) -ge 6 ]
#WVPASS true
#WVPASS true
#WVFAIL false
#WVPASSEQ "$(ls | sort)" "$(ls)"
#
#WVSTART another test
#(echo nested fail; false); WVFAILRC $?
#WVPASS true
#WVPASSNE "5" "5 "
#WVPASSEQ "" ""
#(echo nested test; true); WVPASSRC $?

_max_letterpress_width
WVSTART "_letterpress"
WVPASSEQ "$(_letterpress foo)" "                    foo"
WVPASSEQ "$(_letterpress foo bar)" "bar                 foo"
WVPASSEQ "$(_letterpress foo bar 10)" "bar       foo"
WVPASSEQ "$(_letterpress foo bar)" "bar                 foo"

_max_letterpress_width
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

WVSTART "_max_letterpress_width"
WVPASS [ $(_max_letterpress_width) -gt 0 ]
abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz() { :; }
_max_letterpress_width
WVPASS [ $(_max_letterpress_width) -eq 57 ]
unset -f abcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyz

WVSTART "_transcribe"
