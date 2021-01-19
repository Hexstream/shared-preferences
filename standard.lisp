(in-package #:shared-preferences)

(defmacro shared-prefs:define-setting (name default-value)
  `(defgeneric ,name (preferences)
     (:method ((default null))
       ,default-value)))

(defclass shared-prefs:preferences-class (inheriting-readers:standard-class)
  ()
  (:metaclass inheriting-readers:standard-metaclass)
  (:inheritance-schemes t (:parent-function #'inheriting-readers:parent :nil-is-valid-parent-p t))
  (:default-initargs :inherit t))

(defclass shared-prefs:standard-preferences (inheriting-readers:parent-mixin shared-prefs:preferences)
  ())

(defmacro shared-prefs:define-settings (preferences-class-name direct-superclasses settings &rest options)
  (let ((settings (mapcar (lambda (setting)
                            (destructuring-bind (name default &rest slot-options) setting
                              (declare (ignore slot-options))
                              `(shared-prefs:define-setting ,name ,default)))
                          settings))
        (slots (mapcar (lambda (setting)
                         (destructuring-bind (reader default &rest slot-options) setting
                           (declare (ignore default))
                           (let ((name (intern (format nil "%~A" (symbol-name reader)))))
                             `(,name :initarg ,reader
                                     :reader ,reader
                                     ,@slot-options))))
                       settings))
        (direct-superclasses (or direct-superclasses '(shared-prefs:standard-preferences)))
        (options (unless (member :metaclass options :key #'car :test #'eq)
                   (list '(:metaclass shared-prefs:preferences-class)))))
    `(progn
       ,@settings
       (defclass ,preferences-class-name ,direct-superclasses
         ,slots
         ,@options))))
