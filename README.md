# vim-vertical

vim-vertical is a way to get around in vim vertically the same way you do
horizontally.

## usage

To go down...

```
:[range]Vertical f
```

To go up...

```
:[range]Vertical b
```

## example

The cursor is marked by █.

```
Lorem ipsum dolor sit amet, consectetur adipiscing elit█
Duis ullamcorper consectetur sem in congue. Quisque sagittis felis non lacus tempor, a laoreet elit pellentesque.
In rhoncus condimentum ipsum, et fringilla nunc pharetra in.
In hac habitasse platea dictumst. Mauris rutrum massa ut mauris lobortis venenatis ac et massa.
Lorem ipsum dolor sit amet,
consectetur adipiscing elit.                                    Donec quis ante ornare, suscipit lacus quis,
fermentum purus. Nulla viverra aliquet ornare.    Donec tempus varius risus, nec vulputate lacus bibendum non.
```

```
:Vertical f
```

```
Lorem ipsum dolor sit amet, consectetur adipiscing elit.
Duis ullamcorper consectetur sem in congue. Quisque sagittis felis non lacus tempor, a laoreet elit pellentesque.
In rhoncus condimentum ipsum, et fringilla nunc pharetra in.
In hac habitasse platea dictumst. Mauris rutrum massa u█ mauris lobortis venenatis ac et massa.
Lorem ipsum dolor sit amet,
consectetur adipiscing elit.                                    Donec quis ante ornare, suscipit lacus quis,
fermentum purus. Nulla viverra aliquet ornare.    Donec tempus varius risus, nec vulputate lacus bibendum non.
```

The cursor has jumped to the end of the vertical block, as if it were a word
and we pressed `e`. If we enter the same command...

```
Lorem ipsum dolor sit amet, consectetur adipiscing elit.
Duis ullamcorper consectetur sem in congue. Quisque sagittis felis non lacus tempor, a laoreet elit pellentesque.
In rhoncus condimentum ipsum, et fringilla nunc pharetra in.
In hac habitasse platea dictumst. Mauris rutrum massa ut mauris lobortis venenatis ac et massa.
Lorem ipsum dolor sit amet,
consectetur adipiscing elit.                                    Donec quis ante ornare, suscipit lacus quis,
fermentum purus. Nulla viverra aliquet ornare.    Donec█tempus varius risus, nec vulputate lacus bibendum non.
```

The cursor ignores white space and jumps to the next clear vertical block, as
if it were a word and we pressed `w`. The `w` and `e` like functionality will
eventually be available on their own.

vim-vertical also considers whitespace at the beginning of a line empty space,
even if there is only one space.

## need

Existing vim vertical movements are limited by knowing exactly what you're
looking for and everything inbetween while requiring much typing (with `/` and
`?`), or taking you to the beginning of the line (`[` `]` and `{` `}`) or even
blindly jumping and hoping to hit something (`C-d` and `C-u`).

Many times, I have been at the end of a line after editing it and needed to go
to a nearby long line. Why should I not be able to just press a key and get
there if it's so well defined?

Other times, I have been trying to select clearly defined blocks of text that
don't necessarily have newlines around them, and therefore can't be selected
with `ip` and `ap` or jumped over with `{` and `}`. Even when a block is
surrounded by empty lines, these commands do not always flow very well.

As for jumping with `C-d` and `C-u`, simply doing `:3Vertical b` and
`:3Vertical f` is much more likely to put your cursor in a position to do
something meaningful.

## known problems

vim-vertical is still experimental in its support of tab spaces and visual
selection, as well as ranges. There are many known bugs. Please still submit
any issues.
