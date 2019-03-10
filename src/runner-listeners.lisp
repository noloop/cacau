(in-package #:noloop.cacau)

(defun create-runner-listeners (runner)
  (let ((result-hash (result runner))
        (bus (eventbus runner)))

    (setf-hash result-hash 
               '((:suites 0)
                 (:tests 0)
                 (:passing 0)
                 (:failing 0)
                 (:errors '())
                 (:run-start 0)
                 (:run-end 0)
                 (:run-duration 0)
                 (:completed-tests 0)))

    (on bus
        :add-suite
        (lambda (options)
          (declare (ignore options))
          (incf (gethash :suites result-hash))))

    (on bus
        :add-test
        (lambda (options)
          (declare (ignore options))
          (incf (gethash :tests result-hash))))

    (on bus
        :suite-end
        (lambda ()
          t))

    (on bus
        :test-end
        (lambda ()
          t))

    (once bus
          :run-start
          (lambda ()
            t))

    (once bus
          :run-abort
          (lambda ()
            t))

    (once bus
          :run-end
          (lambda ()
            t))))
