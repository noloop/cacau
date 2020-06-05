(in-package #:noloop.cacau)

(defun cacau-logo ()
  (format t "~a~%~%" (cacau-string-color "<=> Cacau <=>" "red"
                                           :background "yellow"
                                           :style "underline")))

(defun separation-bar (&optional color)
  (format t "~%~a~%" (cacau-string-color  "-------------------------" color)))

(defun suite-tests-list-events (runner)
  (let ((current-parent :suite-root)
        (spaces ""))
    (on-runner
     runner
     :suite-start
     (lambda (suite)
       (unless (equal :suite-root (name suite))
         (format t "~a~%"
                 (concatenate 'string
                              (unless (equal current-parent (name (parent suite)))
                                (setf current-parent (name (parent suite)))
                                (setf spaces (concatenate 'string " ")))
                              (cacau-string-color (string-if-not-string (name suite)) "blue"))))))
    (on-runner
     runner
     :suite-end
     (lambda (suite)
       (setf current-parent (unless (equal :suite-root (name suite))
                              (name (parent suite))))
       (setf spaces (when (> (length spaces) 0) (subseq spaces 1)))))
    (on-runner
     runner
     :pass
     (lambda (test)
       (format t "~a~%"
               (concatenate 'string spaces
                            (cacau-string-color
                             (concatenate 'string " -> " (string-if-not-string (name test)))
                             "green")))))
    (on-runner
     runner
     :fail
     (lambda (test) 
       (format t "~a~%~a~%~a~%"
	       (cacau-string-color
                             (concatenate 'string
                                          spaces
                                          " <- "
                                          (string-if-not-string (name test))
                                          ":")
                             "red" :style "underline")
	       (cacau-string-color "Error message:" "red" :style "underline")
	       (cacau-string-color (gethash :message (runnable-error test)) "white"))))))

(defun epilogue (runner-result)
  (let ((passed-tests
          (concatenate 'string (write-to-string (gethash :passing runner-result)) " passed"))
        (failed-tests
          (concatenate 'string (write-to-string (gethash :failing runner-result)) " failed")))
    (format t "~a~a~a~%~%"
            (cacau-string-color "From " "white")
            (cacau-string-color (write-to-string (gethash :tests runner-result)) "blue")
            (cacau-string-color " running tests: " "white"))
    (format t "~a~%" (cacau-string-color passed-tests "green"))
    (format t "~a~%" (cacau-string-color failed-tests "red"))))

(defun skipped (runner-result)
  (when (> (gethash :skip-suites runner-result) 0)
    (format t "~a~%" (cacau-string-color
                      (concatenate
                       'string
                       (write-to-string (gethash :skip-suites runner-result))
                       " suite"
                       (if (> (gethash :skip-suites runner-result) 1) "s" "")
                       " skipped")
                      "cyan")))
  (when (> (gethash :skip-tests runner-result) 0)
    (format t "~a~%" (cacau-string-color
                      (concatenate
                       'string
                       (write-to-string (gethash :skip-tests runner-result))
                       " test"
                       (if (> (gethash :skip-tests runner-result) 1) "s" "")
                       " skipped")
                      "cyan"))))

(defun create-format-gethash-text-color (runner-result)
  (lambda (key text &optional color)
    (format t "~a~%"
            (cacau-string-color
             (concatenate 'string
                          (write-to-string (gethash key runner-result))
                          text)
             color))))

(defun custom-result (runner-result options)
  (let ((format-color (create-format-gethash-text-color runner-result)))
    (dolist (i options)
      (cond ((equal :running-suites i)
             (funcall format-color :suites " running suites" "blue"))
            ((equal :running-tests i)
             (funcall format-color :tests " running tests" "blue"))
            ((equal :only-suites i)
             (funcall format-color :only-suites " only suites" "purple"))
            ((equal :only-tests i)
             (funcall format-color :only-tests " only tests" "purple"))
            ((equal :skip-suites i)
             (funcall format-color :skip-suites " skip suites" "cyan"))
            ((equal :skip-tests i)
             (funcall format-color :skip-tests " skip tests" "cyan"))
            ((equal :total-suites i)
             (funcall format-color :total-suites " total suites" "white"))
            ((equal :total-tests i)
             (funcall format-color :total-tests " total tests" "white"))
            ((equal :passing i)
             (funcall format-color :passing " passed" "green"))
            ((equal :failing i)
             (funcall format-color :failing " failed" "red"))
            ((equal :errors i)
             (format t "~a~%" (cacau-string-color
                               (concatenate 'string
                                            (write-to-string (length (gethash :errors runner-result)))
                                            " errors")
                               "black")))
            ((equal :run-start i)
             (funcall format-color :run-start " run start" "white"))
            ((equal :run-end i)
             (funcall format-color :run-end " run end" "white"))
            ((equal :run-duration i)
             (funcall format-color :run-duration " run duration" "yellow"))
            ((equal :completed-suites i)
             (funcall format-color :completed-suites " completed suites" "green"))
            ((equal :completed-tests i)
             (funcall format-color :completed-tests " completed tests" "green"))))))

(defun full-epilogue (runner-result options)
  (format t "~%~a" (cacau-string-color "Epilogue" nil))
  (separation-bar)
  (if options
      (custom-result runner-result options)
      (custom-result
       runner-result
       '(:running-suites
         :running-tests
         :only-suites
         :only-tests
         :skip-suites
         :skip-tests
         :total-suites
         :total-tests
         :passing
         :failing
         :errors
         :run-start
         :run-end
         :run-duration
         :completed-suites
         :completed-tests))))

(defun stack-test-errors (runner-result &key (reverse-list t))
  (let ((errors (if reverse-list
                    (reverse (gethash :errors runner-result))
                    (gethash :errors runner-result))))
    (when (> (length errors) 0)
      (format t "~%~a" (cacau-string-color  "Errors" "red")))
    (dolist (test-err errors)
      (separation-bar "red")
      (format t "~a~%"
              (cacau-string-color
               (concatenate 'string
                            "Suite: "
                            (string-if-not-string (gethash :parent test-err)))
               "red"))
      (format t "~a~%"
              (cacau-string-color
               (concatenate 'string
                            "Test: "
                            (string-if-not-string (gethash :name test-err)))
               "red"))
      (format t "~a~%"
              (cacau-string-color
               (concatenate 'string
                            (format nil "Message:~%")
                            (string-if-not-string (gethash :message (gethash :error test-err))))
               "red"))
      (format t "~a" (cacau-string-color "Read Stack (y/n)? " "red"))
      (when (read-yes)
        (dolist (line (gethash :stack (gethash :error test-err)))
          (format t "~a~%" (cacau-string-color (write-to-string line) "red")))))))

