

(define *tests* '())
(define *failed* 0)
(define *passed* 0)

(define (setup-tests)
  (set! *tests* nil)
  (set! *failed* 0)
  (set! *passed* 0))

(define (print-tests)
  (display "failed: ")
  (display *failed*)
  (newline)
  (display "passed: ")
  (display *passed*)
  (newline))

(define (assert test)
  (if (not (eval test))
      (begin
	(set!  *tests* (cons (list "failed: " test) *tests*))
	(set! *failed* (+ *failed* 1)))
      (begin
	(set!  *tests* (cons (list "passed: " test) *tests*))
	(set! *passed* (+ *passed* 1)))))

(define (run-tests test text)
  (if (not (eval test))
      (set!  *tests* (cons (list "failed: " test text) *tests*))))
