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
                 (:file "test" :depends-on ("runnable"))
                 (:file "suite" :depends-on ("runnable" "test"))
                 (:file "runner-listeners" :depends-on ("utils"))
                 (:file "runner" :depends-on ("runner-listeners" "test" "suite"))
                 (:file "cacau" :depends-on ("runner")))))
  :in-order-to ((test-op (test-op "cacau/test"))))

(defsystem :cacau/test
  :author "noloop <noloop@zoho.com>"
  :maintainer "noloop <noloop@zoho.com>"
  :license "GPLv3"
  :description "cacau Test."
  :depends-on (:cacau)
  :components ((:module "test"
                :components
                ((:file "async-runner")
                 (:file "cacau-test" :depends-on ("async-runner")))))
  :perform (test-op (op c)
                    (symbol-call :cacau-test '#:run)))
