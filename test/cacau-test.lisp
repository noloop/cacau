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

(a-test :test-runner-create-test #'test-runner-create-test)
