(defpackage #:cacau-quickstart
  (:use #:common-lisp
        #:assert-p
        #:cacau))
(in-package #:cacau-quickstart)

(deftest "Test-1" () (eql-p 1 1))
(deftest "Test-2" () (eql-p 2 2))
(deftest "Test-3" () (eql-p 3 3))

(run :colorful t)

