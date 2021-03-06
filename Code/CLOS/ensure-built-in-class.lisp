(cl:in-package #:sicl-clos)

;;; The macro DEFINE-BUILT-IN-CLASS expands to a call to this
;;; function, and this function is used only in that situation.  For
;;; that reason, we do not have to be particularly thorough about
;;; checking the validity of arguments.
;;;
;;; The argument DIRECT-SUPERCLASS-NAMES is a list of SYMBOLS.  Unlike
;;; the function ENSURE-CLASS we do not allow for class metaobject
;;; superclasses.
(defun ensure-built-in-class (name
			      &rest arguments
			      &key
				direct-default-initargs
				direct-superclass-names
			      &allow-other-keys)
  ;; If the class already exists, then do nothing.
  (when (null (find-class name nil))
    (let ((superclasses (loop for name in direct-superclass-names
			      for class = (find-class name)
			      do (when (null class)
				   (error "unknown class ~s" name))
			      collect class))
	  (remaining-keys (copy-list arguments)))
      (loop while (remf remaining-keys :direct-superclasses))
      ;; During the bootstrapping phase, there is a method on
      ;; INITIALIZE-INSTANCE specialized for BUILT-IN-CLASS, so we can
      ;; safely call MAKE-INSTANCE on BUILT-IN-CLASS here.  Once the
      ;; bootstrapping phase is finished, we remove that method so
      ;; that MAKE-INSTANCE can no longer be used to create built-in
      ;; classes.
      (let ((result (apply #'make-instance 'built-in-class
			   :direct-default-initargs direct-default-initargs
			   :name name
			   :direct-superclasses superclasses
			   remaining-keys)))
	(setf (find-class name) result)
	;; FIXME: this is where we add create the accessors.
	result))))

	
      
