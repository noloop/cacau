(in-package #:noloop.cacau)

(defclass test-class (runnable)
  ((only-p :initarg :only-p
           :initform nil
           :accessor only-p)
   (skip-p :initarg :skip-p
           :initform nil
           :accessor skip-p)))

(defun make-test (&key name fn only-p skip-p (timeout -1))
  (make-instance 'test-class
                 :name name
                 :fn fn
                 :only-p only-p
                 :skip-p skip-p
                 :timeout timeout))

(defmethod run-runnable ((test test-class) &optional fn)
  (declare (ignore fn))
  (start-iterator (parents-before-each (parent test)))
  (execute-suites-each
   (parent test)
   (parents-before-each (parent test))
   (lambda ()
     (inherit-timeout test)
     (start-timeout test)
     (if (>= (get-function-args-length (fn test)) 1)
         (funcall (fn test) (done test))
         (try-fn
          test
          (lambda ()
            (progn (funcall (fn test))
                   (after-run test))))))))

(defmethod after-run ((test test-class))
  (start-iterator (parents-after-each (parent test)))
  (execute-suites-each
   (parent test)
   (parents-after-each (parent test))
   (lambda ()
     (next-child (parent test))
     (timout-extrapolated-p test)
     (emit (eventbus test) :test-end test))))

(defmethod done ((test test-class))
  "The done function accepts an optional argument, which can be either one error or test-fn(function)."
  (lambda (&optional (arg nil arg-supplied-p))
    (cond ((and arg-supplied-p
                (typep arg 'error))
           (setf (runnable-error test) arg))
          ((and arg-supplied-p
                (typep arg 'function))
           (try-fn test arg)))
    (after-run test)))

(defmethod try-fn ((test test-class) try)
  (handler-case (funcall try)
    (assertion-error (c)
      (let ((error-hash (make-hash-table)))
        (setf-hash error-hash 
                   `((:actual ,(assertion-error-actual c))
                     (:expected ,(assertion-error-expected c))
                     (:message ,(assertion-error-message c))
                     (:result ,(assertion-error-result c))
                     (:stack ,(assertion-error-stack c))))
        (setf (runnable-error test) error-hash)
        (after-run test)))
    (error (c)
      (setf-error test (format nil "~a" c))
      (after-run test))))

