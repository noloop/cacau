(in-package #:noloop.cacau)

(defclass test-class (runnable)
  ((only-p :initarg :only-p
           :initform nil
           :accessor only-p)
   (skip-p :initarg :skip-p
           :initform nil
           :accessor skip-p)))

(defun make-test (&key name fn only-p skip-p (timeout -1) eventbus)
  (make-instance 'test-class
                 :name name
                 :fn fn
                 :only-p only-p
                 :skip-p skip-p
                 :timeout timeout
                 :eventbus eventbus))

(defmethod run-runnable ((test test-class) &optional fn)
  (declare (ignore fn))
  (emit (eventbus test) :test-start test)
  (start-iterator (parents-before-each (parent test)))
  (execute-suites-each
   (parent test)
   (parents-before-each (parent test))
   (lambda ()
     (inherit-timeout test)
     (start-timeout test)
     (if (>= (get-function-args-length (fn test)) 1)
         (try-fn test (lambda () (funcall (fn test) (done-runnable test))))
         (progn
           (try-fn test (lambda () (funcall (fn test))))
           (after-run test))))))

(defmethod after-run ((test test-class))
  (start-iterator (parents-after-each (parent test)))
  (execute-suites-each
   (parent test)
   (parents-after-each (parent test))
   (lambda ()
     (timeout-extrapolated-p test)
     (emit (eventbus test) :test-end test)
     (next-child (parent test)))))

