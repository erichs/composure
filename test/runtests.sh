#!/bin/sh

KSH=$(which ksh 2>/dev/null)
ZSH=$(which zsh 2>/dev/null)
BASH=$(which bash 2>/dev/null)

typeset test shell
for test in t/*.sh; do
  for shell in $BASH $KSH $ZSH; do
    TESTFILE="$test" SHELL=$shell $shell $test
    [ $? -ne 0 ] && exit $?
  done
done

exit 0
