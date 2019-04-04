(in-package #:noloop.cacau)

(defclass suite-class (runnable)
  ((before-all :initform nil
               :accessor before-all)
   (after-all :initform nil
              :accessor after-all)
   (before-each :initform nil
                :accessor before-each)
   (after-each :initform nil
               :accessor after-each)
   (parents-before-each :initform (make-list-iterator)
                        :accessor parents-before-each)
   (parents-after-each :initform (make-list-iterator)
                       :accessor parents-after-each)
   (children :initform (make-list-iterator)
             :accessor children)
   (children-onlys :initform (make-list-iterator)
                   :accessor children-onlys)
   (only-p :initform nil
           :accessor only-p)
   (skip-p :initform nil
           :accessor skip-p)))

(defun make-suite (&key name parent)
  (make-instance 'suite-class
                 :name name
                 :parent parent))

(defmethod create-before-all ((suite suite-class) &rest args)
  (setf (before-all suite) (make-hook args)))

(defmethod add-child ((suite suite-class) child)
  (setf (parent child) suite)
  (add (children suite) child))

(defmethod next-child ((suite suite-class))
  (let ((current-child (next (children suite))))
    (if current-child
        (run-runnable current-child)
        (emit (eventbus suite) :suite-end suite))))

(defmethod run-runnable ((suite suite-class))
  ;;(inspect (children suite))
  (next-child suite))

