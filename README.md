# Composure: don't fear the Unix chainsaw

Based on ideas from Gary Bernhardt's hilarious talk [The Unix
Chainsaw](http://www.confreaks.com/videos/615-cascadiaruby2011-the-unix-chainsaw).

This light-hearted shell script aims to help you treat your shell like a
first-class programming language.

* Grow shell functions organically from your command line history.
* Abstract shell functions into executable scripts.
* Inline arbitrary metadata in your shell functions

## What's included:

 * cite      : creates a new meta keyword for use in your functions
 * draft     : wraps last command into a new function
 * lastcmd   : displays last command from history
 * metafor   : prints function metadata associated with keyword
 * reference : displays help summary for all functions, or help for specific function
 * revise    : loads function into editor for revision
 * write     : prints function declaration to stdout
 * r [ str ] : redo last command, or last command matching 'str'
 * sl        : sudo last command
 * Ctrl-j    : 'jump' from prompt into $EDITOR

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
