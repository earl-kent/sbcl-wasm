




(define *tests* '())

(define (print-tests)
  (display *tests*)
  (newline))

(define (assert test text)
  (if (not (eval test))
      (set!  *tests* (cons (list "failed: " test text) *tests*))))
