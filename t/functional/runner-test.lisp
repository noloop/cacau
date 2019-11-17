(in-package #:noloop.cacau-test)

(r-test
 :test-runner-create-test-sync
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance)))
     (add-child suite-root
                (create-test runner-instance
                             :test-1
                             (lambda ()
                               (= 1 1))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (funcall r-done)))
     (run-runner runner-instance))))

(r-test
 :test-runner-create-test-async
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance)))  
     (add-child suite-root
                (create-test runner-instance
                             :test-1
                             (lambda (done)
                               (funcall done (lambda ()
                                               (funcall r-done))))
			     :async-p t))
     (once-runner runner-instance
                  :end
                  (lambda () ()))
     (run-runner runner-instance))))

(r-test
 :test-runner-create-suite
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1)))
     (add-child suite-root suite-1)
     (add-child suite-1
                (create-test runner-instance
                             :test-1
                             (lambda ()
                               (= 1 1))))
     (add-child suite-1
                (create-test runner-instance
                             :test-2
                             (lambda (done)
                               (funcall done))
			     :async-p t))
     (add-child suite-1
                (create-test runner-instance
                             :test-3
                             (lambda ()
                               (= 1 1))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (funcall r-done)))
     (run-runner runner-instance))))

(r-test
 :test-runner-create-suite-recursive
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (suite-2 (create-suite runner-instance
                                 :suite-2)))
     (add-child suite-root suite-1)
     (add-child suite-1
                (create-test runner-instance
                             :test-1
                             (lambda ()
                               (= 1 1))))
     (add-child suite-1
                (create-test runner-instance
                             :test-2
                             (lambda (done)
                               (funcall done))
			     :async-p t))
     (add-child suite-1 suite-2)
     (add-child suite-2
                (create-test runner-instance
                             :test-1
                             (lambda ()
                               (= 1 1))
			     :async-p nil))
     (add-child suite-2
                (create-test runner-instance
                             :test-2
                             (lambda (done) 
                               (funcall done))
			     :async-p t))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (funcall r-done)))
     (run-runner runner-instance))))

