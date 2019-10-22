(in-package #:noloop.cacau)

(defmacro with-gensyms (vars &body body)
  `(let ,(loop for v in vars collect `(,v (gensym)))
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

(defmacro create-list-iterator (new-list)
  "Creates a new lambda that returns the next item in the new-list reverted. Returns nil if there is not the next item in the list. Example:
(let* ((itens '(1 2))
       (next-item (create-list-iterator itens)))
  (print (funcall next-item))
  (print (funcall next-item))
  (print (funcall next-item)))
=>
1
2
NIL"
  (with-gensyms (itens)
    `(let ((,itens (reverse ,new-list)))
       (lambda ()
         (let ((current-item (car ,itens)))
           (when (> (length ,itens) 0)
             (setf ,itens (cdr ,itens))
             current-item))))))

(defmacro defvar* (bindings)
  `(progn
     ,@(mapcar #'(lambda (var)
                   (let ((var-list-p (listp var)))
                     (if var-list-p
                         (check-type (car var) symbol)
                         (check-type var symbol))
                     `(defvar
                          ,(if (listp var)
                               (car var)
                               var)
                        ,(if (listp var)
                             (cadr var)
                             nil))))
               bindings)))

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

(defun string-ansi-color (stg color &key style background)
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
    (format nil (concatenate 'string "~c[" style color background "m" stg "~c[0m") #\ESC #\ESC)))

(defun read-yes ()
  (find (read-line) '("yes" "y" "t") :test #'string-equal))

(defun string-if-not-string (value)
  (if (typep value 'string)
      value
      (write-to-string value)))

