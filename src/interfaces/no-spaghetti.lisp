(in-package #:noloop.cacau)

(defmacro defbefore-plan (name options &body body)
  (cond-options options
    `(common-create-before-all
      ,name
      ,(if async
           `(lambda (,async-done) ,@body)
           `(lambda () ,@body))
      :timeout ,timeout)))

(defmacro defafter-plan (name options &body body)
  (cond-options options
    `(common-create-after-all
      ,name
      ,(if async
           `(lambda (,async-done) ,@body)
           `(lambda () ,@body))
      :timeout ,timeout)))

(defmacro defbefore-t (name options &body body)
  (cond-options options
    `(common-create-before-each
      ,name
      ,(if async
           `(lambda (,async-done) ,@body)
           `(lambda () ,@body))
      :timeout ,timeout)))

(defmacro defafter-t (name options &body body)
  (cond-options options
    `(common-create-after-each
      ,name
      ,(if async
           `(lambda (,async-done) ,@body)
           `(lambda () ,@body))
      :timeout ,timeout)))

(defmacro in-plan (name &optional (options ()))
  (cond-options options
    `(common-create-suite-with-parent
      ,name
      :only-p ,only-p
      :skip-p ,skip-p
      :timeout ,timeout
      :parent ,parent)))

(defmacro deft (name options &body body)
  (cond-options options
    `(common-create-test
      ,name
      ,(if async
           `(lambda (,async-done) ,@body)
           `(lambda () ,@body))
      :only-p ,only-p
      :skip-p ,skip-p
      :timeout ,timeout)))

