(in-package #:noloop.cacau-test)

(a-test
 :test-new-tdd-interface-one-test
 (lambda (a-done)
   (let* ((runner-instance (make-runner))
          (x 0))
     (create-new-tdd-interface runner-instance)
     (test "Test-1" (lambda () (eql-p x 1)))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((failing
                            (gethash :failing (result runner-instance))))
                      (funcall a-done (eql 1 failing)))))
     (run-runner runner-instance))))

(a-test
 :test-new-tdd-interface-one-suite
 (lambda (a-done)
   (let* ((runner-instance (make-runner)))
     (create-new-tdd-interface runner-instance)
     (suite "Suite-1"
            (lambda (&optional (y 0))
              (test "Test-1" (lambda () (eql-p y 0)))
              (test "Test-2" (lambda () (setf y (incf y)) (eql-p y 1)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((passing
                            (gethash :passing (result runner-instance))))
                      (funcall a-done (eql 2 passing)))))
     (run-runner runner-instance))))

;; (a-test
;;  :test-new-tdd-interface
;;  (lambda (a-done)
;;    (let* ((runner-instance (make-runner))
;;           (x 0))
;;      (create-new-tdd-interface runner-instance)
     ;; (suite "Suite-1"
     ;;        (lambda (&optional (x 0))
     ;;          (before-all "Before-all Suite-1" (lambda () (setf x 1)))
     ;;          (test "Test-1" (lambda () (eql-p x 1)))
     ;;          (test "Test-2" (lambda () (setf x (incf x)) (eql-p x 2)))
     ;;          (suite "Suite-2"
     ;;                 (lambda (&optional (x 0))
     ;;                   (before-all "Before-all Suite-2" (lambda () (setf x 1)))
     ;;                   (test "Test-1" (lambda () (setf x (incf x)) (eql-p x 2)))
     ;;                   (test "Test-2" (lambda () (eql-p x 2)))))))
     
     ;; (once-runner runner-instance
     ;;              :end
     ;;              (lambda ()
     ;;                (funcall a-done (eql x 0))))
     ;; (run-runner runner-instance))))

;; (suite "Suite1"
;;         (lambda ()
;;           (let ((x nil))
;;             (before-all "Before all Suite1" (lambda () (setf x t)))
;;             (test "Test1" (lambda () (is-true? x)))
;;             (test "Test2" (lambda () (is-false? x)))
;;             (suite "Suite2"
;;                    (lambda (&optional (x nil))
;;                      (let ((x nil))
;;                        (before-all "Before all Suite2" (lambda () (setf x t)))
;;                        (test "Test1" (lambda () (is-true? x)))
;;                        (test "Test2" (lambda () (is-false? x)))))))))
