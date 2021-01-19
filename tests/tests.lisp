(cl:defpackage #:shared-preferences_tests
  (:use #:cl #:parachute))

(cl:in-package #:shared-preferences_tests)

(shared-prefs:define-settings preferences-a ()
  ((a-1 'd-1)
   (a-2 'd-2)))

(shared-prefs:define-settings preferences-b ()
  ((b-1 'd-3)
   (b-2 'd-4)))

(defclass preferences-ab (preferences-a preferences-b)
  ())

(define-test "main"
  (let ((prefs (make-instance 'preferences-a)))
    (is eq 'd-1 (a-1 prefs))
    (is eq 'd-2 (a-2 prefs)))
  (let ((prefs (make-instance 'preferences-a 'a-1 'v-1)))
    (is eq 'v-1 (a-1 prefs))
    (is eq 'd-2 (a-2 prefs))
    (let ((prefs (make-instance 'preferences-a :parent prefs)))
      (is eq 'v-1 (a-1 prefs))
      (is eq 'd-2 (a-2 prefs)))))
