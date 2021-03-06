(in-package #:noloop.cacau)

(defclass runner ()
  ((eventbus :initform (make-eventbus)
             :accessor eventbus)
   (suite-root :initarg :suite-root
               :accessor suite-root)
   (abort-p :initform nil
            :accessor abort-p)
   (result :initform (make-hash-table)
           :accessor result)
   (current-suite :accessor current-suite)))

(defun make-runner ()
  (let ((new-runner (make-instance 'runner)))
    (setf (suite-root new-runner)
          (make-suite :name :suite-root
                      :parent nil
                      :eventbus (eventbus new-runner)))
    (create-runner-listeners new-runner)
    (setf (current-suite new-runner) (suite-root new-runner))
    new-runner))

(defmethod create-suite ((obj runner) name &key only-p skip-p (timeout -1))
  (emit (eventbus obj) :add-suite (list :only-p only-p :skip-p skip-p))
  (make-suite :name name
              :only-p only-p
              :skip-p skip-p
              :timeout timeout
              :eventbus (eventbus obj)))

(defmethod create-test ((obj runner) name fn &key async-p only-p skip-p (timeout -1))
  (emit (eventbus obj) :add-test (list :only-p only-p :skip-p skip-p))
  (make-test :name name
             :fn fn
	     :async-p async-p
	     :only-p only-p
             :skip-p skip-p
             :timeout timeout
             :eventbus (eventbus obj)))

(defmethod run-progress ((obj runner))
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

