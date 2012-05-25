# Second-order functions for composure

composed_functions ()
{
    about 'list all functions stored in ~/.composure repository'
    group 'composure_ext'

    typeset f
    for f in ~/.composure/*.inc
    do
        echo ${f%.inc}
    done | awk -F'/' '{print $NF}'
}

findgroup ()
{
    about 'finds all functions belonging to group'
    param '1: name of group'
    example '$ findgroup tools'
    group 'composure_ext'

    typeset func
    for func in $(_typeset_functions)
    do
        typeset group="$(typeset -f $func | metafor group)"
        if [ "$group" = "$1" ]; then
            echo "$func"
        fi
    done
}

overview ()
{
    about 'gives overview of available shell functions, by group'
    group 'composure_ext'

    # display a brief progress message...
    printf '%s' 'building documentation...'
    typeset grouplist=$(mktemp /tmp/grouplist.XXXX);
    typeset func;
    for func in $(_typeset_functions);
    do
        typeset group="$(typeset -f $func | metafor group)";
        if [ -z "$group" ]; then
            group='misc';
        fi;
        typeset about="$(typeset -f $func | metafor about)";
        letterpress "$about" $func >> $grouplist.$group;
        echo $grouplist.$group >> $grouplist;
    done;
    # clear progress message
    printf '\r%s\n' '                          '
    typeset group;
    typeset gfile;
    for gfile in $(cat $grouplist | sort | uniq);
    do
        printf '%s\n' "${gfile##*.}:";
        cat $gfile;
        printf '\n';
        rm $gfile 2> /dev/null;
    done | less
    rm $grouplist 2> /dev/null
}

recompose ()
{
    about 'loads a stored function from ~/.composure repo'
    param '1: name of function'
    example '$ load myfunc'
    group 'composure_ext'

    source ~/.composure/$1.inc
}

recompose_all ()
{
    about 'loads all stored functions from ~/.composure repo'
    group 'composure_ext'

    typeset func
    for func in $(composed_functions)
    do
        load $func
    done
}

unique_metafor ()
{
    about 'displays all unique metadata for a given keyword'
    param '1: keyword'
    example '$ unique_metafor group'
    group 'composure_ext'

    typeset keyword=$1

    typeset file=$(mktemp /tmp/composure.XXXX)
    typeset -f | metafor $keyword >> $file
    cat $file | sort | uniq
    rm $file 2>/dev/null
}
