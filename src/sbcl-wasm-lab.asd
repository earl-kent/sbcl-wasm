




(asdf:defsystem sbcl-wasm-lab
  :depends-on (uiop fiveam)
  :components
  ((:file sbcl-wasm-lab-pre)
   (:file package)
   (:file sbcl-wasm-lab)))
