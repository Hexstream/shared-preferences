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


(shared-prefs:define-settings preferences-c ()
  ((c-1)
   c-2))

(shared-prefs:define-settings preferences-d ()
  (d-1
   (d-2)))

(defclass preferences-cd (preferences-c preferences-d)
  ())

(shared-prefs:define-defaults
  (c-1 'd-1)
  (c-2 'd-2)
  (d-1 'd-3)
  (d-2 'd-4))

(defclass preferences-abcd (preferences-ab preferences-cd)
  ())

(shared-prefs:define-settings preferences-e ()
  (e))

(define-test "main"
  (flet ((test-prefs (class-name reader-a value-a reader-b value-b)
           (let ((prefs (make-instance class-name)))
             (is eq value-a (funcall reader-a prefs))
             (is eq value-b (funcall reader-b prefs)))
           (let ((prefs (make-instance class-name reader-a 'v-1)))
             (is eq 'v-1 (funcall reader-a prefs))
             (is eq value-b (funcall reader-b prefs))
             (let ((prefs (make-instance class-name :parent prefs)))
               (is eq 'v-1 (funcall reader-a prefs))
               (is eq value-b (funcall reader-b prefs))))))
    (test-prefs 'preferences-a 'a-1 'd-1 'a-2 'd-2)
    (test-prefs 'preferences-ab 'a-1 'd-1 'a-2 'd-2)
    (test-prefs 'preferences-abcd 'a-1 'd-1 'a-2 'd-2)
    (test-prefs 'preferences-b 'b-1 'd-3 'b-2 'd-4)
    (test-prefs 'preferences-ab 'b-1 'd-3 'b-2 'd-4)
    (test-prefs 'preferences-abcd 'b-1 'd-3 'b-2 'd-4)
    (test-prefs 'preferences-c 'c-1 'd-1 'c-2 'd-2)
    (test-prefs 'preferences-cd 'c-1 'd-1 'c-2 'd-2)
    (test-prefs 'preferences-abcd 'c-1 'd-1 'c-2 'd-2)
    (test-prefs 'preferences-d 'd-1 'd-3 'd-2 'd-4)
    (test-prefs 'preferences-cd 'd-1 'd-3 'd-2 'd-4)
    (test-prefs 'preferences-abcd 'd-1 'd-3 'd-2 'd-4)
    (let ((prefs (make-instance 'preferences-e)))
      (fail (e prefs)))))
