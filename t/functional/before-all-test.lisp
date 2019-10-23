(in-package #:noloop.cacau-test)

(r-test
 :test-before-all
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (x 0))
     (add-child suite-root suite-1)
     (create-before-all suite-1
                        :before-all-suite-1
                        (lambda ()
                          (setf x 1)))
     (add-child suite-1
                (create-test runner-instance
                             :test-1
                             (lambda ()
                               (eql-p x 1))))
     (add-child suite-1
                (create-test runner-instance
                             :test-2
                             (lambda ()
                               (eql-p x 1))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall r-done (eql 0 failing)))))
     (run-runner runner-instance))))

(r-test
 :test-async-before-all
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (x 0))
     (add-child suite-root suite-1)
     (create-before-all suite-1
                        :before-all-suite-1
                        (lambda (done-hook)
                          (funcall done-hook (lambda ()
                                               (setf x 1)))))
     (add-child suite-1
                (create-test runner-instance
                             :test-1
                             (lambda ()
                               (eql-p x 1))))
     (add-child suite-1
                (create-test runner-instance
                             :test-2
                             (lambda ()
                               (eql-p x 1))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall r-done (eql 0 failing)))))
     (run-runner runner-instance))))

(r-test
 :test-before-all-recursive
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (suite-2 (create-suite runner-instance
                                 :suite-2))
          (x 0))
     (add-child suite-root suite-1)
     (create-before-all suite-1
                        :before-all-suite-1
                        (lambda (done-hook)
                          (setf x 1)
                          (funcall done-hook)))
     (add-child suite-1
                (create-test runner-instance
                             :test-1
                             (lambda ()
                               (eql-p x 1))))
     (add-child suite-1
                (create-test runner-instance
                             :test-2
                             (lambda ()
                               (eql-p x 1))))
     (add-child suite-1 suite-2)
     (create-before-all suite-2
                        :before-all-suite-2
                        (lambda (done-hook)
                          (incf x)
                          (funcall done-hook)))
     (add-child suite-2
                (create-test runner-instance
                             :test-1
                             (lambda ()
                               (eql-p x 2))))
     (add-child suite-2
                (create-test runner-instance
                             :test-2
                             (lambda ()
                               (eql-p x 2))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall r-done (eql 0 failing)))))
     (run-runner runner-instance))))

