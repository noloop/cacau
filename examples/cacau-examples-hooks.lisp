(defpackage #:cacau-examples-hooks
  (:use #:common-lisp
        #:assert-p
        #:cacau))
(in-package #:cacau-examples-hooks)

(defbefore-all "Before-all" () (format t ":suite-root's before-all~%"))
(defbefore-each "Before-each" () (format t ":suite-root's before-each~%"))
(defafter-each "After-each" () (format t ":suite-root's after-each~%"))
(defafter-all "After-all" () (format t ":suite-root's after-all~%~%"))

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
(format t "~%")

;;;; hooks inheritance
;;;; ------------------------------------
;;; before-each
(defsuite :suite-1 ()
  (defbefore-each "Before-each Suite-1" ()
    (format t "run Before-each Suite-1~%"))
  (deftest "Test-1" () (format t "run Test-1~%") (t-p t))
  (defsuite :suite-1 ()
    (defbefore-each "Before-each Suite-2" ()
      (format t "run Before-each Suite-2~%"))
    (deftest "Test-1" () (format t "run Test-2~%~%") (t-p t))))

(run :colorful t)
(format t "~%")

;;; after-each
(defsuite :suite-1 ()
  (defafter-each "After-each Suite-1" ()
    (format t "run After-each Suite-1~%~%"))
  (deftest "Test-1" () (format t "run Test-1~%") (t-p t))
  (defsuite :suite-1 ()
    (defafter-each "After-each Suite-2" ()
      (format t "run After-each Suite-2~%"))
    (deftest "Test-1" () (format t "run Test-2~%") (t-p t))))

(run :colorful t)
(format t "~%")

;;;; hooks not inheritance
;;;; ------------------------------------
;;; before-all
(defsuite :suite-1 ()
  (defbefore-all "Before-all Suite-1" ()
    (format t "run Before-all Suite-1~%"))
  (deftest "Test-1" () (format t "run Test-1~%") (t-p t))
  (defsuite :suite-1 ()
    (defbefore-all "Before-all Suite-2" ()
      (format t "run Before-all Suite-2~%"))
    (deftest "Test-1" () (format t "run Test-2~%~%") (t-p t))))

(run :colorful t)
(format t "~%")

;;; after-all
(defsuite :suite-1 ()
  (defafter-all "After-all Suite-1" ()
    (format t "run After-all Suite-1~%~%"))
  (deftest "Test-1" () (format t "run Test-1~%") (t-p t))
  (defsuite :suite-1 ()
    (defafter-all "After-all Suite-2" ()
      (format t "run After-all Suite-2~%"))
    (deftest "Test-1" () (format t "run Test-2~%") (t-p t))))

(run :colorful t)

