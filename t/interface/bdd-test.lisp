(in-package #:noloop.cacau-test)

(a-test
 :test-bdd-interface
 (lambda (a-done)
   (let* ((runner-instance (make-runner)))
     (create-bdd-interface runner-instance)
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
              (before-each (lambda () (setf x 1)))
              (it "Test-1" (lambda () (incf x) (eql-p x 2)))
              (it "Test-2" (lambda () (eql-p x 1)))))))))
     (context
      "Suite-4"
      (lambda ()
        (let ((x 0))
          (after-each "After-each Suite-4" (lambda ()  (setf x 0)))
          (it "Test-1" (lambda () (incf x) (eql-p x 1)))
          (it "Test-2" (lambda () (eql-p x 0))))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((passing
                            (gethash :passing (result runner-instance))))
                      (funcall a-done (eql 8 passing)))))
     (run-runner runner-instance))))

(a-test
 :test-bdd-interface-skip-and-only
 (lambda (a-done)
   (let* ((runner-instance (make-runner)))
     (create-bdd-interface runner-instance)
     (only-context
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
           (skip-it "Test-2" (lambda () (eql-p x 1)))
           (skip-context
            "Suite-3"
            (lambda (&optional (x 0))
              (before-each (lambda () (setf x 1)))
              (it "Test-1" (lambda () (incf x) (eql-p x 2)))
              (it "Test-2" (lambda () (eql-p x 1)))))))))
     (context
      "Suite-4"
      (lambda ()
        (let ((x 0))
          (after-each "After-each Suite-4" (lambda ()  (setf x 0)))
          (only-it "Test-1" (lambda () (incf x) (eql-p x 1)))
          (it "Test-2" (lambda () (eql-p x 0))))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((passing
                            (gethash :passing (result runner-instance))))
                      (funcall a-done (eql 4 passing)))))
     (run-runner runner-instance))))

