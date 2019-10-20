



slime-repl-ansi-color
=====================


Forked from https://github.com/deadtrickster/slime-repl-ansi-color

Originally stated:

I found this code here http://lists.common-lisp.net/pipermail/slime-devel/2012-March/018497.html. 

Original author is Max Mikhanosha.



## How to setup

Copy slime-repl-ansi-color.el to your slime contribs directory. In my case ~/.emacs.d/site-lisp/slime/contrib/

Modify your (slime-setup) line in your .emacs file.

In my case, this line reads:

```lisp
(slime-setup '(slime-fancy slime-banner slime-repl-ansi-color))
```


## How to use:

The ansi color terminal should no be enabled by default. You can check by running

```lisp
(format t "~c[31mabc~c[0mqweqwe~%" #\ESC #\ESC)
```

If that doesn't work, try M-x and write

```lisp
(slime-repl-ansi-on)
```

You can disable the ansi color terminal with:

```lisp
(slime-repl-ansi-off)
```



## Links

https://github.com/pnathan/cl-ansi-text
