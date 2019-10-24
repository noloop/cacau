(defpackage #:cacau-examples-timeout
  (:use #:common-lisp
        #:assert-p
        #:cacau))
(in-package #:cacau-examples-timeout)

;;; timeout-in-suites
(defsuite :suite-1 ((:timeout 0))
  (deftest "Test-1" () (t-p t)) ;; Timeout Error: Time(0) extrapolated!
  (deftest "Test-2" () (t-p t))) ;; Timeout Error: Time(0) extrapolated!

(run :colorful t
     :reporter :full)

;;; timeout-in-hooks
(defsuite :suite-1 ()
  (defbefore-all "Before-all" ((:timeout 0))) ;; Timeout Error: Time(0) extrapolated!
  (deftest "Test-1" () (t-p t))
  (deftest "Test-2" () (t-p t)))

(run :colorful t
     :reporter :full)

;;; timeout-in-tests
(defsuite :suite-1 ()
  (deftest "Test-1" ((:timeout 0)) (t-p t)) ;; Timeout Error: Time(0) extrapolated!
  (deftest "Test-2" () (t-p t)))

(run :colorful t
     :reporter :full)

;;; timeout-in-tests-with-suites-timeout-configured
(defsuite :suite-1 ((:timeout 0))
  (deftest "Test-1" () (t-p t))   ;; Timeout Error: Time(0) extrapolated!
  (deftest "Test-2" () (t-p t))   ;; Timeout Error: Time(0) extrapolated!
  (defsuite :suite-2 ((:timeout 50000))
    (deftest "Test-1" ((:timeout 0)) (t-p t)) ;; Timeout Error: Time(0) extrapolated!
    (deftest "Test-2" () (t-p t))))

(run :colorful t
     :reporter :full)

