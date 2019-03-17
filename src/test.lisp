(in-package #:noloop.cacau)

(defclass test-class (runnable)
  ((only-p :initform nil
           :accessor only-p)
   (skip-p :initform nil
           :accessor skip-p)))

(defun make-test (&key name fn)
  (make-instance 'test-class
                 :name name
                 :fn fn))

(defmethod run-runnable ((test test-class))
  (if (>= (get-function-args-length (fn test)) 1)
      (funcall (fn test) (done test))
      (progn (funcall (fn test))
             (after-run test))))

(defmethod done ((test test-class))
  "The done function accepts an optional argument, which can be either one error or test-fn(function)."
  (lambda (&optional (arg nil arg-supplied-p))
    (cond ((and arg-supplied-p
                (typep arg 'error))
           (setf (runnable-error test) arg))
          ((and arg-supplied-p
                (typep arg 'function))
           (funcall arg)))
    (after-run test)))

(defmethod after-run ((test test-class))
  (next-child (parent test))
  (emit (eventbus test) :test-end test))

;; TODO: TEST "PENDING"
