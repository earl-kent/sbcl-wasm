

(in-package :sbcl-wasm)

(eval-when (eval compile load)
  #+sbcl
  (progn
    (sb-ext:unlock-package '#:common-lisp)
    (sb-ext:unlock-package '#:common-lisp-user)))

(defmacro defconstant (symbol value &optional doc)
  (declare (cl:ignore doc))
  `(cl:defconstant ,symbol
     (or (and (boundp ',symbol)
              (symbol-value ',symbol))
         ,value)))

(defun length=1 (x)
  "Is x a list of length 1?"
  (and (consp x) (null (cdr x))))

(defun rest2 (x)
  "The rest of a list after the first TWO elements."
  (rest (rest x)))

(defun rest3 (list)
  "The rest of a list after the first THREE elements."
  (cdddr list))

(defun starts-with (list x)
  "Is x a list whose first element is x?"
  (and (consp list) (eql (first list) x)))
