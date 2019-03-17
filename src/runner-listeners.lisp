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
                 (:completed-suites 0)
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
        :pass
        (lambda ()
          t))

    (on bus
        :fail
        (lambda ()
          t))

    (on bus
        :suite-end
        (lambda (suite)
          (unless (eq :suite-root (name suite))
              (next-child (parent suite))
              (incf (gethash :completed-suites result-hash)))))

    (on bus
        :test-end
        (lambda (test)
          (if (runnable-error test)
              (emit bus :fail)
              (emit bus :pass))
          (incf (gethash :completed-tests result-hash))
          (when (= (get-run-progress runner) 100)
            (emit bus :run-end))))
    
    (once bus
          :run-start
          (lambda ()
            (setf (gethash :run-start result-hash) (get-universal-time))))

    (once bus
          :run-abort
          (lambda ()
            (emit bus :run-end)))

    (once bus
          :run-end
          (lambda ()
            (setf (gethash :run-end result-hash) (get-universal-time))
            (setf (gethash :run-duration result-hash)
                  (- (gethash :run-end result-hash)
                     (gethash :run-start result-hash)))
            (emit bus :end)))))

