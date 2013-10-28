# composure - by erichs
# light-hearted functions for intuitive shell programming

# version: 1.1.0
# latest source available at http://git.io/composure

# install: source this script in your ~/.profile or ~/.${SHELL}rc script
# known to work on bash, zsh, and ksh93

# 'plumbing' functions

_get_composure_dir ()
{
  if [ -n "$XDG_DATA_HOME" ]; then
    echo $XDG_DATA_HOME/composure
  else
    echo $HOME/.local/composure
  fi
}

_get_author_name ()
{
  typeset name localname
  localname="$(git --git-dir "$(_get_composure_dir)/.git" config --get user.name)"
  for name in "$GIT_AUTHOR_NAME" "$localname"; do
    if [ -n "$name" ]; then
      echo $name
      break
    fi
  done
}

_composure_keywords ()
{
  echo "about author example group param version"
}

_letterpress ()
{
  typeset rightcol="$1" leftcol="${2:- }" leftwidth="${3:-20}"

  if [ -z "$rightcol" ]; then
    return
  fi

  printf "%-*s%s\n" "$leftwidth" "$leftcol" "$rightcol"
}

_longest_function_name_length ()
{
   _typeset_functions | awk 'BEGIN{ maxlength=0 }
  {
  for(i=1;i<=NF;i++)
    if (length($i)>maxlength)
    {
    maxlength=length($i)
    }
  }
  END{ print maxlength}'
}

_add_composure_file()
{
  typeset func="$1"
  typeset file="$2"
  typeset operation="$3"
  typeset comment="${4:-}"
  typeset composure_dir=$(_get_composure_dir)

  (
    cd "$composure_dir"
    if git rev-parse 2>/dev/null; then
      if [ ! -f "$file" ]; then
        printf "%s\n" "Oops! Couldn't find $file to version it for you..."
        return
      fi
      cp "$file" "$composure_dir/$func.inc"
      git add --all .
      if [ -z "$comment" ]; then
        echo -n "Git Comment: "
        read comment
      fi
      git commit -m "$operation $func: $comment"
    fi
  )
}

_transcribe ()
{
  typeset func="$1"
  typeset file="$2"
  typeset operation="$3"
  typeset comment="${4:-}"
  typeset composure_dir=$(_get_composure_dir)

  if git --version >/dev/null 2>&1; then
    if [ -d "$composure_dir" ]; then
      _add_composure_file "$func" "$file" "$operation" "$comment"
    else
      if [ "$USE_COMPOSURE_REPO" = "0" ]; then
        return  # if you say so...
      fi
      printf "%s\n" "I see you don't have a $composure_dir repo..."
      typeset input=''
      typeset valid=0
      while [ $valid != 1 ]; do
        printf "\n%s" 'would you like to create one? y/n: '
        read input
        case $input in
          y|yes|Y|Yes|YES)
            (
              echo 'creating git repository for your functions...'
              mkdir -p "$composure_dir" || return 1
              cd "$composure_dir" || return 1
              git init
              echo "composure stores your function definitions here" > README.txt
              git add README.txt
              git commit -m 'initial commit'
            )
            # if at first you don't succeed...
            _transcribe "$func" "$file" "$operation" "$comment"
            valid=1
            ;;
          n|no|N|No|NO)
            printf "%s\n" "ok. add 'export USE_COMPOSURE_REPO=0' to your startup script to disable this message."
            valid=1
          ;;
          *)
            printf "%s\n" "sorry, didn't get that..."
          ;;
        esac
      done
     fi
  fi
}

_typeset_functions ()
{
  # unfortunately, there does not seem to be a easy, portable way to list just the
  # names of the defined shell functions...

  # first, determine our shell:
  typeset shell
  # here's a hack I modified from a StackOverflow post:
  # we loop over the ps listing for the current process ($$), and print the last column (CMD)
  # stripping any leading hyphens bash sometimes throws in there
  typeset x ans
  typeset this=$(for x in $(ps -p $$); do ans=$x; done; printf "%s\n" "$ans" | sed 's/^-*//')
  typeset shell="${this##*/}"  # e.g. /bin/bash => bash
  case "$shell" in
    sh|bash)
      typeset -F | awk '{print $3}'
      ;;
    *)
      # trim everything following '()' in ksh/zsh
      typeset +f | sed 's/().*$//'
      ;;
  esac
}

