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
  :depends-on (:eventbus :assertion-error)
  :components ((:module "src"
                :components
                ((:file "asdf")
                 (:file "package")
                 (:file "utils" :depends-on ("package"))
                 (:file "timer" :depends-on ("package"))
                 (:file "runnable" :depends-on ("timer"))
                 (:file "list-iterator" :depends-on ("package"))
                 (:file "test" :depends-on ("runnable" "utils"))
                 (:file "hook" :depends-on ("runnable"))
                 (:file "suite" :depends-on ("test" "list-iterator" "hook"))
                 (:file "runner-listeners" :depends-on ("package"))
                 (:file "runner" :depends-on ("runner-listeners" "suite"))
                 (:module "interfaces"
                  :components
                  ((:file "common")
                   (:file "cl")
                   (:file "bdd")
                   (:file "tdd")
                   (:file "no-spaghetti"))))))
                :in-order-to ((test-op (test-op "cacau/test"))))

