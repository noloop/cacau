(defpackage #:cacau-examples-interfaces
  (:use #:common-lisp
        #:assert-p
        #:cacau))
(in-package #:cacau-examples-interfaces)
  
;;; cl
(defsuite :suite-1 ()
  (let ((x 0))
    (defbefore-all "Before-all Suite-1" () (setf x 1))
    (defbefore-each "Before-each Suite-1" () (setf x 0))
    (defafter-each "After-each Suite-1" () (setf x 1))
    (defafter-all "After-all Suite-1" ((:async done))
      (setf x 1)
      (funcall done))
    (deftest "Test-1" () (eql-p x 0))
    (deftest "Test-2" ((:async done))
      (funcall done (lambda () (eql-p x 0))))
    (defsuite :suite-2 ()
      (let ((x 0))
        (deftest "Test-1" ((:async done))
          (funcall done (lambda () (eql-p x 0))))
        (deftest "Test-2" () (eql-p x 0))))))

(run :colorful t)

;;; bdd
(context
 "Suite-1"
 (lambda (&optional (x 0))
   (before-all "Before-all Suite-1" (lambda () (setf x 1)))
   (before-each "Before-each Suite-1" (lambda () (setf x 1)))
   (after-each "After-each Suite-1" (lambda () (setf x 1)))
   (after-all "After-all Suite-1" (lambda (done) (funcall done)))
   (it "Test-1" (lambda () (eql-p x 1)))
   (it "Test-2" (lambda () (incf x) (eql-p x 2)))
   (context
    "Suite-2"
    (lambda (&optional (x 0))
      (it "Test-1" (lambda () (incf x) (eql-p x 1)))
      (it "Test-2" (lambda () (eql-p x 1)))
      (context
       "Suite-3"
       (lambda (&optional (x 0))
         (it "Test-1" (lambda () (incf x) (eql-p x 1)))
         (it "Test-2" (lambda () (eql-p x 1)))))))))

(run :colorful t)

;;; tdd
(suite
 "Suite-1"
 (lambda (&optional (x 0))
   (suite-setup "Suite-setup Suite-1" (lambda () (setf x 1)))
   (test-setup "Test-setup Suite-1" (lambda () (setf x 1)))
   (test-teardown "Test-teardown Suite-1" (lambda () (setf x 1)))
   (suite-teardown "Suite-teardown Suite-1" (lambda (done) (funcall done)))
   (test "Test-1" (lambda () (eql-p x 1)))
   (test "Test-2" (lambda () (incf x) (eql-p x 2)))
   (suite
    "Suite-2"
    (lambda (&optional (x 0))
      (test "Test-1" (lambda () (incf x) (eql-p x 1)))
      (test "Test-2" (lambda () (eql-p x 1)))
      (suite
       "Suite-3"
       (lambda (&optional (x 0))
         (test "Test-1" (lambda (done)
                          (incf x)
                          (funcall done (lambda () (eql-p x 1)))))
         (test "Test-2" (lambda () (eql-p x 1)))))))))

(run :colorful t)

;;; no-spaghetti
(let ((x 0))
  (in-plan :suite-1 ()) ;; or (in-suite :suite-1 ((:parent :suite-root)))
  (defbefore-plan :before-plan-suite-1 () (setf x 1))
  (deft :test-1 () (eql-p x 1))
  (deft :test-2 ((:async done))
    (incf x)
    (funcall done (lambda () (eql-p x 2))))

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

(run :colorful t)

