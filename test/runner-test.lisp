(in-package #:noloop.cacau-test)

(defun test-runner-create-test-sync (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance)))
    (add-child suite-root
               (create-test runner-instance
                            :test-1
                            (lambda ()
                              (= 1 1))
                            '(:only-p nil :skip-p nil)))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (funcall a-done)))
    (run-runner runner-instance)))

(defun test-runner-create-test-async (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance)))  
    (add-child suite-root
               (create-test runner-instance
                            :test-1
                            (lambda (done)
                              (funcall done a-done))
                            '(:only-p nil :skip-p nil)))
    (once-runner runner-instance
                 :end
                 (lambda () ()))
    (run-runner runner-instance)))

(defun test-runner-create-suite (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (suite-1 (create-suite runner-instance
                                :suite-1
                                '(:only-p nil :skip-p nil))))
    (add-child suite-root suite-1)
    (add-child suite-1
               (create-test runner-instance
                            :test-1
                            (lambda ()
                              (= 1 1))
                            '(:only-p nil :skip-p nil)))
    (add-child suite-1
               (create-test runner-instance
                            :test-2
                            (lambda (done)
                              (funcall done))
                            '(:only-p nil :skip-p nil)))
    (add-child suite-1
               (create-test runner-instance
                            :test-3
                            (lambda ()
                              (= 1 1))
                            '(:only-p nil :skip-p nil)))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (funcall a-done)))
    (run-runner runner-instance)))

(defun test-runner-create-suite-recursive (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (suite-1 (create-suite runner-instance
                                :suite-1
                                '(:only-p nil :skip-p nil)))
         (suite-2 (create-suite runner-instance
                                :suite-2
                                '(:only-p nil :skip-p nil))))
    (add-child suite-root suite-1)
    (add-child suite-1
               (create-test runner-instance
                            :test-1
                            (lambda ()
                              (= 1 1))
                            '(:only-p nil :skip-p nil)))
    (add-child suite-1
               (create-test runner-instance
                            :test-2
                            (lambda (done)
                              (funcall done))
                            '(:only-p nil :skip-p nil)))
    (add-child suite-1 suite-2)
    (add-child suite-2
               (create-test runner-instance
                            :test-1
                            (lambda ()
                              (t-p nil))
                            '(:only-p nil :skip-p nil)))
    (add-child suite-2
               (create-test runner-instance
                            :test-2
                            (lambda (done)
                              (funcall done))
                            '(:only-p nil :skip-p nil)))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (inspect runner-instance)
                   (funcall a-done)))
    (run-runner runner-instance)))

