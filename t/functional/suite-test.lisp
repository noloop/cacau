(in-package #:noloop.cacau-test)

(r-test
 :test-suite-with-suite-root-void
 (lambda (r-done)
   (let* ((runner-instance (make-runner)))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall r-done (eql 0 failing)))))
     (run-runner runner-instance))))

(r-test
 :test-suite-with-suite-root-with-suite-void
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1)))
     (add-child suite-root suite-1)
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall r-done (eql 0 failing)))))
     (run-runner runner-instance))))

