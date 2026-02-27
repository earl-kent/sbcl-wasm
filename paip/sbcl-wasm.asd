


(asdf:defsystem #:sbcl-wasm
  :depends-on (iterate uiop fiveam)
  :components
  ((:module "sbcl-wasm"
    :components
    ((:file sbcl-wasm-packages)
     (:file sbcl-wasm-auxfns)
     (:file sbcl-wasm-vm)
     (:file sbcl-wasm-scheme-macro)
     ;; (:file sbcl-wasm-interp1)
     (:file sbcl-wasm-compile1)
     (:file sbcl-wasm-compile2)
     (:file sbcl-wasm-compile3)
     (:file sbcl-wasm-scheme-defs)
     (:file sbcl-wasm-scheme-env)
     (:file sbcl-wasm-cl-defs)
     (:file sbcl-wasm-cl-compiler)
     (:file sbcl-wasm-cl-compiler-tests)
     ;; (:file sbcl-wasm-util)
     ;; (:file sbcl-wasm)
     ;; (:file sbcl-wasm-env-access)
     ;; (:file scheme-test.scm)
     ))))
