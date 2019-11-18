;;;; -*- Mode: Lisp; Syntax: ANSI-Common-Lisp; Base: 10 -*-
(defsystem :cacau
  :author "noloop <noloop@zoho.com>"
  :maintainer "noloop <noloop@zoho.com>"
  :license "GPLv3"
  :version "1.0.0"
  :homepage "https://github.com/noloop/cacau"
  :bug-tracker "https://github.com/noloop/cacau/issues"
  :source-control (:git "git@github.com:noloop/cacau.git")
  :description "Test Runner in Common Lisp."
  :depends-on (:eventbus :assertion-error)
  :serial t
  :components ((:module "src"
                :components
                ((:file "package")
                 (:file "utils")
                 (:module "kernel"
                  :components
                  ((:file "timer")
                   (:file "runnable")
                   (:file "list-iterator")
                   (:file "test")
                   (:file "hook")
                   (:file "suite")
                   (:file "runner-listeners")
                   (:file "runner")))
                 (:module "reporters"
                  :components
                  ((:file "base")
                   (:file "min")
                   (:file "list")
                   (:file "full")))
                 (:file "cacau")
                 (:module "interfaces"
                  :components
                  ((:file "common")
                   (:file "cl")
                   (:file "bdd")
                   (:file "tdd")
                   (:file "no-spaghetti"))))))
  :in-order-to ((test-op (test-op :cacau-test))))

