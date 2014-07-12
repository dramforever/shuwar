# Shuwar

[![Build Status](https://travis-ci.org/dramforever/shuwar.svg?branch=master)](https://travis-ci.org/dramforever/shuwar)

Just a writing system, but with lisp-like syntax.

Inspired by [eido][] and [youki][]

[youki]: https://github.com/be5invis/youki
[eido]:  https://github.com/be5invis/eido

## Usage

An "interactive shell":

    $ shuwar

Now try typing some expressions

    [print 1]

    [set ppp [lambda [x]
        [print x]
        [print x]
    ]]

    [ppp 1]

We have syntax support for writing, but no functions for that

    puts | Each line
    puts | is an arg to the tag

    puts | Another

Remember to put a blank line after the last line

This should be the same as the following, but shuwar has no support for string literals, so it
will not work

    [dont type this block]
    [puts "Each line" "is an arg to the tag"]
    [puts "Another"]

Like lisp we have `#` for quote

    [print #[print 1]]

No comment syntax yet
