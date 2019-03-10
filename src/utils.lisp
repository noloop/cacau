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

(defun arglist (fn)
  "Return the signature of the function."
  #+allegro (excl:arglist fn)
  #+clisp (sys::arglist fn)
  #+(or cmu scl)
  (let ((f (coerce fn 'function)))
    (typecase f
      (STANDARD-GENERIC-FUNCTION (pcl:generic-function-lambda-list f))
      (EVAL:INTERPRETED-FUNCTION (eval:interpreted-function-arglist f))
      (FUNCTION (values (read-from-string (kernel:%function-arglist f))))))
  #+cormanlisp (ccl:function-lambda-list
                (typecase fn (symbol (fdefinition fn)) (t fn)))
  #+gcl (let ((fn (etypecase fn
                    (symbol fn)
                    (function (si:compiled-function-name fn)))))
          (get fn 'si:debug))
  #+lispworks (lw:function-lambda-list fn)
  #+lucid (lcl:arglist fn)
  #+sbcl (sb-introspect:function-lambda-list fn)
  #-(or allegro clisp cmu cormanlisp gcl lispworks lucid sbcl scl)
  (error 'not-implemented :proc (list 'arglist fn)))

(defun get-function-args-length (func) 
  (length (arglist func)))
