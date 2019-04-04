(in-package #:noloop.cacau-test)

(defun test-before-all-check-failing-eql-zero (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (suite-1 (create-suite runner-instance
                                :suite-1
                                '(:only-p nil :skip-p nil)))
         (x 0))
    (add-child suite-root suite-1)
    (create-before-all suite-1
                       (lambda ()
                         (setf x 1)))
    (add-child suite-1
               (create-test runner-instance
                            :test-1
                            (lambda ()
                              ;;(format t "~%X: ~a~%" x)
                              (eql-p x 1))
                            '(:only-p nil :skip-p nil)))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   ;;(inspect runner-instance)
                   (let ((failing
                           (gethash :failing (result runner-instance))))
                     (funcall a-done (eq 0 failing)))))
    (run-runner runner-instance)))

(defun test-async-before-all-check-failing-eql-zero (a-done))
