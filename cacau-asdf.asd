(defsystem :cacau-asdf
  :depends-on (:cl-fad)
  :components ((:module "src"
                :components
                ((:file "asdf")))))

