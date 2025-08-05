




(define *tests* '())

(define (setup-tests)
  (set! *tester* nil))

(define (print-tests)
  (display *tests*)
  (newline))

(define (assert test)
  (if (not (eval test))
      (set!  *tests* (cons (list "failed: " test) *tests*))))



(define (run-tests test text)
  (if (not (eval test))
      (set!  *tests* (cons (list "failed: " test text) *tests*))))
