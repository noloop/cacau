(in-package #:noloop.cacau)

(defclass hook-class (runnable)
  ((pos-hook-fn :initform nil
                :accessor pos-hook-fn)))

(defun make-hook (&key name fn (timeout -1) eventbus)
  (make-instance 'hook-class
                 :name name
                 :fn fn
                 :timeout timeout
                 :eventbus eventbus))

(defmethod run-runnable ((hook hook-class) &optional after-hook)
  (setf (pos-hook-fn hook) after-hook)
  (start-timeout hook)
  (if (>= (get-function-args-length (fn hook)) 1)
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

