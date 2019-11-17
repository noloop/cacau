(in-package #:noloop.cacau-test)

(r-test
 :test-timeout-test
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (test-1 nil))
     (add-child suite-root suite-1)
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t))
                                   :timeout 0)))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall r-done (eql 1 failing)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-suite 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1
                                 :timeout 0))
          (test-1 nil))
     (add-child suite-root suite-1)
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall r-done (eql 1 failing)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-suite-with-three-tests 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1
                                 :timeout 0))
          (test-1 nil)
          (test-2 nil)
          (test-3 nil))
     (add-child suite-root suite-1)
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (setf test-2
           (add-child suite-1
                      (create-test runner-instance
                                   :test-2
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (setf test-3
           (add-child suite-1
                      (create-test runner-instance
                                   :test-3
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall r-done (eql 3 failing)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-suite-recursive-with-five-tests 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1
                                 :timeout 0))
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
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (setf test-2
           (add-child suite-1
                      (create-test runner-instance
                                   :test-2
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (add-child suite-1 suite-2)
     (setf test-3
           (add-child suite-2
                      (create-test runner-instance
                                   :test-3
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (setf test-4
           (add-child suite-2
                      (create-test runner-instance
                                   :test-4
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (setf test-5
           (add-child suite-1
                      (create-test runner-instance
                                   :test-5
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall r-done (eql 5 failing)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-suite-recursive-with-five-tests-one-test-reconfigured 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1
                                 :timeout 0))
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
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (setf test-2
           (add-child suite-1
                      (create-test runner-instance
                                   :test-2
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (add-child suite-1 suite-2)
     (setf test-3
           (add-child suite-2
                      (create-test runner-instance
                                   :test-3
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (setf test-4
           (add-child suite-2
                      (create-test runner-instance
                                   :test-4
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t))
                                   :timeout 50000)))
     (setf test-5
           (add-child suite-1
                      (create-test runner-instance
                                   :test-5
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall r-done (eql 4 failing)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-suite-recursive-with-five-tests-suite-2-reconfigured 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1
                                 :timeout 0))
          (suite-2 (create-suite runner-instance
                                 :suite-2
                                 :timeout 50000))
         
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
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (setf test-2
           (add-child suite-1
                      (create-test runner-instance
                                   :test-2
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (add-child suite-1 suite-2)
     (setf test-3
           (add-child suite-2
                      (create-test runner-instance
                                   :test-3
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (setf test-4
           (add-child suite-2
                      (create-test runner-instance
                                   :test-4
                                   (lambda () 
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (setf test-5
           (add-child suite-1
                      (create-test runner-instance
                                   :test-5
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall r-done (eql 3 failing)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-suite-recursive-with-five-tests-suite-2-reconfigured-with-one-test-reconfigured 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1
                                 :timeout 0))
          (suite-2 (create-suite runner-instance
                                 :suite-2
                                 :timeout 50000))
         
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
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (setf test-2
           (add-child suite-1
                      (create-test runner-instance
                                   :test-2
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (add-child suite-1 suite-2)
     (setf test-3
           (add-child suite-2
                      (create-test runner-instance
                                   :test-3
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t))
                                   :timeout 0)))
     (setf test-4
           (add-child suite-2
                      (create-test runner-instance
                                   :test-4
                                   (lambda () 
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (setf test-5
           (add-child suite-1
                      (create-test runner-instance
                                   :test-5
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall r-done (eql 4 failing)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-before-all 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (test-1 nil)
          (before-all-suite-1 nil))
     (add-child suite-root suite-1)
     (setf before-all-suite-1
           (create-before-all suite-1
                              :before-all-suite-1
                              (lambda ()
                                (loop for i upto 10 collect i))
                              :timeout 0))
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((errors
                            (gethash :errors (result runner-instance))))
                      (funcall r-done (> (length errors) 0)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-before-all-with-tests-in-suite-root 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (test-1 nil)
          (before-all-suite-root nil))
     (setf before-all-suite-root
           (create-before-all suite-root
                              :before-all-suite-root
                              (lambda ()
                                (loop for i upto 10 collect i))
                              :timeout 0))
     (setf test-1
           (add-child suite-root
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((errors
                            (gethash :errors (result runner-instance))))
                      (funcall r-done (> (length errors) 0)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-async-before-all 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (test-1 nil)
          (before-all-suite-1 nil))
     (add-child suite-root suite-1)
     (setf before-all-suite-1
           (create-before-all suite-1
                              :before-all-suite-1
                              (lambda (done-hook)
                                (loop for i upto 10 collect i)
                                (funcall done-hook))
			      :async-p t
                              :timeout 0))
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((errors
                            (gethash :errors (result runner-instance))))
                      (funcall r-done (> (length errors) 0)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-before-all-recursive 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (suite-2 (create-suite runner-instance
                                 :suite-2))
          (test-1 nil)
          (test-2 nil)
          (before-all-suite-1 nil)
          (before-all-suite-2 nil))
     (add-child suite-root suite-1)
     (setf before-all-suite-1
           (create-before-all suite-1
                              :before-all-suite-1
                              (lambda ()
                                (loop for i upto 10 collect i))
                              :timeout 50000))
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (add-child suite-1 suite-2)
     (setf before-all-suite-2
           (create-before-all suite-2
                              :before-all-suite-2
                              (lambda (done-hook)
                                (loop for i upto 10 collect i)
                                (funcall done-hook))
			      :async-p t
			      :timeout 0))
     (setf test-2
           (add-child suite-2
                      (create-test runner-instance
                                   :test-2
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((errors
                            (gethash :errors (result runner-instance))))
                      (funcall r-done (> (length errors) 0)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-after-all 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (test-1 nil)
          (after-all-suite-1 nil))
     (add-child suite-root suite-1)
     (setf after-all-suite-1
           (create-after-all suite-1
                             :after-all-suite-1
                             (lambda ()
                               (loop for i upto 10 collect i))
                             :timeout 0))
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((errors
                            (gethash :errors (result runner-instance))))
                      (funcall r-done (> (length errors) 0)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-after-all-with-tests-in-suite-root 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (test-1 nil)
          (after-all-suite-root nil))
     (setf after-all-suite-root
           (create-after-all suite-root
                             :after-all-suite-root
                             (lambda ()
                               (loop for i upto 10 collect i))
                             :timeout 0))
     (setf test-1
           (add-child suite-root
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((errors
                            (gethash :errors (result runner-instance))))
                      (funcall r-done (> (length errors) 0)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-async-after-all 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (test-1 nil)
          (after-all-suite-1 nil))
     (add-child suite-root suite-1)
     (setf after-all-suite-1
           (create-after-all suite-1
                             :after-all-suite-1
                             (lambda (done-hook)
                               (loop for i upto 10 collect i)
                               (funcall done-hook))
			     :async-p t
			     :timeout 0))
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((errors
                            (gethash :errors (result runner-instance))))
                      (funcall r-done (> (length errors) 0)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-after-all-recursive 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (suite-2 (create-suite runner-instance
                                 :suite-2))
          (test-1 nil)
          (test-2 nil)
          (after-all-suite-1 nil)
          (after-all-suite-2 nil))
     (add-child suite-root suite-1)
     (setf after-all-suite-1
           (create-after-all suite-1
                             :after-all-suite-1
                             (lambda ()
                               (loop for i upto 10 collect i))
                             :timeout 50000))
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (add-child suite-1 suite-2)
     (setf after-all-suite-2
           (create-after-all suite-2
                             :after-all-suite-2
                             (lambda (done-hook)
                               (loop for i upto 10 collect i)
                               (funcall done-hook))
			     :async-p t
                             :timeout 0))
     (setf test-2
           (add-child suite-2
                      (create-test runner-instance
                                   :test-2
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((errors
                            (gethash :errors (result runner-instance))))
                      (funcall r-done (> (length errors) 0)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-before-each 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (test-1 nil)
          (before-each-suite-1 nil))
     (add-child suite-root suite-1)
     (setf before-each-suite-1
           (create-before-each suite-1
                               :before-each-suite-1
                               (lambda ()
                                 (loop for i upto 10 collect i))
                               :timeout 0))
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((errors
                            (gethash :errors (result runner-instance))))
                      (funcall r-done (> (length errors) 0)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-before-each-with-tests-in-suite-root 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (test-1 nil)
          (before-each-suite-root nil))
     (setf before-each-suite-root
           (create-before-each suite-root
                               :before-each-suite-root
                               (lambda ()
                                 (loop for i upto 10 collect i))
                               :timeout 0))
     (setf test-1
           (add-child suite-root
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((errors
                            (gethash :errors (result runner-instance))))
                      (funcall r-done (> (length errors) 0)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-async-before-each 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (test-1 nil)
          (before-each-suite-1 nil))
     (add-child suite-root suite-1)
     (setf before-each-suite-1
           (create-before-each suite-1
                               :before-each-suite-1
                               (lambda (done-hook)
                                 (loop for i upto 10 collect i)
                                 (funcall done-hook))
			       :async-p t
                               :timeout 0))
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((errors
                            (gethash :errors (result runner-instance))))
                      (funcall r-done (> (length errors) 0)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-before-each-recursive 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (suite-2 (create-suite runner-instance
                                 :suite-2))
          (test-1 nil)
          (test-2 nil)
          (before-each-suite-1 nil)
          (before-each-suite-2 nil))
     (add-child suite-root suite-1)
     (setf before-each-suite-1
           (create-before-each suite-1
                               :before-each-suite-1
                               (lambda ()
                                 (loop for i upto 10 collect i))
                               :timeout 50000))
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (add-child suite-1 suite-2)
     (setf before-each-suite-2
           (create-before-each suite-2
                               :before-each-suite-2
                               (lambda (done-hook)
                                 (loop for i upto 10 collect i)
                                 (funcall done-hook))
			       :async-p t
                               :timeout 0))
     (setf test-2
           (add-child suite-2
                      (create-test runner-instance
                                   :test-2
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((errors
                            (gethash :errors (result runner-instance))))
                      (funcall r-done (> (length errors) 0)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-after-each 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (test-1 nil)
          (after-each-suite-1 nil))
     (add-child suite-root suite-1)
     (setf after-each-suite-1
           (create-after-each suite-1
                              :after-each-suite-1
                              (lambda ()
                                (loop for i upto 10 collect i))
                              :timeout 0))
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((errors
                            (gethash :errors (result runner-instance))))
                      (funcall r-done (> (length errors) 0)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-after-each-with-tests-in-suite-root 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (test-1 nil)
          (after-each-suite-root nil))
     (setf after-each-suite-root
           (create-after-each suite-root
                               :after-each-suite-1
                               (lambda ()
                                 (loop for i upto 10 collect i))
                               :timeout 0))
     (setf test-1
           (add-child suite-root
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((errors
                            (gethash :errors (result runner-instance))))
                      (funcall r-done (> (length errors) 0)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-async-after-each 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (test-1 nil)
          (after-each-suite-1 nil))
     (add-child suite-root suite-1)
     (setf after-each-suite-1
           (create-after-each suite-1
                              :after-each-suite-1
                              (lambda (done-hook)
                                (loop for i upto 10 collect i)
                                (funcall done-hook))
			      :async-p t
                              :timeout 0))
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((errors
                            (gethash :errors (result runner-instance))))
                      (funcall r-done (> (length errors) 0)))))
     (run-runner runner-instance))))

(r-test
 :test-timeout-after-each-recursive 
 (lambda (r-done)
   (let* ((runner-instance (make-runner))
          (suite-root (suite-root runner-instance))
          (suite-1 (create-suite runner-instance
                                 :suite-1))
          (suite-2 (create-suite runner-instance
                                 :suite-2))
          (test-1 nil)
          (test-2 nil)
          (after-each-suite-1 nil)
          (after-each-suite-2 nil))
     (add-child suite-root suite-1)
     (setf after-each-suite-1
           (create-after-each suite-1
                              :after-each-suite-1
                              (lambda ()
                                (loop for i upto 10 collect i))
                              :timeout 0))
     (setf test-1
           (add-child suite-1
                      (create-test runner-instance
                                   :test-1
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (add-child suite-1 suite-2)
     (setf after-each-suite-2
           (create-after-each suite-2
                              :after-each-suite-2
                              (lambda (done-hook)
                                (loop for i upto 10 collect i)
                                (funcall done-hook))
			      :async-p t
                              :timeout 50000))
     (setf test-2
           (add-child suite-2
                      (create-test runner-instance
                                   :test-2
                                   (lambda ()
                                     (loop for i upto 10 collect i)
                                     (t-p t)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((errors
                            (gethash :errors (result runner-instance))))
                      (funcall r-done (> (length errors) 0)))))
     (run-runner runner-instance))))

