(in-package #:shared-preferences)

(defmacro shared-prefs:define-setting (name &optional (default-value nil default-value-p))
  `(defgeneric ,name (preferences)
     ,@(when default-value-p
         (list `(:method ((default null))
                  ,default-value)))))

(defclass shared-prefs:preferences-class (inheriting-readers:standard-class)
  ()
  (:metaclass inheriting-readers:standard-metaclass)
  (:inheritance-schemes t (:parent-function #'inheriting-readers:parent :nil-is-valid-parent-p t))
  (:default-initargs :inherit t))

(defclass shared-prefs:standard-preferences (inheriting-readers:parent-mixin shared-prefs:preferences)
  ())

(defmacro shared-prefs:define-settings (preferences-class-name direct-superclasses settings &rest options)
  (multiple-value-bind (settings slots)
      (flet ((parse (setting)
               (etypecase setting
                 (cons (destructuring-bind (name &rest maybe-default-then-slot-options) setting
                         (multiple-value-bind (default defaultp slot-options)
                             (if (oddp (length maybe-default-then-slot-options))
                                 (values (first maybe-default-then-slot-options)
                                         t
                                         (rest maybe-default-then-slot-options))
                                 (values nil nil maybe-default-then-slot-options))
                           (values name default defaultp slot-options))))
                 (symbol (values setting nil nil nil)))))
        (values (mapcar (lambda (setting)
                          (multiple-value-bind (name default defaultp slot-options) (parse setting)
                            (declare (ignore slot-options))
                            `(shared-prefs:define-setting ,name ,@(when defaultp (list default)))))
                        settings)
                (mapcar (lambda (setting)
                          (multiple-value-bind (reader default defaultp slot-options) (parse setting)
                            (declare (ignore default defaultp))
                            (let ((name (intern (format nil "%~A" (symbol-name reader)))))
                              `(,name :initarg ,reader
                                      :reader ,reader
                                      ,@slot-options))))
                        settings)))
    (let ((direct-superclasses (or direct-superclasses '(shared-prefs:standard-preferences)))
          (options (unless (member :metaclass options :key #'car :test #'eq)
                     (list '(:metaclass shared-prefs:preferences-class)))))
      `(progn
         ,@settings
         (defclass ,preferences-class-name ,direct-superclasses
           ,slots
           ,@options)))))

(defun %check-setting-exists (setting-name)
  (unless (and (fboundp setting-name)
               (typep (symbol-function setting-name) 'generic-function))
    (error "There is no setting named ~S." setting-name)))

(defmacro shared-prefs:define-defaults (&body setting-defaults)
  `(progn
     ,@(mapcan (lambda (setting-default)
                 (destructuring-bind (setting-name default) setting-default
                   (check-type setting-name symbol)
                   (list `(%check-setting-exists ',setting-name)
                         `(defmethod ,setting-name ((default null))
                            ,default))))
               setting-defaults)))
