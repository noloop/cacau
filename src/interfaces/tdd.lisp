(in-package #:noloop.cacau)

(defun suite-setup (name fn &key async (timeout -1))
  (common-create-before-all name fn :async-p async :timeout timeout))

(defun suite-teardown (name fn &key async (timeout -1))
  (common-create-after-all name fn :async-p async :timeout timeout))

(defun test-setup (name fn &key async (timeout -1))
  (common-create-before-each name fn :async-p async :timeout timeout))

(defun test-teardown (name fn &key async (timeout -1))
  (common-create-after-each name fn :async-p async :timeout timeout))

(defun suite (name fn &key only skip (timeout -1))
  (common-create-suite name fn :only-p only
                               :skip-p skip
                               :timeout timeout))

(defun test (name fn &key async only skip (timeout -1))
  (common-create-test name fn :async-p async
		              :only-p only
                              :skip-p skip
                              :timeout timeout))

