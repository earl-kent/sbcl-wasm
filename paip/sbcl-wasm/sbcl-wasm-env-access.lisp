

(in-package :sbcl-wasm)


(defun get-globals ()
  (do-symbols (s (find-package "PAIP"))
    (let ((symbols-list nil))
      (iter (for s in-package "PAIP")
        (accumulate s by (lambda (s so-far)
			   (if (get s 'global-val)
			       (cons s so-far)
			       so-far)))))))


(defun list-primitives ()
  (mapcar #'car *primitive-fns*))



(defun get-prim-def (prim)
  (assoc prim *primitive-fns*))

(get-prim-def 'read)

(defparameter *my-fn* (get-prim-def 'read))

(let ((prim my-fn*))
  (list (prim-symbol prim)
	`(new-fn :env nil :name ,(prim-symbol prim)
		 :code (seq ,(gen 'PRIM (prim-symbol prim))
                            ,(gen 'RETURN)))))




(defparameter *my-file*
  (open "/home/rett/dev/cmu-perq/sbcl-wasm.git/paip/lisp/test-file.lisp"
	:direction :input :if-does-not-exist nil ))

(defun eof-p (stream)
  (eq (peek-char nil stream nil :eof) :eof))



(defparameter *my-file-name* "/oeuoeu/qjkqjkqjk.txt")


(defun make-directory-absolute (directory-path default)
  (let ((merged-path (if default (merge-pathnames directory-path default)
			 directory-path)))
    (make-pathname :directory (cons :absolute merged-path))))


(multiple-value-bind
      (unix-pathname-type-flag directory-path file-namestring file-namestring-flag)
    (split-unix-namestring-directory-components *my-file-name*)
  (let ((directory
	  (make-pathname :directory "/mnt/sometext" :name "afilename" :type "txt")))
	name
	type)
    (cond
      ((and (eq unix-pathname-type-flag :relative)
	    directory-path
	    file-namestring)





       (file-exsts-p (make-pathname :directory *my-file-name* :name "afilename" :type "txt")))))




(multiple-value-bind
      (unix-pathname-type-flag directory-path file-namestring file-namestring-flag)
    (split-unix-namestring-directory-components "dev1/dev2/dev3")
  (multiple-value-bind
	(defaut-unix-pathname-type-flag defaut-directory-path
	 defaut-file-namestring defaut-file-namestring-flag)
      (split-unix-namestring-directory-components "/dir0/dira")
    (list unix-pathname-type-flag directory-path file-namestring file-namestring-flag
	  defaut-unix-pathname-type-flag defaut-directory-path
	  defaut-file-namestring defaut-file-namestring-flag)
    (make-pathname :type unix-pathname-type-flag
		   :directory directory-path
		   :name ""
		   :type "")))



(let* ((
       (pathname1 (make-pathname :directory '(:relative "backups") :defaults input-file))
       (pathname2 (make-pathname :directory '(:relative "backups") :defaults input-file)))










Function: normalize-pathname-directory-component directory


relativize-directory-component

pathname-directory-pathname

 make-pathname*

 make-pathname-logical

make-pathname-component-logical

 directorize-pathname-host-device

(multiple-value-bind
      (unix-pathname-type-flag directory-path file-namestring file-namestring-flag)
    (split-unix-namestring-directory-components *my-file-name*)
  (format t "directory part: ~s~%" directory-path)
  (list unix-pathname-type-flag directory-path file-namestring file-namestring-flag))



(file-exsts-p (make-pathname :directory "/mnt/sometext" :name "afilename" :type "txt")

    (pathname-parent-directory-pathname  "/oeuoeu/qjkqjkqjk.txt")



(make-pathname :directory "/mnt/sometext" :name "afilename" :type "txt")




  (split-unix-namestring-directory-components "/oeuoeu/qjkqjkqjk.txt")

  parse-unix-namestring
