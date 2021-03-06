(in-package #:noloop.cacau-test)

(r-test
 :test-before-each 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (x 0))
     (add-child suite-root suite-1)
     (create-before-each suite-1
                         :before-each-suite-1
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
                      (funcall r-done (eql 0 failing)))))
     (run-runner runner-instance))))

(r-test
 :test-async-before-each 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (x 0))
     (add-child suite-root suite-1)
     (create-before-each suite-1
                         :before-each-suite-1
                         (lambda (done-hook)
                           (setf x 0)
                           (funcall done-hook))
			 :async-p t)
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
                      (funcall r-done (eql 0 failing)))))
     (run-runner runner-instance))))

(r-test
 :test-before-each-recursive
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (suite-2 (create-suite runner-instance
                                 :suite-2))
          (x 0))
     (add-child suite-root suite-1)
     (create-before-each suite-1
                         :before-each-suite-1
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
                         :before-each-suite-2
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
                      (funcall r-done (eql 0 failing)))))
     (run-runner runner-instance))))

