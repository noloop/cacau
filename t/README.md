# cacau Test

### Dependencies

[:cacau](https://github.com/noloop/cacau)
[:assert-p](https://github.com/noloop/assert-p)

## How to test cacau?

It's quite simple, in REPL:

```lisp
(asdf:test-system :cacau)
```

If "T" is returned in Test result because it passed, if "NIL" is returned because it failed.
