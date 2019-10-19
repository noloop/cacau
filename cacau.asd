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
                :serial t
                :components
                ((:file "asdf")
                 (:file "package")
                 (:module "kernel"
                  :serial t
                  :components
                  ((:file "utils")
                   (:file "timer")
                   (:file "runnable")
                   (:file "list-iterator")
                   (:file "test")
                   (:file "hook")
                   (:file "suite")
                   (:file "runner-listeners")
                   (:file "runner")))
                 (:file "cacau")
                 (:module "interfaces"
                  :serial t
                  :components
                  ((:file "common")
                   (:file "cl")
                   (:file "bdd")
                   (:file "tdd")
                   (:file "no-spaghetti"))))))
  :in-order-to ((test-op (test-op :cacau-test))))

