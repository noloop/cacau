(in-package #:noloop.cacau)

(defun reporter-list (runner)
  (cacau-logo)
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
       (format t "~a~%"
               (concatenate 'string
                            (cacau-string-color
                             (concatenate 'string
                                          spaces
                                          " <- "
                                          (string-if-not-string (name test))
                                          ":")
                             "red" :style "underline")
                            " "
                            (cacau-string-color (gethash :message (runnable-error test)) "white"))))))
  (lambda ()
    (separation-bar)
    (epilogue (result runner))))

