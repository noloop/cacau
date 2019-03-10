(in-package #:noloop.cacau)

(defclass runnable ()
  ((name :initarg :name
         :accessor name)
   (fn :initarg :fn
       :accessor fn)
   (parent :initarg :parent
           :accessor parent)
   (runnable-error :initarg :runnable-error
                   :accessor runnable-error)
   (eventbus :initarg :eventbus
             :accessor eventbus
             :allocation :class)))
