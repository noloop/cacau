(in-package #:noloop.cacau)

(let ((runner (make-runner)))
  (defun cacau-reset-runner () (setf runner (make-runner)))
  
  (defun cacau-runner () runner)

  ;; (defun cacau-reporter (name)
  ;;   (cond ((equal :min name)
  ;;          (once-runner
  ;;           runner
  ;;           :end
  ;;           (lambda ()
  ;;             (funcall fn (result runner))
  ;;             (setf runner (make-runner)))))))

  (defun cacau-run (&key (reporter :min) (end-hook (lambda (runner) runner)))
    (declare (ignore reporter))
    (once-runner
     runner
     :end
     (lambda ()
       (when (eq (type-of end-hook) 'function)
         (funcall end-hook runner))))
      (run-runner runner)
      (cacau-reset-runner)))

