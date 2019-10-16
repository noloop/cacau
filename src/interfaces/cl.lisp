(in-package #:noloop.cacau)

(defmacro cond-options (options &body body)
  `(let ((only-p nil)
         (skip-p nil)
         (async nil)
         (async-done nil)
         (timeout -1))
     (dolist (i ,options)
       (cond ((equal :only i)
              (setf only-p t))
             ((equal :skip i)
              (setf skip-p t))
             ((listp i)
              (cond ((equal :timeout (first i))
                     (setf timeout (second i)))
                    ((equal :async (first i))
                     (progn (setf async t)
                            (setf async-done (second i))))))))
     ,@body))

(defmacro defbefore-all (name options &body body)
  (cond-options options
    `(common-create-before-all
      ,name
      ,(if async
           `(lambda (,async-done) ,@body)
           `(lambda () ,@body))
      :timeout ,timeout)))

(defmacro defafter-all (name options &body body)
  (cond-options options
    `(common-create-after-all
      ,name
      ,(if async
           `(lambda (,async-done) ,@body)
           `(lambda () ,@body))
      :timeout ,timeout)))

(defmacro defbefore-each (name options &body body)
  (cond-options options
    `(common-create-before-each
      ,name
      ,(if async
           `(lambda (,async-done) ,@body)
           `(lambda () ,@body))
      :timeout ,timeout)))

(defmacro defafter-each (name options &body body)
  (cond-options options
    `(common-create-after-each
      ,name
      ,(if async
           `(lambda (,async-done) ,@body)
           `(lambda () ,@body))
      :timeout ,timeout)))

(defmacro defsuite (name options &body body)
  (cond-options options
    `(common-create-suite
      ,name
      (lambda () ,@body)
      :only-p ,only-p
      :skip-p ,skip-p
      :timeout ,timeout)))

(defmacro deftest (name options &body body)
  (cond-options options
    `(common-create-test
      ,name
      ,(if async
           `(lambda (,async-done) ,@body)
           `(lambda () ,@body))
      :only-p ,only-p
      :skip-p ,skip-p
      :timeout ,timeout)))

