(in-package #:noloop.cacau-test)

(defun run ()
  (a-test :test-runner-create-test-sync #'test-runner-create-test-sync)
  (a-test :test-runner-create-test-async #'test-runner-create-test-async)
  (a-test :test-runner-create-suite #'test-runner-create-suite)
  (a-test :test-runner-create-suite-recursive #'test-runner-create-suite-recursive)
  (a-test :test-before-all #'test-before-all)
  (a-test :test-async-before-all #'test-async-before-all)
  (a-test :test-before-all-recursive #'test-before-all-recursive)
  (a-test :test-after-all #'test-after-all)
  (a-test :test-async-after-all #'test-async-after-all)
  (a-test :test-after-all-order #'test-after-all-order)
  (a-test :test-after-all-recursive #'test-after-all-recursive)
  (a-test :test-before-each #'test-before-each)
  (a-test :test-async-before-each #'test-async-before-each)
  (a-test :test-before-each-recursive #'test-before-each-recursive)
  (a-test :test-after-each #'test-after-each)
  (a-test :test-async-after-each #'test-async-after-each)
  (a-test :test-after-each-order #'test-after-each-order)
  (a-test :test-after-each-recursive #'test-after-each-recursive)
  (a-test :test-timeout-test #'test-timeout-test)
  (a-test :test-timeout-suite #'test-timeout-suite)
  (a-test :test-timeout-suite-with-three-tests #'test-timeout-suite-with-three-tests)
  (a-test :test-timeout-suite-recursive-with-five-tests #'test-timeout-suite-recursive-with-five-tests)
  (a-test :test-timeout-suite-recursive-with-five-tests-one-test-reconfigured #'test-timeout-suite-recursive-with-five-tests-one-test-reconfigured)
  (a-test :test-timeout-suite-recursive-with-five-tests-suite-2-reconfigured #'test-timeout-suite-recursive-with-five-tests-suite-2-reconfigured)
  (a-test :test-timeout-suite-recursive-with-five-tests-suite-2-reconfigured-with-one-test-reconfigured #'test-timeout-suite-recursive-with-five-tests-suite-2-reconfigured-with-one-test-reconfigured)
  (a-test :test-timeout-before-all #'test-timeout-before-all)
  (a-test :test-timeout-before-all-with-tests-in-suite-root #'test-timeout-before-all-with-tests-in-suite-root)
  (a-test :test-timeout-async-before-all #'test-timeout-async-before-all)
  (a-test :test-timeout-before-all-recursive #'test-timeout-before-all-recursive)
  (a-test :test-timeout-after-all #'test-timeout-after-all)
  (a-test :test-timeout-after-all-with-tests-in-suite-root #'test-timeout-after-all-with-tests-in-suite-root)
  (a-test :test-timeout-async-after-all #'test-timeout-async-after-all)
  (a-test :test-timeout-after-all-recursive #'test-timeout-after-all-recursive)
  (a-test :test-timeout-before-each #'test-timeout-before-each)
  (a-test :test-timeout-before-each-with-tests-in-suite-root #'test-timeout-before-each-with-tests-in-suite-root)
  (a-test :test-timeout-async-before-each #'test-timeout-async-before-each)
  (a-test :test-timeout-before-each-recursive #'test-timeout-before-each-recursive)
  (a-test :test-timeout-after-each #'test-timeout-after-each)
  (a-test :test-timeout-after-each-with-tests-in-suite-root #'test-timeout-after-each-with-tests-in-suite-root)
  (a-test :test-timeout-async-after-each #'test-timeout-async-after-each)
  (a-test :test-timeout-after-each-recursive #'test-timeout-after-each-recursive)
  (a-test :test-not-only-test #'test-not-only-test)
  (a-test :test-only-test #'test-only-test)
  (a-test :test-only-test-with-two-only-tests #'test-only-test-with-two-only-tests)
  (a-test :test-only-test-recursive-with-three-only-tests #'test-only-test-recursive-with-three-only-tests)
  (a-test :test-only-test-recursive-with-two-suites-in-suite-root #'test-only-test-recursive-with-two-suites-in-suite-root)
  (a-test :test-only-suite #'test-only-suite)
  (a-test :test-only-suite-recursive #'test-only-suite-recursive)
  (a-test :test-only-suite-recursive-with-one-only-test #'test-only-suite-recursive-with-one-only-test)
  (a-test :test-only-suite-recursive-with-two-only-test #'test-only-suite-recursive-with-two-only-test)
  (a-test :test-only-suite-recursive-with-two-only-suite #'test-only-suite-recursive-with-two-only-suite)
  (a-test :test-only-suite-recursive-with-two-only-suite-and-three-only-test #'test-only-suite-recursive-with-two-only-suite-and-three-only-test)
  (a-run))

