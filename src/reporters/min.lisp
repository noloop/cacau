(in-package #:noloop.cacau)

(defun reporter-min (runner)
  (lambda ()
    (cacau-logo)
    (epilogue (result runner))))

