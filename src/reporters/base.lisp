(in-package #:noloop.cacau)

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

(defmacro format-string-ansi-color (stg color &key style background (return-string-p t))
  (let ((color (cond ((equal "black" color) "30")
                     ((equal "red" color) "31")
                     ((equal "green" color) "32")
                     ((equal "yellow" color) "33")
                     ((equal "blue" color) "34")
                     ((equal "purple" color) "35")
                     ((equal "cyan" color) "36")
                     ((equal "white" color) "37")
                     (t "0")))
        (style (cond ((equal "bold" style) "1;")
                     ((equal "italic" style) "3;")
                     ((equal "underline" style) "4;")
                     ((equal "blink" style) "5;")
                     ((equal "strick" style) "9;")
                     (t "")))
        (background (cond ((equal "black" background) ";40")
                          ((equal "red" background) ";41")
                          ((equal "green" background) ";42")
                          ((equal "yellow" background) ";43")
                          ((equal "blue" background) ";44")
                          ((equal "purple" background) ";45")
                          ((equal "cyan" background) ";46")
                          ((equal "white" background) ";47")
                          (t ""))))
    `(format ,return-string-p ,(concatenate 'string "~c[" style color background "m" stg "~c[0m") #\ESC #\ESC)))

