


(in-package sbcl-wasm-lab)


;; sbcl likes to build in the root of the sbcl source directory. This
;; changes the pwd, i.e. what (uiop:getcwd) returns.
(uiop:chdir
 ;; copy sbcl sources or make them a link to the sub directory
 ;; sbcl-source at the root of the sbcl-wasm-lab directory.
 (uiop:subpathname
  (asdf:system-source-directory 'sbcl-wasm-lab)
  "sbcl-source"))




(defun pathify (subdir)
  (uiop:subpathname
   (asdf:system-source-directory 'sbcl-wasm-lab)
   subdir))


;; Confirm that default evaluation strategy is :INTERPRET if
;; sb-fasteval was built
(defun verify-strategy ()
  (when (find-package "sb-interpreter")
    (assert (eq *evaluator-mode* :interpret))))


(defvar *arch-flag* "sbcl_arch=\"riscv\"")
(defvar *gnumake* 'make)
(defvar *sbcl-xc-host* 'sbcl)
(defvar *android* nil)
(defvar *sbcl-contrib-blocklist* 'sb-simd)


;; compiled:
;; $GNUMAKE -C tools-for-build perfecthash || true
(defvar *perfecthash* (pathify "sbcl-source/xperfecthash63.lisp-expr"))



(defun white-space-hygene ()
  (error "doesn't work as is PWD mismatch.")
  (load (pathify "sbcl-source/tools-for-build/canonicalize-whitespace.lisp")))



;;; some make-host-1.sh stuff




(defun make-host-1-interactive ()
  (let ((*default-pathname-defaults* (uiop:getcwd)))
    ;; Some notes:
    ;;
    ;; - load-or-cload-xcompiler loads the cross compiler into the
    ;;   host lisp.
    ;;
    ;; - Build the the unicode table
    ;;
    ;; - SBCL::*STEMS-AND-FLAGS* is a list of all the files that make
    ;;   up the cross compiler. It's generated and retrieved using
    ;;   SB-COLD::GET-STEMS-AND-FLAGS
    ;;
    ;; - create a special environment and run the compiler.
    ;;
    ;; - create the header files (but not the core) using
    ;;   (sb-cold:genesis :c-header-dir-name "src/runtime/genesis")
    (load "make-host-1.lisp")))

;; after loading make-host-1.lisp sb-xc:*features* will be populated,
;; you will also be able to run the following:

;; (sb-cold::get-stems-and-flags 1)
;; (sb-cold::get-stems-and-flags 2)


(defun make-host-1-omnibus ()
  (let ((*default-pathname-defaults* (uiop:getcwd)))
    (declare (ftype load-sbcl-file))
    ;; not this loads load-sbcl-file which is a function that loads a
    ;; file and then dies. This allows you to continue with
    ;; make-host-2.lisp without a image file contaminated with the first run.
    (load "loader.lisp")
    (load-sbcl-file "make-host-1.lisp")))