_zsh_shell_check ()
{
  # see above
  #
  # we can not use the $SHELL variable because it is set from a login shell, so
  # starting a bash shell inside your zsh login shell "brings" all the previously
  # environment variables
  # example:
  #
  # zsh-4 $ echo $SHELL
  # /bin/zsh
  # zsh-4 $ sh
  # sh-4.2$ echo $SHELL
  # /bin/zsh

  typeset this=$(for x in $(ps -p $$); do ans=$x; done; printf "%s\n" "$ans" | sed 's/^-*//')
  typeset shell="${this##*/}"  # e.g. /bin/bash => bash

  if [ "$shell" = "zsh" ]; then
    return 0
  else
    return 1
  fi
}

_zsh_shell_option_check ()
{
  # checks for problematic known options (like noclobber) and invert them

  if _zsh_shell_check; then

    # we need to expose the variable for a while
    typeset -x _composure_zsh_options
    _composure_zsh_options="$@"

    for zsh_option in "${_composure_zsh_options[@]}"; do

      if setopt | command grep -qw "$zsh_option"; then

        # since we need to invert the option (starts with no),
        # we must check first check if it actually starts with `no`
        # for example:
        # noclobber -> setopt clobber
        # interactivecomments -> nointeractivecomments

        if [ "$zsh_option" = "${zsh_option#no}" ]; then
          zsh_option=no${zsh_option} # add no
        else
          zsh_option=${zsh_option#no} # remove no
        fi

        setopt $zsh_option

      fi

    done
  fi
}

_reenable_zsh_options ()
{
  # restablish the zsh option previous state
  if _zsh_shell_check; then
    for zsh_option in "${_composure_zsh_options[@]}"; do
      setopt $zsh_option
    done
    unset _composure_zsh_options
  fi
}

# bootstrap metadata keywords for porcelain functions

for f in $(_composure_keywords)
do
  eval "$f() { :; }"
done
unset f


# 'porcelain' functions

cite ()
{
  about 'creates one or more meta keywords for use in your functions'
  param 'one or more keywords'
  example '$ cite url username'
  example '$ url http://somewhere.com'
  example '$ username alice'
  group 'composure'

  # this is the storage half of the 'metadata' system:
  # we create dynamic metadata keywords with function wrappers around
  # the NOP command, ':'

  # anything following a keyword will get parsed as a positional
  # parameter, but stay resident in the ENV. As opposed to shell
  # comments, '#', which do not get parsed and are not available
  # at runtime.

  # a BIG caveat--your metadata must be roughly parsable: do not use
  # contractions, and consider single or double quoting if it contains
  # non-alphanumeric characters

  if [ -z "$1" ]; then
    printf '%s\n' 'missing parameter(s)'
    reference cite
    return
  fi

  typeset keyword
  for keyword in "$@"; do
    eval "$keyword() { :; }"
  done
}

draft ()
{
  about 'wraps command from history into a new function, default is last command'
  param '1: name to give function'
  param '2: optional history line number'
  example '$ ls'
  example '$ draft list'
  example '$ draft newfunc 1120  # wraps command at history line 1120 in newfunc()'
  group 'composure'

  typeset func=$1
  typeset num=$2

  if [ -z "$func" ]; then
    printf '%s\n' 'missing parameter(s)'
    reference draft
    return
  fi

  # aliases bind tighter than function names, disallow them
  if [ -n "$(type -a "$func" 2>/dev/null | grep 'is.*alias')" ]; then
    printf '%s\n' "sorry, $(type -a "$func"). please choose another name."
    return
  fi

  _zsh_shell_option_check noclobber

  typeset cmd
  if [ -z "$num" ]; then
    typeset lines=1
    # some versions of 'fix command, fc' need corrective lenses...
    fc -ln -1 | grep -q draft && lines=2
    # parse last command from fc output
    cmd=$(fc -ln -$lines | head -1 | sed 's/^[[:blank:]]*//')
  else
    # parse command from history line number
    cmd=$(eval "history | grep '^[[:blank:]]*$num' | head -1" | sed 's/^[[:blank:][:digit:]]*//')
  fi
  eval "$func() {
  author '$(_get_author_name)'
  about ''
  param ''
  example ''
  group ''

  $cmd;
}"
  typeset file=$(mktemp /tmp/draft.XXXX)
  typeset -f $func > $file
  _transcribe "$func" "$file" Draft "initial draft"
  rm "$file" 2>/dev/null
  _reenable_zsh_options
  revise $func
}

glossary ()
{
  about 'displays help summary for all functions, or summary for a group of functions'
  param '1: optional, group name'
  example '$ glossary'
  example '$ glossary misc'
  group 'composure'

  typeset targetgroup=${1:-}
  typeset maxwidth=$(_longest_function_name_length | awk '{print $1 + 5}')

  for func in $(_typeset_functions); do
    if [ -n "$targetgroup" ]; then
      typeset group="$(typeset -f $func | metafor group)"
      if [ "$group" != "$targetgroup" ]; then
        continue  # skip non-matching groups, if specified
      fi
    fi
    typeset about="$(typeset -f $func | metafor about)"
    _letterpress "$about" "$func" "$maxwidth"
  done
}

