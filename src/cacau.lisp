(in-package #:noloop.cacau)

;; (set-ui-cacau 'no-spaghetti)
;; (in-suite :suite-1
;;           :timeout 0
;;           :parent :suite-root)
;; (test :test-1 (t-p t) :timeout 50000)
;; (test :test-2
;;       (let ((actual nil)
;;             (expected 1))
;;         (setf actual 1)
;;         (eq-p actual expected))
;;       :timeout -1)
;; (run-cacau :reporter 'min)
;;
;; or
;;
;; (set-ui-cacau 'cl)
;; (suite :suite-1
;;        (let ((x y z))
;;          (test :test-1 (t-p t))
;;          (test :test-2 (t-p t) :timeout 50000))
;;        :timeout 0)
;; (run-cacau :reporter 'min)

(let ((runner-instance (make-runner)))

  (defun cacau-ui (interface-name)
    interface-name)

  (defun cacau-reporter (reporter-name)
    reporter-name)

  (defun cacau-run ()
    (run-suite (suite-root runner-instance))))

