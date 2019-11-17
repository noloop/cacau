;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
(defsystem :cacau-examples-asdf-integration
  :components ((:file "cacau-examples-asdf-integration"))
  :in-order-to ((test-op (test-op :cacau-examples-asdf-integration-test))))

