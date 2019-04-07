(in-package #:noloop.cacau-test)

(defun test-before-each (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (suite-1 (create-suite runner-instance
                                :suite-1
                                '(:only-p nil :skip-p nil)))
         (x 0))
    (add-child suite-root suite-1)
    (create-before-each suite-1
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
                   (let ((failing
                           (gethash :failing (result runner-instance))))
                     (funcall a-done (eql 0 failing)))))
    (run-runner runner-instance)))

(defun test-async-before-each (a-done)
  (let* ((runner-instance (make-runner))
         (suite-root (suite-root runner-instance))
         (suite-1 (create-suite runner-instance
                                :suite-1
                                '(:only-p nil :skip-p nil)))
         (x 0))
    (add-child suite-root suite-1)
    (create-before-each suite-1
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
                   (let ((failing
                           (gethash :failing (result runner-instance))))
                     (funcall a-done (eql 0 failing)))))
    (run-runner runner-instance)))

(defun test-before-each-recursive (a-done)
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
    (create-before-each suite-1
                        :hook-suite-1
                        (lambda (done-hook)
                          ;;(print :primeiro)
                          (setf x 0)
                          (funcall done-hook)))
    (add-child suite-1
               (create-test runner-instance
                            :suite-1-test-1
                            (lambda ()
                              (format t "~%s1 - test-1 x: ~a~%" x)
                              (incf x 1)
                              (eql-p x 1))
                            '(:only-p nil :skip-p nil)))
    (add-child suite-1
               (create-test runner-instance
                            :suite-1-test-2
                            (lambda ()
                              (format t "~%s1 - test-2 x: ~a~%" x)
                              (incf x 1)
                              (eql-p x 1))
                            '(:only-p nil :skip-p nil)))
    (add-child suite-1 suite-2)
    (create-before-each suite-2
                        :hook-suite-2
                        (lambda ()
                          ;;(print :segundo)
                          (incf x 1)))
    (add-child suite-2
               (create-test runner-instance
                            :suite-2-test-1
                            (lambda ()
                              (incf x 1)
                              (format t "~%s2 - test-1 x: ~a~%" x)
                              (eql-p x 2))
                            '(:only-p nil :skip-p nil)))
    ;; (add-child suite-2
    ;;            (create-test runner-instance
    ;;                         :test-2
    ;;                         (lambda ()
    ;;                           (format t "~%s2 - test-2 x: ~a~%" x)
    ;;                           (incf x 1)
    ;;                           (eql-p x 2))
    ;;                         '(:only-p nil :skip-p nil)))
    ;; (add-child suite-1
    ;;            (create-test runner-instance
    ;;                         :test-3
    ;;                         (lambda ()
    ;;                           (format t "~%s1 - test-3 x: ~a~%" x)
    ;;                           (incf x 1)
    ;;                           (eql-p x 1))
    ;;                         '(:only-p nil :skip-p nil)))
    ;; (add-child suite-root
    ;;            (create-test runner-instance
    ;;                         :test-1
    ;;                         (lambda ()
    ;;                           (format t "~%suite root - test-2 x: ~a~%" x)
    ;;                           (incf x 1)
    ;;                           (eql-p x 1))
    ;;                         '(:only-p nil :skip-p nil)))
    (once-runner runner-instance
                 :end
                 (lambda ()
                   (let ((failing
                           (gethash :failing (result runner-instance))))
                     (format t "~%end x: ~a~%" x)
                     (funcall a-done (eql 0 failing)))))
    (run-runner runner-instance)))
