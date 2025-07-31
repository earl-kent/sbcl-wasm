
(defpackage #:sbcl-wasm
  (:shadow :defconstant)
  (:use #:cl))

(in-package #:sbcl-wasm)

(asdf:defsystem #:sbcl-wasm
  :depends-on (iterate)
  :components
  ((:module "lisp"
    :components
    ((:file sbcl-wasm-auxfns)
     (:file sbcl-wasm-interp1)
     (:file sbcl-wasm-compile1)
     (:file sbcl-wasm-compile2)
     (:file sbcl-wasm-compile3)
     ;; (:file sbcl-wasm-util)
     ;; (:file sbcl-wasm)
     ;; (:file sbcl-wasm-env-access)
     ;; (:file scheme-test.scm)
     ))))
