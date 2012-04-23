#!/bin/bash

source_composure() {
  if [ -z "$EDITOR" ]; then
    export EDITOR=vi
  fi

  if $(tty -s); then  # is this a TTY?
    bind '"\C-j": edit-and-execute-command'
  fi

  last_cmd() { echo $(fc -ln -1); }

  name ()
  { local name=$1
    eval 'function ' $name ' { ' $(last_cmd) '; }'
  }

  write ()
  { local func=$1
    declare -f $func
  }

  alias r='fc -s'
  alias sl='eval sudo $(last_cmd)'
}

install_composure() {
  echo 'stay calm. installing composure elements...'

  # find our absolute PATH
  SOURCE="${BASH_SOURCE[0]}"
  while [ -h "$SOURCE" ] ; do SOURCE="$(readlink "$SOURCE")"; done
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

  # vim: automatically chmod +x scripts with #! lines
  done_previously() { [ ! -z "$(grep BufWritePost | grep bin | grep chmod)" ]; }

  if ! $(<~/.vimrc done_previously); then
    echo 'vimrc: adding automatic chmod+x for files with shebang (#!) lines...'
    echo 'au BufWritePost * if getline(1) =~ "^#!" | if getline(1) =~ "/bin/" | silent execute "!chmod a+x <afile>" | endif | endif' >> ~/.vimrc
  fi

  # source this file in .bashrc
  done_previously() { [ ! -z "$(grep source | grep $DIR | grep composure)" ]; }

  if ! $(<~/.bashrc done_previously) && ! $(<~/.bash_profile done_previously); then
    echo 'sourcing composure from .bashrc...'
    echo "source $DIR/$(basename $0)" >> ~/.bashrc
  fi

  echo 'composure installed.'
}

if [[ "$BASH_SOURCE" == "$0" ]]; then
  install_composure
else
  source_composure
  unset install_composure source_composure
fi
