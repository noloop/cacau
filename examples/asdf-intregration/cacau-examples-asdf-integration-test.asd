(defsystem :cacau-examples-asdf-integration-test
  :depends-on (:cacau-examples-asdf-integration
               :cacau
               :assert-p)
  :defsystem-depends-on (:cacau-asdf)
  :components ((:file "cacau-examples-asdf-integration-test"))
  :perform (test-op (op c)
		    (progn
		      (funcall (intern #.(string :run-cacau-asdf) :cacau-asdf) c)
		      (symbol-call :cacau '#:run))))
