(in-package #:noloop.cacau-test)

(defun test-timeout-test (a-done)
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
                                    (timeout test-1 0.1)
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((failing
                           (gethash :failing (result runner-instance))))
                     (funcall a-done (eql 1 failing)))))
    (run-runner runner-instance)))

(defun test-timeout-suite (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (suite-1 (create-suite runner-instance
                                :suite-1))
         (test-1 nil))
    (add-child suite-root suite-1)
    (timeout suite-1 0.1)
    (setf test-1
          (add-child suite-1
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((failing
                           (gethash :failing (result runner-instance))))
                     (funcall a-done (eql 1 failing)))))
    (run-runner runner-instance)))

(defun test-timeout-suite-with-three-tests (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (suite-1 (create-suite runner-instance
                                :suite-1))
         (test-1 nil)
         (test-2 nil)
         (test-3 nil))
    (add-child suite-root suite-1)
    (timeout suite-1 0.1)
    (setf test-1
          (add-child suite-1
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (setf test-2
          (add-child suite-1
                     (create-test runner-instance
                                  :test-2
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (setf test-3
          (add-child suite-1
                     (create-test runner-instance
                                  :test-3
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((failing
                           (gethash :failing (result runner-instance))))
                     (funcall a-done (eql 3 failing)))))
    (run-runner runner-instance)))

(defun test-timeout-suite-recursive-with-five-tests (a-done)
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
    (timeout suite-1 0.1)
    (setf test-1
          (add-child suite-1
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (setf test-2
          (add-child suite-1
                     (create-test runner-instance
                                  :test-2
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (add-child suite-1 suite-2)
    (setf test-3
          (add-child suite-2
                     (create-test runner-instance
                                  :test-3
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (setf test-4
          (add-child suite-2
                     (create-test runner-instance
                                  :test-4
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (setf test-5
          (add-child suite-1
                     (create-test runner-instance
                                  :test-5
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((failing
                           (gethash :failing (result runner-instance))))
                     (funcall a-done (eql 5 failing)))))
    (run-runner runner-instance)))

(defun test-timeout-suite-recursive-with-five-tests-one-test-reconfigured (a-done)
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
    (timeout suite-1 0.1)
    (setf test-1
          (add-child suite-1
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (setf test-2
          (add-child suite-1
                     (create-test runner-instance
                                  :test-2
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (add-child suite-1 suite-2)
    (setf test-3
          (add-child suite-2
                     (create-test runner-instance
                                  :test-3
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (setf test-4
          (add-child suite-2
                     (create-test runner-instance
                                  :test-4
                                  (lambda ()
                                    (timeout test-4 50000)
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (setf test-5
          (add-child suite-1
                     (create-test runner-instance
                                  :test-5
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((failing
                           (gethash :failing (result runner-instance))))
                     (funcall a-done (eql 4 failing)))))
    (run-runner runner-instance)))

(defun test-timeout-suite-recursive-with-five-tests-suite-2-reconfigured (a-done)
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
    (timeout suite-1 0.1)
    (setf test-1
          (add-child suite-1
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (setf test-2
          (add-child suite-1
                     (create-test runner-instance
                                  :test-2
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (add-child suite-1 suite-2)
    (timeout suite-2 50000)
    (setf test-3
          (add-child suite-2
                     (create-test runner-instance
                                  :test-3
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (setf test-4
          (add-child suite-2
                     (create-test runner-instance
                                  :test-4
                                  (lambda () 
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (setf test-5
          (add-child suite-1
                     (create-test runner-instance
                                  :test-5
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((failing
                           (gethash :failing (result runner-instance))))
                     (funcall a-done (eql 3 failing)))))
    (run-runner runner-instance)))

(defun test-timeout-suite-recursive-with-five-tests-suite-2-reconfigured-with-one-test-reconfigured (a-done)
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
    (timeout suite-1 0.1)
    (setf test-1
          (add-child suite-1
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (setf test-2
          (add-child suite-1
                     (create-test runner-instance
                                  :test-2
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (add-child suite-1 suite-2)
    (timeout suite-2 50000)
    (setf test-3
          (add-child suite-2
                     (create-test runner-instance
                                  :test-3
                                  (lambda ()
                                    (timeout test-3 0.1)
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (setf test-4
          (add-child suite-2
                     (create-test runner-instance
                                  :test-4
                                  (lambda () 
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (setf test-5
          (add-child suite-1
                     (create-test runner-instance
                                  :test-5
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((failing
                           (gethash :failing (result runner-instance))))
                     (funcall a-done (eql 4 failing)))))
    (run-runner runner-instance)))

(defun test-timeout-before-all (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (suite-1 (create-suite runner-instance
                                :suite-1))
         (test-1 nil)
         (before-all-suite-1 nil))
    (add-child suite-root suite-1)
    (setf before-all-suite-1
          (create-before-all suite-1
                             (lambda ()
                               (timeout before-all-suite-1 0.1)
                               (loop for i upto 10000000 collect i))))
    (setf test-1
          (add-child suite-1
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((errors
                           (gethash :errors (result runner-instance))))
                     (funcall a-done (/= 0 (length errors))))))
    (run-runner runner-instance)))

(defun test-timeout-before-all-with-tests-in-suite-root (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (test-1 nil)
         (before-all-suite-root nil))
    (setf before-all-suite-root
          (create-before-all suite-root
                            (lambda ()
                              (timeout before-all-suite-root 0.1)
                              (loop for i upto 10000000 collect i))))
    (setf test-1
          (add-child suite-root
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((errors
                           (gethash :errors (result runner-instance))))
                     (funcall a-done (/= 0 (length errors))))))
    (run-runner runner-instance)))

(defun test-timeout-async-before-all (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (suite-1 (create-suite runner-instance
                                :suite-1))
         (test-1 nil)
         (before-all-suite-1 nil))
    (add-child suite-root suite-1)
    (setf before-all-suite-1
          (create-before-all suite-1
                             (lambda (done-hook)
                               (timeout before-all-suite-1 0.1)
                               (loop for i upto 10000000 collect i)
                               (funcall done-hook))))
    (setf test-1
          (add-child suite-1
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((errors
                           (gethash :errors (result runner-instance))))
                     (funcall a-done (/= 0 (length errors))))))
    (run-runner runner-instance)))

(defun test-timeout-before-all-recursive (a-done)
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
                             (lambda ()
                               (timeout before-all-suite-1 50000)
                               (loop for i upto 10000000 collect i))))
    (setf test-1
          (add-child suite-1
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (add-child suite-1 suite-2)
    (setf before-all-suite-2
          (create-before-all suite-2
                             (lambda (done-hook)
                               (timeout before-all-suite-2 0.1)
                               (loop for i upto 10000000 collect i)
                               (funcall done-hook))))
    (setf test-2
          (add-child suite-2
                     (create-test runner-instance
                                  :test-2
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((errors
                           (gethash :errors (result runner-instance))))
                     (funcall a-done (/= 0 (length errors))))))
    (run-runner runner-instance)))

(defun test-timeout-after-all (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (suite-1 (create-suite runner-instance
                                :suite-1))
         (test-1 nil)
         (after-all-suite-1 nil))
    (add-child suite-root suite-1)
    (setf after-all-suite-1
          (create-after-all suite-1
                             (lambda ()
                               (timeout after-all-suite-1 0.1)
                               (loop for i upto 10000000 collect i))))
    (setf test-1
          (add-child suite-1
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((errors
                           (gethash :errors (result runner-instance))))
                     (funcall a-done (/= 0 (length errors))))))
    (run-runner runner-instance)))

(defun test-timeout-after-all-with-tests-in-suite-root (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (test-1 nil)
         (after-all-suite-root nil))
    (setf after-all-suite-root
          (create-after-all suite-root
                            (lambda ()
                              (timeout after-all-suite-root 0.1)
                              (loop for i upto 10000000 collect i))))
    (setf test-1
          (add-child suite-root
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((errors
                           (gethash :errors (result runner-instance))))
                     (funcall a-done (/= 0 (length errors))))))
    (run-runner runner-instance)))

(defun test-timeout-async-after-all (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (suite-1 (create-suite runner-instance
                                :suite-1))
         (test-1 nil)
         (after-all-suite-1 nil))
    (add-child suite-root suite-1)
    (setf after-all-suite-1
          (create-after-all suite-1
                             (lambda (done-hook)
                               (timeout after-all-suite-1 0.1)
                               (loop for i upto 10000000 collect i)
                               (funcall done-hook))))
    (setf test-1
          (add-child suite-1
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((errors
                           (gethash :errors (result runner-instance))))
                     (funcall a-done (/= 0 (length errors))))))
    (run-runner runner-instance)))

(defun test-timeout-after-all-recursive (a-done)
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
                             (lambda ()
                               (timeout after-all-suite-1 50000)
                               (loop for i upto 10000000 collect i))))
    (setf test-1
          (add-child suite-1
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (add-child suite-1 suite-2)
    (setf after-all-suite-2
          (create-after-all suite-2
                             (lambda (done-hook)
                               (timeout after-all-suite-2 0.1)
                               (loop for i upto 10000000 collect i)
                               (funcall done-hook))))
    (setf test-2
          (add-child suite-2
                     (create-test runner-instance
                                  :test-2
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((errors
                           (gethash :errors (result runner-instance))))
                     (funcall a-done (/= 0 (length errors))))))
    (run-runner runner-instance)))

(defun test-timeout-before-each (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (suite-1 (create-suite runner-instance
                                :suite-1))
         (test-1 nil)
         (before-each-suite-1 nil))
    (add-child suite-root suite-1)
    (setf before-each-suite-1
          (create-before-each suite-1
                             (lambda ()
                               (timeout before-each-suite-1 0.1)
                               (loop for i upto 10000000 collect i))))
    (setf test-1
          (add-child suite-1
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((errors
                           (gethash :errors (result runner-instance))))
                     (funcall a-done (/= 0 (length errors))))))
    (run-runner runner-instance)))

(defun test-timeout-before-each-with-tests-in-suite-root (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (test-1 nil)
         (before-each-suite-root nil))
    (setf before-each-suite-root
          (create-before-each suite-root
                             (lambda ()
                               (timeout before-each-suite-root 0.1)
                               (loop for i upto 10000000 collect i))))
    (setf test-1
          (add-child suite-root
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((errors
                           (gethash :errors (result runner-instance))))
                     (funcall a-done (/= 0 (length errors))))))
    (run-runner runner-instance)))

(defun test-timeout-async-before-each (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (suite-1 (create-suite runner-instance
                                :suite-1))
         (test-1 nil)
         (before-each-suite-1 nil))
    (add-child suite-root suite-1)
    (setf before-each-suite-1
          (create-before-each suite-1
                             (lambda (done-hook)
                               (timeout before-each-suite-1 0.1)
                               (loop for i upto 10000000 collect i)
                               (funcall done-hook))))
    (setf test-1
          (add-child suite-1
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((errors
                           (gethash :errors (result runner-instance))))
                     (funcall a-done (/= 0 (length errors))))))
    (run-runner runner-instance)))

(defun test-timeout-before-each-recursive (a-done)
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
                             (lambda ()
                               (timeout before-each-suite-1 50000)
                               (loop for i upto 10000000 collect i))))
    (setf test-1
          (add-child suite-1
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (add-child suite-1 suite-2)
    (setf before-each-suite-2
          (create-before-each suite-2
                             (lambda (done-hook)
                               (timeout before-each-suite-2 0.1)
                               (loop for i upto 10000000 collect i)
                               (funcall done-hook))))
    (setf test-2
          (add-child suite-2
                     (create-test runner-instance
                                  :test-2
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((errors
                           (gethash :errors (result runner-instance))))
                     (funcall a-done (/= 0 (length errors))))))
    (run-runner runner-instance)))

(defun test-timeout-after-each (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (suite-1 (create-suite runner-instance
                                :suite-1))
         (test-1 nil)
         (after-each-suite-1 nil))
    (add-child suite-root suite-1)
    (setf after-each-suite-1
          (create-after-each suite-1
                              (lambda ()
                                (timeout after-each-suite-1 0.1)
                                (loop for i upto 10000000 collect i))))
    (setf test-1
          (add-child suite-1
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((errors
                           (gethash :errors (result runner-instance))))
                     (funcall a-done (/= 0 (length errors))))))
    (run-runner runner-instance)))

(defun test-timeout-after-each-with-tests-in-suite-root (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (test-1 nil)
         (after-each-suite-root nil))
    (setf after-each-suite-root
          (create-before-each suite-root
                              (lambda ()
                                (timeout after-each-suite-root 0.1)
                                (loop for i upto 10000000 collect i))))
    (setf test-1
          (add-child suite-root
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((errors
                           (gethash :errors (result runner-instance))))
                     (funcall a-done (/= 0 (length errors))))))
    (run-runner runner-instance)))

(defun test-timeout-async-after-each (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (suite-1 (create-suite runner-instance
                                :suite-1))
         (test-1 nil)
         (after-each-suite-1 nil))
    (add-child suite-root suite-1)
    (setf after-each-suite-1
          (create-after-each suite-1
                              (lambda (done-hook)
                                (timeout after-each-suite-1 0.1)
                                (loop for i upto 10000000 collect i)
                                (funcall done-hook))))
    (setf test-1
          (add-child suite-1
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((errors
                           (gethash :errors (result runner-instance))))
                     (funcall a-done (/= 0 (length errors))))))
    (run-runner runner-instance)))

(defun test-timeout-after-each-recursive (a-done)
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
                              (lambda ()
                                (timeout after-each-suite-1 0.1)
                                (loop for i upto 10000000 collect i))))
    (setf test-1
          (add-child suite-1
                     (create-test runner-instance
                                  :test-1
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (add-child suite-1 suite-2)
    (setf after-each-suite-2
          (create-after-each suite-2
                              (lambda (done-hook)
                                (timeout after-each-suite-2 50000)
                                (loop for i upto 10000000 collect i)
                                (funcall done-hook))))
    (setf test-2
          (add-child suite-2
                     (create-test runner-instance
                                  :test-2
                                  (lambda ()
                                    (loop for i upto 10000000 collect i)
                                    (t-p t)))))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((errors
                           (gethash :errors (result runner-instance))))
                     (funcall a-done (/= 0 (length errors))))))
    (run-runner runner-instance)))

