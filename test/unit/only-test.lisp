(in-package #:noloop.cacau-test)

(a-test
 :test-not-only-test
 (lambda (a-done)
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
                                   (lambda () (t-p t)))))
     (setf test-2
           (add-child suite-1
                      (create-test runner-instance
                                   :test-2
                                   (lambda () (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((completed-tests
                            (gethash :completed-tests (result runner-instance))))
                      (funcall a-done (eql 2 completed-tests)))))
     (run-runner runner-instance))))

(a-test
 :test-only-test 
 (lambda (a-done)
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
                                     (t-p nil)))))
     (setf test-2
           (add-child suite-1
                      (create-test runner-instance
                                   :test-2
                                   (lambda ()
                                     (t-p nil))
                                   :only-p t)))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall a-done (eql 1 failing)))))
     (run-runner runner-instance))))

(a-test
 :test-only-test-with-two-only-tests 
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (test-1 nil)
          (test-2 nil)
          (test-3 nil))
     (add-child suite-root suite-1)
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (t-p nil))
                                   :only-p t)))
     (setf test-2
           (add-child suite-1
                      (create-test runner-instance
                                   :test-2
                                   (lambda ()
                                     (t-p nil)))))
     (setf test-3
           (add-child suite-1
                      (create-test runner-instance
                                   :test-3
                                   (lambda ()
                                     (t-p nil))
                                   :only-p t)))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall a-done (eql 2 failing)))))
     (run-runner runner-instance))))

(a-test
 :test-only-test-recursive-with-three-only-tests 
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (suite-2 (create-suite runner-instance
                                 :suite-2))
          (test-1 nil)
          (test-2 nil)
          (test-3 nil)
          (test-4 nil)
          (test-5 nil))
     (add-child suite-root suite-1)
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (t-p nil))
                                   :only-p t)))
     (setf test-2
           (add-child suite-1
                      (create-test runner-instance
                                   :test-2
                                   (lambda ()
                                     (t-p nil)))))
     (add-child suite-1 suite-2)
     (setf test-4
           (add-child suite-2
                      (create-test runner-instance
                                   :test-4
                                   (lambda ()
                                     (t-p nil))
                                   :only-p t)))
     (setf test-5
           (add-child suite-2
                      (create-test runner-instance
                                   :test-5
                                   (lambda ()
                                     (t-p nil)))))
     (setf test-3
           (add-child suite-1
                      (create-test runner-instance
                                   :test-3
                                   (lambda ()
                                     (t-p nil))
                                   :only-p t)))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall a-done (eql 3 failing)))))
     (run-runner runner-instance))))

(a-test
 :test-only-test-recursive-with-two-suites-in-suite-root 
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (suite-2 (create-suite runner-instance
                                 :suite-2))
          (suite-3 (create-suite runner-instance
                                 :suite-3))
          (test-1 nil)
          (test-2 nil)
          (test-3 nil)
          (test-4 nil)
          (test-5 nil)
          (test-6 nil))
     (add-child suite-root suite-1)
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (t-p nil))
                                   :only-p t)))
     (setf test-2
           (add-child suite-1
                      (create-test runner-instance
                                   :test-2
                                   (lambda ()
                                     (t-p nil)))))
     (add-child suite-1 suite-2)
     (setf test-4
           (add-child suite-2
                      (create-test runner-instance
                                   :test-4
                                   (lambda ()
                                     (t-p nil))
                                   :only-p t)))
     (setf test-5
           (add-child suite-2
                      (create-test runner-instance
                                   :test-5
                                   (lambda ()
                                     (t-p nil)))))
     (setf test-3
           (add-child suite-1
                      (create-test runner-instance
                                   :test-3
                                   (lambda ()
                                     (t-p nil))
                                   :only-p t)))
     (add-child suite-root suite-3)
     (setf test-6
           (add-child suite-3
                      (create-test runner-instance
                                   :test-6
                                   (lambda ()
                                     (t-p nil))
                                   :only-p t)))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall a-done (eql 4 failing)))))
     (run-runner runner-instance))))

(a-test
 :test-only-suite 
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1
                                 :only-p t))
          (test-1 nil)
          (test-2 nil))
     (add-child suite-root suite-1)
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda () (t-p nil)))))
     (setf test-2
           (add-child suite-1
                      (create-test runner-instance
                                   :test-2
                                   (lambda () (t-p nil)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall a-done (eql 2 failing)))))
     (run-runner runner-instance))))

(a-test
 :test-only-suite-recursive 
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1
                                 :only-p t))
          (suite-2 (create-suite runner-instance
                                 :suite-2))
          (suite-3 (create-suite runner-instance
                                 :suite-3))
          (test-1 nil)
          (test-2 nil)
          (test-3 nil)
          (test-4 nil)
          (test-5 nil))
     (add-child suite-root suite-1)
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda () (t-p nil)))))
     (setf test-2
           (add-child suite-1
                      (create-test runner-instance
                                   :test-2
                                   (lambda () (t-p nil)))))
     (add-child suite-1 suite-2)
     (setf test-3
           (add-child suite-2
                      (create-test runner-instance
                                   :test-3
                                   (lambda () (t-p nil)))))
     (setf test-4
           (add-child suite-1
                      (create-test runner-instance
                                   :test-4
                                   (lambda () (t-p nil)))))
     (add-child suite-root suite-3)
     (setf test-5
           (add-child suite-3
                      (create-test runner-instance
                                   :test-5
                                   (lambda () (t-p nil)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall a-done (eql 4 failing)))))
     (run-runner runner-instance))))

