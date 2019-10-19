(in-package #:noloop.cacau)

(defclass hook-class (runnable)
  ((pos-hook-fn :initform nil
                :accessor pos-hook-fn)))

(defun make-hook (&key name fn (timeout -1))
  (make-instance 'hook-class
                 :name name
                 :fn fn
                 :timeout timeout))

(defmethod run-runnable ((hook hook-class) &optional after-hook)
  (setf (pos-hook-fn hook) after-hook)
  (start-timeout hook)
  (if (>= (get-function-args-length (fn hook)) 1)
      (funcall (fn hook) (done hook))
      (try-fn
       hook
       (lambda ()
         (progn (funcall (fn hook))
                (after-run hook)
                (funcall (pos-hook-fn hook)))))))

(defmethod after-run ((hook hook-class))
  (timout-extrapolated-p hook)
  (emit (eventbus hook) :hook-end hook))

(defmethod done ((hook hook-class))
  (lambda ()
    (try-fn
     hook
     (lambda ()
       (after-run hook)
       (funcall (pos-hook-fn hook))))))

(defmethod try-fn ((hook hook-class) try)
  (handler-case (funcall try)
    (assertion-error (c)
      (let ((error-hash (make-hash-table)))
        (setf-hash error-hash 
                   `((:actual ,(assertion-error-actual c))
                     (:expected ,(assertion-error-expected c))
                     (:message ,(assertion-error-message c))
                     (:result ,(assertion-error-result c))
                     (:stack ,(assertion-error-stack c))))
        (setf (runnable-error hook) error-hash)
        (emit (eventbus hook) :run-abort hook)))
    (error (c)
      (setf-error hook (format nil "~a" c))
      (emit (eventbus hook) :run-abort hook))))

