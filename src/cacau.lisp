(in-package #:noloop.cacau)

(let ((runner (make-runner)))
  (defun cacau-runner () runner)
  
  (defun cacau-reset-runner () (setf runner (make-runner)))

  (defun cacau-reporter (runner name)
    (cond ((equal :min name) (reporter-min runner))))

  (defun cacau-run (&key (reporter :min)
                         end-hook
                         colorful)
    (let ((old-runner runner))
      (once-runner
       old-runner
       :end
       (lambda ()
         (when (eq (type-of end-hook) 'function)
           (funcall end-hook old-runner)
           (unless (equal :off reporter)
             (defun cacau-string-color (stg color &key style background)
               (if colorful
                   (string-ansi-color stg color
                     :background background
                     :style style)
                   stg))
             (cacau-reporter old-runner reporter)))))
      (cacau-reset-runner)
      (run-runner old-runner))))


(defun cacau-string-color (colorful)
  (lambda (stg color &key style background)
    (if colorful
        (string-ansi-color stg  color
          :background background
          :style style)
        stg)))
