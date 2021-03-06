(in-package #:noloop.cacau-test)

(r-test 
 :test-interface-mix
 (lambda (r-done)
   (let ((x 0))
     (context
      :suite-1
      (lambda ()
        (before-all "Before-all Suite-1" (lambda () (setf x 1)))
        (it "Test-1" (lambda (done) (funcall done (lambda () (eql-p x 1)))) :async t)
        (it "Test-2" (lambda () (incf x) (eql-p x 2)))
        
        (in-plan :suite-2 ((:parent :suite-1)))
        (defafter-plan :after-plan-suite-2 ((:async done-hook)) (setf x 1) (funcall done-hook))
        (deft :test-1 () (eql-p x 2))
        (deft :test-2 () (incf x) (eql-p x 3))

        (suite
         "Suite-3"
         (lambda (&optional (x 0))
           (test-setup "Test-setup Suite-3" (lambda () (setf x 1)))
           (test "Test-1" (lambda () (incf x) (eql-p x 2)))
           (test "Test-2" (lambda () (eql-p x 1)))))))

     (defsuite :suite-4 ()
       (let ((x 0))
         (defafter-each "After-each Suite-4" ()  (setf x 0))
         (deftest "Test-1" () (incf x) (eql-p x 1))
         (deftest "Test-2" ((:async done))
           (funcall done (lambda () (eql-p x 0)))))))
   
   (run
    :reporter :off
    :after-run
    (lambda (runner)
      (let ((passing
              (gethash :passing (result runner))))
        (funcall r-done (eql 8 passing)))))))
