(defpackage #:cacau-examples-reporters
  (:use #:common-lisp
        #:assert-p
        #:cacau))
(in-package #:cacau-examples-reporters)

;;; :min
(defsuite :suite-1 ()
  (deftest "Test-1" () (t-p t))
  (deftest "Test-2" (:skip) (t-p t))
  (deftest "Test-3" () (t-p nil)))

(run :colorful t) ;; or (run :colorful t :reporter :min)

;;; :list
(defsuite :suite-1 ()
  (deftest "Test-1" () (t-p t))
  (deftest "Test-2" (:skip) (t-p t))
  (deftest "Test-3" () (t-p nil)))

(run :colorful t :reporter :list)

;;; :full
(defsuite :suite-1 ()
  (deftest "Test-1" () (t-p t))
  (deftest "Test-2" () (t-p t))
  (deftest "Test-3" () (t-p nil)))

(run :colorful t :reporter :full)

;;; :full with :reporter-options
(defsuite :suite-1 ()
  (deftest "Test-1" () (t-p t))
  (deftest "Test-2" () (t-p t))
  (deftest "Test-3" () (t-p nil)))

(run :colorful t
     :reporter :full
     :reporter-options
     ;; You can hide any options below
     ;; or change your order.
     '(:tests-list
       (:epilogue
        (:running-suites
         :running-tests
         :only-suites
         :only-tests
         :skip-suites
         :skip-tests
         :total-suites
         :total-tests
         :passing
         :failing
         :errors
         :run-start
         :run-end
         :run-duration
         :completed-suites
         :completed-tests))
       :stack))

