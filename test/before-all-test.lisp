(in-package #:noloop.cacau-test)

(defun test-before-all (a-done)
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
    (add-child suite-1
               (create-test runner-instance
                            :test-2
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
                     (funcall a-done (eql 0 failing)))))
    (run-runner runner-instance)))

(defun test-async-before-all (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (suite-1 (create-suite runner-instance
                                :suite-1
                                '(:only-p nil :skip-p nil)))
         (x 0))
    (add-child suite-root suite-1)
    (create-before-all suite-1
                       (lambda (done-hook)
                         (setf x 1)
                         (funcall done-hook)))
    (add-child suite-1
               (create-test runner-instance
                            :test-1
                            (lambda ()
                              ;;(format t "~%X: ~a~%" x)
                              (eql-p x 1))
                            '(:only-p nil :skip-p nil)))
    (add-child suite-1
               (create-test runner-instance
                            :test-2
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
                     (funcall a-done (eql 0 failing)))))
    (run-runner runner-instance)))

(defun test-before-all-recursive (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (suite-1 (create-suite runner-instance
                                :suite-1
                                '(:only-p nil :skip-p nil)))
         (suite-2 (create-suite runner-instance
                                :suite-2
                                '(:only-p nil :skip-p nil)))
         (x 0))
    (add-child suite-root suite-1)
    (create-before-all suite-1
                       (lambda (done-hook)
                         (setf x 1)
                         (funcall done-hook)))
    (add-child suite-1
               (create-test runner-instance
                            :test-1
                            (lambda ()
                              ;;(format t "~%X1: ~a~%" x)
                              (eql-p x 1))
                            '(:only-p nil :skip-p nil)))
    (add-child suite-1
               (create-test runner-instance
                            :test-2
                            (lambda ()
                              ;;(format t "~%X: ~a~%" x)
                              (eql-p x 1))
                            '(:only-p nil :skip-p nil)))
    (add-child suite-1 suite-2)
    (create-before-all suite-2
                       (lambda (done-hook)
                         (incf x)
                         (funcall done-hook)))
    (add-child suite-2
               (create-test runner-instance
                            :test-1
                            (lambda ()
                              ;;(format t "~%X2: ~a~%" x)
                              (eql-p x 2))
                            '(:only-p nil :skip-p nil)))
    (add-child suite-2
               (create-test runner-instance
                            :test-2
                            (lambda ()
                              ;;(format t "~%X: ~a~%" x)
                              (eql-p x 2))
                            '(:only-p nil :skip-p nil)))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   ;;(inspect runner-instance)
                   (let ((failing
                           (gethash :failing (result runner-instance))))
                     (funcall a-done (eql 0 failing)))))
    (run-runner runner-instance)))
