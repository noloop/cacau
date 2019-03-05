(in-package #:noloop.cacau)

(defclass test-class (runnable)
  ((only-p :initform nil :accessor only-p)
   (skip-p :initform nil :accessor skip-p)))

(defun make-test (&key name fn)
  (make-instance 'test-class
                 :name name
                 :fn fn))

(defmethod run-test ((obj test-class))
  (funcall (fn obj)))

;; TEST
;; (defun create-test (description fn &key only skip)
;;   (lambda ()
;;     (list description
;;           (if (null fn)
;;               "PENDING"
;;               (funcall fn))
;;           only skip)))
