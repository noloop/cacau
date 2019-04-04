(in-package #:noloop.cacau-test)

(defun run ()
  ;; (a-test :test-runner-create-test-sync #'test-runner-create-test-sync)
  ;; (a-test :test-runner-create-test-async #'test-runner-create-test-async)
  ;; (a-test :test-runner-create-suite #'test-runner-create-suite)
  ;; (a-test :test-runner-create-suite-recursive #'test-runner-create-suite-recursive)
  (a-test :test-before-all #'test-before-all)
  (a-run))
