(in-package #:noloop.cacau)

(defmacro with-gensyms ((&rest names) &body body)
  `(let ,(loop for n in names collect `(,n (gensym)))
     ,@body))

(defmacro create-hash (&rest fields)
  "Example: (create-hash '((:a 1) (:b 2)))"
  (let ((new-hash-table (gensym)))
    `(let ((,new-hash-table (make-hash-table)))
       (dolist (i ,@fields)
         (setf (gethash (car i) ,new-hash-table) (cadr i)))
       ,new-hash-table)))

(defmacro setf-hash (hash &rest fields)
  "Example: (let ((hash (make-hash-table :test 'eq)))
  (setf-hash hash '((:a 1) (:b 2)))
  hash)"
  `(progn
     (dolist (i ,@fields)
       (setf (gethash (car i) ,hash) (cadr i)))
     ,hash))

