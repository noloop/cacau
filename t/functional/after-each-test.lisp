(in-package #:noloop.cacau-test)

(a-test
 :test-after-each
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (x 0))
     (add-child suite-root suite-1)
     (create-after-each suite-1
                        :after-each-suite-1
                        (lambda ()
                          (setf x 0)))
     (add-child suite-1
                (create-test runner-instance
                             :test-1
                             (lambda ()
                               (incf x 1)
                               (eql-p x 1))))
     (add-child suite-1
                (create-test runner-instance
                             :test-2
                             (lambda ()
                               (incf x 1)
                               (eql-p x 1))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (funcall a-done (eql x 0))))
     (run-runner runner-instance))))

(a-test
 :test-async-after-each 
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (x 0))
     (add-child suite-root suite-1)
     (create-after-each suite-1
                        :after-each-suite-1
                        (lambda (done-hook)
                          (setf x 0)
                          (funcall done-hook)))
     (add-child suite-1
                (create-test runner-instance
                             :test-1
                             (lambda ()
                               (incf x 1)
                               (eql-p x 1))))
     (add-child suite-1
                (create-test runner-instance
                             :test-2
                             (lambda ()
                               (incf x 1)
                               (eql-p x 1))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (funcall a-done (eql x 0))))
     (run-runner runner-instance))))

(a-test
 :test-after-each-order 
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (suite-2 (create-suite runner-instance
                                 :suite-2))
          (x 0))
     (add-child suite-root suite-1)
     (create-after-each suite-1
                        :after-each-suite-1
                        (lambda (hook-done)
                          (setf x 1)
                          (funcall hook-done)))
     (add-child suite-1
                (create-test runner-instance
                             :test-1
                             (lambda ()
                               (eql-p x 0))))
     (add-child suite-1 suite-2)
     (create-after-each suite-2
                        :after-each-suite-2
                        (lambda ()
                          (setf x 2)))
     (add-child suite-2
                (create-test runner-instance
                             :test-1
                             (lambda ()
                               (eql-p x 0))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (funcall a-done (eql x 1))))
     (run-runner runner-instance))))

(a-test
 :test-after-each-recursive 
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (suite-2 (create-suite runner-instance
                                 :suite-2))
          (x 0))
     (add-child suite-root suite-1)
     (create-after-each suite-1
                        :after-each-suite-1
                        (lambda (done-hook)
                          (incf x 1)
                          (funcall done-hook)))
     (add-child suite-1
                (create-test runner-instance
                             :test-1
                             (lambda ()
                               (incf x 1)
                               (eql-p x 1))))
     (add-child suite-1
                (create-test runner-instance
                             :test-2
                             (lambda ()
                               (incf x 1)
                               (eql-p x 3))))
     (add-child suite-1 suite-2)
     (create-after-each suite-2
                        :after-each-suite-2
                        (lambda ()
                          (setf x 0)))
     (add-child suite-2
                (create-test runner-instance
                             :test-1
                             (lambda (done-test)
                               (incf x 1)
                               (funcall done-test
                                        (lambda ()
                                          (eql-p x 5))))))
     (add-child suite-2
                (create-test runner-instance
                             :test-2
                             (lambda ()
                               (incf x 1))))
     (add-child suite-1
                (create-test runner-instance
                             :test-3
                             (lambda ()
                               (incf x 1)
                               (eql-p x 2))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (funcall a-done (eql x 3))))
     (run-runner runner-instance))))

