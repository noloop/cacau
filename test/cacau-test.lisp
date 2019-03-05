(defpackage #:noloop.cacau-test
  (:use #:common-lisp)
  (:nicknames #:cacau-test)
  (:import-from #:cacau
                #:make-runner
                #:suite-root
                #:add-child
                #:create-test
                #:once-runner
                #:run-runner))
(in-package #:noloop.cacau-test)

(defun test-runner-create-test (done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance)))  
    (add-child suite-root
               (create-test runner-instance
                            :test-1
                            (lambda ()
                              (funcall done (= 1 1)))
                            '(nil nil)))
    (once-runner runner-instance :run-end (lambda () 'END!))
    (run-runner runner-instance)))

(defun async-done (test)
  (format t "Test: ~a" test))

(defun async-test (name fn)
  (declare (ignore name))
  (funcall fn #'async-done))

(defun run ()
  (async-test :test-1 #'test-runner-create-test))

