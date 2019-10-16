(in-package #:noloop.cacau-test)

(a-test
 :test-after-all
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (x 0))
     (add-child suite-root suite-1)
     (create-after-all suite-1
                       :after-all-suite-1
                       (lambda ()
                         (setf x 1)))
     (add-child suite-1
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
 :test-async-after-all 
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (x 0))
     (add-child suite-root suite-1)
     (create-after-all suite-1
                       :after-all-suite-1
                       (lambda (hook-done)
                         (setf x 1)
                         (funcall hook-done)))
     (add-child suite-1
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
 :test-after-all-order 
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (suite-2 (create-suite runner-instance
                                 :suite-2))
          (x 0))
     (add-child suite-root suite-1)
     (create-after-all suite-1
                       :after-all-suite-1
                       (lambda (hook-done)
                         (setf x 1)
                         (funcall hook-done)))
     (add-child suite-1
                (create-test runner-instance
                             :test-1
                             (lambda ()
                               (eql-p x 0))))
     (add-child suite-1 suite-2)
     (create-after-all suite-2
                       :after-all-suite-2
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
 :test-after-all-recursive 
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (suite-2 (create-suite runner-instance
                                 :suite-2))
          (suite-3 (create-suite runner-instance
                                 :suite-2))
          (x 0))
     (add-child suite-root suite-1)
     (create-after-all suite-1
                       :after-all-suite-1
                       (lambda (hook-done)
                         (incf x 1)
                         (funcall hook-done)))
     (add-child suite-1
                (create-test runner-instance
                             :test-1
                             (lambda ()
                               (eql-p x 0))))
     (add-child suite-1 suite-2)
     (create-after-all suite-2
                       :after-all-suite-2
                       (lambda ()
                         (incf x 1)))
     (add-child suite-2
                (create-test runner-instance
                             :test-1
                             (lambda ()
                               (eql-p x 0))))
     (add-child suite-root
                (create-test runner-instance
                             :test-1
                             (lambda ()
                               (eql-p x 1))))
     (add-child suite-root suite-3)
     (create-after-all suite-3
                       :after-all-suite-3
                       (lambda ()
                         (incf x 1)))
     (add-child suite-3
                (create-test runner-instance
                             :test-1
                             (lambda ()
                               (eql-p x 1))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (funcall a-done (eql x 3))))
     (run-runner runner-instance))))
