;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-

(defsystem :cacau
  :author "noloop <noloop@zoho.com>"
  :maintainer "noloop <noloop@zoho.com>"
  :license "GPLv3"
  :version "0.1.0"
  :homepage "https://github.com/noloop/cacau"
  :bug-tracker "https://github.com/noloop/cacau/issues"
  :source-control (:git "git@github.com:noloop/cacau.git")
  :description "Test Runner in Common Lisp."
  :depends-on (:eventbus)
  :components ((:module "src"
                :components
                ((:file "package")
                 (:file "utils" :depends-on ("package"))
                 (:file "runnable" :depends-on ("package"))
                 (:file "list-iterator" :depends-on ("package"))
                 (:file "test" :depends-on ("runnable" "utils"))
                 (:file "suite" :depends-on ("test" "list-iterator"))
                 (:file "runner-listeners" :depends-on ("package"))
                 (:file "runner" :depends-on ("runner-listeners" "suite"))
                 )))
                :in-order-to ((test-op (test-op "cacau/test"))))

;; (:file "cacau" :depends-on ("runner"))

(defsystem :cacau/test
  :author "noloop <noloop@zoho.com>"
  :maintainer "noloop <noloop@zoho.com>"
  :license "GPLv3"
  :description "cacau Test."
  :depends-on (:cacau)
  :serial t
  :components ((:module "test"
                :components
                ((:file "async-runner")
                 (:file "runner-test")
                 (:file "before-all-test")
                 (:file "run"))))
  :perform (test-op (op c)
                    (symbol-call :cacau-test '#:run)))
