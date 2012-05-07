# Second-order functions for composure

all_groups ()
{
    about displays all unique metadata groups
    group composure_ext

    typeset func
    typeset file=$(mktemp /tmp/composure.XXXX)
    for func in $(typeset_functions);
    do
        metafor $func group >> $file
    done
    cat $file | sort | uniq
    rm $file
}

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

list_functions_by_group ()
{
    about lists functions belonging to a given group
    param 1: group name
    example $ list_functions_by_group tools
    group composure_ext

    glossary $1 | cut -d' ' -f 1
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
