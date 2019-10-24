(in-package #:noloop.cacau-test)

(r-test
 :test-full-reporter
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
               (deftest "Test-2" () (eql-p x 0))))
           ))))
   (defsuite :suite-4 ()
     (let ((x 0))
       (defafter-each "After-each Suite-4" ()  (setf x 0))
       (deftest "Test-1" (:skip) (incf x) (eql-p x 1))
       (deftest "Test-2" ((:async done))
         (funcall done (lambda () (eql-p x 1))))))
   (let ((out (with-output-to-string (*standard-output*) 
                (with-input-from-string (*standard-input* (format nil "n~%n"))
                  (run
                  :reporter :full
                  :colorful nil
                  :reporter-options
                  '(:tests-list
                    (:epilogue
                     (:running-suites
                      :running-tests
                      :only-suites
                      :only-tests
                      :skip-suites
                      :skip-tests
                      :total-suites
                      :total-tests
                      :passing
                      :failing
                      :errors
                      :completed-suites
                      :completed-tests))
                    :stack))))))
     (funcall r-done (equal out "
<=> Cacau <=>

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
 <- Test-2: 0 EQL 1

Epilogue
-------------------------
2 running suites
7 running tests
0 only suites
0 only tests
0 skip suites
1 skip tests
4 total suites
8 total tests
5 passed
2 failed
2 errors
0 completed suites
7 completed tests

Errors
-------------------------
Suite: :SUITE-3
Test: Test-2
Message: 1 EQL 0
Read Stack (y/n)? 
-------------------------
Suite: :SUITE-4
Test: Test-2
Message: 0 EQL 1
Read Stack (y/n)? ")))))

(r-test
 :test-full-reporter-colorful
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
               (deftest "Test-2" () (eql-p x 0))))
           ))))
   (defsuite :suite-4 ()
     (let ((x 0))
       (defafter-each "After-each Suite-4" ()  (setf x 0))
       (deftest "Test-1" (:skip) (incf x) (eql-p x 1))
       (deftest "Test-2" ((:async done))
         (funcall done (lambda () (eql-p x 1))))))
   (let ((out (with-output-to-string (*standard-output*) 
                (with-input-from-string (*standard-input* (format nil "n~%n"))
                  (run
                   :reporter :full
                   :colorful t
                   :reporter-options
                   '(:tests-list
                     (:epilogue
                      (:running-suites
                       :running-tests
                       :only-suites
                       :only-tests
                       :skip-suites
                       :skip-tests
                       :total-suites
                       :total-tests
                       :passing
                       :failing
                       :errors
                       :completed-suites
                       :completed-tests))
                     :stack))))))
     (funcall r-done (equal out "
[4;31;43m<=> Cacau <=>[0m

[34m:SUITE-1[0m
[32m -> Test-1[0m
[32m -> Test-2[0m
 [34m:SUITE-2[0m
 [32m -> Test-1[0m
 [32m -> Test-2[0m
 [34m:SUITE-3[0m
 [32m -> Test-1[0m
[4;31m  <- Test-2:[0m [37m1 EQL 0[0m
[34m:SUITE-4[0m
[4;31m <- Test-2:[0m [37m0 EQL 1[0m

[0mEpilogue[0m
[0m-------------------------[0m
[34m2 running suites[0m
[34m7 running tests[0m
[35m0 only suites[0m
[35m0 only tests[0m
[36m0 skip suites[0m
[36m1 skip tests[0m
[37m4 total suites[0m
[37m8 total tests[0m
[32m5 passed[0m
[31m2 failed[0m
[30m2 errors[0m
[32m0 completed suites[0m
[32m7 completed tests[0m

[31mErrors[0m
[31m-------------------------[0m
[31mSuite: :SUITE-3[0m
[31mTest: Test-2[0m
[31mMessage: 1 EQL 0[0m
[31mRead Stack (y/n)? [0m
[31m-------------------------[0m
[31mSuite: :SUITE-4[0m
[31mTest: Test-2[0m
[31mMessage: 0 EQL 1[0m
[31mRead Stack (y/n)? [0m")))))

