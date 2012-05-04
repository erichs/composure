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

Many Unix users I know like to iteratively build up complex commands by trying
something out, hitting the up arrow and perhaps adding a filter with a pipe:

```bash
  $ cat servers.txt
  bashful: up
  doc: down

  up-arrow

  $ cat servers.txt | grep down
  doc: down

  up-arrow

  $ cat servers.txt | grep down | mail -s "down server(s)" admin@here.com
```

Composure helps by letting your quickly draft simple shell functions, breaking down
your long pipe filters and complex commands into readable and reusable chunks.

### Draft first, ask questions later

Once you've crafted your gem of a command, don't throw it away! Use 'draft ()'
and give it a good name. This stores your last command as a function you can
reuse later. Think of it like a rough draft.

```bash
  $ cat servers.txt
  bashful: up
  doc: down

  up-arrow

  $ cat servers.txt | grep down
  doc: down

  $ draft finddown

  $ finddown | mail -s "down server(s)" admin@here.com
```

### Revise, revise, revise!

Now that you've got a minimal shell function, you may want to make it better
through refactoring and revision. Use the 'revise ()' command to revise your
shell function in your favorite editor.

 * generalize functions with input parameters
 * add or remove functionality
 * add supporting metadata for documentation

```bash
  $ revise finddown
  finddown ()
  {
      about finds servers marked 'down' in text file
      group admin
      cat $1 | grep down
  }

  $ finddown servers.txt
  doc: down
```

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
  metafor foo about  # displays:
  perform mad script-foo
```

By default, composure knows the keywords: about, param, group, author, and example.

These default keywords are used by the help system:

## Intuitive help system

The 'glossary ()' function will automatically summarize all functions with
'about' metadata. If called with a 'group' name as a parameter, it will
summarize functions belonging to that group.

To display apidoc-style help for a function, use 'reference ()'.

```bash
  $ glossary   # displays:
  cite                creates a new meta keyword for use in your functions
  draft               wraps last command into a new function
  finddown            finds servers marked 'down' in text file
  foo                 perform mad script-foo
  glossary            displays help summary for all functions, or summary for a group of functions
  metafor             prints function metadata associated with keyword
  reference           displays apidoc help for a specific function
  revise              loads function into editor for revision

  meanwhile

  $ glossary admin   # displays:
  finddown            finds servers marked 'down' in text file

  and

  $ reference draft  # displays:
  draft               wraps last command into a new function
  parameters:
                      1: name to give function
  examples:
                      $ ls
                      $ draft list
                      $ list
```

## Git integration

If you already use git, installing composure will initialize a ~/.composure
repository, and store and version your functions there. Just use 'draft ()' and
'revise ()', they automatically version for you.

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
  $ unset -f lsl  # or, open a new terminal...
  $ lsl  # displays: lsl: command not found
  $ source ~/.composure/lsl.inc
  $ lsl  # joy!
```

## Installing

Put composure.sh where you'd like it to live and source it from your
shell's profile or rc file.

On Bash:

```bash
    $ cd /where/you/put/composure.sh
    $ echo "source $(pwd)/composure.sh" >> ~/.bashrc   # or, ~/.bash_profile on osx
```

# Compatibility

Composure should be POSIX-compatible, and is known to work on ksh93, zsh, and
bash, on osx and linux.

Please feel free to open an issue if you have any difficulties on your system.

## Additional Resources

By default, most Bash shells support the command 'Ctrl-x,Ctrl-e' which opens
the current command at the prompt in your favorite editor. I find that awkward
to type, so I binds this to 'Ctrl-j'. Use the full power of your
favorite text editor to quickly edit your complex commands!

In bash, try adding the following to your ~/.bashrc or ~/.bash_profile:

```bash
  bind '"\C-j": edit-and-execute-command'
```

A few references I find helpful:

 * [vi editing mode cheat sheet](http://www.catonmat.net/download/bash-vi-editing-mode-cheat-sheet.txt)
 * [Bash Readline bindings](http://www.delorie.com/gnu/docs/bash/bashref_103.html)

## Known Issues

'glossary ()' and 'reference ()' do not support nested functions with metadata.

## Credits

Composure grew out of ideas taken from from Gary Bernhardt's hilarious talk [The Unix
Chainsaw](http://www.confreaks.com/videos/615-cascadiaruby2011-the-unix-chainsaw) (31 minutes),
which refers to the Elements of Programming described in MIT's [SICP
text](http://mitpress.mit.edu/sicp/full-text/book/book.html):

 * primitive expressions
 * means of combination
 * means of abstraction