metafor ()
{
  about 'prints function metadata associated with keyword'
  param '1: meta keyword'
  example '$ typeset -f glossary | metafor example'
  group 'composure'

  typeset keyword=$1

  if [ -z "$keyword" ]; then
    printf '%s\n' 'missing parameter(s)'
    reference metafor
    return
  fi

  # this sed-fu is the retrieval half of the 'metadata' system:
  # 'grep' for the metadata keyword, and then parse/filter the matching line

  # grep keyword # strip trailing '|"|; # ignore thru keyword and leading '|"
  sed -n "/$keyword / s/['\";]*\$//;s/^[ 	]*$keyword ['\"]*\([^([].*\)*\$/\1/p"
}

reference ()
{
  about 'displays apidoc help for a specific function'
  param '1: function name'
  example '$ reference revise'
  group 'composure'

  typeset func=$1
  if [ -z "$func" ]; then
    printf '%s\n' 'missing parameter(s)'
    reference reference
    return
  fi

  typeset line

  typeset about="$(typeset -f "$func" | metafor about)"
  _letterpress "$about" "$func"

  typeset author="$(typeset -f $func | metafor author)"
  if [ -n "$author" ]; then
    _letterpress "$author" 'author:'
  fi

  typeset version="$(typeset -f $func | metafor version)"
  if [ -n "$version" ]; then
    _letterpress "$version" 'version:'
  fi

  if [ -n "$(typeset -f $func | metafor param)" ]; then
    printf "parameters:\n"
    typeset -f $func | metafor param | while read line
    do
      _letterpress "$line"
    done
  fi

  if [ -n "$(typeset -f $func | metafor example)" ]; then
    printf "examples:\n"
    typeset -f $func | metafor example | while read line
    do
      _letterpress "$line"
    done
  fi
}

revise ()
{
  about 'loads function into editor for revision'
  param '<optional> -e: revise version stored in ENV'
  param '1: name of function'
  example '$ revise myfunction'
  example '$ revise -e myfunction'
  example 'save a zero-length file to abort revision'
  group 'composure'

  typeset source='git'
  if [ "$1" = '-e' ]; then
    source='env'
    shift
  fi

  typeset func=$1
  typeset temp=$(mktemp /tmp/revise.XXXX)

  if [ -z "$func" ]; then
    printf '%s\n' 'missing parameter(s)'
    reference revise
    return
  fi

  typeset composure_dir=$(_get_composure_dir)
  _zsh_shell_option_check noclobber
  # populate tempfile...
  if [ "$source" = 'env' ] || [ ! -f "$composure_dir/$func.inc" ]; then
    # ...with ENV if specified or not previously versioned
    typeset -f $func >> $temp
  else
    # ...or with contents of latest git revision
    cat "$composure_dir/$func.inc" >> "$temp"
  fi

  if [ -z "$EDITOR" ]
  then
    typeset EDITOR=vi
  fi

  $EDITOR "$temp"
  if [ -s "$temp" ]; then
    typeset edit='N'

    # source edited file
    . "$temp" || edit='Y'

    while [ $edit = 'Y' ]; do
      echo -n "Re-edit? Y/N: "
      read edit
      case $edit in
         y|yes|Y|Yes|YES)
           edit='Y'
           $EDITOR "$temp"
           . "$temp" && edit='N';;
         *)
           edit='N';;
      esac
    done
    _transcribe "$func" "$temp" Revise
  else
    # zero-length files abort revision
    printf '%s\n' 'zero-length file, revision aborted!'
  fi
  rm "$temp"
  _reenable_zsh_options
}

write ()
{
about 'writes one or more composed function definitions to stdout'
param 'one or more function names'
example '$ write finddown foo'
example '$ write finddown'
group 'composure'

if [ -z "$1" ]; then
  printf '%s\n' 'missing parameter(s)'
  reference write
  return
fi

echo "#!/usr/bin/env ${SHELL##*/}"

# bootstrap metadata
cat <<END
for f in $(_composure_keywords)
do
  eval "\$f() { :; }"
done
unset f
END

# write out function definitons
typeset -f cite "$@"

cat <<END
main() {
  echo "edit me to do something useful!"
  exit 0
}

main \$*
END
}

: <<EOF
License: The MIT License

Copyright © 2012 Erich Smith

Permission is hereby granted, free of charge, to any person obtaining a copy of this
software and associated documentation files (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy, modify,
merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be included in all copies
or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE
OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
EOF

