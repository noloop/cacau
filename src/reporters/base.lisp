(in-package #:noloop.cacau)

(defun cacau-logo ()
  (format t "~%~a~%~%" (cacau-string-color "<=> Cacau <=>" "red"
                                           :background "yellow"
                                           :style "underline")))

(defun separation-bar (&optional color)
  (format t "~%~a~%" (cacau-string-color  "-------------------------" color)))

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

(defun test-stack-error (runner-result)
  (dolist (test-err (gethash :errors runner-result))
    (separation-bar "red")
    (format t "~%~a~%"
            (cacau-string-color
             (concatenate 'string
                          "In Test: "
                          (gethash :name test-err))
             "red"))
    (format t "~a~%~%"
            (cacau-string-color
             (concatenate 'string
                          "Message: "
                          (gethash :message (gethash :error test-err)))
             "red"))
    (format t "~%~a" (cacau-string-color "Read Stack (y/n)? " "red"))
    (when (read-yes)
      (dolist (line (gethash :stack (gethash :error test-err)))
        (format t "~a~%" (cacau-string-color (write-to-string line) "red"))))))

