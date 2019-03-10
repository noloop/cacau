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

(defmethod run-test ((test-obj test-class)) 
  (if (>= (get-function-args-length (fn test-obj)) 1)
      (funcall (fn test-obj) (done test-obj))
      (funcall (fn test-obj))))

(defmethod done ((test-obj test-class))
  (lambda (&optional (arg nil arg-supplied-p)) 
    (cond (arg-supplied-p
           t)
          ((and arg-supplied-p
                (typep arg 'error))
           (setf (runnable-error test-obj) arg))
          ((and arg-supplied-p
                (typep arg 'function))
           (funcall arg)))))

;; cada suite ter seu método next-test, assim passa o proximo test, e também ter seu método get-current-test(precisa mesmo?!) para pegar o teste que está sendo executado no momento.

;; TEST
;; (defun create-test (description fn &key only skip)
;;   (lambda ()
;;     (list description
;;           (if (null fn)
;;               "PENDING"
;;               (funcall fn))
;;           only skip)))

;; done accept optional argument, error or test-fn!!!
