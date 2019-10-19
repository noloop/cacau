(in-package #:noloop.cacau-test)

(r-test
 :test-skip-only-rule-skip-test-precedes-only-test  
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
                                   (lambda () (t-p nil))
                                   :only-p t)))
     (setf test-2
           (add-child suite-1
                      (create-test runner-instance
                                   :test-2
                                   (lambda () (t-p nil))
                                   :skip-p t)))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance)))
                          (only-tests
                            (gethash :only-tests (result runner-instance)))
                          (skip-tests
                            (gethash :skip-tests (result runner-instance))))
                      (funcall r-done (and (eql 1 only-tests)
                                           (eql 1 skip-tests)
                                           (eql 1 failing))))))
     (run-runner runner-instance))))

(r-test
 :test-skip-only-rule-skip-test-precedes-only-test-recursive  
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (suite-2 (create-suite runner-instance
                                 :suite-2))
          (test-1 nil)
          (test-2 nil)
          (test-3 nil))
     (add-child suite-root suite-1)
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda () (t-p nil))
                                   :only-p t)))
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
                                   :skip-p t)))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance)))
                          (only-tests
                            (gethash :only-tests (result runner-instance)))
                          (skip-tests
                            (gethash :skip-tests (result runner-instance))))
                      (funcall r-done (and (eql 1 only-tests)
                                           (eql 1 skip-tests)
                                           (eql 1 failing))))))
     (run-runner runner-instance))))

(r-test
 :test-skip-only-rule-skip-test-precedes-only-suite  
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1
                                 :only-p t))
          (suite-2 (create-suite runner-instance
                                 :suite-2))
          (test-1 nil)
          (test-2 nil)
          (test-3 nil))
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
                                   :skip-p t)))
     (add-child suite-1 suite-2)
     (setf test-3
           (add-child suite-2
                      (create-test runner-instance
                                   :test-3
                                   (lambda () (t-p nil))
                                   :skip-p t)))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance)))
                          (only-suites
                            (gethash :only-suites (result runner-instance)))
                          (skip-tests
                            (gethash :skip-tests (result runner-instance))))
                      (funcall r-done (and (eql 1 only-suites)
                                           (eql 2 skip-tests)
                                           (eql 1 failing))))))
     (run-runner runner-instance))))

(r-test
 :test-skip-only-rule-skip-only-suite-not-precedes-skip-suite  
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1
                                 :only-p t))
          (suite-2 (create-suite runner-instance
                                 :suite-2
                                 :skip-p t))
          (test-1 nil)
          (test-2 nil)
          (test-3 nil))
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
                                   :skip-p t)))
     (add-child suite-1 suite-2)
     (setf test-3
           (add-child suite-2
                      (create-test runner-instance
                                   :test-3
                                   (lambda () (t-p nil)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance)))
                          (only-suites
                            (gethash :only-suites (result runner-instance)))
                          (skip-tests
                            (gethash :skip-tests (result runner-instance)))
                          (skip-suites
                            (gethash :skip-suites (result runner-instance))))
                      (funcall r-done (and (eql 1 only-suites)
                                           (eql 1 skip-tests)
                                           (eql 1 skip-suites)
                                           (eql 1 failing))))))
     (run-runner runner-instance))))

(r-test
 :test-skip-only-rule-skip-suite-precedes-only-test  
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1
                                 :skip-p t))
          (suite-2 (create-suite runner-instance
                                 :suite-2))
          (test-1 nil)
          (test-2 nil)
          (test-3 nil))
     (add-child suite-root suite-1)
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda () (t-p nil))
                                   :only-p t)))
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
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance)))
                          (skip-suites
                            (gethash :skip-suites (result runner-instance))))
                      (funcall r-done (and (eql 1 skip-suites)
                                           (eql 0 failing))))))
     (run-runner runner-instance))))

(r-test
 :test-skip-only-rule-skip-suite-precedes-only-suite  
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1
                                 :skip-p t))
          (suite-2 (create-suite runner-instance
                                 :suite-2
                                 :only-p t))
          (test-1 nil)
          (test-2 nil)
          (test-3 nil))
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
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance)))
                          (skip-suites
                            (gethash :skip-suites (result runner-instance))))
                      (funcall r-done (and (eql 1 skip-suites)
                                           (eql 0 failing))))))
     (run-runner runner-instance))))

(r-test
 :test-skip-only-rule-skip-suite-precedes-only-test-and-only-suite  
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1
                                 :only-p t))
          (suite-2 (create-suite runner-instance
                                 :suite-2
                                 :skip-p t))
          (test-1 nil)
          (test-2 nil)
          (test-3 nil))
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
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance)))
                          (only-suites
                            (gethash :only-suites (result runner-instance)))
                          (skip-suites
                            (gethash :skip-suites (result runner-instance))))
                      (funcall r-done (and (eql 1 only-suites)
                                           (eql 1 skip-suites)
                                           (eql 2 failing))))))
     (run-runner runner-instance))))

