


(in-package sbcl-wasm-lab)

(defvar *default-pathname-defaults-back*
  *default-pathname-defaults*)
;;; In general the following is a reverse engineering of
;; sh make.sh --xc-host="sbcl" --arch=riscv64  > riscv64.log 2>&1


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
    (load "loader.lisp")
    (load "make-host-1.lisp")
    (load "make-host-2.lisp")))

;; after loading make-host-1.lisp sb-xc:*features* will be populated,
;; you will also be able to run the following:

;; (sb-cold::get-stems-and-flags 1)
;; (sb-cold::get-stems-and-flags 2)


;;(load "loader.lisp") (load-sbcl-file "make-host-2.lisp")



(defun make-host-1-omnibus ()
  (let ((*default-pathname-defaults* (uiop:getcwd)))
    (declare (ftype load-sbcl-file))
    ;; not this loads load-sbcl-file which is a function that loads a
    ;; file and then dies. This allows you to continue with
    ;; make-host-2.lisp without a image file contaminated with the first run.
    (load "loader.lisp")
    (load-sbcl-file "make-host-1.lisp")))





;; The following is the core of make-host-2.lisp

(defun copy-file-from-file (new old)
  (with-open-file (output new :direction :output :if-exists :supersede
                              :if-does-not-exist :create)
    (with-open-file (input old)
      (loop (let ((line (read-line input nil)))
              (if line (write-line line output) (return new)))))))

(defun make-host-2-prep ()
  (setf *default-pathname-defaults* (uiop:getcwd))
  (load "loader.lisp")
  (setf *print-level* 5 *print-length* 5)
  (load "src/cold/shared.lisp")
  (in-package "SB-COLD")

;;; FIXME: these prefixes look like non-pathnamy ways of defining a
;;; relative pathname.  Investigate whether they can be made relative
;;; pathnames.
  (setf *host-obj-prefix* "obj/from-host/"
        *target-obj-prefix* "obj/from-xc/")
  (load "src/cold/set-up-cold-packages.lisp")
  (load "src/cold/defun-load-or-cload-xcompiler.lisp")
  (load-or-cload-xcompiler #'host-load-stem)
;;; Set up the perfect hash generator for the target's value of N-FIXNUM-BITS.
  (preload-perfect-hash-generator (perfect-hash-generator-journal :input))

  ;; Supress function/macro redefinition warnings under clisp.
  #+clisp (setf custom:*suppress-check-redefinition* t)

  ;; Avoid natively compiling new code under ecl
  #+ecl (ext:install-bytecodes-compiler)


;;; Run the cross-compiler to produce cold fasl files.
  (setq sb-c::*track-full-called-fnames* :minimal) ; Change this as desired
  (setq sb-c::*static-vop-usage-counts* (make-hash-table))
  (defvar *emitted-full-calls*))




(defun make-host-2-core ()
  (let (fail
        variables
        functions
        types
        warnp
        style-warnp)
    ;; Even the host may get STYLE-WARNINGS from e.g. cross-compiling
    ;; macro definitions. FIXME: This is duplicate code from make-host-1
    (handler-bind ((style-warning
                     (lambda (c)
                       (signal c)
                       (setq style-warnp 'style-warning)))
                   (simple-warning
                     (lambda (c)
                       (declare (ignore c))
                       (setq warnp 'warning))))
      (sb-xc::with-compilation-unit ()
        (load "src/cold/compile-cold-sbcl.lisp")
        (setf *emitted-full-calls*
              (sb-c::cu-emitted-full-calls sb-c::*compilation-unit*))
        (let ((cache (math-journal-pathname :output)))
          (when (probe-file cache)
            (copy-file-from-file "output/xfloat-math.lisp-expr" cache)
            (format t "~&Math journal: replaced from ~S~%" cache)))
        ;; Enforce absence of unexpected forward-references to warm loaded code.
        ;; Looking into a hidden detail of this compiler seems fair game.
        (when sb-c::*undefined-warnings*
          (setf fail t)
          (dolist (warning sb-c::*undefined-warnings*)
            (case (sb-c::undefined-warning-kind warning)
              (:variable (setf variables t))
              (:type (setf types t))
              (:function (setf functions t))))))
      )
    ;; Exit the compilation unit so that the summary is printed. Then complain.
    (when fail
      (cerror "Proceed anyway"
              "Undefined ~:[~;variables~] ~:[~;types~]~
             ~:[~;functions (incomplete SB-COLD::*UNDEFINED-FUN-ALLOWLIST*?)~]"
              variables types functions))
    (when (and (or warnp style-warnp) *fail-on-warnings*)
      (cerror "Proceed anyway"
              "make-host-2 stopped due to unexpected ~A raised from the host." (or warnp style-warnp)))))
