;;; -*- Mode: Lisp; Syntax: Common-Lisp; -*-
;;; Code from Paradigms of Artificial Intelligence Programming
;;; Copyright (c) 1991 Peter Norvig

;;; File interp1.lisp: simple Scheme interpreter, including macros.

;; (declaim (ftype (function (vars vals env) t) extend-env))

(in-package :sbcl-wasm)

;; (defun interp (x &optional env)
;;   "Interpret (evaluate) the expression x in the environment env."
;;   (cond
;;     ((symbolp x) (get-var x env))
;;     ((atom x) x)
;;     ((case (first x)
;;        (QUOTE  (second x))
;;        (BEGIN  (last1 (mapcar #'(lambda (y) (interp y env))
;;                               (rest x))))
;;        (SET!   (set-var! (second x) (interp (third x) env) env))
;;        (IF     (if (interp (second x) env)
;;                    (interp (third x) env)
;;                    (interp (fourth x) env)))
;;        (LAMBDA (let ((parms (second x))
;;                      (code (maybe-add 'begin (rest2 x))))
;;                  #'(lambda (&rest args)
;;                      (interp code (extend-env parms args env)))))
;;        (t      ;; a procedure application
;;                (apply (interp (first x) env)
;;                       (mapcar #'(lambda (v) (interp v env))
;;                               (rest x))))))))

(defun set-var! (var val env)
  "Set a variable to a value, in the given or global environment."
  (if (assoc var env)
      (setf (second (assoc var env)) val)
      (set-global-var! var val))
  val)

(defun get-var (var env)
  "Get the value of a variable, from the given or global environment."
    (if (assoc var env)
        (second (assoc var env))
        (get-global-var var)))


(defvar *global-vals* (gensym))


(defun set-global-var! (var val)
  (setf (get *global-vals* var) val))

(defun get-global-var (var)
  (let* ((default "unbound")
         (val (get *global-vals* var default)))
    (if (eq val default)
        (error "Unbound scheme variable: ~a" var)
        val)))



;; (defun set-global-var-old! (var val)
;;   (setf (get var 'global-val) val))

;; (defun get-global-var-old (var)
;;   (let* ((default "unbound")
;;          (val (get var 'global-val default)))
;;     (if (eq val default)
;;         (error "Unbound scheme variable: ~a" var)
;;         val)))









;; (defun set-global-var! (var val)
;;   (setf (get var 'global-val) val))

;; (defun get-global-var (var)
;;   (let* ((default "unbound")
;;          (val (get var 'global-val default)))
;;     (if (eq val default)
;;         (error "Unbound scheme variable: ~a" var)
;;         val)))

;; (defun extend-env (vars vals env)
;;   "Add some variables and values to an environment."
;;   (nconc (mapcar #'list vars vals) env))

;; (defparameter *scheme-procs*
;;   '(+ - * / = < > <= >= cons car cdr not append list read member
;;     (null? null) (eq? eq) (equal? equal) (eqv? eql)
;;     (write prin1) (display princ) (newline terpri)))

;; (defun init-scheme-interp ()
;;   "Initialize the scheme interpreter with some global variables."
;;   ;; Define Scheme procedures as CL functions:
;;   (mapc #'init-scheme-proc *scheme-procs*)
;;   ;; Define the boolean `constants'. Unfortunately, this won't
;;   ;; stop someone from saying: (set! t nil)
;;   (set-global-var! t t)
;;   (set-global-var! nil nil))

;; (defun init-scheme-proc (f)
;;   "Define a Scheme procedure as a corresponding CL function."
;;   (if (listp f)
;;       (set-global-var! (first f) (symbol-function (second f)))
;;       (set-global-var! f (symbol-function f))))

;; (defun scheme (&optional x)
;;   "A Scheme read-eval-print loop (using interp)"
;;   ;; Modified by norvig Jun 11 96 to handle optional argument
;;   ;; instead of always going into a loop.
;;   (init-scheme-interp)
;;   (if x
;;       (interp x nil)
;;     (loop (format t "~&==> ")
;;       (print (interp (read) nil)))))

;;;; The following version handles macros:

;; (defun interp (x &optional env)
;;   "Interpret (evaluate) the expression x in the environment env.
;;   This version handles macros."
;;   (cond
;;     ((symbolp x) (get-var x env))
;;     ((atom x) x)
;;     ((scheme-macro (first x))              ;***
;;      (interp (scheme-macro-expand x) env)) ;***
;;     ((case (first x)
;;        (QUOTE  (second x))
;;        (BEGIN  (last1 (mapcar #'(lambda (y) (interp y env))
;;                               (rest x))))
;;        (SET!   (set-var! (second x) (interp (third x) env) env))
;;        (IF     (if (interp (second x) env)
;;                    (interp (third x) env)
;;                    (interp (fourth x) env)))
;;        (LAMBDA (let ((parms (second x))
;;                      (code (maybe-add 'begin (rest2 x))))
;;                  #'(lambda (&rest args)
;;                      (interp code (extend-env parms args env)))))
;;        (t      ;; a procedure application
;;                (apply (interp (first x) env)
;;                       (mapcar #'(lambda (v) (interp v env))
;;                               (rest x))))))))
