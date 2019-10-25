;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
(defsystem :cacau-examples-asdf-integration
  :components ((:file "cacau-examples-asdf-integration"))
  :in-order-to ((test-op (test-op :cacau-examples-asdf-integration-test))))

(defsystem :cacau-examples-asdf-integration-test
  :depends-on (:cacau-examples-asdf-integration
               :cacau
               :assert-p)
  :defsystem-depends-on (:cacau-asdf)
  :components ((:cacau-file "cacau-examples-asdf-integration-test"))
  :perform
  (test-op (op c)
           (progn
             (funcall (intern #.(string :run-cacau-asdf) :cacau) c)
             (symbol-call :cacau '#:run))))

