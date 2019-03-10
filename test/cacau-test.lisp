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
                 :run-end
                 (lambda () (funcall a-done)))
    (run-runner runner-instance)))

(defun test-runner-create-test-async (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance)))  
    (add-child suite-root
               (create-test runner-instance
                            :test-1
                            (lambda (done)
                              (funcall done (funcall a-done)))
                            '(:only-p nil :skip-p nil)))
    (once-runner runner-instance
                 :run-end
                 (lambda () ()))
    (run-runner runner-instance)))

(defun run ()
  (a-test :test-runner-create-test-sync #'test-runner-create-test-sync)
  (a-test :test-runner-create-test-async #'test-runner-create-test-async)
  (a-run))

