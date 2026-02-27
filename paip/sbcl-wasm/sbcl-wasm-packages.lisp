
(defpackage sbcl-wasm
  (:use cl uiop)
  (:shadow defconstant)
  (:export defconstant scheme halt exit load-go))

(defpackage sbcl-wasm-scheme
  (:use cl uiop sbcl-wasm)
  (:shadow defconstant))

(defpackage sbcl-wasm-cl
  (:use cl uiop sbcl-wasm fiveam)
  (:shadow defconstant))
