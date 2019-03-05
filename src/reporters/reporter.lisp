(in-package #:noloop.cacau)

;; REPORTER
(defun reporter (runner-result &key return-string-p)
  (let ((suite-results (car runner-result))
        (end-result (cadr runner-result))
        (epilogue ""))
    (dolist (suite suite-results)
      (dolist (test (cadr suite))
        (setf epilogue
              (concatenate 'string
                           epilogue
                           (format nil "~a: ~a~%" (car test) (cadr test)))))
      (setf epilogue
            (concatenate 'string
                         epilogue
                         (format nil "-----------------------------------~%" )
                         (format nil "~a: ~a~%~%" (car suite) (caddr suite)))))
    (setf epilogue
          (concatenate 'string
                       epilogue
                       (format nil "Runner result: ~a~%~%" end-result)))
    (if return-string-p
        (format nil "#...Simplet...#~%~%~a" epilogue)
        (format t "#...Simplet...#~%~%~a" epilogue))))
