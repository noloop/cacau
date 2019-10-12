(in-package #:noloop.cacau-test)

(a-test
 :test-before-each 
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (x 0))
     (add-child suite-root suite-1)
     (create-before-each suite-1
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
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall a-done (eql 0 failing)))))
     (run-runner runner-instance))))

(a-test
 :test-async-before-each 
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (x 0))
     (add-child suite-root suite-1)
     (create-before-each suite-1
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
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall a-done (eql 0 failing)))))
     (run-runner runner-instance))))

(a-test
 :test-before-each-recursive
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (suite-2 (create-suite runner-instance
                                 :suite-2))
          (x 0))
     (add-child suite-root suite-1)
     (create-before-each suite-1
                         :hook-suite-1
                         (lambda ()
                           (setf x 0)))
     (add-child suite-1
                (create-test runner-instance
                             :suite-1-test-1
                             (lambda ()
                               (incf x 1)
                               (eql-p x 1))))
     (add-child suite-1
                (create-test runner-instance
                             :suite-1-test-2
                             (lambda ()
                               (incf x 1)
                               (eql-p x 1))))
     (add-child suite-1 suite-2)
     (create-before-each suite-2
                         :hook-suite-2
                         (lambda ()
                           (incf x 1)))
     (add-child suite-2
                (create-test runner-instance
                             :suite-2-test-1
                             (lambda ()
                               (incf x 1)
                               (eql-p x 2))))
     (add-child suite-2
                (create-test runner-instance
                             :suite-2-test-2
                             (lambda ()
                               (incf x 1)
                               (eql-p x 2))))
     (add-child suite-1
                (create-test runner-instance
                             :suite-1-test-3
                             (lambda ()
                               (incf x 1)
                               (eql-p x 1))))
     (add-child suite-root
                (create-test runner-instance
                             :suite-root-test-1
                             (lambda ()
                               (incf x 1)
                               (eql-p x 2))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall a-done (eql 0 failing)))))
     (run-runner runner-instance))))

