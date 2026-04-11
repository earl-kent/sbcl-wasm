




(asdf:defsystem sbcl-wasm-lab
  :depends-on (uiop fiveam)
  :components
  ((:file package)
   (:file setup)
   (:file load-loader)
   ;; (:file load-make-host-1)
   ;; (:file sbcl-wasm-lab-host-2)
   ;; (:file sbcl-wasm-lab)
   ))
