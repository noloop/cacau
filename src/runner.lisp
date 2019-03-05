(in-package #:noloop.cacau)

(defclass runner ()
  ((eventbus :initform (make-eventbus)
             :accessor eventbus)
   (suite-root :initarg :suite-root
               :accessor suite-root)
   (abort-p :initarg :abort-p
            :accessor abort-p)
   (result :initform (make-hash-table)
           :accessor result)))

(defun make-runner ()
  (let ((new-runner (make-instance 'runner)))
    (setf (suite-root new-runner) (make-suite))
    (create-runner-listeners new-runner)
    new-runner))

(defmethod create-suite ((obj runner) name fn options)
  (emit (eventbus obj) :add-suite options)
  (make-suite :name name :fn fn))

(defmethod create-test ((obj runner) name fn options)
  (emit (eventbus obj) :add-test options)
  (make-test :name name :fn fn))

(defmethod once-runner ((obj runner) event-name fn)
  (once (eventbus obj) event-name fn))

(defmethod on-runner ((obj runner) event-name fn)
  (on (eventbus obj) event-name fn))

(defmethod run-runner ((obj runner))
  (emit (eventbus obj) :run-start)
  (run-suite (suite-root obj)))


