(in-package #:noloop.cacau)

(defclass hook-class (runnable)
  ((pos-hook-fn :initform nil
                :accessor pos-hook-fn)))

(defun make-hook (args)
  (let* ((function-p (typep (first args) 'function))
         (new-hook (make-instance 'hook-class
                                  :name (if function-p
                                            :Anonymous
                                            (first args))
                                  :fn (if function-p
                                          (first args)
                                          (second args)))))
    ;;(format t "~%p: ~a~%" function-p)
    ;;(inspect new-hook)
    new-hook))

(defmethod run-runnable ((test test-class))
  (if (>= (get-function-args-length (fn test)) 1)
      (funcall (fn test) (done test))
      (progn (funcall (fn test))
             (after-run test))))
