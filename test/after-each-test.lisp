(in-package #:noloop.cacau-test)

(defun test-after-each (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (suite-1 (create-suite runner-instance
                                :suite-1
                                '(:only-p nil :skip-p nil)))
         (x 0))
    (add-child suite-root suite-1)
    (create-after-each suite-1
                        (lambda ()
                          (setf x 0)))
    (add-child suite-1
               (create-test runner-instance
                            :test-1
                            (lambda ()
                              (incf x 1)
                              (eql-p x 1))
                            '(:only-p nil :skip-p nil)))
    (add-child suite-1
               (create-test runner-instance
                            :test-2
                            (lambda ()
                              (incf x 1)
                              (eql-p x 1))
                            '(:only-p nil :skip-p nil)))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (funcall a-done (eql x 0))))
    (run-runner runner-instance)))

(defun test-async-after-each (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (suite-1 (create-suite runner-instance
                                :suite-1
                                '(:only-p nil :skip-p nil)))
         (x 0))
    (add-child suite-root suite-1)
    (create-after-each suite-1
                       (lambda (done-hook)
                         (setf x 0)
                         (funcall done-hook)))
    (add-child suite-1
               (create-test runner-instance
                            :test-1
                            (lambda ()
                              (incf x 1)
                              (eql-p x 1))
                            '(:only-p nil :skip-p nil)))
    (add-child suite-1
               (create-test runner-instance
                            :test-2
                            (lambda ()
                              (incf x 1)
                              (eql-p x 1))
                            '(:only-p nil :skip-p nil)))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (funcall a-done (eql x 0))))
    (run-runner runner-instance)))

(defun test-after-each-order (a-done)
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
    (create-after-each suite-1
                      (lambda (hook-done)
                        (setf x 1)
                        (funcall hook-done)))
    (add-child suite-1
               (create-test runner-instance
                            :test-1
                            (lambda ()
                              (eql-p x 0))
                            '(:only-p nil :skip-p nil)))
    (add-child suite-1 suite-2)
    (create-after-each suite-2
                      (lambda ()
                        (setf x 2)))
    (add-child suite-2
               (create-test runner-instance
                            :test-1
                            (lambda ()
                              (eql-p x 0))
                            '(:only-p nil :skip-p nil)))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (funcall a-done (eql x 1))))
    (run-runner runner-instance)))

(defun test-after-each-recursive (a-done)
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
    (create-after-each suite-1
                       (lambda (done-hook)
                         ;;(print :hook1)
                         (incf x 1)
                         (funcall done-hook)))
    (add-child suite-1
               (create-test runner-instance
                            :test-1
                            (lambda ()
                              (incf x 1)
                              ;;(format t "~%suite-1-test-1 x: ~a~%" x)
                              (eql-p x 1))
                            '(:only-p nil :skip-p nil)))
    (add-child suite-1
               (create-test runner-instance
                            :test-2
                            (lambda ()
                              (incf x 1)
                              ;;(format t "~%suite-1-test-2 x: ~a~%" x)
                              (eql-p x 3))
                            '(:only-p nil :skip-p nil)))
    (add-child suite-1 suite-2)
    (create-after-each suite-2
                       (lambda ()
                         ;;(print :hook2)
                         (setf x 0)))
    (add-child suite-2
               (create-test runner-instance
                            :test-1
                            (lambda (done-test)
                              (incf x 1)
                              ;;(format t "~%suite-2-test-1 x: ~a~%" x)
                              (funcall done-test
                                       (lambda ()
                                         (eql-p x 5))))
                            '(:only-p nil :skip-p nil)))
    (add-child suite-2
               (create-test runner-instance
                            :test-2
                            (lambda ()
                              (incf x 1)
                              ;;(format t "~%suite-2-test-2 x: ~a~%" x)
                              )
                            '(:only-p nil :skip-p nil)))
    (add-child suite-1
               (create-test runner-instance
                            :test-3
                            (lambda ()
                              (incf x 1)
                              ;;(format t "~%suite-1-test-3 x: ~a~%" x)
                              (eql-p x 2))
                            '(:only-p nil :skip-p nil)))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (funcall a-done (eql x 3))))
    (run-runner runner-instance)))

