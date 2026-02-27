


(flet ((#:cleanup () c))
  (block #:return
    (multiple-value-bind
        (#:next #:start #:count)
        (block #:unwind
          (%unwind-protect
           #'(lambda (x) (return-from #:unwind x)))
          (%within-cleanup :unwind-protect
            (return-from #:return p)))
      (#:cleanup)
      (%continue-unwind #:next #:start #:count))))



(block #:foo
  (%catch #'(lambda () (return-from #:foo (%unknown-values)))
          'foo)
  (%within-cleanup :catch
    @var{xxx}))



(or (simple-string-p x)
    (and (complex-array-p x)
         (= (array-rank x) 1)
         (simple-string-p (%array-data x))))
