(defsystem :cacau-test
  :author "noloop <noloop@zoho.com>"
  :maintainer "noloop <noloop@zoho.com>"
  :license "GPLv3"
  :description "cacau Test."
  :depends-on (:cacau :assert-p)
  :defsystem-depends-on (:cacau-asdf)
  :components
  ((:module "t"
    :components
    ((:file "async-runner")
     (:module "unit"
      :components
      ((:cacau-file "runner-test")
       (:cacau-file "suite-test")
       (:cacau-file "before-all-test")
       (:cacau-file "after-all-test")
       (:cacau-file "before-each-test")
       (:cacau-file "after-each-test")
       (:cacau-file "timeout-test")
       (:cacau-file "only-test")
       (:cacau-file "skip-test")
       (:cacau-file "skip-only-rule-test")))
     (:module "interface"
      :components
      ((:cacau-file "new-tdd-test")
       (:cacau-file "bdd-test")
       (:cacau-file "cl-test")
       (:cacau-file "no-spaghetti-test"))))))
  :perform
  (test-op (op c)
           (progn
             (funcall (intern #.(string :run-cacau-asdf) :cacau) c)
             (symbol-call :cacau-test '#:a-run))))
