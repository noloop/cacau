(in-package #:noloop.cacau)

(let ((runner (make-runner)))
  (defun cacau-runner () runner)
  
  (defun cacau-reset-runner () (setf runner (make-runner)))

  (defun cacau-reporter (runner name reporter-options)
    (cond ((equal :min name) (reporter-min runner reporter-options))
          ((equal :list name) (reporter-list runner reporter-options))
          ((equal :full name) (reporter-full runner reporter-options))))

  (defun cacau-run (&key (reporter :min)
                         end-hook
                         colorful
                         reporter-options)
    (let* ((old-runner runner)
           (reporter-fn
             (unless (equal :off reporter)
               (defun cacau-string-color (stg color &key style background)
                 (if colorful
                     (string-ansi-color stg color
                                        :background background
                                        :style style)
                     stg))
               (cacau-reporter old-runner reporter reporter-options))))
      (once-runner
       old-runner
       :end
       (lambda ()
         (when (eq (type-of end-hook) 'function)
           (funcall end-hook old-runner))
         (funcall reporter-fn)))
      (cacau-reset-runner)
      (run-runner old-runner))))

