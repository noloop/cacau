(in-package #:cl-user)
(defpackage #:cacau-asdf
  (:use #:common-lisp)
  (:import-from #:asdf
  		#:component-children
  		#:component-pathname)
  (:import-from #:cl-fad
		#:directory-exists-p
		#:file-exists-p)
  (:export #:run-cacau-asdf))
(in-package #:cacau-asdf)

(defun run-cacau-asdf (c)
  (dolist (child (component-children c))
    (let ((path (component-pathname child)))
      (cond ((pathname-is-file path)
	     (load path))
	    ((directory-exists-p path)
	     (run-cacau-asdf child))))))

(defun pathname-is-file (path)
  (and (not (directory-exists-p path))
       (file-exists-p path)))

