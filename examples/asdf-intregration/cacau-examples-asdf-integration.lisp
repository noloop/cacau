(defpackage #:cacau-examples-asdf-integration
  (:use #:common-lisp)
  (:export #:add-multiplication))
(in-package #:cacau-examples-asdf-integration)

(defun add-multiplication (a b)
  (+ (* a a) (* b b)))

