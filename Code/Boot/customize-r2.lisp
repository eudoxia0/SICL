(cl:in-package #:sicl-boot)

(defun define-validate-superclass (boot)
  (setf (sicl-genv:fdefinition 'sicl-clos:validate-superclass (r2 boot))
	(constantly t)))

(defun define-ensure-generic-function (boot)
  (setf (sicl-genv:fdefinition 'ensure-generic-function (r2 boot))
	(lambda (function-name &rest arguments)
	  (declare (ignore arguments))
	  (assert (sicl-genv:fboundp function-name (r3 boot)))
	  (let ((result (sicl-genv:fdefinition function-name (r3 boot))))
	    (assert (eq (class-of result)
			(sicl-genv:find-class 'standard-generic-function
					      (r1 boot))))
	    result))))

(defun customize-r2 (boot)
  (let ((c (c1 boot))
	(r (r2 boot)))
    (define-make-instance boot)
    (define-direct-slot-definition-class boot)
    (define-find-class boot)
    (define-validate-superclass boot)
    (define-ensure-generic-function boot)
    (ld "default-superclasses-temporary-defun.lisp" c r)
    (ld "../CLOS/ensure-generic-function-using-class-support.lisp" c r)))