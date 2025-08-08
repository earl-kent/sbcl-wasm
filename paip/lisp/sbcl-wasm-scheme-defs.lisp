



(in-package :sbcl-wasm)


(defconstant +scheme-top-level+
  '(begin (define (scheme)
            (newline)
            (display "=> ")
            (write ((compiler (read))))
            (scheme))
          (scheme)))
