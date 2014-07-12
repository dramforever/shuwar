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

We have syntax support for writing: you can call functions like this

    puts | Each line
    puts | is an arg to the tag

    puts | Another

Remember to put a blank line after the last line

This should be the same as the following, but shuwar has no support for string literals, so it
will not work

    [dont type this block]
    [puts "Each line" "is an arg to the tag"]
    [puts "Another"]

If you load the nokogiri library, you can have some html

    [load #nokogiri]

    [set main_content
        [div #[
            class | content
            id    | main-content
        ]

    h1      | Sample
    ]

    [put_html
        [html [body
            main_content
        ]]
    ]

It's from `sample.swr`, you should look at it.

Note the attributes: it's the same as the following

    #[ [class
       | content
       ]

       [id
       | main-content
       ]]

However just as `sample.swr` says:

> It's looks like a hack, but it feels great!

We recommend this rather than the spell-out-by-hand method

We have `#` for quote

    [print #[print 1]]

No comment syntax yet
