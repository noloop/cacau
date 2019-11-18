;; Use cacau-file to load the file awalys that call test-system.
;; Use cacau-file-nd ("nd" of "never done") to load and compile the file awalys that call test-system.
(defsystem :cacau-examples-asdf-integration-test
  :depends-on (:cacau-examples-asdf-integration
               :cacau
               :assert-p)
  :defsystem-depends-on (:cacau-asdf)
  :components ((:cacau-file "cacau-examples-asdf-integration-test"))
  :perform (test-op (op c) (symbol-call :cacau '#:run)))

