(in-package #:noloop.cacau)

(let ((runner (make-runner)))
  (defun cacau-reset-runner () (setf runner (make-runner)))
  
  (defun cacau-runner () runner)

  (defun cacau-reporter (name)
    (cond ((equal :min name)
           ;;(funcall reporter-min (result runner))
           )))

  (defun cacau-run (&key (reporter :min) (end-hook (lambda (runner) runner)))
    (once-runner
     runner
     :end
     (lambda ()
       (when (eq (type-of end-hook) 'function)
         (funcall end-hook runner)
         (unless (equal :off reporter)
           (cacau-reporter reporter)) ;; STOP HERE!!!
         )))
      (run-runner runner)
    (cacau-reset-runner)))

