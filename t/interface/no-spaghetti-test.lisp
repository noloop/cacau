(in-package #:noloop.cacau-test)

(a-test
 :test-no-spaghetti-interface
 (lambda (a-done)
   (let ((runner-instance (make-runner))
         (x 0))
     (create-no-spaghetti-interface runner-instance)
     
     (in-suite :suite-1) ;; or (in-suite :suite-1 :parent :suite-root)
     (before-all :before-all-suite-1 (lambda () (setf x 1)))
     (deftest :test-1 (lambda () (eql-p x 1)))
     (deftest :test-2 (lambda (done) (incf x) (eql-p x 2) (funcall done)))

     (in-suite :suite-2 :parent :suite-1)
     (after-all :after-all-suite-2 (lambda (done-hook) (setf x 1) (funcall done-hook)))
     (deftest :test-1 (lambda () (eql-p x 2)))
     (deftest :test-2 (lambda () (incf x) (eql-p x 3)))

     (in-suite :suite-3 :parent :suite-2)
     (before-each (lambda () (setf x 0))) ;; Anonymous 
     (deftest :test-1 (lambda () (incf x) (eql-p x 1)))
     (deftest :test-2 (lambda () (eql-p x 0)))

     (in-suite :suite-4) ;; or (in-suite :suite-4 :parent :suite-root)
     (after-each :after-each-suite-4 (lambda () (setf x 0)))
     (deftest :test-1 (lambda () (incf x) (eql-p x 2)))
     (deftest :test-2 (lambda () (eql-p x 0)))
     
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((passing
                            (gethash :passing (result runner-instance))))
                      (funcall a-done (eql 8 passing)))))
     (run-runner runner-instance))))

(a-test
 :test-no-spaghetti-interface-skip-and-only
 (lambda (a-done)
   (let ((runner-instance (make-runner))
         (x 0))
     (create-no-spaghetti-interface runner-instance)
     
     (in-suite :suite-1 :only t) ;; or (in-suite :suite-1 :parent :suite-root)
     (before-all :before-all-suite-1 (lambda () (setf x 1)))
     (deftest :test-1 (lambda () (eql-p x 1)))
     (deftest :test-2 (lambda (done) (incf x) (eql-p x 2) (funcall done)))

     (in-suite :suite-2 :parent :suite-1)
     (after-all :after-all-suite-2 (lambda (done-hook) (setf x 1) (funcall done-hook)))
     (deftest :test-1 (lambda () (eql-p x 2)))
     (deftest-skip :test-2 (lambda () (incf x) (eql-p x 3)))

     (in-suite :suite-3 :parent :suite-2 :skip t)
     (before-each (lambda () (setf x 0))) ;; Anonymous 
     (deftest :test-1 (lambda () (incf x) (eql-p x 1)))
     (deftest :test-2 (lambda () (eql-p x 0)))

     (in-suite :suite-4) ;; or (in-suite :suite-4 :parent :suite-root)
     (after-each :after-each-suite-4 (lambda () (setf x 0)))
     (deftest-only :test-1 (lambda () (incf x) (eql-p x 2)))
     (deftest :test-2 (lambda () (eql-p x 0)))
     
     (once-runner runner-instance
                  :end
                  (lambda ()
                    (let ((passing
                            (gethash :passing (result runner-instance))))
                      (funcall a-done (eql 4 passing)))))
     (run-runner runner-instance))))

