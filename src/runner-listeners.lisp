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
          (incf (gethash :passing result-hash))))

    (on bus
        :fail
        (lambda ()
          (incf (gethash :failing result-hash))))

    (on bus
        :suite-end
        (lambda (suite)
          (let* ((suite-root-p
                   (eq :suite-root (name suite)))
                 (suite-next-fn
                   (lambda ()
                     (unless suite-root-p
                       (next-child (parent suite)) 
                       (incf (gethash :completed-suites result-hash))))))
            (if (after-all suite)
                (run-runnable (after-all suite)
                              (lambda ()
                                (funcall suite-next-fn)))
                (funcall suite-next-fn)))))

    (on bus
        :test-end
        (lambda (test)
          (if (runnable-error test)
              (let ((new-error (make-hash-table)))
                (setf-hash new-error
                           `((:name ,(name test))
                             (:fn ,(fn test))
                             (:parent ,(parent test))
                             (:error ,(runnable-error test))))
                (push new-error (gethash :errors result-hash))
                (emit bus :fail))
              (emit bus :pass))
          (incf (gethash :completed-tests result-hash))
          (when (= (get-run-progress runner) 100)
            (emit bus :run-end))))
    
    (once bus
          :run-start
          (lambda ()
            (setf (gethash :run-start result-hash) (get-internal-real-time))))

    (once bus
          :run-abort
          (lambda ()
            (emit bus :run-end)))

    (once bus
          :run-end
          (lambda ()
            (setf (gethash :run-end result-hash) (get-internal-real-time))
            (let ((duration (- (gethash :run-end result-hash)
                        (gethash :run-start result-hash))))
              (setf (gethash :run-duration result-hash)
                    (/ (if (<= duration 0) 1 duration)
                       internal-time-units-per-second)))
            (emit bus :end)))))

