(in-package #:noloop.cacau)

;; (let ((suites (make-hash-table))
;;       (current-parent (suite-root (common-runner))))
;;   (setf (gethash :suite-root suites) (suite-root runner))
;;   (defun defbefore-suite (&rest args)
;;     (create-before-all current-parent args))
;;   (defun defafter-suite (&rest args)
;;     (create-after-all current-parent args))
;;   (defun defbefore-test (&rest args)
;;     (create-before-each current-parent args))
;;   (defun defafter-test (&rest args)
;;     (create-after-each current-parent args))
;;   (defun in-suite (name &key (parent :suite-root) (only nil) (skip nil))
;;     (let ((suite (create-suite runner name :only-p only :skip-p skip)))
;;       (setf (gethash name suites) suite)
;;       (setf current-parent (gethash parent suites))
;;       (add-child current-parent suite)
;;       (setf current-parent suite)
;;       suite))
;;   (defun deft (name fn &key (only-p nil) (skip-p nil))
;;     (let ((test (create-test runner name fn :only-p only-p :skip-p skip-p)))
;;       (add-child current-parent test)
;;       test)))

(defmacro defbefore-plan (name options &body body)
  (cond-options options
    `(common-create-before-all
      ,name
      ,(if async
           `(lambda (,async-done) ,@body)
           `(lambda () ,@body))
      :timeout ,timeout)))

(defmacro defafter-plan (name options &body body)
  (cond-options options
    `(common-create-after-all
      ,name
      ,(if async
           `(lambda (,async-done) ,@body)
           `(lambda () ,@body))
      :timeout ,timeout)))

(defmacro defbefore-t (name options &body body)
  (cond-options options
    `(common-create-before-each
      ,name
      ,(if async
           `(lambda (,async-done) ,@body)
           `(lambda () ,@body))
      :timeout ,timeout)))

(defmacro defafter-t (name options &body body)
  (cond-options options
    `(common-create-after-each
      ,name
      ,(if async
           `(lambda (,async-done) ,@body)
           `(lambda () ,@body))
      :timeout ,timeout)))

(defmacro in-plan (name &optional (options ()))
  (cond-options options
    `(common-create-suite-with-parent
      ,name
      :only-p ,only-p
      :skip-p ,skip-p
      :timeout ,timeout
      :parent ,parent)))

(defmacro deft (name options &body body)
  (cond-options options
    `(common-create-test
      ,name
      ,(if async
           `(lambda (,async-done) ,@body)
           `(lambda () ,@body))
      :only-p ,only-p
      :skip-p ,skip-p
      :timeout ,timeout)))

