# Composure: don't fear the Unix chainsaw

Based on ideas from Gary Bernhardt's talk [The Unix
Chainsaw](http://www.confreaks.com/videos/615-cascadiaruby2011-the-unix-chainsaw).

This light-hearted shell script aims to help you treat your shell like a
first-class programming language.

* Grow shell functions organically from your command line history.
* Abstract shell functions into executable scripts.

## What's included:

 * name()    : create function from last command
 * write()   : write out definition of a function
 * r < str > : redo last command, or last command matching < str >
 * sl        : sudo last command
 * Ctrl-j    : 'jump' from prompt into $EDITOR

## Installing

I like to keep configuration source files in my ~/conf directory. You'll likely
have a different preference. That's okay, just put composure.sh where you'd
like it to live and execute it. It will install itself automatically.
