(defvar *built-in-symbols*)
(defvar *built-in-symbol-index*)

;; everytime you load the page rebuilt our *built-in-symbols*
;; table. Definitions depend on the order they're created to stay in
;; sync with lisp500.c If you need to add or delete, use the
;; index-override parameter.


(defmacro def-builtsin-sym (&body entry)
  (let ((symbol (gensym))
	(rest (gensym)))
    `(eval-when (:compile-toplevel :load-toplevel :execute)
       (let ((,symbol (car ',entry))
	     (,rest (rest ',entry))
	     (index (1- (incf *built-in-symbol-index*))))
	 (push (cons index (cons (make-symbol ,symbol) ,rest))
	       *built-in-symbols*)))))

(defun reset-cl-environmnt ()
  (setf  *built-in-symbols* '())
  (setf  *built-in-symbol-index* 0))




;; - lval is a common lisp lvalue, i.e. storage location. It's an
;;   integer.
;;
;; - sp: (o & 3) == 3      Is symbol pointer?
;;
;; - o2s: (lval *) (o - 3)
;;
;; - o2u: (unsigned) (sp(o) ? *(double *) (o2s(o) + 2) : o >> 5)
;;
;; - o2a: (lval *) (o - 2);

;; Roughly, parameter 1 is f[1], parameter 2 is f[2]: object and value
;; type. Symbol 'slots' are indexed using f[2]

;; lval liref(lval * f) {
;; 	if (o2u(f[2]) >= o2a(f[1])[0] / 256 + 2)
;; 		write(1, "out of bounds in iref\n", 22);
;; 	return ((lval *) (f[1] & ~3))[o2u(f[2])] & ~4;
;; }


;; lival: d2o(f, f[1])


;; sype 'types', in lisp500: 5, 6, 8


(defconstant +name-index+ 0)
(defconstant +top-level-value-index+ 1)
(defconstant +property-list-index+ 2)
(defconstant +function-def-index+ 3)


(defun iref (object index)
  (elt object index))

(defun (setf iref) (value object index)
  (setf (elt object index) value))

(defun make-iref ()
  (make-array 4 :element-type '(unsigned-byte 4)))

(defun make-iref ()
  (make-array 8))

(defun ival (object)
  (elt object +top-level-value-index+))


(defparameter *my-iref* (make-iref))

;; (funcall #'(setf iref)
;; 	 #'(lambda (object) (= (ldb (cons 2 0) (ival object)) 1))
;; 	 'consp 5)

;; In plain cl

(setf (iref 'consp 5)
      #'(lambda (object) (= (ldb (cons 2 0) (ival object)) 1)))



;; 6 is a setf definition, 5 is a an ordinary definition.

(defun (setf fdefinition) (new-definition function-name)
  (if (consp function-name)
      (setf (iref (car (cdr function-name)) 6) new-definition)
      (progn
	(setf (iref function-name 5) new-definition)
	(setf (iref function-name 8)
	       (dpb 0 '(1 . 1) (iref function-name 8)))))
  new-definition)

(defun (setf macro-function) (new-function symbol &optional environment)
  (setf (iref symbol 5) new-function)
  (setf (iref symbol 8) )(dpb 1 '(1 . 1) (iref symbol 8))
  new-function)


(setf (macro-function 'defmacro)
      #'(lambda (name lambda-list &rest body)
	  (list 'progn
		(list 'funcall '#'(setf macro-function)
		      (list 'function
			    (cons 'lambda (cons lambda-list body)))
		      (list 'quote name))
		(list 'quote name))))








(defun defmacro (macro-function funcall #'(setf macro-function)
	 #'(lambda (name lambda-list &rest body)
	     (list 'progn
		   (list 'funcall '#'(setf macro-function)
			 (list 'function
			       (cons 'lambda (cons lambda-list body)))
			 (list 'quote name))
		   (list 'quote name)))
	 ')



;; deposit 1 at '(1 . 1) to (iref symbol 8) to indicate macro
(setf (iref 'macro-function 6)
	 #'(lambda (new-function symbol &optional environment)
	     (funcall #'(setf iref) new-function symbol 5)
	     (funcall #'(setf iref) (dpb 1 '(1 . 1) (iref symbol 8))
		      symbol 8)
	     new-function)
	 'macro-function 6)

(defun (setf macro-funciton) (value name type)






(funcall #'(setf macro-function)
	 #'(lambda (name lambda-list &rest body)
	     (list 'progn
		   (list 'funcall '#'(setf macro-function)
			 (list 'function
			       (cons 'lambda (cons lambda-list body)))
			 (list 'quote name))
		   (list 'quote name)))
	 'defmacro)






lval liref(lval * f) {
	if (o2u(f[2]) >= o2a(f[1])[0] / 256 + 2)
		write(1, "out of bounds in iref\n", 22);
	return ((lval *) (f[1] & ~3))[o2u(f[2])] & ~4;
}

lval setfiref(lval * f) {
	int i = o2i(f[3]);
	if (i >= o2a(f[2])[0] / 256 + 2)
		printf("out of bounds in setf iref\n");
	return ((lval *) (f[2] & ~3))[i] = i == 1 ? f[1] | 4 : f[1];
}






lval lival(lval * f) {
	return d2o(f, f[1]);
}
lval lmakei(lval * f, lval * h) {
	int i = 2;
	int l = o2i(f[1]);
	lval *r = ma0(h, l);
	r[1] = f[2] | 4;
	memset(r + 2, 0, 4 * o2i(f[1]));
	for (f += 3; f < h; f++, i++) {
		if (i >= l + 2)
			printf("overinitializing in makei\n");
		r[i] = *f;
	}
	return a2o(r);
}
