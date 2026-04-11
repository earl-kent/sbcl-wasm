


(in-package sbcl-wasm-lab)

;; the following runs make.sh



(defun make-alt-sh-test ()
  (let ((output (make-string-output-stream))
        (error-output (make-string-output-stream)))
    (make-alt-sh output error-output "--xc-host=sbcl" "--arch=riscv64")
    (format t "output= ~s~%" (get-output-stream-string output))
    (format t "error-output= ~s~%" (get-output-stream-string error-output))))

(defun clean-sh-test ()
  (let ((output (make-string-output-stream))
        (error-output (make-string-output-stream)))
    (clean-sh output error-output)
    (format t "output= ~s~%" (get-output-stream-string output))
    (format t "error-output= ~s~%" (get-output-stream-string error-output))))


(defun clean-sh (output error-output)
  (uiop:run-program "./clean.sh "
                    :output output
                    :error-output error-output))


(defun make-alt-sh (output error-output &rest rest)
  (uiop:run-program `("./make-alt.sh" ,@rest)
                    :ignore-error-status t
                    :output output
                    :error-output error-output))


(defun load-cross-compiler ()
  ;; FIXME: these prefixes look like non-pathnamy ways of defining a
  ;; relative pathname.  Investigate whether they can be made relative
  ;; pathnames.
  (setf sb-cold::*host-obj-prefix* "obj/from-host/"
        sb-cold::*target-obj-prefix* "obj/from-xc/")

  (let ((*default-pathname-defaults* (uiop:getcwd)))
    (sb-cold::load-or-cload-xcompiler #'sb-cold::host-load-stem)
    ;; Set up the perfect hash generator for the target's value of N-FIXNUM-BITS.
    ;; (preload-perfect-hash-generator (perfect-hash-generator-journal :input))
    ))




;; sh make-config.sh "$@" --check-host-lisp || exit $?

;; . output/prefix.def
;; . output/build-config

;; echo //building host tools
;; # Build the perfect-hash-generator. It's actually OK if this fails,
;; # as long as xperfecthash.lisp-expr is up-to-date
;; $GNUMAKE -C tools-for-build perfecthash || true

;; build_started=`date`
;; echo "//Starting build: $build_started"
;; # Apparently option parsing succeeded. Print out the results.
;; echo "//Options: --prefix='$SBCL_PREFIX' --xc-host='$SBCL_XC_HOST'"

;; # Enforce the source policy for no bogus whitespace
;; $SBCL_XC_HOST < tools-for-build/canonicalize-whitespace.lisp || exit 1

;; # The make-host-*.sh scripts are run on the cross-compilation host,
;; # and the make-target-*.sh scripts are run on the target machine. In
;; # ordinary compilation, we just do these phases consecutively on the
;; # same machine, but if you wanted to cross-compile from one machine
;; # which supports Common Lisp to another which does not (yet:-) support
;; # Common Lisp, you could do something like this:
;; #   Create copies of the source tree on both the host and the target.
;; #   Read the make-config.sh script carefully and emulate it by hand
;; #     on both machines (e.g. creating "target"-named symlinks to
;; #     identify the target architecture).
;; #   On the host system:
;; #     SBCL_XC_HOST=<whatever> sh make-host-1.sh
;; #   Copy src/runtime/genesis/*.h from the host system to the target
;; #     system.
;; #   On the target system:
;; #     sh make-target-1.sh
;; #   Copy output/stuff-groveled-from-headers.lisp
;; #     from the target system to the host system.
;; #   On the host system:
;; #     SBCL_XC_HOST=<whatever> sh make-host-2.sh
;; #   Copy output/cold-sbcl.core from the host system to the target system.
;; #   On the target system:
;; #     sh make-target-2.sh
;; #     sh make-target-contrib.sh
;; # Or, if you can set up the files somewhere shared (with NFS, AFS, or
;; # whatever) between the host machine and the target machine, the basic
;; # procedure above should still work, but you can skip the "copy" steps.
;; # If you can use rsync on the host machine, you can call make-config.sh
;; # with:
;; # --host-location=user@host-machine:<rsync path to host sbcl directory>
;; # and the make-target-*.sh scripts will take care of transferring the
;; # necessary files.
;; maybetime() {
;;     if command -v time > /dev/null ; then
;;         time $@
;;     else
;;         $@
;;     fi
;; }
;; maybetime sh make-host-1.sh
;; maybetime sh make-target-1.sh
;; maybetime sh make-host-2.sh
;; maybetime sh make-target-2.sh
;; maybetime sh make-target-contrib.sh

;; # Confirm that default evaluation strategy is :INTERPRET if sb-fasteval was built
;; src/runtime/sbcl --core output/sbcl.core --lose-on-corruption --noinform \
;;   --no-sysinit --no-userinit --disable-debugger \
;;   --eval '(when (find-package "SB-INTERPRETER") (assert (eq *evaluator-mode* :interpret)))' \
;;   --quit

;; ./src/runtime/sbcl --core output/sbcl.core \
;;  --lose-on-corruption --noinform $SBCL_MAKE_TARGET_2_OPTIONS --no-sysinit --no-userinit --eval '
;;     (progn
;;       #-sb-devel
;;       (restart-case
;;           (let (l1 l2)
;;             (sb-vm:map-allocated-objects
;;              (lambda (obj type size)
;;                (declare (ignore size))
;;                (when (and (= type sb-vm:symbol-widetag) (not (symbol-package obj))
;;                           (search "!" (string obj)))
;;                  (push obj l1))
;;                (when (and (= type sb-vm:fdefn-widetag)
;;                           (not (symbol-package
;;                                 (sb-int:fun-name-block-name
;;                                  (sb-kernel:fdefn-name obj)))))
;;                  (push obj l2)))
;;              :all)
;;             (when l1 (format t "Found ~D:~%~S~%" (length l1) l1))
;;             ;; Assert that a chosen few symbols not named using the ! convention are removed
;;             ;; by tree-shaking. This list was made by hand-checking various macros that seemed
;;             ;; not to be needed after the build. I would have thought
;;             ;; (EVAL-WHEN (:COMPILE-TOPLEVEL)) to be preferable, but revision fb1ba6de5e makes
;;             ;; a case for not doing that. Either way is less than fabulous.
;;             (sb-int:awhen
;;                 (mapcan (quote apropos-list)
;;                         (quote ("DEFINE-INFO-TYPE" "LVAR-TYPE-USING"
;;                                                    "TWO-ARG-+/-"
;;                                                    "PPRINT-TAGBODY-GUTS" "WITH-DESCRIPTOR-HANDLERS"
;;                                                    "SUBTRACT-BIGNUM-LOOP" "BIGNUM-REPLACE" "WITH-BIGNUM-BUFFERS"
;;                                                    "GCD-ASSERT" "BIGNUM-NEGATE-LOOP"
;;                                                    "SHIFT-RIGHT-UNALIGNED"
;;                                                    "STRING-LESS-GREATER-EQUAL-TESTS")))
;;               (format t "~&Leftover from [disabled?] tree-shaker:~%~S~%" sb-int:it))
;;             (when l2
;;               (format t "Found ~D fdefns named by uninterned symbols:~%~S~%" (length l2) l2)))
;;         (abort-build ()
;;           :report "Abort building SBCL."
;;           (sb-ext:exit :code 1))))' --quit

;; # contrib/Makefile shouldn't be counted in NCONTRIBS nor should asdf and uiop.
;; # The asdf directory produces 2 fasls, so is unlike all our other contribs
;; # and would therefore mess up the accounting here if included.
;; NPASSED=`ls obj/sbcl-home/contrib/sb-*.fasl | wc -l`
;; echo
;; echo "The build seems to have finished successfully, including $NPASSED"
;; echo "contributed modules. If you would like to run more extensive tests on"
;; echo "the new SBCL, you can try:"
;; echo
;; echo "  cd ./tests && sh ./run-tests.sh"
;; echo
;; echo "To build documentation:"
;; echo
;; echo "  cd ./doc/manual && make"
;; echo
;; echo "To install SBCL (more information in INSTALL):"
;; echo
;; echo "  sh install.sh"

;; build_finished=`date`
;; echo
;; echo "//build started:  $build_started"
;; echo "//build finished: $build_finished"















































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
  ;; (setq sb-c::*track-full-called-fnames* :minimal) ; Change this as desired
  ;; (setq sb-c::*static-vop-usage-counts* (make-hash-table))
  (defvar *emitted-full-calls*))




;; (defun make-host-2-core ()
;;   (let (fail
;;         variables
;;         functions
;;         types
;;         warnp
;;         style-warnp)
;;     ;; Even the host may get STYLE-WARNINGS from e.g. cross-compiling
;;     ;; macro definitions. FIXME: This is duplicate code from make-host-1
;;     (handler-bind ((style-warning
;;                      (lambda (c)
;;                        (signal c)
;;                        (setq style-warnp 'style-warning)))
;;                    (simple-warning
;;                      (lambda (c)
;;                        (declare (ignore c))
;;                        (setq warnp 'warning))))
;;       (sb-xc::with-compilation-unit ()
;;         (load "src/cold/compile-cold-sbcl.lisp")
;;         (setf *emitted-full-calls*
;;               (sb-c::cu-emitted-full-calls sb-c::*compilation-unit*))
;;         (let ((cache (math-journal-pathname :output)))
;;           (when (probe-file cache)
;;             (copy-file-from-file "output/xfloat-math.lisp-expr" cache)
;;             (format t "~&Math journal: replaced from ~S~%" cache)))
;;         ;; Enforce absence of unexpected forward-references to warm loaded code.
;;         ;; Looking into a hidden detail of this compiler seems fair game.
;;         (when sb-c::*undefined-warnings*
;;           (setf fail t)
;;           (dolist (warning sb-c::*undefined-warnings*)
;;             (case (sb-c::undefined-warning-kind warning)
;;               (:variable (setf variables t))
;;               (:type (setf types t))
;;               (:function (setf functions t))))))
;;       )
;;     ;; Exit the compilation unit so that the summary is printed. Then complain.
;;     (when fail
;;       (cerror "Proceed anyway"
;;               "Undefined ~:[~;variables~] ~:[~;types~]~
;;              ~:[~;functions (incomplete SB-COLD::*UNDEFINED-FUN-ALLOWLIST*?)~]"
;;               variables types functions))
;;     (when (and (or warnp style-warnp) *fail-on-warnings*)
;;       (cerror "Proceed anyway"
;;               "make-host-2 stopped due to unexpected ~A raised from the host." (or warnp style-warnp)))))
