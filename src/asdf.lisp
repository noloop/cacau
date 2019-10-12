(in-package #:cl-user)
(defpackage #:cacau-asdf
  (:nicknames #:cacau-asdf)
  (:use #:common-lisp
        #:asdf)
  (:export #:cacau-file
           #:run-cacau-asdf))
(in-package #:cacau-asdf)

(defvar *system-cacau-files* (make-hash-table))

(defclass cacau-file (asdf:cl-source-file) ())

(defmethod asdf:input-files ((o asdf:compile-op) (c cacau-file)) ())

(defmethod asdf:output-files ((o asdf:compile-op) (c cacau-file)) ())

(defmethod asdf:perform ((op asdf:compile-op) (c cacau-file)) ())

(defmethod asdf:perform ((op asdf:load-op) (c cacau-file))
  (pushnew c (gethash (asdf:component-system c) *system-cacau-files*)
           :key #'asdf:component-pathname
           :test #'equal))

(defun run-cacau-asdf (system-designator)
  #+quicklisp (ql:quickload (if (typep system-designator 'asdf:system)
                                (asdf:component-name system-designator)
                                system-designator))
  #-Quicklisp (asdf:load-system system-designator)
  (restart-case
      (dolist (c (reverse
                  (gethash (asdf:find-system system-designator) *system-cacau-files*)))
        (restart-case
            (asdf:perform 'asdf:load-source-op c)))))

(import 'cacau-file :asdf)

