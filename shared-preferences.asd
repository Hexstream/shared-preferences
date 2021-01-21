(asdf:defsystem #:shared-preferences

  :author "Jean-Philippe Paradis <hexstream@hexstreamsoft.com>"

  :license "Unlicense"

  :description "Notably allows flexible specification of package-local preferences."

  :depends-on ("trivial-garbage"
               "inheriting-readers")

  :version "1.1"
  :serial cl:t
  :components ((:file "package")
               (:file "core")
               (:file "standard"))

  :in-order-to ((asdf:test-op (asdf:test-op #:shared-preferences_tests))))
