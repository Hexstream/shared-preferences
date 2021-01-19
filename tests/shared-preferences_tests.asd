(asdf:defsystem #:shared-preferences_tests

  :author "Jean-Philippe Paradis <hexstream@hexstreamsoft.com>"

  :license "Unlicense"

  :description "shared-preferences unit tests."

  :depends-on ("shared-preferences"
               "parachute")

  :serial cl:t
  :components ((:file "tests"))

  :perform (asdf:test-op (op c) (uiop:symbol-call '#:parachute '#:test '#:shared-preferences_tests)))
