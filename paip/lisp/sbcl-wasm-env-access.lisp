

(in-package :paip)


(defun get-globals ()
  (do-symbols (s (find-package "PAIP"))
    (let ((symbols-list nil))
      (iter (for s in-package "PAIP")
        (accumulate s by (lambda (s so-far)
			   (if (get s 'global-val)
			       (cons s so-far)
			       so-far)))))))
