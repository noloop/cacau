(defpackage #:cacau-examples-asdf-integration-test
  (:use #:common-lisp
        #:cacau
        #:assert-p
        #:cacau-examples-asdf-integration))
(in-package #:cacau-examples-asdf-integration-test)

(deftest "Test-add-multiplication" ()
  (eql-p (add-multiplication 1 2) 5))