(a-test
 :test-only-suite-recursive-with-one-only-test 
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (suite-2 (create-suite runner-instance
                                 :suite-2))
          (suite-3 (create-suite runner-instance
                                 :suite-3))
          (test-1 nil)
          (test-2 nil)
          (test-3 nil)
          (test-4 nil)
          (test-5 nil))
     (add-child suite-root suite-1)
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda () (t-p nil)))))
     (setf test-2
           (add-child suite-1
                      (create-test runner-instance
                                   :test-2
                                   (lambda () (t-p nil)))))
     (add-child suite-1 suite-2)
     (setf test-3
           (add-child suite-2
                      (create-test runner-instance
                                   :test-3
                                   (lambda () (t-p nil)))))
     (setf test-4
           (add-child suite-1
                      (create-test runner-instance
                                   :test-4
                                   (lambda () (t-p nil))
                                   :only-p t)))
     (add-child suite-root suite-3)
     (setf test-5
           (add-child suite-3
                      (create-test runner-instance
                                   :test-5
                                   (lambda () (t-p nil)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall a-done (eql 1 failing)))))
     (run-runner runner-instance))))

(a-test
 :test-only-suite-recursive-with-two-only-test 
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (suite-2 (create-suite runner-instance
                                 :suite-2))
          (suite-3 (create-suite runner-instance
                                 :suite-3))
          (test-1 nil)
          (test-2 nil)
          (test-3 nil)
          (test-4 nil)
          (test-5 nil))
     (add-child suite-root suite-1)
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda () (t-p nil)))))
     (setf test-2
           (add-child suite-1
                      (create-test runner-instance
                                   :test-2
                                   (lambda () (t-p nil)))))
     (add-child suite-1 suite-2)
     (setf test-3
           (add-child suite-2
                      (create-test runner-instance
                                   :test-3
                                   (lambda () (t-p nil))
                                   :only-p t)))
     (setf test-4
           (add-child suite-1
                      (create-test runner-instance
                                   :test-4
                                   (lambda () (t-p nil)))))
     (add-child suite-root suite-3)
     (setf test-5
           (add-child suite-3
                      (create-test runner-instance
                                   :test-5
                                   (lambda () (t-p nil))
                                   :only-p t)))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall a-done (eql 2 failing)))))
     (run-runner runner-instance))))

(a-test
 :test-only-suite-recursive-with-two-only-suite 
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1
                                 :only-p t))
          (suite-2 (create-suite runner-instance
                                 :suite-2))
          (suite-3 (create-suite runner-instance
                                 :suite-3))
          (suite-4 (create-suite runner-instance
                                 :suite-4
                                 :only-p t))
          (test-1 nil)
          (test-2 nil)
          (test-3 nil)
          (test-4 nil)
          (test-5 nil)
          (test-6 nil))
     (add-child suite-root suite-1)
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda () (t-p nil)))))
     (setf test-2
           (add-child suite-1
                      (create-test runner-instance
                                   :test-2
                                   (lambda () (t-p nil)))))
     (add-child suite-1 suite-2)
     (setf test-3
           (add-child suite-2
                      (create-test runner-instance
                                   :test-3
                                   (lambda () (t-p nil)))))
     (setf test-4
           (add-child suite-1
                      (create-test runner-instance
                                   :test-4
                                   (lambda () (t-p nil)))))
     (add-child suite-root suite-3)
     (setf test-5
           (add-child suite-3
                      (create-test runner-instance
                                   :test-5
                                   (lambda () (t-p nil)))))
     (add-child suite-3 suite-4)
     (setf test-6
           (add-child suite-4
                      (create-test runner-instance
                                   :test-6
                                   (lambda () (t-p nil)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall a-done (eql 5 failing)))))
     (run-runner runner-instance))))

(a-test
 :test-only-suite-recursive-with-two-only-suite-and-three-only-test 
 (lambda (a-done) 
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (suite-2 (create-suite runner-instance
                                 :suite-2
                                 :only-p t))
          (suite-3 (create-suite runner-instance
                                 :suite-3))
          (suite-4 (create-suite runner-instance
                                 :suite-4
                                 :only-p t))
          (test-1 nil)
          (test-2 nil)
          (test-3 nil)
          (test-4 nil)
          (test-5 nil)
          (test-6 nil))
     (add-child suite-root suite-1)
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda () (t-p nil)))))
     (setf test-2
           (add-child suite-1
                      (create-test runner-instance
                                   :test-2
                                   (lambda () (t-p nil))
                                   :only-p t)))
     (add-child suite-1 suite-2)
     (setf test-3
           (add-child suite-2
                      (create-test runner-instance
                                   :test-3
                                   (lambda () (t-p nil))
                                   :only-p t)))
     (setf test-4
           (add-child suite-1
                      (create-test runner-instance
                                   :test-4
                                   (lambda () (t-p nil)))))
     (add-child suite-root suite-3)
     (setf test-5
           (add-child suite-3
                      (create-test runner-instance
                                   :test-5
                                   (lambda () (t-p nil)))))
     (add-child suite-3 suite-4)
     (setf test-6
           (add-child suite-4
                      (create-test runner-instance
                                   :test-6
                                   (lambda () (t-p nil))
                                   :only-p t)))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall a-done (eql 3 failing)))))
     (run-runner runner-instance))))

