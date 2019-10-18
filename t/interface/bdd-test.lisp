(in-package #:noloop.cacau-test)

(a-test
 :test-bdd-interface
 (lambda (a-done)
   (common-runner-init)
   (context
    "Suite-1"
    (lambda (&optional (x 0))
      (before-all "Before-all Suite-1" (lambda () (setf x 1)))
      (it "Test-1" (lambda () (eql-p x 1)))
      (it "Test-2" (lambda () (incf x) (eql-p x 2)))
      (context
       "Suite-2"
       (lambda (&optional (x 0))
         (after-all "After-all Suite-2" (lambda (done-hook) (setf x 1) (funcall done-hook)))
         (it "Test-1" (lambda () (incf x) (eql-p x 1)))
         (it "Test-2" (lambda () (eql-p x 1)))
         (context
          "Suite-3"
          (lambda (&optional (x 0))
            (before-each "Before-each Suite-3" (lambda () (setf x 1)))
            (it "Test-1" (lambda () (incf x) (eql-p x 2)))
            (it "Test-2" (lambda () (eql-p x 1)))))))))
   (context
    "Suite-4"
    (lambda ()
      (let ((x 0))
        (after-each "After-each Suite-4" (lambda ()  (setf x 0)))
        (it "Test-1" (lambda () (incf x) (eql-p x 1)))
        (it "Test-2" (lambda () (eql-p x 0))))))
   (once-runner (common-runner)
                :end
                (lambda ()
                  (let ((passing
                          (gethash :passing (result (common-runner)))))
                    (funcall a-done (eql 8 passing)))))
   (run-runner (common-runner))))

(a-test
 :test-bdd-interface-timeout
 (lambda (a-done)
   (common-runner-init)
   (context
    "Suite-1"
    (lambda (&optional (x 0))
      (before-all "Before-all Suite-1" (lambda () (setf x 1)))
      (it "Test-1" (lambda () (eql-p x 1)) :timeout 50000)
      (it "Test-2" (lambda () (incf x) (eql-p x 2)))
      (context
       "Suite-2"
       (lambda (&optional (x 0))
         (after-all "After-all Suite-2" (lambda (done-hook) (setf x 1) (funcall done-hook)))
         (it "Test-1" (lambda () (incf x) (eql-p x 1)))
         (it "Test-2" (lambda () (eql-p x 1)) :timeout 50000)
         (context
          "Suite-3"
          (lambda (&optional (x 0))
            (before-each "Before-each Suite-3" (lambda () (setf x 1)))
            (it "Test-1" (lambda () (incf x) (eql-p x 2)))
            (it "Test-2" (lambda () (eql-p x 1))))))))
    :timeout 0)
   (context
    "Suite-4"
    (lambda ()
      (let ((x 0))
        (after-each "After-each Suite-4" (lambda ()  (setf x 0)))
        (it "Test-1" (lambda () (incf x) (eql-p x 1)))
        (it "Test-2" (lambda () (eql-p x 0))))))
   (once-runner (common-runner)
                :end
                (lambda ()
                  (let ((passing
                          (gethash :passing (result (common-runner)))))
                    (funcall a-done (eql 4 passing)))))
   (run-runner (common-runner))))

(a-test
 :test-bdd-interface-skip-and-only
 (lambda (a-done)
   (common-runner-init)
   (context
    "Suite-1"
    (lambda (&optional (x 0))
      (before-all "Before-all Suite-1" (lambda () (setf x 1)))
      (it "Test-1" (lambda () (eql-p x 1)))
      (it "Test-2" (lambda () (incf x) (eql-p x 2)))
      (context
       "Suite-2"
       (lambda (&optional (x 0))
         (after-all "After-all Suite-2" (lambda (done-hook) (setf x 1) (funcall done-hook)))
         (it "Test-1" (lambda () (incf x) (eql-p x 1)))
         (it "Test-2" (lambda () (eql-p x 1)) :skip t)
         (context
          "Suite-3"
          (lambda (&optional (x 0))
            (before-each "Before-each Suite-3" (lambda () (setf x 1)))
            (it "Test-1" (lambda () (incf x) (eql-p x 2)))
            (it "Test-2" (lambda () (eql-p x 1))))
          :skip t))))
    :only t)
   (context
    "Suite-4"
    (lambda ()
      (let ((x 0))
        (after-each "After-each Suite-4" (lambda ()  (setf x 0)))
        (it "Test-1" (lambda () (incf x) (eql-p x 1)) :only t)
        (it "Test-2" (lambda () (eql-p x 0))))))
   (once-runner (common-runner)
                :end
                (lambda ()
                  (let ((passing
                          (gethash :passing (result (common-runner)))))
                    (funcall a-done (eql 4 passing)))))
   (run-runner (common-runner))))

