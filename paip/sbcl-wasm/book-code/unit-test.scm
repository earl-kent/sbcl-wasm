










;; Debugging operator error,
;; (operator? (make-operator 'syntax 'lambda #f #f)) generates error
;; (operator-uid (make-operator 'syntax 'lambda #f #f))




;; (define-syntax define-record-type
;;   (syntax-rules ()
;;     ((define-record-type ?id ?type
;;        (?constructor ?arg ...)
;;        (?field . ?field-stuff)
;;        ...)
;;      (begin (define ?type (make-record-type '?id '(?field ...)))
;; 	    (define ?constructor (record-constructor ?type '(?arg ...)))
;; 	    (define-accessors ?type (?field . ?field-stuff) ...)))
;;     ((define-record-type ?id ?type
;;        (?constructor ?arg ...)
;;        ?pred
;;        ?more ...)
;;      (begin (define-record-type ?id ?type
;; 	      (?constructor ?arg ...)
;; 	      ?more ...)
;; 	    (define ?pred (record-predicate ?type))))))

;; (define-record-type operator type/operator
;;   (make-operator type name uid transform)  ; transform ?
;;   operator?
;;   (type operator-type)
;;   (name operator-name)
;;   (transform operator-transform set-operator-transform!)
;;   (uid operator-uid-maybe set-operator-uid-maybe!))


;; ?type = type/operator
;; ?id = 'operator
;; ?arg = type
;;   ... = name uid transform
;; ?field = type
;;   ... name transform uid


;; (define ?type (make-record-type '?id '(?field ...))) ==>
;; (define my-type/operator
;;   (make-record-type 'operator '(type name transform uid)))


;; (?constructor ?arg ...) ==> (make-operator type name uid transform)
;; (define ?constructor (record-constructor ?type '(?arg ...))) ==>
;; (define my-make-operator
;;   (record-constructor my-type/operator '(type name uid transform)))






















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

(define (deftests test)
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




;; (map (lambda (test)
;;        (set!

;;        (let ((expr (car test))
;; 	     (expected (caddr test))
;; 	     (result (eval test)))
;; 	 (if (eq result expected)
