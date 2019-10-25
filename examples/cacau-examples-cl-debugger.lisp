(defpackage #:cacau-examples-cl-debugger
  (:use #:common-lisp
        #:assert-p
        #:cacau))
(in-package #:cacau-examples-cl-debugger)

(defsuite :suite-1 ()
  (deftest "Test-1" () (t-p t))
  (deftest "Test-2" () (t-p nil))
  (deftest "Test-3" () (t-p t)))

(run :cl-debugger t)

