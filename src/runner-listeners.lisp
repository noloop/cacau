(in-package #:noloop.cacau)

(defun create-runner-listeners (runner)
  (let ((result-hash (result runner))
        (bus (eventbus runner)))
    
    (setf-hash result-hash 
               `((:suites ,0)
                 (:tests ,0)
                 (:only-suites ,0)
                 (:only-tests ,0)
                 (:skip-suites ,0)
                 (:skip-tests ,0)
                 (:total-suites ,0)
                 (:total-tests ,0)
                 (:passing ,0)
                 (:failing ,0)
                 (:errors ,(list))
                 (:run-start ,0)
                 (:run-end ,0)
                 (:run-duration ,0)
                 (:completed-suites ,0)
                 (:completed-tests ,0)))

    (on bus
        :add-suite
        (lambda (options)
          (incf (gethash :total-suites result-hash))
          (let ((only-p (second options))
                (skip-p (fourth options)))
            (cond (only-p (incf (gethash :only-suites result-hash)))
                  (skip-p (incf (gethash :skip-suites result-hash)))
                  (t (incf (gethash :suites result-hash)))))))

    (on bus
        :add-test
        (lambda (options)
          (incf (gethash :total-tests result-hash))
          (let ((only-p (second options))
                (skip-p (fourth options)))
            (cond (only-p (incf (gethash :only-tests result-hash)))
                  (skip-p (incf (gethash :skip-tests result-hash)))
                  (t (incf (gethash :tests result-hash)))))))

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
                       (progn (next-child (parent suite))  
                              (incf (gethash :completed-suites result-hash)))))))
            (if (suite-after-all suite)
                (run-runnable (suite-after-all suite)
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
            ;;(format t "~%test-end: ~a~%" "test")
            (emit bus :run-end))))

    (on bus
        :hook-end
        (lambda (hook)
          (when (runnable-error hook)
              (let ((new-error (make-hash-table)))
                (setf-hash new-error
                           `((:name ,(name hook))
                             (:fn ,(fn hook))
                             (:parent ,(parent hook))
                             (:error ,(runnable-error hook))))
                (push new-error (gethash :errors result-hash))
                (emit bus :run-abort)))))
    
    (once bus
          :run-start
          (lambda ()
            (when (or (> (gethash :only-suites result-hash) 0) 
                      (> (gethash :only-tests result-hash) 0))
              (inherit-only-recursive (suite-root runner))
              (remove-not-only-children-recursive (suite-root runner)))
            (when (or (> (gethash :skip-suites result-hash) 0)
                      (> (gethash :skip-tests result-hash) 0))
              (remove-skip-children-recursive (suite-root runner))
              ;;(inspect (itens (children (suite-root runner))))
              )
            (setf (gethash :suites result-hash)
                  (count-suites-recursive (itens (children (suite-root runner)))))
            (when (zerop (setf (gethash :tests result-hash)
                               (count-tests-recursive (itens (children (suite-root runner))))))
              (emit bus :run-end))  
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
            ;;(inspect result-hash)
            (emit bus :end)))))

