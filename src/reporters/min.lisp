(in-package #:noloop.cacau)

(defun reporter-min (runner options)
  (declare (ignore options))
  (lambda ()
    (cacau-logo)
    (epilogue (result runner))))

