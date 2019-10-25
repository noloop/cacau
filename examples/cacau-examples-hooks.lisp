(defpackage #:cacau-examples-hooks
  (:use #:common-lisp
        #:assert-p
        #:cacau))
(in-package #:cacau-examples-hooks)

(defbefore-all "Before-all" () (print ":suite-root's before-all"))
(defbefore-each "Before-each" () (print ":suite-root's before-each"))
(defafter-each "After-each" () (print ":suite-root's after-each"))
(defafter-all "After-all" () (print ":suite-root's after-all"))

(defsuite :suite-with-before-all ()
  (let ((x 0))
    (defbefore-all "Before-all" () (setf x 1))
    (deftest "Test-1" () (eql-p x 1))
    (deftest "Test-2" () (eql-p x 1))))

(defsuite :suite-with-before-each ()
  (let ((x 0))
    (defbefore-each "Before-each" () (setf x 1))
    (deftest "Test-1" () (eql-p x 1))
    (deftest "Test-2" () (eql-p x 1))))

(defsuite :suite-with-after-each ()
  (let ((x 0))
    (defafter-each "After-each" () (setf x 1))
    (deftest "Test-1" () (eql-p x 0))
    (deftest "Test-2" () (eql-p x 1))))

(defsuite :suite-with-after-all ()
  (let ((x 0))
    (defafter-all "After-all" () (setf x 1))
    (deftest "Test-1" () (eql-p x 0))
    (deftest "Test-2" () (eql-p x 0))))

(run :colorful t)

;;;; hooks inheritance
;;;; ------------------------------------
;;; before-each
(defsuite :suite-1 ()
  (defbefore-each "Before-each Suite-1" ()
    (print "run Before-each Suite-1"))
  (deftest "Test-1" () (print "run Test-1") (t-p t))
  (defsuite :suite-1 ()
    (defbefore-each "Before-each Suite-2" ()
      (print "run Before-each Suite-2"))
    (deftest "Test-1" () (print "run Test-2") (t-p t))))

(run :colorful t)

;;; after-each
(defsuite :suite-1 ()
  (defafter-each "After-each Suite-1" ()
    (print "run After-each Suite-1"))
  (deftest "Test-1" () (print "run Test-1") (t-p t))
  (defsuite :suite-1 ()
    (defafter-each "After-each Suite-2" ()
      (print "run After-each Suite-2"))
    (deftest "Test-1" () (print "run Test-2") (t-p t))))

(run :colorful t)

;;;; hooks not inheritance
;;;; ------------------------------------
;;; before-all
(defsuite :suite-1 ()
  (defbefore-all "Before-all Suite-1" ()
    (print "run Before-all Suite-1"))
  (deftest "Test-1" () (print "run Test-1") (t-p t))
  (defsuite :suite-1 ()
    (defbefore-all "Before-all Suite-2" ()
      (print "run Before-all Suite-2"))
    (deftest "Test-1" () (print "run Test-2") (t-p t))))

(run :colorful t)

;;; after-all
(defsuite :suite-1 ()
  (defafter-all "After-all Suite-1" ()
    (print "run After-all Suite-1"))
  (deftest "Test-1" () (print "run Test-1") (t-p t))
  (defsuite :suite-1 ()
    (defafter-all "After-all Suite-2" ()
      (print "run After-all Suite-2"))
    (deftest "Test-1" () (print "run Test-2") (t-p t))))

(run :colorful t)

