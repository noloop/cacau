(in-package #:noloop.cacau-test)

(r-test
 :test-min-reporter
 (lambda (r-done)
   (defsuite :suite-1 ()
     (let ((x 0))
       (defbefore-all "Before-all Suite-1" () (setf x 1))
       (deftest "Test-1" () (eql-p x 1))
       (deftest "Test-2" ((:async done))
         (incf x) 
         (funcall done (lambda () (eql-p x 2))))
       (defsuite :suite-2 ()
         (let ((x 0))
           (defafter-all "After-all Suite-2" ((:async done-hook)) (setf x 1) (funcall done-hook))
           (deftest "Test-1" ((:async done))
             (incf x)
             (funcall done (lambda () (eql-p x 1))))
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
       (deftest "Test-2" ((:async done))
         (funcall done (lambda () (eql-p x 0))))))
   (let ((out (with-output-to-string (*standard-output*)
                (cacau-run
                 :reporter :min
                 :colorful nil))))
     (funcall r-done (equal out "
<=> Cacau <=>

From 8 running tests: 

8 passed
0 failed
")))))

(r-test
 :test-min-reporter-colorful
 (lambda (r-done)
   (defsuite :suite-1 ()
     (let ((x 0))
       (defbefore-all "Before-all Suite-1" () (setf x 1))
       (deftest "Test-1" () (eql-p x 1))
       (deftest "Test-2" ((:async done))
         (incf x)
         (funcall done (lambda () (eql-p x 2))))
       (defsuite :suite-2 ()
         (let ((x 0))
           (defafter-all "After-all Suite-2" ((:async done-hook)) (setf x 1) (funcall done-hook))
           (deftest "Test-1" ((:async done))
             (incf x)
             (funcall done (lambda () (eql-p x 1))))
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
       (deftest "Test-2" ((:async done))
         (funcall done (lambda () (eql-p x 0))))))
   (let ((out (with-output-to-string (*standard-output*)
                (cacau-run
                 :reporter :min
                 :colorful t))))
     (funcall r-done (equal out "
[4;31;43m<=> Cacau <=>[0m

[37mFrom [0m[34m8[0m[37m running tests: [0m

[32m8 passed[0m
[31m0 failed[0m
")))))

