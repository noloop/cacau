;; (in-package #:noloop.cacau-test)

;; (defun test-before-all (a-done)
;;   (let* ((runner-instance (make-runner))
;;          (suite-root (suite-root runner-instance))
;;          (suite-1 (create-suite runner-instance
;;                                 :suite-1
;;                                 '(:only-p nil :skip-p nil))))
;;     (let ((x nil))
;;       (create-before-all (lambda ()
;;                           (setf x t)))
;;       (add-child suite-1
;;                  (create-test runner-instance
;;                               :test-1
;;                               (lambda ()
;;                                 (eq x t))
;;                               '(:only-p nil :skip-p nil))))
;;     (once-runner runner-instance
;;                  :end
;;                  (lambda ()
;;                    (funcall a-done)))
;;     (run-runner runner-instance)))
