(defpackage #:cacau-examples-skips-onlys-rules
  (:use #:common-lisp
        #:assert-p
        #:cacau))
(in-package #:cacau-examples-skips-onlys-rules)

;;; skip-test-precedes-only-test
(defsuite :suite-1 ()
  (deftest "Test-1" (:only) (t-p t)) ;; run!
  (deftest "Test-2" (:skip) (t-p t)))
(run :colorful t
     :reporter :list)
(format t "~%")

;;; skip-test-precedes-only-suite
(defsuite :suite-1 (:only) 
  (deftest "Test-1" () (t-p t)) ;; run!
  (deftest "Test-2" (:skip) (t-p t)))
(run :colorful t
     :reporter :list)
(format t "~%")

;;; skip-only-suite-not-precedes-skip-suite
(defsuite :suite-1 (:only)
  (deftest "Test-1" () (t-p t)) ;; run!
  (deftest "Test-2" () (t-p t)) ;; run!
  (defsuite :suite-2 (:skip)
    (deftest "Test-1" () (t-p t))
    (deftest "Test-2" () (t-p t))))
(run :colorful t
     :reporter :list)
(format t "~%")

;;; skip-suite-precedes-only-test
;;; Attention here! Because before the cacau is isolating the "Test-1"
;;; and after is skipping the :suite-2, so it doesn't run any test.
(defsuite :suite-1 ()
  (deftest "Test-1" () (t-p t))
  (deftest "Test-2" () (t-p t))
  (defsuite :suite-2 (:skip)
    (deftest "Test-1" (:only) (t-p t))
    (deftest "Test-2" () (t-p t))))
(run :colorful t
     :reporter :list)
(format t "~%")

;;; skip-suite-precedes-only-suite
(defsuite :suite-1 (:skip)
  (deftest "Test-1" () (t-p t))
  (deftest "Test-2" () (t-p t))
  (defsuite :suite-2 (:only)
    (deftest "Test-1" () (t-p t))
    (deftest "Test-2" () (t-p t))))
(run :colorful t
     :reporter :list)
(format t "~%")

;;; skip-suite-precedes-only-test-and-only-suite
(defsuite :suite-1 (:skip)
  (deftest "Test-1" () (t-p t))
  (deftest "Test-2" (:only) (t-p t))
  (defsuite :suite-2 (:only)
    (deftest "Test-1" () (t-p t))
    (deftest "Test-2" () (t-p t))))
(run :colorful t
     :reporter :list)

