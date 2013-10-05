#!/bin/sh

# run code quality metrics
echo "Testing \"code quality\" with shellcheck.net in ../composure.sh:"
typeset metricfile=shellcheck.out
curl -s --data-urlencode script="$(cat ../composure.sh)" \
  www.shellcheck.net/shellcheck.php | python -mjson.tool > $metricfile
cat $metricfile

# check for shellcheck.net errors
cat $metricfile | grep -q error
if [ $? -eq 0 ]; then
  echo "! shellcheck.net:../composure.sh:0  [ errors ]  FAILED"
  rm $metricfile
  exit 2
fi

# check for shellcheck.net warnings
cat $metricfile | grep -q warning
if [ $? -eq 0 ]; then
  echo "! shellcheck.net:../composure.sh:0  [ warnings ]  FAILED"
  rm $metricfile
  exit 2
fi

echo "! shellcheck.net:../composure.sh:0 [ no errors or warnings ] ok"
rm $metricfile

# detect available testing shells
KSH=$(which ksh 2>/dev/null)
ZSH=$(which zsh 2>/dev/null)
BASH=$(which bash 2>/dev/null)

# run wvtests against available shells
typeset test shell
for test in t/*.sh; do
  for shell in $BASH $KSH $ZSH; do
    TESTFILE="$test" SHELL=$shell $shell $test
    [ $? -ne 0 ] && exit $?
  done
done

exit 0
