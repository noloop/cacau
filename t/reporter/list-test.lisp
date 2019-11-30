(in-package #:noloop.cacau-test)

(r-test
 :test-list-reporter
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
               (deftest "Test-2" () (eql-p x 0))))))))
   (defsuite :suite-4 ()
     (let ((x 0))
       (defafter-each "After-each Suite-4" ()  (setf x 0))
       (deftest "Test-1" (:skip) (incf x) (eql-p x 1))
       (deftest "Test-2" ((:async done))
         (funcall done (lambda () (eql-p x 0))))))
   
   (let ((out (with-output-to-string (*standard-output*)
                (run
                 :reporter :list
                 :colorful nil))))
     (funcall r-done (equal out "<=> Cacau <=>

:SUITE-1
 -> Test-1
 -> Test-2
 :SUITE-2
  -> Test-1
  -> Test-2
 :SUITE-3
  -> Test-1
  <- Test-2: 1 EQL 0
:SUITE-4
 -> Test-2

-------------------------
From 7 running tests: 

6 passed
1 failed
1 test skipped
")))))

(r-test
 :test-list-reporter-colorful
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
           (deftest "Test-1" (:skip (:async done))
             (incf x)
             (funcall done (lambda () (eql-p x 1))))
           (deftest "Test-2" (:skip) (eql-p x 1))
           (defsuite :suite-3 ()
             (let ((x 0))
               (defbefore-each "Before-each Suite-3" () (setf x 1))
               (deftest "Test-1" () (incf x) (eql-p x 2))
               (deftest "Test-2" () (eql-p x 0))))))))
   (defsuite :suite-4 (:skip)
     (let ((x 0))
       (defafter-each "After-each Suite-4" ()  (setf x 0))
       (deftest "Test-1" () (incf x) (eql-p x 1))
       (deftest "Test-2" ((:async done))
         (funcall done (lambda () (eql-p x 0))))))
   (let ((out (with-output-to-string (*standard-output*)
                (run
                 :reporter :list
                 :colorful t))))
     (funcall r-done (equal out "[4;31;43m<=> Cacau <=>[0m

[34m:SUITE-1[0m
[32m -> Test-1[0m
[32m -> Test-2[0m
 [34m:SUITE-2[0m
 [34m:SUITE-3[0m
 [32m -> Test-1[0m
[4;31m  <- Test-2:[0m [37m1 EQL 0[0m

[0m-------------------------[0m
[37mFrom [0m[34m4[0m[37m running tests: [0m

[32m3 passed[0m
[31m1 failed[0m
[36m1 suite skipped[0m
[36m2 tests skipped[0m
")))))

