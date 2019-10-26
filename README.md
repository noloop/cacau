# cacau

#### <font color="red">Attention! I am learning English, should be many english errors over here, I would be grateful that when you find them, let me know with a new issue in this repository. </font>
 
<p align="center">
  <img width="500" height="500" src="./images/cacau-logo-background-white-test-runner.png">
</p>

## <a name="read-in-other-languages">Leia em outros idiomas</a>

# <font color="red">I am learning English, should be many english errors over here, I would be grateful that when you find them, let me know with a new issue in this repository. </font>

Read this in other languages: [English](https://github.com/noloop/cacau/blob/master/README.md),
[Portuguese-br](https://github.com/noloop/cacau/blob/master/README.pt-br.md)

## <a name="quickstart">Quickstart</a>

```lisp
(defpackage #:cacau-examples-quickstart
  (:use #:common-lisp
        #:assert-p
        #:cacau))
(in-package #:cacau-examples-quickstart)

(deftest "Test-1" () (eql-p 1 1))
(deftest "Test-2" () (eql-p 2 2))
(deftest "Test-3" () (eql-p 3 3))

(run :colorful t)
```

And you get the output of the reporter `:min` that is the default of the cacacau:

![cacau quickstart output by :min reporter](images/cacau-quickstart.png)

There are also others [reporters](#reporters).

See that the cacau returned `T`, this happened because none test failed, when there are tests failing or errors (errors
of hooks by example) it's returned `NIL`.

## 
## <a name="getting-started">Getting Started in cacau</a>

### <a name="summary">Summary</a>
* [cacau](#cacau)
  * [Read in other languages](#read-in-other-languages)
  * [Quickstart](#quickstart)
  * [Getting started in cacau](#getting-started)
    * [Summary](#summary)
    * [Portability](#portability)
    * [Dependencies](#dependencies)
    * [Download and Load](#download-and-load)
    * [Funcionalities](#functionalities)
      * [Suites](#suites)
      * [Hooks](#hooks)
        * [before all](#before-all)
        * [before each](#before-each)
        * [after each](#after-each)
        * [after all](#after-all)
        * [hooks in :suite-root](#hooks-in-suite-root)
        * [before/after each inheritance](#before-after-each-inheritance)
      * [Only and Skip](#only-and-skip)
        * [run only tests/suites](#onlys)
        * [skip tests/suites](#skips)
        * [precedence order "skip -> only"](#skip-only-rules)
      * [Timeout](#timeout)
        * [defining suite timeout](#timeout-suites)
        * [defining hook timeout](#timeout-hooks)
        * [defining test timeout](#timeout-tests)
      * [Test asynchronous code](#async-test)
      * [Interfaces](#interfaces)
        * [cl](#cl)
        * [bdd](#bdd)
        * [tdd](#tdd)
        * [no-spaghetti](#no-spaghetti)
      * [Cacau com cores](#cacau-with-colors)
      * [Repórteres](#reporters)
        * [min](#min)
        * [list](#list)
        * [full](#full)
      * [Enabling cl-debugger](#enabling-cl-debugger)
      * [Run hooks](#run-hooks)
  * [Cacau with colors in SLIME](#cacau-with-colors-in-slime)
  * [ASDF integration](#asdf-integration)
  * [Contributing](#contributing)
  * [TODO](#todo)
  * [API](#api)
  * [LICENSE](#license)

### <a name="portability">Portability</a>

I just tested on Linux using SBCL, coming soon I will writer tests for the others platforms using some CI tool.

### <a name="dependencies">Dependencies</a>

[:eventbus](https://github.com/noloop/eventbus)
[:assertion-error](https://github.com/noloop/assertion-error)

### <a name="download-and-load">Download and Load</a>

**1 - Load cacau system by quicklisp**

```
IN PROGRESS...
```

**2 - Download and load cacau system by github and asdf**

download from github:

```
git clone https://github.com/noloop/cacau.git
```

and load by asdf:

```lisp
(asdf:load-system :cacau)
```

_**Note: Remember to configure asdf to find your directory where you downloaded the libraries (asdf call them "systems")
 above, if you do not know how to make a read at:**
 
 https://common-lisp.net/project/asdf/asdf/Configuring-ASDF-to-find-your-systems.html 
 
 **or**
 
 https://lisp-lang.org/learn/writing-libraries


## <a name="assertions">Assertions</a>

The cacau was built to be independent of assertions systems, is true 
that in Common Lisp we don't have many systems of assertions, but I'm 
trying with the cacau create this pattern so it can make it easier to use 
of one some assertion system in many different test runner systems.
So the user stay free to choice what more please you.
I built the assertion system [:assert-p](https://github.com/noloop/assert-p),
and in the example [quickstart](examples/cacau-examples-quickstart.lisp) 
I use both systems together to create the tests.

Is simple, there is the `:cacau` test runner system and the `:assert-p` assertion 
system, when there is one assertion fail is throw one 
[:assertion-error](https://github.com/noloop/assertion-error) 
that is caught and stored by `:cacau` it to give the end result of the 
tests race.

With this is easier emerge new assertions systems for specific cases 
or aiming different syntax, which the `:cacau` can works with them.

## <a name="functionalities">Functionalities</a>

### <a name="suites">Suites</a>

You can organize your tests in suites:

```lisp
(defpackage #:cacau-examples-suites
  (:use #:common-lisp
        #:assert-p
        #:cacau))
(in-package #:cacau-examples-suites)

(defsuite :suite-1 ()
  (deftest "Test-1" () (t-p t))
  (deftest "Test-2" () (t-p t)))

(defsuite :suite-2 ()
  (let ((x 0))
    (deftest "Test-1" () (eql-p x 0))
    (deftest "Test-2" () (t-p t))
    (defsuite :suite-3 ()
      (deftest "Test-1" () (t-p t))
      (deftest "Test-2" () (t-p t)))))

(run)
```

The cacau test runner it has one `:suite-root`, so always that you call the 
function `(run)` a new runner is created with one new `:suite-root`.

### <a name="hooks">Hooks</a>

The order of execution of the hooks follow the topics order below, 
thus is executed:

1. before-all hook
2. before-each hook
3. after-each hook
4. after-all hook

#### <a name="before-all">before all</a>

Do something before all tests of one suite.

```lisp
(defpackage #:cacau-examples-hooks
  (:use #:common-lisp
        #:assert-p
        #:cacau))
(in-package #:cacau-examples-hooks)

(defsuite :suite-with-before-all ()
  (let ((x 0))
    (defbefore-all "Before-all" () (setf x 1))
    (deftest "Test-1" () (eql-p x 1))
    (deftest "Test-2" () (eql-p x 1))))
    
(run)
```

#### <a name="before-each">before each</a>

Do something before each test of one suite.

```lisp
(defpackage #:cacau-examples-hooks
  (:use #:common-lisp
        #:assert-p
        #:cacau))
(in-package #:cacau-examples-hooks)

(defsuite :suite-with-before-each ()
  (let ((x 0))
    (defbefore-each "Before-each" () (setf x 1))
    (deftest "Test-1" () (eql-p x 1))
    (deftest "Test-2" () (eql-p x 1))))
    
(run)
```

#### <a name="after-each">after each</a>

Do something after each test of one suite.

```lisp
(defpackage #:cacau-examples-hooks
  (:use #:common-lisp
        #:assert-p
        #:cacau))
(in-package #:cacau-examples-hooks)

(defsuite :suite-with-after-each ()
  (let ((x 0))
    (defafter-each "After-each" () (setf x 1))
    (deftest "Test-1" () (eql-p x 0))
    (deftest "Test-2" () (eql-p x 1))))
    
(run)
```

#### <a name="after-all">after all</a>

Do something after all tests of one suite.

```lisp
(defpackage #:cacau-examples-hooks
  (:use #:common-lisp
        #:assert-p
        #:cacau))
(in-package #:cacau-examples-hooks)

(defsuite :suite-with-after-all ()
  (let ((x 0))
    (defafter-all "After-all" () (setf x 1))
    (deftest "Test-1" () (eql-p x 0))
    (deftest "Test-2" () (eql-p x 0))))
    
(run)
```

#### <a name="hooks-in-suite-root">hooks in :suite-root</a>

For use hooks in `:suite-root` it's as simple as call the hooks functions 
without be inside of some suite:

```lisp
(defpackage #:cacau-examples-hooks
  (:use #:common-lisp
        #:assert-p
        #:cacau))
(in-package #:cacau-examples-hooks)

(defbefore-all "Before-all" () (print ":suite-root's before-all"))
(defbefore-each "Before-each" () (print ":suite-root's before-each"))
(defafter-each "After-each" () (print ":suite-root's after-each"))
(defafter-all "After-all" () (print ":suite-root's after-all"))

(defsuite :suite-1 ()
  (deftest "Test-1" () (t-p t))
  (deftest "Test-2" () (t-p t)))
  
(run)

```
#### <a name="before-after-each-inheritance">Before/after each inheritance</a>

The hooks that execute something before or after of one suite are executed 
only once time, and only at that suite.

However the hooks that execute something before or after each test are 
inherited, by example, if one dad suite of name `:suite-1` has one hook 
for execute something before each test, and this suite have one daughter 
suite called `:suite-2`, that also has one hook for execute something before 
each test, so, when run the tests of the `:suite-1` only the your hook will 
be executed, but when run the tests of the `:suite-2`, will be executed the 
first hook of the dad suite and after the hook of the daughter suite.
See one example for better understanding:

```lisp
(defpackage #:cacau-examples-hooks
  (:use #:common-lisp
        #:assert-p
        #:cacau))
(in-package #:cacau-examples-hooks)

(defsuite :suite-1 ()
  (defbefore-each "Before-each Suite-1" ()
    (print "run Before-each Suite-1"))
  (deftest "Test-1" () (print "run Test-1") (t-p t))
  (defsuite :suite-1 ()
    (defbefore-each "Before-each Suite-2" ()
      (print "run Before-each Suite-2"))
    (deftest "Test-1" () (print "run Test-2") (t-p t))))
    
(run)
```

This will print:

```lisp
"run Before-each Suite-1" 
"run Test-1" 
"run Before-each Suite-1" 
"run Before-each Suite-2" 
"run Test-2" 
```

For more understanding see the file of [hooks examples](examples/cacau-examples-hooks.lisp).

Be aware that when hooks throw errors with except of the extrapolated 
timeout error, they are going to abort the tests race and the result 
will be give. This happens because the cacau think that for the tests 
be run correctly before should whole your configured hooks be run 
correctly.

### <a name="only-and-skip">Only and Skip</a>


### LICENSE

Copyright (C) 2019 noloop

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.

Contact author:

noloop@zoho.com

