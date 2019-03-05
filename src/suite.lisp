(in-package #:noloop.cacau)

(defclass suite-class (runnable)
  ((before-all :initform nil :accessor before-all)
   (after-all :initform nil :accessor after-all)
   (before-each :initform nil :accessor before-each)
   (after-each :initform nil :accessor after-each)
   (parents-before-each :initform '() :accessor parents-before-each)
   (parents-after-each :initform '() :accessor parents-after-each)
   (children :initform '() :accessor children)
   (children-onlys :initform '() :accessor children-onlys)
   (only-p :initform nil :accessor only-p)
   (skip-p :initform nil :accessor skip-p)))

(defun make-suite (&key name fn)
  (make-instance 'suite-class
                 :name name
                 :fn fn))

(defmethod add-child (obj child)
  (setf (parent obj) obj)
  (setf (children obj) (push child (children obj))))

(defmethod run-suite ((obj suite-class))
  (dolist (child (children obj))
    (run-test child)))
