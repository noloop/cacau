(in-package #:noloop.cacau)

(let ((runner (make-runner)))
  (defun cacau-runner () runner)
  
  (defun reset-runner () (setf runner (make-runner)))

  (defun create-reporter (runner name reporter-options)
    (cond ((equal :min name) (reporter-min runner reporter-options))
          ((equal :list name) (reporter-list runner reporter-options))
          ((equal :full name) (reporter-full runner reporter-options))))

  (defun cl-debugger (obj-runnable on-off)
    "Attention that the slot cl-debugger-p is :allocation :class in runnable class."
    (setf (cl-debugger-p obj-runnable) on-off))

  (defun create-reporter-fn (old-runner colorful reporter reporter-options)
     (unless (equal :off reporter)
       (defun cacau-string-color (stg color &key style background)
         (if colorful
             (string-ansi-color stg color
                                :background background
                                :style style)
             stg))
       (create-reporter old-runner reporter reporter-options)))

  (defun run (&key (reporter :min)
                   before-run
                   after-run
                   colorful
                   reporter-options
                   cl-debugger)
    (let* ((old-runner runner)
           (reporter-fn (create-reporter-fn old-runner
                                            colorful
                                            reporter
                                            reporter-options))
           (result nil))
      (cl-debugger (suite-root old-runner) cl-debugger)
      (when (typep before-run 'function)
        (funcall before-run old-runner))
      (once-runner old-runner :end
                   (lambda ()
                     (setf result (and (zerop (gethash :failing (result old-runner)))
                                       (zerop (length (gethash :errors (result old-runner))))))
                     (when (typep after-run 'function)
                       (funcall after-run old-runner))
                     (when (typep reporter-fn 'function)
                       (funcall reporter-fn))))
      (reset-runner)
      (run-runner old-runner)
      result)))

