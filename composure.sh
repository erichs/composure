export EDITOR=vi

cull ()
{ local name=$1
  eval 'function ' $name ' { ' $(fc -ln -1) '; }'
}

write ()
{ local func=$1
  declare -f $func
}
