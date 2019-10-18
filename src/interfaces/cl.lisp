(in-package #:noloop.cacau)

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

