# Composure: don't fear the Unix chainsaw

Based on ideas from Gary Bernhardt's hilarious talk [The Unix
Chainsaw](http://www.confreaks.com/videos/615-cascadiaruby2011-the-unix-chainsaw).

This light-hearted shell script aims to make programming the shell easier and
more intuitive.

* Grow shell functions organically from your command line history
* Intuitive help system with arbitrary shell metadata
* Automatically version and store your shell functions with Git

## Seriously, what?

Check out composure in action. In the asciicast below, we'll:

 * group some functions by attaching metadata
 * compose a function to find those grouped functions
 * compose a function that displays the group api documentation

Here's the asciicast: [Composure Demo](http://ascii.io/a/435) (7 minutes)

## Arbitrary metadata in your shell functions!

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
  metafor foo about  # displays 'perform mad script-foo'
```

By default, composure knows the keywords: about, param, and example.

The default keywords are used by the integrated help system:

## Intuitive help system

The 'reference ()' function will automatically summarize all functions with
'about' metadata. If called with a function name as a parameter, it will
display apidoc-style help for that function.

## Git integration

If you already have git installed, composure will initialize a ~/.composure
repository, and store and version your functions there. Just use 'draft ()' and
'revise ()', they automatically version for you.

Or, you can manually version a function at any time by calling 'gitonlyknows ()'.

Why do this?

 * the latest version of any function you've composed may always be sourced from
   your ~/.composure repo
 * there's no such thing as throw-away code. Keep your one-off functions in
   your composure 'junk drawer', and grep through it later for long-forgotten
   gems
 * every version of every function you write is always
   available to you via basic git commands

## What's included:

 * cite           : creates a new meta keyword for use in your functions
 * draft          : wraps last command into a new function
 * gitonlyknows   : store and version a function in your ~/.composure repo
 * metafor        : prints function metadata associated with keyword
 * reference      : displays summary of all functions, or help for specific function
 * revise         : loads function into editor for revision
 * write          : prints function declaration to stdout
 * Ctrl-j         : 'jump' from prompt into $EDITOR

## Installing

I like to keep configuration source files in my ~/conf directory. You'll likely
have a different preference. That's okay, just put composure.sh where you'd
like it to live and execute it. It will install itself automatically.

Try:

```bash
    $ cd ~/some/path
    $ curl http://git.io/composure > composure.sh
    $ chmod +x composure.sh
    $ ./composure.sh
```
