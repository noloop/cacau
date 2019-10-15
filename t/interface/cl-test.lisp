(in-package #:noloop.cacau-test)

(a-test
 :test-cl-interface
 (lambda (a-done)
   (let* ((runner-instance (make-runner)))
     (create-cl-interface runner-instance)
     (defsuite :suite-1
         (let ((x 0))
           (before-all "Before-all Suite-1" (lambda () (setf x 1)))
           (deftest "Test-1" (lambda () (eql-p x 1)))
           (deftest "Test-2" (lambda (done) (incf x) (eql-p x 2) (funcall done)))
           (defsuite :suite-2
             (let ((x 0))
               (after-all "After-all Suite-2" (lambda (done-hook) (setf x 1) (funcall done-hook)))
               (deftest "Test-1" (lambda () (incf x) (eql-p x 1)))
               (deftest "Test-2" (lambda () (eql-p x 1)))
               (defsuite :suite-3
                 (let ((x 0))
                   (before-each (lambda () (setf x 1)))
                   (deftest "Test-1" (lambda () (incf x) (eql-p x 2)))
                   (deftest "Test-2" (lambda () (eql-p x 1)))))))))
     (defsuite :suite-4
         (let ((x 0))
           (after-each "After-each Suite-4" (lambda ()  (setf x 0)))
           (deftest "Test-1" (lambda () (incf x) (eql-p x 1)))
           (deftest "Test-2" (lambda () (eql-p x 0)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((passing
                            (gethash :passing (result runner-instance))))
                      (funcall a-done (eql 8 passing)))))
     (run-runner runner-instance))))

(a-test
 :test-cl-interface-skip-and-only
 (lambda (a-done)
   (let* ((runner-instance (make-runner)))
     (create-cl-interface runner-instance)
     (defsuite-only :suite-1
         (let ((x 0))
           (before-all "Before-all Suite-1" (lambda () (setf x 1)))
           (deftest "Test-1" (lambda () (eql-p x 1)))
           (deftest "Test-2" (lambda () (incf x) (eql-p x 2)))
           (defsuite :suite-2
             (let ((x 0))
              (after-all "After-all Suite-2" (lambda (done-hook) (setf x 1) (funcall done-hook)))
              (deftest "Test-1" (lambda () (incf x) (eql-p x 1)))
              (deftest-skip "Test-2" (lambda () (eql-p x 1)))
              (defsuite-skip :suite-3
                (let ((x 0))
                  (before-each (lambda () (setf x 1)))
                  (deftest "Test-1" (lambda () (incf x) (eql-p x 2)))
                  (deftest "Test-2" (lambda () (eql-p x 1)))))))))
     (defsuite :suite-4
         (let ((x 0))
           (after-each "After-each Suite-4" (lambda ()  (setf x 0)))
           (deftest-only "Test-1" (lambda () (incf x) (eql-p x 1)))
           (deftest "Test-2" (lambda () (eql-p x 0)))))
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((passing
                            (gethash :passing (result runner-instance))))
                      (funcall a-done (eql 4 passing)))))
     (run-runner runner-instance))))

