(in-package #:noloop.cacau)

(let ((runner (make-runner)))
  (defun cacau-runner () runner)
  
  (defun cacau-reset-runner () (setf runner (make-runner)))

  (defun cacau-reporter (name)
    (cond ((equal :min name)
           ;;(funcall reporter-min (result runner))
           )))

  (defun cacau-run (&key (reporter :min) (end-hook (lambda (runner) runner)))
    (let ((old-runner runner))
      (once-runner
       old-runner
       :end
       (lambda ()
         (when (eq (type-of end-hook) 'function)
           (funcall end-hook old-runner)
           (unless (equal :off reporter)
             (cacau-reporter reporter)) ;; STOP HERE!!!
           )))
      (cacau-reset-runner)
      (run-runner old-runner))))

