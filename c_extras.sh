# Second-order functions for composure

composed_functions ()
{
    about list all functions stored in ~/.composure repository
    group composure_ext

    typeset f
    for f in ~/.composure/*.inc
    do
        echo ${f%.inc}
    done | awk -F'/' '{print $NF}'
}

functions_by_group ()
{
    about lists functions belonging to a given group
    param 1: group name
    example '$ list_functions_by_group tools'
    group composure_ext

    glossary $1 | cut -d' ' -f 1
}

overview ()
{
    about gives overview of available shell functions, by group
    group composure_ext

    for group in $(unique_metafor group)
    do
        printf '%s\n' "group: $group"
        glossary $group
        printf '\n'
    done
}

recompose ()
{
    about loads a stored function from ~/.composure repo
    param 1: name of function
    example $ load myfunc
    group composure_ext

    source ~/.composure/$1.inc
}

recompose_all ()
{
    about loads all stored functions from ~/.composure repo
    group composure_ext

    typeset func
    for func in $(composed_functions)
    do
        load $func
    done
}

unique_metafor ()
{
    about displays all unique metadata for a given keyword
    param 1: keyword
    example '$ unique_metafor group'
    group composure_ext

    typeset keyword=$1

    typeset file=$(mktemp /tmp/composure.XXXX)
    typeset -f | metafor $keyword >> $file
    cat $file | sort | uniq
    rm $file 2>/dev/null
}
