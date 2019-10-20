(in-package #:noloop.cacau)

(defun reporter-min (runner)
  runner
  (format t "~%~a~%~%" (cacau-string-color "<-> Cacau <->" "red"
                         :background "yellow"
                         :style "underline"))
  (epilogue (result runner)))

;; (once-runner
;;  old-runner
;;  :pass
;;  (lambda ()
;;    ))
;; (once-runner
;;  old-runner
;;  :fail
;;  (lambda ()
;;    ))
