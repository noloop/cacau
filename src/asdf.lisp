(in-package #:cl-user)
(defpackage #:cacau-asdf
  (:use #:common-lisp)
  (:import-from #:asdf
		#:cl-source-file
		#:operation-done-p
  		#:load-op
  		#:compile-op)
  (:export #:cacau-file
	   #:cacau-file-nd))
(in-package #:cacau-asdf)

(defclass cacau-file (cl-source-file) ())
(defmethod operation-done-p ((op load-op) (c cacau-file)) nil)
(defmethod operation-done-p ((op compile-op) (c cacau-file)) t)
(import 'cacau-file :asdf)

(defclass cacau-file-nd (cl-source-file) ())
(defmethod operation-done-p ((op load-op) (c cacau-file-nd)) nil)
(defmethod operation-done-p ((op compile-op) (c cacau-file-nd)) nil)
(import 'cacau-file-nd :asdf)
