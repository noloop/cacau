(in-package #:noloop.cacau)

(defun create-runner-listeners (runner)
  (let ((result-hash (result runner))
        (bus (eventbus runner))
        (abortedp nil))

    ;; (setf (gethash :suites result-hash) 0)
    ;; (setf (gethash :tests result-hash) 0)
    ;; (setf (gethash :passing result-hash) 0)
    ;; (setf (gethash :failing result-hash) 0)
    ;; (setf (gethash :errors result-hash) '())
    ;; (setf (gethash :run-start result-hash) 0)
    ;; (setf (gethash :run-end result-hash) 0)
    ;; (setf (gethash :run-duration result-hash) 0)
    ;; (setf (gethash :completed-suites result-hash) 0)
    ;; (setf (gethash :completed-tests result-hash) 0)
    
    (setf-hash result-hash 
               `((:suites ,0)
                 (:tests ,0)
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
          (incf (gethash :failing result-hash))
          ;;(inspect result-hash)
          ))

    (on bus
        :suite-end
        (lambda (suite)
          (let* ((suite-root-p
                   (eq :suite-root (name suite)))
                 (suite-next-fn
                   (lambda ()
                     ;;(format t "~%suite-root-p: ~a~%" suite-root-p)
                     ;;(inspect suite)
                     (unless suite-root-p
                       ;;(format t "~%next-child: ~a~%" (name suite))
                       (progn (next-child (parent suite))  
                              (incf (gethash :completed-suites result-hash)))))))
            (if (after-all suite)
                (run-runnable (after-all suite)
                              (lambda ()
                                (funcall suite-next-fn)))
                (funcall suite-next-fn)))))

    (on bus
        :test-end
        (lambda (test)
          ;;(format t "~%test-end: ~a~%" (name test))
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
                ;;(format t "~%hook-end-len-1: ~a~%" (length (gethash :errors result-hash)))
                (push new-error (gethash :errors result-hash))
                ;;(format t "~%hook-end-len-2: ~a~%" (length (gethash :errors result-hash)))
                ;; (setf (gethash :errors result-hash)
                ;;       (cons new-error (gethash :errors result-hash)))
                ;;(inspect (gethash :errors result-hash))
                ;;(format t "~%hook-end: ~a~%" "hook")
                (emit bus :run-abort)))))
    
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
            ;;(inspect result-hash)
            (emit bus :end)))))

