



(or (simple-string-p x)
    (and (complex-array-p x)
	 (= (array-rank x) 1)
	 (simple-string-p (%array-data x))))
