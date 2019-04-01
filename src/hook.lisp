(in-package #:noloop.cacau)

(defclass hook-class (runnable)
  ((pos-hook-fn :initform nil
                :accessor pos-hook-fn)))

(defun make-hook (&key name fn)
  (make-instance 'hook-class
                 :name name
                 :fn fn))

(defmethod run-runnable ((test test-class))
  (if (>= (get-function-args-length (fn test)) 1)
      (funcall (fn test) (done test))
      (progn (funcall (fn test))
             (after-run test))))
