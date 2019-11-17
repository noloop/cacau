(defsystem :cacau-test
  :author "noloop <noloop@zoho.com>"
  :maintainer "noloop <noloop@zoho.com>"
  :license "GPLv3"
  :description "cacau Test."
  :depends-on (:cacau :assert-p)
  :defsystem-depends-on (:cacau-asdf)
  :components
  ((:module "t"
    :serial t
    :components
    ((:file "recursive-runner")
     (:module "functional"
      :components
      ((:file "runner-test")
       (:file "suite-test")
       (:file "test-test")     
       (:file "before-all-test")
       (:file "after-all-test")
       (:file "before-each-test")
       (:file "after-each-test")
       (:file "timeout-test")
       (:file "only-test")
       (:file "skip-test")
       (:file "skip-only-rule-test")))
     (:module "interface"
      :components
      ((:file "cl-test")
       (:file "bdd-test")
       (:file "tdd-test")
       (:file "no-spaghetti-test")
       (:file "mix-test")))
     (:module "reporter"
      :components
      ((:file "min-test")
       (:file "list-test")
       (:file "full-test"))))))
  :perform
  (test-op (op c)
           (progn
	     (funcall (intern #.(string :run-cacau-asdf) :cacau-asdf) c)
             (symbol-call :cacau-test '#:r-run))))

