(in-package #:noloop.cacau-test)

(r-test
 :test-new-tdd-interface
 (lambda (r-done)
   (suite
    "Suite-1"
    (lambda (&optional (x 0))
      (suite-setup "Suite-setup Suite-1" (lambda () (setf x 1)))
      (test "Test-1" (lambda () (eql-p x 1)))
      (test "Test-2" (lambda () (incf x) (eql-p x 2)))
      (suite
       "Suite-2"
       (lambda (&optional (x 0))
         (suite-teardown "Suite-teardown Suite-2" (lambda (done-hook) (setf x 1) (funcall done-hook)) :async t)
         (test "Test-1" (lambda () (incf x) (eql-p x 1)))
         (test "Test-2" (lambda () (eql-p x 1)))
         (suite
          "Suite-3"
          (lambda (&optional (x 0))
            (test-setup "Test-setup Suite-3" (lambda () (setf x 1)))
            (test "Test-1" (lambda (done)
                             (incf x)
                             (funcall done (lambda () (eql-p x 2))))
		  :async t)
            (test "Test-2" (lambda () (eql-p x 1)))))))))
   (suite
    "Suite-4"
    (lambda ()
      (let ((x 0))
        (test-teardown "Test-teardown Suite-4" (lambda ()  (setf x 0)))
        (test "Test-1" (lambda () (incf x) (eql-p x 1)))
        (test "Test-2" (lambda () (eql-p x 0))))))
   (run
    :reporter :off
    :after-run
    (lambda (runner)
      (let ((passing
              (gethash :passing (result runner))))
        (funcall r-done (eql 8 passing)))))))

(r-test
 :test-new-tdd-interface-timeout
 (lambda (r-done)
   (suite
    "Suite-1"
    (lambda (&optional (x 0))
      (suite-setup "Suite-setup Suite-1" (lambda () (setf x 1)))
      (test "Test-1" (lambda () (eql-p x 1)) :timeout 0)
      (test "Test-2" (lambda () (incf x) (eql-p x 2)))
      (suite
       "Suite-2"
       (lambda (&optional (x 0))
         (suite-teardown "Suite-teardown Suite-2" (lambda (done-hook) (setf x 1) (funcall done-hook)) :async t)
         (test "Test-1" (lambda () (incf x) (eql-p x 1)))
         (test "Test-2" (lambda () (eql-p x 1)) :timeout 0)
         (suite
          "Suite-3"
          (lambda (&optional (x 0))
            (test-setup "Test-setup Suite-3" (lambda () (setf x 1)))
            (test "Test-1" (lambda () (incf x) (eql-p x 2)) :timeout 0)
            (test "Test-2" (lambda () (eql-p x 1))))))))
    :timeout 50000)
   (suite
    "Suite-4"
    (lambda ()
      (let ((x 0))
        (test-teardown "Test-teardown Suite-4" (lambda ()  (setf x 0)))
        (test "Test-1" (lambda () (incf x) (eql-p x 1)))
        (test "Test-2" (lambda () (eql-p x 0)) :timeout 0))))
   (run
    :reporter :off
    :after-run
    (lambda (runner)
      (let ((passing
              (gethash :passing (result runner))))
        (funcall r-done (eql 4 passing)))))))

(r-test
 :test-new-tdd-interface-skip-and-only
 (lambda (r-done)
   (suite
    "Suite-1"
    (lambda (&optional (x 0))
      (suite-setup "Suite-setup Suite-1" (lambda () (setf x 1)))
      (test "Test-1" (lambda () (eql-p x 1)))
      (test "Test-2" (lambda () (incf x) (eql-p x 2)))
      (suite
       "Suite-2"
       (lambda (&optional (x 0))
         (suite-teardown "Suite-teardown Suite-2" (lambda (done-hook) (setf x 1) (funcall done-hook)) :async t)
         (test "Test-1" (lambda () (incf x) (eql-p x 1)))
         (test "Test-2" (lambda () (eql-p x 1)) :skip t)
         (suite
          "Suite-3"
          (lambda (&optional (x 0))
            (test-setup "Test-setup Suite-3" (lambda () (setf x 1)))
            (test "Test-1" (lambda () (incf x) (eql-p x 2)))
            (test "Test-2" (lambda () (eql-p x 1))))
          :skip t))))
    :only t)
   (suite
    "Suite-4"
    (lambda ()
      (let ((x 0))
        (test-teardown "Test-teardown Suite-4" (lambda ()  (setf x 0)))
        (test "Test-1" (lambda () (incf x) (eql-p x 1)) :only t)
        (test "Test-2" (lambda () (eql-p x 0))))))
   (run
    :reporter :off
    :after-run
    (lambda (runner)
      (let ((passing
              (gethash :passing (result runner))))
        (funcall r-done (eql 4 passing)))))))

