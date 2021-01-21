(cl:defpackage #:shared-prefs
  (:nicknames #:shared-preferences)
  (:use #:cl)
  (:export #:scope
           #:scopep
           #:preferences-1
           #:preferences
           #:preferencesp
           #:preferences-mixin

           #:define-setting
           #:preferences-class
           #:standard-preferences
           #:define-settings
           #:define-defaults))
