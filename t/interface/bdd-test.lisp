(in-package #:noloop.cacau-test)

(r-test
 :test-bdd-interface
 (lambda (r-done)
   (context
    "Suite-1"
    (lambda (&optional (x 0))
      (before-all "Before-all Suite-1" (lambda () (setf x 1)))
      (it "Test-1" (lambda () (eql-p x 1)))
      (it "Test-2" (lambda () (incf x) (eql-p x 2)))
      (context
       "Suite-2"
       (lambda (&optional (x 0))
         (after-all "After-all Suite-2" (lambda (done-hook) (setf x 1) (funcall done-hook)) :async t)
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
   (run
    :reporter :off
    :after-run
    (lambda (runner)
      (let ((passing
              (gethash :passing (result runner))))
        (funcall r-done (eql 8 passing)))))))

(r-test
 :test-bdd-interface-timeout
 (lambda (r-done)
   (context
    "Suite-1"
    (lambda (&optional (x 0))
      (before-all "Before-all Suite-1" (lambda () (setf x 1)))
      (it "Test-1" (lambda () (eql-p x 1)) :timeout 50000)
      (it "Test-2" (lambda () (incf x) (eql-p x 2)))
      (context
       "Suite-2"
       (lambda (&optional (x 0))
         (after-all "After-all Suite-2" (lambda (done-hook) (setf x 1) (funcall done-hook)) :async t)
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
   (run
    :reporter :off
    :after-run
    (lambda (runner)
      (let ((passing
              (gethash :passing (result runner))))
        (funcall r-done (eql 4 passing)))))))

(r-test
 :test-bdd-interface-skip-and-only
 (lambda (r-done)
   (context
    "Suite-1"
    (lambda (&optional (x 0))
      (before-all "Before-all Suite-1" (lambda () (setf x 1)))
      (it "Test-1" (lambda () (eql-p x 1)))
      (it "Test-2" (lambda () (incf x) (eql-p x 2)))
      (context
       "Suite-2"
       (lambda (&optional (x 0))
         (after-all "After-all Suite-2" (lambda (done-hook) (setf x 1) (funcall done-hook)) :async t)
         (it "Test-1" (lambda () (incf x) (eql-p x 1)))
         (it "Test-2" (lambda () (eql-p x 1)) :skip t)
         (context
          "Suite-3"
          (lambda (&optional (x 0))
            (before-each "Before-each Suite-3" (lambda () (setf x 1)))
            (it "Test-1" (lambda (done)
                           (incf x)
                           (funcall done (lambda () (eql-p x 2))))
		:async t)
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
   (run
    :reporter :off
    :after-run
    (lambda (runner)
      (let ((passing
              (gethash :passing (result runner))))
        (funcall r-done (eql 4 passing)))))))

