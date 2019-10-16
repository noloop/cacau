(in-package #:noloop.cacau-test)

;; (a-test
;;  :test-new-tdd-interface
;;  (lambda (a-done)
;;    (let* ((runner-instance (make-runner)))
;;      (create-new-tdd-interface runner-instance)
;;      (suite
;;       "Suite-1"
;;       (let ((x 0))
;;         (before-all "Before-all Suite-1" (lambda () (setf x 1)))
;;         (test "Test-1" (eql-p x 1))
;;         (test-async "Test-2" (incf x) (eql-p x 2) (funcall done))
;;         (suite
;;          "Suite-2"
;;          (let ((x 0))
;;            (after-all "After-all Suite-2" (lambda (done-hook) (setf x 1) (funcall done-hook)))
;;            (test-async "Test-1" (incf x) (eql-p x 1) (funcall done))
;;            (test "Test-2" (eql-p x 1))
;;            (suite
;;             "Suite-3"
;;             (let ((x 0))
;;               (before-each (lambda () (setf x 1)))
;;               (test "Test-1" (incf x) (eql-p x 2))
;;               (test "Test-2" (eql-p x 1))))))))
;;      (suite
;;       "Suite-4"
;;       (let ((x 0))
;;         (after-each "After-each Suite-4" (lambda ()  (setf x 0)))
;;         (test "Test-1" (incf x) (eql-p x 1))
;;         (test-async "Test-2" (eql-p x 0) (funcall done))))
;;      (once-runner runner-instance
;;                   :end
;;                   (lambda ()
;;                     (let ((passing
;;                             (gethash :passing (result runner-instance))))
;;                       (funcall a-done (eql 8 passing)))))
;;      (run-runner runner-instance))))

;; (a-test
;;  :test-new-tdd-interface-timeout
;;  (lambda (a-done)
;;    (let* ((runner-instance (make-runner)))
;;      (create-new-tdd-interface runner-instance)
;;      (suite
;;       "Suite-1"
;;       (lambda (&optional (x 0))
;;         (before-all "Before-all Suite-1" (lambda () (setf x 1)))
;;         (test "Test-1" (lambda () (eql-p x 1)) :timeout 50000)
;;         (test "Test-2" (lambda () (incf x) (eql-p x 2)))
;;         (suite
;;          "Suite-2"
;;          (lambda (&optional (x 0))
;;            (after-all "After-all Suite-2" (lambda (done-hook) (setf x 1) (funcall done-hook)))
;;            (test "Test-1" (lambda () (incf x) (eql-p x 1)))
;;            (test "Test-2" (lambda () (eql-p x 1)) :timeout 50000)
;;            (suite
;;             "Suite-3"
;;             (lambda (&optional (x 0))
;;               (before-each (lambda () (setf x 1)))
;;               (test "Test-1" (lambda () (incf x) (eql-p x 2)))
;;               (test "Test-2" (lambda () (eql-p x 1)))))))) :timeout 0)
;;      (suite
;;       "Suite-4"
;;       (lambda ()
;;         (let ((x 0))
;;           (after-each "After-each Suite-4" (lambda ()  (setf x 0)))
;;           (test "Test-1" (lambda () (incf x) (eql-p x 1)))
;;           (test "Test-2" (lambda () (eql-p x 0))))))
;;      (once-runner runner-instance
;;                   :end
;;                   (lambda ()
;;                     (let ((passing
;;                             (gethash :passing (result runner-instance))))
;;                       (funcall a-done (eql 4 passing)))))
;;      (run-runner runner-instance))))

(a-test
 :test-new-tdd-interface-skip-and-only
 (lambda (a-done)
   (let* ((runner-instance (make-runner)))
     (create-new-tdd-interface runner-instance)
     (only-suite
      "Suite-1"
      (lambda (&optional (x 0))
        (before-all "Before-all Suite-1" (lambda () (setf x 1)))
        (test "Test-1" (lambda () (eql-p x 1)))
        (test "Test-2" (lambda () (incf x) (eql-p x 2)))
        (suite
         "Suite-2"
         (lambda (&optional (x 0))
           (after-all "After-all Suite-2" (lambda (done-hook) (setf x 1) (funcall done-hook)))
           (test "Test-1" (lambda () (incf x) (eql-p x 1)))
           (skip-test "Test-2" (lambda () (eql-p x 1)))
           (skip-suite
            "Suite-3"
            (lambda (&optional (x 0))
              (before-each (lambda () (setf x 1)))
              (test "Test-1" (lambda () (incf x) (eql-p x 2)))
              (test "Test-2" (lambda () (eql-p x 1)))))))))
     (suite
      "Suite-4"
      (lambda ()
        (let ((x 0))
          (after-each "After-each Suite-4" (lambda ()  (setf x 0)))
          (only-test "Test-1" (lambda () (incf x) (eql-p x 1)))
          (test "Test-2" (lambda () (eql-p x 0))))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((passing
                            (gethash :passing (result runner-instance))))
                      (funcall a-done (eql 4 passing)))))
     (run-runner runner-instance))))

