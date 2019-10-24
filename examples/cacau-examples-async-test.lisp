(defpackage #:cacau-examples-async-test
  (:use #:common-lisp
        #:assert-p
        #:cacau))
(in-package #:cacau-examples-async-test)

(defsuite :suite-1 ()
  (deftest "Test-1" ((:async done))
    (funcall done (lambda () (t-p t))))
  (deftest "Test-2" () (t-p t)))

(defsuite :suite-1 ()
  (let ((x 0))
    (defbefore-each "Before-each" ((:async done))
      (setf x 1)
      (funcall done))
    ;;; only call done
    (deftest "Test-1" ((:async done))
      (funcall done))
    ;;; passing function catch error for done
    (deftest "Test-2" ((:async done))
      (funcall done (lambda () (t-p t))))
    ;;; passing error for done
    (deftest "Test-3" ((:async done))
      (handler-case (t-p nil)
        (error (c)
          (funcall done c))))))

(run :colorful t)

