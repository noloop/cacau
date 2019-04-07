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

(defmethod run-runnable ((test test-class) &optional fn)
  (declare (ignore fn))
  ;;(start-iterator (parents-before-each (parent test)))
  ;;(inspect (parents-before-each (parent test)))
  (setf (current-index (parents-before-each (parent test))) 0)
  (execute-suites-each
   (parent test)
   (parents-before-each (parent test))
   (lambda ()
     (if (>= (get-function-args-length (fn test)) 1)
         (funcall (fn test) (done test))
         (try-fn
          test
          (lambda ()
            (progn (funcall (fn test))
                   (after-run test))))))))

(defmethod done ((test test-class))
  "The done function accepts an optional argument, which can be either one error or test-fn(function)."
  (lambda (&optional (arg nil arg-supplied-p))
    (try-fn
     test
     (lambda ()
       (cond ((and arg-supplied-p
                   (typep arg 'error))
              (setf (runnable-error test) arg))
             ((and arg-supplied-p
                   (typep arg 'function))
              (funcall arg)))))
    (after-run test)))

(defmethod after-run ((test test-class))
  (next-child (parent test))
  (emit (eventbus test) :test-end test))

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
    (error (c) (error c))))

;; TODO: TEST "PENDING"
