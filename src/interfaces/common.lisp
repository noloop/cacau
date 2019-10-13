(in-package #:noloop.cacau)

(defclass common-interface-class ()
  ((runner :initarg :runner
           :initform (error "You didn't supply an initial value for slot runner")
           :accessor runner)
   (suites :initform nil
           :accessor suites)))

(defun make-common-interface (runner)
  (let ((common-interface-instance
          (make-instance 'common-interface-class :runner runner)))
    (setf (suites common-interface-instance)
          (list (suite-root runner)))
    common-interface-instance))

;; (defmethod common-create-before-all ((common common-interface-class) &rest args)
;;   (create-before-all (first (suites common)) args))

;; (defmethod common-create-after-all ((common common-interface-class) &rest args)
;;   (create-after-all (first (suites common)) args))

;; (defmethod common-create-before-each ((common common-interface-class) &rest args)
;;   (create-before-each (first (suites common)) args))

;; (defmethod common-create-after-each ((common common-interface-class) &rest args)
;;   (create-after-each (first (suites common)) args))

(defmethod common-create-suite
    ((common common-interface-class) name fn &key (only-p nil) (skip-p nil))
  (let ((suite (create-suite (runner common) name :only-p only-p :skip-p skip-p)))
    (add-child (first (suites common)) suite)
    (push suite (suites common))
    (funcall fn)
    (setf (suites common) (rest (suites common)))
    suite))

(defmethod common-create-test
    ((common common-interface-class) name fn &key (only-p nil) (skip-p nil))
  (let ((test (create-test (runner common) name fn :only-p only-p :skip-p skip-p)))
    (add-child (first (suites common)) test)
    test))

