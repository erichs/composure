     e88~~\  e88~-_  888-~88e-~88e 888-~88e   e88~-_   d88~\ 888  888 888-~\  e88~~8e
    d888    d888   i 888  888  888 888  888b d888   i C888   888  888 888    d888  88b
    8888    8888   | 888  888  888 888  8888 8888   |  Y88b  888  888 888    8888__888
    Y888    Y888   ' 888  888  888 888  888P Y888   '   888D 888  888 888    Y888    ,
     "88__/  "88_-~  888  888  888 888-_88"   "88_-~  \_88P  "88_-888 888     "88___/
                                   888

    # Composure: don't fear the Unix chainsaw

This light-hearted shell script makes programming the shell easier and
more intuitive:

* Transition organically from command, to function, to script
* Use an unobtrusive help system with arbitrary shell metadata
* Automatically version and store your shell functions with Git

## Craft - Draft - Revise

### Crafting the command line

[REPL environments](http://repl.it) are great for trying out programming ideas
and crafting snippets of working code, aren't they? Composure helps you make
better use of the REPL environment constantly at your fingertips: the shell.

By default, most Bash shells support the command 'Ctrl-x,Ctrl-e' which opens
the current command at the prompt in your favorite editor. I find that awkward
to type, so composure also binds this to 'Ctrl-j'. Use the full power of your
favorite text editor to quickly edit your complex commands!

A few references I find helpful:

 * [vi editing mode cheat sheet](http://www.catonmat.net/download/bash-vi-editing-mode-cheat-sheet.txt)
 * [Bash Readline bindings](http://www.delorie.com/gnu/docs/bash/bashref_103.html)

### Draft first, ask questions later

Once you've crafted your gem of a command, don't throw it away! Use 'draft ()'
and give it a good name. This stores your long command as a function you can
reuse later. Think of it like a rough draft.

### Revise, revise, revise!

Now that you've got a minimal shell function, you may want to make it better
through refactoring and revision. Use the 'revise ()' command to revise your
shell function in your favorite editor.

 * generalize functions with input parameters
 * add or remove functionality
 * add supporting metadata for documentation

## Arbitrary shell metadata!

Composure uses a simple system of dynamic keywords that allow you to add
metadata to your functions. Just call 'cite ()' to initialize your new
keyword(s), and use them freely in your functions:

```bash
  foo()
  {
      cite about
      about perform mad script-foo
      echo 'foo'
  }
```

Retrieve your metadata later by calling 'metafor ()':

```bash
  metafor foo about  # displays: 'perform mad script-foo'
```

By default, composure knows the keywords: about, param, and example.

These default keywords are used by the help system:

## Intuitive help system

The 'reference ()' function will automatically summarize all functions with
'about' metadata. If called with a function name as a parameter, it will
display apidoc-style help for that function.

```bash
  $ reference   # displays:
  cite                creates a new meta keyword for use in your functions
  draft               wraps last command into a new function
  metafor             prints function metadata associated with keyword
  reference           displays help summary for all functions, or help for specific function
  revise              loads function into editor for revision
  transcribe          store function in ~/.composure git repository
```

and

```bash
  $ reference transcribe  # displays:
  transcribe        store function in ~/.composure git repository
  parameters:
                      1: function name
                      2: file containing function
                      3: operation label
  examples:
                      $ transcribe myfunc /tmp/myfunc.sh 'scooby-doo version'
                      stores your function changes with:
                      master 7a7e524 scooby-doo version myfunc
```

## Git integration

If you already use git, installing composure will initialize a ~/.composure
repository, and store and version your functions there. Just use 'draft ()' and
'revise ()', they automatically version for you.

Or, you can manually version a function at any time by calling 'transcribe ()'.

Why do this?

 * the latest version of any function you've composed may always be sourced from
   your ~/.composure repo
 * never throw away code--keep your one-off functions in your composure 'junk
   drawer', and grep through it later for long-forgotten gems
 * every version of every function you write is always
   available to you via basic git commands

try:

```bash
  $ ls -l | awk '{print $1 " " $3 " " $5  " " $9}'
  $ draft lsl
  $ unset -f lsl
  $ lsl  # displays: -bash: lsl: command not found
  $ source ~/.composure/lsl.sh
  $ lsl  # joy!
```

## What's included:

 * cite           : creates a new meta keyword for use in your functions
 * draft          : wraps last command into a new function
 * metafor        : prints function metadata associated with keyword
 * reference      : displays summary of all functions, or help for specific function
 * revise         : loads function into editor for revision
 * transcribe     : store and version a function in your ~/.composure repo
 * Ctrl-j         : 'jump' from prompt into $EDITOR

## Installing

I like to keep configuration source files in my ~/conf directory. You'll likely
have a different preference. That's okay, just put composure.sh where you'd
like it to live and execute it. It will install itself automatically.

Try:

```bash
    $ cd ~/some/path
    $ curl -L http://git.io/composure > composure.sh
    $ chmod +x composure.sh
    $ ./composure.sh
```

## Credits

Composure grew out of ideas taken from from Gary Bernhardt's hilarious talk [The Unix
Chainsaw](http://www.confreaks.com/videos/615-cascadiaruby2011-the-unix-chainsaw) (31 minutes),
which refers to the Elements of Programming famously described in MIT's [SICP
text](http://mitpress.mit.edu/sicp/full-text/book/book.html):

 * primitive expressions
 * means of combination
 * means of abstraction
