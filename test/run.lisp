(in-package #:noloop.cacau-test)

(defun run ()
  ;; (a-test :test-runner-create-test-sync #'test-runner-create-test-sync)
  ;; (a-test :test-runner-create-test-async #'test-runner-create-test-async)
  ;; (a-test :test-runner-create-suite #'test-runner-create-suite)
  ;; (a-test :test-runner-create-suite-recursive #'test-runner-create-suite-recursive)
  ;; (a-test :test-before-all #'test-before-all)
  ;; (a-test :test-async-before-all #'test-async-before-all)
  ;; (a-test :test-before-all-recursive #'test-before-all-recursive)
  ;; (a-test :test-after-all #'test-after-all)
  ;; (a-test :test-async-after-all #'test-async-after-all)
  ;; (a-test :test-after-all-order #'test-after-all-order)
  ;; (a-test :test-after-all-recursive #'test-after-all-recursive)
  ;; (a-test :test-before-each #'test-before-each)
  ;; (a-test :test-async-before-each #'test-async-before-each)
  (a-test :test-before-each-recursive #'test-before-each-recursive)
  (a-run))
