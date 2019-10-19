(in-package #:noloop.cacau-test)

(r-test
 :test-cl-interface
 (lambda (r-done)
   (cacau-reset-runner)
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
    :reporter :off
    :end-hook
    (lambda (runner)
      (let ((passing
              (gethash :passing (result runner))))
        (funcall r-done (eql 8 passing)))))))

(r-test
 :test-cl-interface-timeout
 (lambda (r-done)
   (cacau-reset-runner)
   (defsuite :suite-1 ((:timeout 0))
     (let ((x 0))
       (defbefore-all "Before-all Suite-1" ((:timeout 50000)) (setf x 1))
       (deftest "Test-1" ((:timeout 50000)) (eql-p x 1))
       (deftest "Test-2" ((:async done)) (incf x) (eql-p x 2) (funcall done))
       (defsuite :suite-2 ()
         (let ((x 0))
           (defafter-all "After-all Suite-2" ((:timeout 50000) (:async done-hook)) (setf x 1) (funcall done-hook))
           (deftest "Test-1" ((:async done)) (incf x) (eql-p x 1) (funcall done))
           (deftest "Test-2" () (eql-p x 1))
           (defsuite :suite-3 ()
             (let ((x 0))
               (defbefore-each "Before-each Suite-3" ((:timeout 50000)) (setf x 1))
               (deftest "Test-1" ((:timeout 50000)) (incf x) (eql-p x 2))
               (deftest "Test-2" () (eql-p x 1))))))))
   (defsuite :suite-4 ()
     (let ((x 0))
       (defafter-each "After-each Suite-4" ((:timeout 50000))  (setf x 0))
       (deftest "Test-1" () (incf x) (eql-p x 1))
       (deftest "Test-2" ((:async done)) (eql-p x 0) (funcall done))))
   (cacau-run
    :reporter :off
    :end-hook
    (lambda (runner)
      (let ((passing
              (gethash :passing (result runner))))
        (funcall r-done (eql 4 passing)))))))

(r-test
 :test-cl-interface-skip-and-only
 (lambda (r-done)
   (cacau-reset-runner)
   (defsuite :suite-1 (:only)
     (let ((x 0))
       (defbefore-all "Before-all Suite-1" () (setf x 1))
       (deftest "Test-1" () (eql-p x 1))
       (deftest "Test-2" ((:async done)) (incf x) (eql-p x 2) (funcall done))
       (defsuite :suite-2 ()
         (let ((x 0))
           (defafter-all "After-all Suite-2" ((:async done-hook)) (setf x 1) (funcall done-hook))
           (deftest "Test-1" ((:async done)) (incf x) (eql-p x 1) (funcall done))
           (deftest "Test-2" (:skip) (eql-p x 1))
           (defsuite :suite-3 (:skip)
             (let ((x 0))
               (defbefore-each "Before-each Suite-3" () (setf x 1))
               (deftest "Test-1" () (incf x) (eql-p x 2))
               (deftest "Test-2" () (eql-p x 1))))))))
   (defsuite :suite-4 ()
     (let ((x 0))
       (defafter-each "After-each Suite-4" () (setf x 0))
       (deftest "Test-1" () (incf x) (eql-p x 1))
       (deftest "Test-2" (:only (:async done)) (eql-p x 0) (funcall done))))
   (cacau-run
    :reporter :off
    :end-hook
    (lambda (runner)
      (let ((passing
              (gethash :passing (result runner))))
        (funcall r-done (eql 4 passing)))))))

