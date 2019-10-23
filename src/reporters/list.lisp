(in-package #:noloop.cacau)

(defun reporter-list (runner options)
  (declare (ignore options))
  (cacau-logo)
  (suite-tests-list-events runner)
  (lambda ()
    (separation-bar)
    (epilogue (result runner))
    (skipped (result runner))))

