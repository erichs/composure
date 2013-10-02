#!/bin/sh

KSH=$(which ksh 2>/dev/null)
ZSH=$(which zsh 2>/dev/null)
BASH=$(which bash 2>/dev/null)

for test in t/*.sh; do
  for shell in $KSH $ZSH $BASH; do
    echo "Testing $test with shell $shell..."
    SHELL=$shell $shell $test
    [ $? -ne 0 ] && exit $?
  done
done

exit 0
