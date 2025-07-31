

(in-package :sbcl-wasm)

(declaim (ftype (function (vars vals env) t) extend-env))

(defun label-p (x) "Is x a label?" (atom x))
