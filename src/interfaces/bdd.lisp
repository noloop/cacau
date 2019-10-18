(in-package #:noloop.cacau)

(defun before-all (name fn &key (timeout -1))
  (common-create-before-all name fn :timeout timeout))

(defun after-all (name fn &key (timeout -1))
  (common-create-after-all name fn :timeout timeout))

(defun before-each (name fn &key (timeout -1))
  (common-create-before-each name fn :timeout timeout))

(defun after-each (name fn &key (timeout -1))
  (common-create-after-each name fn :timeout timeout))

(defun context (name fn &key only skip (timeout -1))
  (common-create-suite name fn :only-p only
                               :skip-p skip
                               :timeout timeout))

(defun it (name fn &key only skip (timeout -1))
  (common-create-test name fn :only-p only
                              :skip-p skip
                              :timeout timeout))

