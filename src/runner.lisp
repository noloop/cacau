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
  (let ((new-runner (make-instance 'runner))
        (temp-runnable (make-instance 'runnable)))
    (setf (suite-root new-runner)
          (make-suite :name :suite-root
                      :parent nil))
    (setf (eventbus temp-runnable) (eventbus new-runner))
    (create-runner-listeners new-runner)
    new-runner))

(defmethod create-suite ((obj runner) name options)
  (emit (eventbus obj) :add-suite options)
  (make-suite :name name
              :only-p (second options)
              :skip-p (fourth options)))

(defmethod create-test ((obj runner) name fn options)
  (emit (eventbus obj) :add-test options)
  (make-test :name name
             :fn fn
             :only-p (second options)
             :skip-p (fourth options)))

(defmethod get-run-progress ((obj runner))
  (let ((completed-tests (gethash :completed-tests (result obj)))
        (tests-percent (/ (gethash :tests (result obj)) 100)))
    (round (/ completed-tests
              (if (= tests-percent 0)
                  1
                  tests-percent)))))

(defmethod once-runner ((obj runner) event-name fn)
  (once (eventbus obj) event-name fn))

(defmethod on-runner ((obj runner) event-name fn)
  (on (eventbus obj) event-name fn))

(defmethod run-runner ((obj runner))
  (emit (eventbus obj) :run-start)
  (run-runnable (suite-root obj)))

