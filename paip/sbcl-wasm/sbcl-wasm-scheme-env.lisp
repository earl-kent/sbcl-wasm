


(in-package :sbcl-wasm)


;; for now test with
;; (ql:quickload :sbcl-wasm)(in-package :sbcl-wasm)(load-go "/home/rett/dev/cmu-perq/sbcl-wasm.git/paip/lisp/book-code/ch1.scm")


(defvar *primitive-fns*)
(defparameter *scheme-current-load-file-stream* nil)


(defun init-scheme-comp ()
  "Initialize values (including call/cc) for the Scheme compiler."
  (set-global-var! 'exit
    (new-fn :name 'exit :args '(val) :code '((HALT))))
  (set-global-var! 'call/cc
    (new-fn :name 'call/cc :args '(f)
            :code '((ARGS 1) (CC) (LVAR 0 0 ";" f)
		    (CALLJ 1)))) ; *** Bug fix, gat, 11/9/92
  (dolist (prim *primitive-fns*)
    (set-global-var! (prim-symbol prim)
		     (new-fn :env nil :name (prim-symbol prim)
			     :code (seq (gen 'PRIM (prim-symbol prim))
					(gen 'RETURN))))))

(defparameter *scheme-primitive-fns*
  '((eq? 2 eq)
    (equal? 2 equal)
    (eqv? 2 eql)
    (null? 1 not)
    (read 0 scheme-read nil t)
    (eof-object? 1 eof-object?) ;***
    (write 1 write nil t)
    (display 1 display nil t)
    (newline 0 newline nil t)
    (compiler 1 compiler t)
    (name! 2 name! true t)
    (random 1 random true nil)
    (load 1 scheme-load nil t)))


(defun scheme-load-file (file)
  "If files is a string load that file. Otherwise iterate over files."
  (let (result)
    (dolist (exp (collect-top-level-expressions file) result)
      (setf result (machine (compiler `(exit ,exp)))))))

;; initialize the scheme environment and load a file.

(defun load-go (filename)
  (let ((*primitive-fns*
	  (concatenate 'list *shared-primitive-fns* *scheme-primitive-fns*)))
    (init-scheme-comp)
    (with-open-file (*scheme-current-load-file-stream* filename :direction :input)
      (let ((*readtable* *scheme-readtable*))
	(scheme-load-file *scheme-current-load-file-stream*)))))

(defun scheme ()
  "A compiled Scheme read-eval-print loop"
  (let ((*primitive-fns*
	  (concatenate 'list *shared-primitive-fns* *scheme-primitive-fns*)))
    (init-scheme-comp)
    (machine (compiler +scheme-top-level+))))

(defconstant eof "EoF")
(defun eof-object? (x) (eq x eof))
(defvar *scheme-readtable* (copy-readtable))

(defun scheme-read (&optional (stream *standard-input*))
  (let ((*readtable* *scheme-readtable*))
    (read stream nil eof)))


(set-dispatch-macro-character
 #\# #\t
 #'(lambda (&rest ignore)
     (declare (ignore ignore))
     t)
 *scheme-readtable*)

(set-dispatch-macro-character
 #\# #\f
 #'(lambda (&rest ignore)
     (declare (ignore ignore))
     nil)
 *scheme-readtable*)

(set-dispatch-macro-character
 #\# #\d
 ;; In both Common Lisp and Scheme,
 ;; #x, #o and #b are hexidecimal, octal, and binary,
 ;; e.g. #xff = #o377 = #b11111111 = 255
 ;; In Scheme only, #d255 is decimal 255.
 #'(lambda (stream &rest ignore)
     (declare (ignore ignore))
     (let ((*read-base* 10)) (scheme-read stream)))
 *scheme-readtable*)

(set-macro-character
 #\`
 #'(lambda (s ignore)
     (declare (ignore ignore))
     (list 'quasiquote (scheme-read s)))
 nil *scheme-readtable*)

(set-macro-character
 #\,
 #'(lambda (stream ignore)
     (declare (ignore ignore))
     (let ((ch (read-char stream)))
       (if (char= ch #\@)
           (list 'unquote-splicing (read stream))
           (progn (unread-char ch stream)
                  (list 'unquote (read stream))))))
 nil *scheme-readtable*)




(defun print-load-variables ()
  (format t "*scheme-current-load-file-stream*: ~s~%"
	  *scheme-current-load-file-stream*))

(defun scheme-load (filename)
  (unless (and (uiop:absolute-pathname-p filename)
	       (probe-file filename))
    (setf filename
	  (merge-pathnames
	   (directory-namestring *scheme-current-load-file-stream*)
	   filename))
    (unless (probe-file filename)
      (error "Unable to find file ~S" filename)))
  (with-open-file (*scheme-current-load-file-stream* filename :direction :input)
    (declare (special *scheme-current-load-file-stream*))
    (scheme-load-file *scheme-current-load-file-stream*)))


(defun scheme-load-old (filename)
  (unless (and (uiop:absolute-pathname-p filename)
	       (probe-file filename))
    (setf filename
	  (merge-pathnames
	   (directory-namestring *scheme-current-load-file-stream*)
	   filename))
    (unless (probe-file filename)
      (error "Unable to find file ~S" filename)))
  (with-open-file (*scheme-current-load-file-stream* filename :direction :input)
    (declare (special *scheme-current-load-file-stream*))
    (loop
      for form = (read *scheme-current-load-file-stream* nil :eof)
      until (eq form :eof)
      collect (convert-numbers form))))



(defun scheme-read (&optional (stream *standard-input*))
  (let ((*readtable* *scheme-readtable*))
    (convert-numbers (read stream nil eof))))

(defun convert-numbers (x)
  "Replace symbols that look like Scheme numbers with their values."
  ;; Don't copy structure, make changes in place.
  (typecase x
    (cons   (setf (car x) (convert-numbers (car x)))
            (setf (cdr x) (convert-numbers (cdr x)))
	    x) ; *** Bug fix, gat, 11/9/92
    (symbol (or (convert-number x) x))
    (vector (dotimes (i (length x))
              (setf (aref x i) (convert-numbers (aref x i))))
	    x) ; *** Bug fix, gat, 11/9/92
    (t x)))

(defun convert-number (symbol)
  "If str looks like a complex number, return the number."
  (let* ((str (symbol-name symbol))
         (pos (position-if #'sign-p str))
         (end (- (length str) 1)))
    (when (and pos (char-equal (char str end) #\i))
      (let ((re (read-from-string str nil nil :start 0 :end pos))
            (im (read-from-string str nil nil :start pos :end end)))
        (when (and (numberp re) (numberp im))
          (complex re im))))))

(defun sign-p (char) (find char "+-"))
