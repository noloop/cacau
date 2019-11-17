(in-package #:noloop.cacau)

(defclass hook-class (runnable)
  ((async-p :initarg :async-p
	    :initform nil
	    :accessor async-p)
   (pos-hook-fn :initform nil
                :accessor pos-hook-fn)))

(defun make-hook (&key name fn async-p (timeout -1) eventbus)
  (make-instance 'hook-class
                 :name name
                 :fn fn
		 :async-p async-p
                 :timeout timeout
                 :eventbus eventbus))

(defmethod run-runnable ((hook hook-class) &optional after-hook)
  (setf (pos-hook-fn hook) after-hook)
  (start-timeout hook)
  (if (async-p hook)
      (funcall (fn hook) (done-runnable hook))
      (progn
        (try-fn hook
                (lambda () (funcall (fn hook)))
                :after-error-fn
                (lambda () (emit (eventbus hook) :run-abort hook)))
        (after-run hook))))

(defmethod after-run ((hook hook-class))
  (timeout-extrapolated-p hook)
  (emit (eventbus hook) :hook-end hook)
  (funcall (pos-hook-fn hook)))

