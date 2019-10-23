(in-package #:noloop.cacau-test)

(r-test
 :test-failing-async-test-done-whitout-arg
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (test-1 nil)
          (test-2 nil))
     (add-child suite-root suite-1)
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda (done)
                                     (funcall done (lambda () (t-p nil)))))))
     (setf test-2
           (add-child suite-1
                      (create-test runner-instance
                                   :test-2
                                   (lambda () (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((passing
                            (gethash :passing (result runner-instance))))
                      (funcall r-done (eql 1 passing)))))
     (run-runner runner-instance))))

(r-test
 :test-failing-async-test-done-whit-arg-function
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (test-1 nil)
          (test-2 nil))
     (add-child suite-root suite-1)
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (t-p t)))))
     (setf test-2
           (add-child suite-1
                      (create-test runner-instance
                                   :test-2
                                   (lambda (done)
                                     (funcall done (lambda () (t-p nil)))))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((passing
                            (gethash :passing (result runner-instance))))
                      (funcall r-done (eql 1 passing)))))
     (run-runner runner-instance))))

(r-test
 :test-failing-async-test-done-whit-arg-error
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (test-1 nil)
          (test-2 nil))
     (add-child suite-root suite-1)
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (t-p t)))))
     (setf test-2
           (add-child suite-1
                      (create-test runner-instance
                                   :test-2
                                   (lambda (done)
                                     (handler-case (t-p nil)
                                       (error (c)
                                         (funcall done c)))))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((passing
                            (gethash :passing (result runner-instance))))
                      (funcall r-done (eql 1 passing)))))
     (run-runner runner-instance))))

