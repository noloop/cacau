(in-package #:noloop.cacau-test)

(r-test
 :test-min-reporter
 (lambda (r-done)
   (defsuite :suite-1 ()
     (let ((x 0))
       (defbefore-all "Before-all Suite-1" () (setf x 1))
       (deftest "Test-1" () (eql-p x 1))
       (deftest "Test-2" ((:async done)) (incf x) (eql-p x 2) (funcall done))
       (defsuite :suite-2 ()
         (let ((x 0))
           (defafter-all "After-all Suite-2" ((:async done-hook)) (setf x 1) (funcall done-hook))
           (deftest "Test-1" ((:async done)) (incf x) (eql-p x 1) (funcall done))
           (deftest "Test-2" () (eql-p x 1))
           (defsuite :suite-3 ()
             (let ((x 0))
               (defbefore-each "Before-each Suite-3" () (setf x 1))
               (deftest "Test-1" () (incf x) (eql-p x 2))
               (deftest "Test-2" () (eql-p x 1))))))))
   (defsuite :suite-4 ()
     (let ((x 0))
       (defafter-each "After-each Suite-4" ()  (setf x 0))
       (deftest "Test-1" () (incf x) (eql-p x 1))
       (deftest "Test-2" ((:async done)) (eql-p x 0) (funcall done))))
   (cacau-run
    :reporter :min
    :colorful t
    :end-hook
    (lambda (runner)
      (let ((passing
              (gethash :passing (result runner))))
        (funcall r-done (eql 8 passing)))))))

