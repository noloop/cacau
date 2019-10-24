(defpackage #:cacau-examples-async-test
  (:use #:common-lisp
        #:assert-p
        #:cacau))
(in-package #:cacau-examples-async-test)

(handler-case (t-p nil)
  (error (c)
    (defparameter err c)))

(defsuite :suite-1 ()
  (deftest "Test-1" ((:async done))
    (funcall done (lambda () (t-p t))))
  (deftest "Test-2" () (t-p t)))

(defsuite :suite-1 ()
  (let ((x 0))
    ;;; only call done
    (defbefore-each "Before-each" ((:async done))
      (setf x 1)
      (funcall done))
    ;; ;;; passing function catch error for done
    ;; (defafter-each "Before-each" ((:async done))
    ;;   (funcall done (lambda () (setf x 1))))
    ;;; passing error for done
    ;; (defafter-all "after-all" ((:async done))
    ;;   (handler-case (t-p nil)
    ;;     (error (c)
    ;;       (funcall done c))))
    ;;; only call done
    (deftest "Test-1" ((:async done))
      (funcall done))
    ;;; passing function catch error for done
    (deftest "Test-2" ((:async done))
      (funcall done (lambda () (t-p t))))
    passing error for done
    (deftest "Test-3" ((:async done))
      (funcall done err))
    ))

(run :colorful t
     :reporter :full)

