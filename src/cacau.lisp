(in-package #:noloop.cacau)

;; (set-ui-cacau 'classic)
;; (in-suite :suite-1
;;           :timeout 30
;;           :parent :root)

;; (test :test-1
;;       (let ((actual nil))
;;         (t-p actual))
;;       :timeout 50)

;; (test :test-2
;;       (let ((actual nil)
;;             (expected 1))
;;         (setf actual 1)
;;         (eq-p actual expected))
;;       :timeout 70)
;; (run-cacau :reporter 'min)

;; or

;; (set-ui-cacau 'new-tdd)
;; (suite :suite-1
;;        (let ((x y z))
;;          (test :test-1
;;                (let ((actual nil))
;;                  (t-p t))
;;                :timeout 50)

;;          (test :test-2
;;                (let ((actual nil))
;;                  (t-p t))
;;                :timeout 70)))
;; (run-cacau :reporter 'min)

(let ((runner-instance (make-runner)))

  (defun cacau-ui (interface-name)
    interface-name)

  (defun cacau-reporter (reporter-name)
    reporter-name)

  (defun cacau-run ()
    (run-suite (suite-root runner-instance))))

