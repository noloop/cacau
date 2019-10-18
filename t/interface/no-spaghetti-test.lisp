(in-package #:noloop.cacau-test)

(a-test
 :test-no-spaghetti-interface
 (lambda (a-done)
   (common-runner-init)
   (let ((x 0))
     (in-plan :suite-1 ()) ;; or (in-suite :suite-1 ((:parent :suite-root)))
     (defbefore-plan :before-plan-suite-1 () (setf x 1))
     (deft :test-1 () (eql-p x 1))
     (deft :test-2 ((:async done)) (incf x) (eql-p x 2) (funcall done))

     (in-plan :suite-2 ((:parent :suite-1)))
     (defafter-plan :after-plan-suite-2 ((:async done-hook)) (setf x 1) (funcall done-hook))
     (deft :test-1 () (eql-p x 2))
     (deft :test-2 () (incf x) (eql-p x 3))

     (in-plan :suite-3 ((:parent :suite-2)))
     (defbefore-t :before-t-suite-3 () (setf x 0))
     (deft :test-1 () (incf x) (eql-p x 1))
     (deft :test-2 () (eql-p x 0))

     (in-plan :suite-4) ;; or (in-suite :suite-4 ((:parent :suite-root)))
     (defafter-t :after-t-suite-4 () (setf x 0))
     (deft :test-1 () (incf x) (eql-p x 2))
     (deft :test-2 () (eql-p x 0)))
     
   (once-runner (common-runner)
                :end
                (lambda ()
                  (let ((passing
                          (gethash :passing (result (common-runner)))))
                    (funcall a-done (eql 8 passing)))))
   (run-runner (common-runner))))

(a-test
 :test-no-spaghetti-interface-timeout
 (lambda (a-done)
   (common-runner-init)
   (let ((x 0))
     (in-plan :suite-1 ((:timeout 0)))
     (defbefore-plan :before-plan-suite-1 () (setf x 1))
     (deft :test-1 ((:timeout 50000)) (eql-p x 1))
     (deft :test-2 ((:async done)) (incf x) (eql-p x 2) (funcall done))

     (in-plan :suite-2 ((:parent :suite-1)))
     (defafter-plan :after-plan-suite-2 ((:async done-hook)) (setf x 1) (funcall done-hook))
     (deft :test-1 () (eql-p x 2))
     (deft :test-2 () (incf x) (eql-p x 3))

     (in-plan :suite-3 ((:parent :suite-2)))
     (defbefore-t :before-t-suite-3 () (setf x 0))
     (deft :test-1 () (incf x) (eql-p x 1))
     (deft :test-2 ((:timeout 50000)) (eql-p x 0))

     (in-plan :suite-4)
     (defafter-t :after-t-suite-4 () (setf x 0))
     (deft :test-1 () (incf x) (eql-p x 2))
     (deft :test-2 () (eql-p x 0)))
   
   (once-runner (common-runner)
                :end
                (lambda ()
                  (let ((passing
                          (gethash :passing (result (common-runner)))))
                    (funcall a-done (eql 4 passing)))))
   (run-runner (common-runner))))

(a-test
 :test-no-spaghetti-interface-skip-and-only
 (lambda (a-done)
   (common-runner-init)
   (let ((x 0))
     (in-plan :suite-1 (:only))
     (defbefore-plan :before-plan-suite-1 () (setf x 1))
     (deft :test-1 () (eql-p x 1))
     (deft :test-2 ((:async done)) (incf x) (eql-p x 2) (funcall done))

     (in-plan :suite-2 ((:parent :suite-1)))
     (defafter-plan :after-plan-suite-2 ((:async done-hook)) (setf x 1) (funcall done-hook))
     (deft :test-1 () (eql-p x 2))
     (deft :test-2 (:skip) (incf x) (eql-p x 3))

     (in-plan :suite-3 ((:parent :suite-2) :skip))
     (defbefore-t :before-t-suite-3 () (setf x 0))
     (deft :test-1 () (incf x) (eql-p x 1))
     (deft :test-2 () (eql-p x 0))

     (in-plan :suite-4)
     (defafter-t :after-t-suite-4 () (setf x 0))
     (deft :test-1 (:only) (incf x) (eql-p x 2))
     (deft :test-2 () (eql-p x 0)))
   
   (once-runner (common-runner)
                :end
                (lambda ()
                  (let ((passing
                          (gethash :passing (result (common-runner)))))
                    (funcall a-done (eql 4 passing)))))
   (run-runner (common-runner))))

