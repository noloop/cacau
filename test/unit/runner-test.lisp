(in-package #:noloop.cacau-test)


(a-test
 :test-runner-create-test-sync
 (lambda (a-done)
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
                    (funcall a-done)))
     (run-runner runner-instance))))

(a-test
 :test-runner-create-test-async
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance)))  
     (add-child suite-root
                (create-test runner-instance
                             :test-1
                             (lambda (done)
                               (funcall done a-done))))
     (once-runner runner-instance
                  :end
                  (lambda () ()))
     (run-runner runner-instance))))

(a-test
 :test-runner-create-suite
 (lambda (a-done)
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
                               (funcall done))))
     (add-child suite-1
                (create-test runner-instance
                             :test-3
                             (lambda ()
                               (= 1 1))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (funcall a-done)))
     (run-runner runner-instance))))

(a-test
 :test-runner-create-suite-recursive
 (lambda (a-done)
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
                               (funcall done))))
     (add-child suite-1 suite-2)
     (add-child suite-2
                (create-test runner-instance
                             :test-1
                             (lambda ()
                               (= 1 1))))
     (add-child suite-2
                (create-test runner-instance
                             :test-2
                             (lambda (done) 
                               (funcall done))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (funcall a-done)))
     (run-runner runner-instance))))

