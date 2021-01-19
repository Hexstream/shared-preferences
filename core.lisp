(in-package #:shared-preferences)

(defclass shared-prefs:scope () ())

(defgeneric shared-prefs:scopep (object)
  (:method :around (object)
    (or (shared-prefs:preferencesp object)
        (call-next-method)))
  (:method ((scope shared-prefs:scope))
    t)
  (:method ((package package))
    t)
  (:method (object)
    (declare (ignore object))
    nil))


(defclass shared-prefs:preferences () ())

(defvar *scope-to-preferences* (trivial-garbage:make-weak-hash-table :test 'eq :weakness :key))

(defgeneric shared-prefs:preferencesp (object)
  (:method ((default null))
    t)
  (:method ((preferences shared-prefs:preferences))
    t))

(defgeneric shared-prefs:preferences-1 (scope)
  (:method :around (scope)
    (cond
      ((shared-prefs:preferencesp scope)
       scope)
      ((not (shared-prefs:scopep scope))
       (error "~S is not a scope." scope))
      (t (call-next-method))))
  (:method (scope)
    (identity (gethash scope *scope-to-preferences*))))

(defgeneric (setf shared-prefs:preferences-1) (preferences scope)
  (:method :around (preferences scope)
    (declare (ignore preferences))
    (cond
      ((shared-prefs:preferencesp scope)
       (error "Scope ~S is preferences, so it always refers to itself." scope))
      ((not (shared-prefs:scopep scope))
       (error "~S is not a scope." scope))
      (t (call-next-method))))
  (:method (preferences scope)
    (setf (gethash scope *scope-to-preferences*) preferences)))

(defun shared-prefs:preferences (scope)
  (let ((resolved (shared-prefs:preferences-1 scope)))
    (if (shared-prefs:preferencesp resolved)
        resolved
        (shared-prefs:preferences resolved))))


(defclass shared-prefs:preferences-mixin (shared-prefs:scope)
  ((%preferences :initarg :preferences
                 :accessor shared-prefs:preferences-1
                 :initform nil)))
