







								     "NIL"))


;; speciall forms
"QUOTE", eval_quote, 1
"LET", eval_let, -2
"LET*", eval_letm, -2
"FLET", eval_flet, -2
"LABELS", eval_labels, -2
"MACROLET", eval_macrolet, -2
"SYMBOL-MACROLET", eval_symbol_macrolet, -2
"SETQ", eval_setq, 2
"FUNCTION", eval_function, 1
"TAGBODY", eval_tagbody, -1
"GO", eval_go, 1
"BLOCK", eval_block, -2
"RETURN-FROM", eval_return_from, 2
"CATCH", eval_catch, -2
"THROW", eval_throw, -2
"UNWIND-PROTECT", eval_unwind_protect, -2
"IF", eval_if, -3
"MULTIPLE-VALUE-CALL", eval_multiple_value_call, -2
"MULTIPLE-VALUE-PROG1", eval_multiple_value_prog1, -2
"PROGN", eval_body, -1
"PROGV", eval_progv, -3
"_SETF", eval_setf, 2
"FINISH-FILE-STREAM", lfinish_fs, 1
"MAKEI", lmakei, -3
"DPB", ldpb, 3
"LDB", lldb, 2
"BACKQUOTE"
"UNQUOTE"
"UNQUOTE-SPLICING"
"IBOUNDP", liboundp, 2
"LISTEN-FILE-STREAM", llisten_fs, 1
"LIST", llist, -1
"VALUES", lvalues, -1
"FUNCALL", lfuncall, -2
"APPLY", lapply, -2
"EQ", leq, 2
"CONS", lcons, 2
"CAR", lcar, 1, setfcar, 2
"CDR", lcdr, 1, setfcdr, 2
"=", lequ, -2
"<", lless, -2
"+", lplus, -1
"-", lminus, -2
"*", ltimes, -1
"/", ldivi, -2
"MAKE-FILE-STREAM", lmake_fs, 2
"HASH", lhash, 1
"IERROR"
"GENSYM", lgensym, 0
"STRING", lstring, -1
"FASL", lfasl, 1
"MAKEJ", lmakej, 2
"MAKEF", lmakef, 0
"FREF", lfref, 1
"PRINT", lprint, 1
"GC", gc, 0
"CLOSE-FILE-STREAM", lclose_fs, 1
"IVAL", lival, 1
"FLOOR", lfloor, -2
"READ-FILE-STREAM", lread_fs, 3
"WRITE-FILE-STREAM", lwrite_fs, 4
"LOAD", lload, 1
"IREF", liref, 2, setfiref, 3
"LAMBDA"
"CODE-CHAR", lcode_char, 1
"CHAR-CODE", lchar_code, 1
"*STANDARD-INPUT*"
"*STANDARD-OUTPUT*"
"*ERROR-OUTPUT*"
"*PACKAGES*"
"STRING=", lstring_equal, 2
"IMAKUNBOUND", limakunbound, 2
"EVAL", leval, -2
"JREF", ljref, 2, setfjref, 3
"RUN-PROGRAM", lrp, -2
"UNAME", luname, 0







(funcall #'(setf iref)
	 #'(lambda (object) (= (ldb (cons 2 0) (ival object)) 1))
	 'consp 5)

;; equivelent to

(setf (iref 'consp 5) (lambda (object) (= (ldb (cons 2 0) (ival object)) 1)))





;; lval setfiref(lval * f) {
;; 	int i = o2i(f[3]);
;; 	if (i >= o2a(f[2])[0] / 256 + 2)
;; 		printf("out of bounds in setf iref\n");
;; 	return ((lval *) (f[2] & ~3))[i] = i == 1 ? f[1] | 4 : f[1];
;; }

;; setf take 3 arguments: the symbol, the value type, the value.
(defun (setf iref) (value symbol type)
  ;; along these lines: (setf (get symbol type) value)
  (setf (get symbol type) value))






(funcall #'(setf iref)
	 #'(lambda (new-definition function-name)
	     (if (consp function-name)
		 (funcall #'(setf iref) new-definition
			  (car (cdr function-name)) 6)
		 (progn
		   (funcall #'(setf iref) new-definition function-name 5)
		   (funcall #'(setf iref)
			    (dpb 0 '(1 . 1) (iref function-name 8))
			    function-name 8)))
	     new-definition)
	 'fdefinition 6)




(setf (iref 'fdefinition 6)
      (lambda (new-definition function-name)
	     (if (consp function-name)
		 (funcall #'(setf iref) new-definition
			  (car (cdr function-name)) 6)
		 (progn
		   (funcall #'(setf iref) new-definition function-name 5)
		   (funcall #'(setf iref)
			    (dpb 0 '(1 . 1) (iref function-name 8))
			    function-name 8)))
	     new-definition))



(defun my-fdefinition (new-definition function-name)
  (if (consp function-name)
      (funcall #'(setf iref) new-definition
	       (car (cdr function-name)) 6)
      (progn
	(funcall #'(setf iref) new-definition function-name 5)
	(funcall #'(setf iref)
		 (dpb 0 '(1 . 1) (iref function-name 8))
		 function-name 8)))
  new-definition)







(funcall #'(setf iref)
	 #'(lambda (new-function symbol &optional environment)
	     ;; slot 5 macro definition
	     (funcall #'(setf iref) new-function symbol 5)
	     ;;
	     (funcall #'(setf iref) (dpb 1 '(1 . 1) (iref symbol 8))
		      symbol 8)
	     new-function)
	 'macro-function 6)


(defun macro-function (new-function symbol &optional environment)
  (setf (iref new-function symbol) 5)
  (setf (iref (dpb 1 '(1 . 1) (iref symbol 8)) symbol 8)))

;; to be used: (setf (macro-function symbol) fn)



(defun my-defmacro (name lambda-list &rest body)
  (list 'progn
	(list 'funcall '#'(setf macro-function)
	      (list 'function
		    (cons 'lambda (cons lambda-list body)))
	      (list 'quote name))
	(list 'quote name)))


(setf (




(funcall #'(setf macro-function)
	 #'(lambda (name lambda-list &rest body)
	     (list 'progn
		   (list 'funcall '#'(setf macro-function)
			 (list 'function
			       (cons 'lambda (cons lambda-list body)))
			 (list 'quote name))
		   (list 'quote name)))
	 'defmacro)

(defmacro defun (name lambda-list &rest body)
  (list 'progn
	(list 'funcall '#'(setf fdefinition)
	      (list 'function
		    (list 'lambda lambda-list
			  (cons 'block (cons (if (consp name)
						 (car (cdr name))
						 name)
					     body))))
	      (list 'quote name))
	(list 'quote name)))

(defmacro setf (place new-value)
  (if (consp place)
      (cons 'funcall (cons (list 'function (list 'setf (car place)))
			   (cons new-value (cdr place))))
      (list 'setq place new-value)))
