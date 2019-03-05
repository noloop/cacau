(in-package #:noloop.cacau)

;; (set-ui-cacau 'tdd)

;; (suite :suite-1
;;        :timeout 30
;;        :parent :root)

;; (test :test-1
;;       (let ((actual nil)
;;             (expected 1))
;;         (setf actual 1)
;;         (null-p actual))
;;       :timeout 50)

;; (test :test-2
;;       (let ((actual nil)
;;             (expected 1))
;;         (setf actual 1)
;;         (eq-p actual expected))
;;       :timeout 70)

;; ;; or

;; (suite :suite-1
       
;;        (test :test-1
;;              (let ((actual nil)
;;                    (expected 1))
;;                (setf actual 1)
;;                (is-t t))
;;              :timeout 50)

;;        (test :test-2
;;              (let ((actual nil)
;;                    (expected 1))
;;                (setf actual 1)
;;                (is-t t))
;;              :timeout 70))

;; (run-cacau :reporter 'min)

(let ((runner-instance (make-runner)))

  (defun cacau-ui (interface-name)
    interface-name)

  (defun cacau-reporter (reporter-name)
    reporter-name)

  (defun cacau-run ()
    (run-suite (suite-root runner-instance))))

