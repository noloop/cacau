(in-package #:noloop.cacau)

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

