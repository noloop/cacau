(in-package #:noloop.cacau)

(defclass runnable ()
  ((name :initarg :name
         :accessor name)
   (fn :initarg :fn
       :accessor fn)
   (parent :initarg :parent
           :accessor parent)
   (runnable-error :initform nil
                   :accessor runnable-error)
   (eventbus :initarg :eventbus
             :accessor eventbus
             :allocation :class)))

(defgeneric run-runnable (obj &optional fn)
  (:documentation "Something must be run, such as a test suite that calls run-runnable from each tests, or running a hook."))
