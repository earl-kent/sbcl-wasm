


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

main.lisp -- ir1-phases
*compile-trace-targets*
(memq :checkgen *compile-trace-targets*)
*compiler-trace-output*


;;; Bind this to a stream to capture various internal debugging output.
;; (defvar *compiler-trace-output* nil)

main.lisp -- %compile-component (component)
(when *compiler-trace-output*
  (when (memq :ir1 *compile-trace-targets*)
    (describe-component component *compiler-trace-output*))
  (when (memq :ir2 *compile-trace-targets*)
    (describe-ir2-component component *compiler-trace-output*)))


(with-output-to-string (compiler-trace-output)
	   (let ((sb-c::*compiler-trace-output* compiler-trace-output))
	     (compile nil '(lambda ()))
             (format sb-c::*compiler-trace-output* "Ending compile.")))

(compile nil '(lambda ()))




(with-output-to-string (compiler-trace-output)
	   (let ((sb-c::*compiler-trace-output* compiler-trace-output))
	     (compile nil '(lambda  (a b) (+ a b)))
             (format sb-c::*compiler-trace-output* "Ending compile.")))



;; (memq :checkgen sb-c::*compile-trace-targets*)
;; codegen.lisp
;; (defun trace-instruction (section vop inst args state
;;                           &aux (*standard-output* *compiler-trace-output*))



;;; I don't know the best combination of OPTIMIZE qualities to produce a correct
;;; and reasonably fast cross-compiler in ECL. At over half an hour to complete
;;; make-host-{1,2}, I don't really want to waste any more time finding out.
;;; These settings work, while the defaults do not.
#+ecl (proclaim '(optimize (safety 2) (debug 2)))

(maybe-with-compilation-unit
  ;; If make-host-1 is parallelized, it will produce host fasls without loading
  ;; them. The host will have interpreted definitions of most everything,
  ;; which is OK because writing out the C headers is not compute-intensive.
  (load-or-cload-xcompiler #'host-cload-stem)
 ;; propagate structure offset and other information to the C runtime
 ;; support code.
 (load "tools-for-build/corefile.lisp" :verbose nil)
 (host-cload-stem "src/compiler/generic/genesis" nil)
) ; END with-compilation-unit

(unless (member :crossbuild-test sb-xc:*features*)
  (sb-cold:genesis :c-header-dir-name "src/runtime/genesis"))


;;;; building. Make sure to start sbcl in the make directory.
(load "/home/rett/dev/sbcl/sbcl-using-ecl/loader.lisp")
(load "/home/rett/dev/sbcl/sbcl-using-ecl/make-host-1.lisp")
(load "/home/rett/dev/sbcl/sbcl-using-ecl/make-host-2.lisp")






sb-c::*
sb-c::**
sb-c::***
sb-c::**BASELINE-POLICY**
sb-c::**MOST-COMMON-XREF-NAMES-BY-INDEX**
sb-c::**MOST-COMMON-XREF-NAMES-BY-NAME**
sb-c::**POLICY-DEPENDENT-QUALITIES**
sb-c::**PRIMITIVE-OBJECT-LAYOUTS**
sb-c::**TYPE-SPEC-INTERR-SYMBOLS**
sb-c::**TYPE-SPEC-UNIONS-INTERR-SYMBOLS**
sb-c::**WEAKEN-TYPE-CACHE-VECTOR**
sb-c::**ZERO-TYPECHECK-POLICY**
sb-c::*-BY-FIXNUM-TO-FIXNUM
sb-c::*-CONSTRAINT-PROPAGATE-BACK-OPTIMIZER
sb-c::*-DERIVE-TYPE-AUX
sb-c::*-DERIVE-TYPE-OPTIMIZER
sb-c::*-REWRITE-FULL-CALL-OPTIMIZER
sb-c::*-TRANSFORMER
sb-c::*2BLOCK-INFO*
sb-c::*ABORTED-COMPILATION-UNIT-COUNT*
sb-c::*AFTER-GC-HOOKS*
sb-c::*ALIEN-STACK-POINTER*
sb-c::*ALIEN-TYPE-HASHSETS*
sb-c::*ALLOCATION-PATCH-POINTS*
sb-c::*ALLOW-INSTRUMENTING*
sb-c::*ALLOW-WITH-INTERRUPTS*
sb-c::*AMC-ABS*
sb-c::*ARGUMENT-MISMATCH-WARNINGS*
sb-c::*ASM-ROUTINE-OFFSETS*
sb-c::*ASMSTREAM*
sb-c::*ASSEMBLER-ROUTINES*
sb-c::*BACKEND-BYTE-ORDER*
sb-c::*BACKEND-COND-SCS*
sb-c::*BACKEND-PARSED-VOPS*
sb-c::*BACKEND-PREDICATE-TYPES*
sb-c::*BACKEND-PRIMITIVE-TYPE-ALIASES*
sb-c::*BACKEND-PRIMITIVE-TYPE-NAMES*
sb-c::*BACKEND-REGISTER-SAVE-PENALTY*
sb-c::*BACKEND-SBS*
sb-c::*BACKEND-SC-NAMES*
sb-c::*BACKEND-SC-NUMBERS*
sb-c::*BACKEND-SUBFEATURES*
sb-c::*BACKEND-T-PRIMITIVE-TYPE*
sb-c::*BACKEND-TEMPLATE-NAMES*
sb-c::*BACKEND-TYPE-PREDICATES*
sb-c::*BACKEND-TYPE-PREDICATES-GROUPED*
sb-c::*BACKEND-UNION-TYPE-PREDICATES*
sb-c::*BACKGROUND-TASKS*
sb-c::*BLOCK-COMPILE-ARGUMENT*
sb-c::*BLOCK-COMPILE-DEFAULT*
sb-c::*BLOCKS-TO-TERMINATE*
sb-c::*BREAK-ON-SIGNALS*
sb-c::*BYTE-BUFFER*
sb-c::*CHECK-CONSISTENCY*
sb-c::*CIRCULARITIES-DETECTED*
sb-c::*CL-PACKAGE*
sb-c::*COALESCE-MORE-LTN-NUMBERS-EVENT-INFO*
sb-c::*CODE-COVERAGE-INFO*
sb-c::*CODE-SERIALNO*
sb-c::*COMPILATION*
sb-c::*COMPILATION-UNIT*
sb-c::*COMPILE-COMPONENT-HOOK*
sb-c::*COMPILE-ELAPSED-TIME*
sb-c::*COMPILE-FILE-ELAPSED-TIME*
sb-c::*COMPILE-FILE-PATHNAME*
sb-c::*COMPILE-FILE-TO-MEMORY-SPACE*
sb-c::*COMPILE-FILE-TRUENAME*
sb-c::*COMPILE-OBJECT*
sb-c::*COMPILE-PRINT*
sb-c::*COMPILE-PROGRESS*
sb-c::*COMPILE-TIME-EVAL*
sb-c::*COMPILE-TO-MEMORY-SPACE*
sb-c::*COMPILE-TRACE-TARGETS*
sb-c::*COMPILE-VERBOSE*
sb-c::*COMPILER-ERROR-BAILOUT*
sb-c::*COMPILER-ERROR-CONTEXT*
sb-c::*COMPILER-ERROR-COUNT*
sb-c::*COMPILER-NOTE-COUNT*
sb-c::*COMPILER-PRINT-VARIABLE-ALIST*
sb-c::*COMPILER-STYLE-WARNING-COUNT*
sb-c::*COMPILER-TRACE-OUTPUT*
sb-c::*COMPILER-WARNING-COUNT*
sb-c::*COMPONENT-BEING-COMPILED*
sb-c::*CONCATENATE-OPEN-CODE-LIMIT*
sb-c::*CONSERVATIVE-QUOTIENT-BOUND*
sb-c::*CONSTANTS-BEING-CREATED*
sb-c::*CONSTANTS-CREATED-SINCE-LAST-INIT*
sb-c::*CONSTRAINT-BLOCKS*
sb-c::*CONSTRAINT-BLOCKS-P*
sb-c::*CONSTRAINT-PROPAGATE*
sb-c::*CONSTRAINT-UNIVERSE*
sb-c::*CONTEXTS*
sb-c::*CONTROL-DELETED-BLOCK-EVENT-INFO*
sb-c::*COPY-DELETED-MOVE-EVENT-INFO*
sb-c::*CORE-PATHNAME*
sb-c::*CORE-STRING*
sb-c::*COVERAGE-AUGMENTATION-HOOK*
sb-c::*CTYPE-TEST-FUN*
sb-c::*CURRENT-COMPONENT*
sb-c::*CURRENT-FORM-NUMBER*
sb-c::*CURRENT-INTERNAL-ERROR-CONTEXT*
sb-c::*CURRENT-LEVEL-IN-PRINT*
sb-c::*CURRENT-PATH*
sb-c::*DEBUG-COMPONENT-NAME*
sb-c::*DEBUG-IO*
sb-c::*DEBUG-PRINT-TYPES*
sb-c::*DEBUG-PRINT-VARIABLE-ALIST*
sb-c::*DEBUG-PRINT-VOP-TEMPS*
sb-c::*DEBUGGER-HOOK*
sb-c::*DEFAULT-C-STRING-EXTERNAL-FORMAT*
sb-c::*DEFAULT-EXTERNAL-FORMAT*
sb-c::*DEFAULT-NTHCDR-OPEN-CODE-LIMIT*
sb-c::*DEFAULT-PATHNAME-DEFAULTS*
sb-c::*DEFAULT-SOURCE-EXTERNAL-FORMAT*
sb-c::*DELAYED-IR1-TRANSFORMS*
sb-c::*DERIVE-FUNCTION-TYPES*
sb-c::*DERIVED-NUMERIC-UNION-COMPLEXITY-LIMIT*
sb-c::*DISABLED-PACKAGE-LOCKS*
sb-c::*DISASSEMBLE-ANNOTATE*
sb-c::*DO-INSTCOMBINE-PASS*
sb-c::*ED-FUNCTIONS*
sb-c::*EFFICIENCY-NOTE-COST-THRESHOLD*
sb-c::*EFFICIENCY-NOTE-LIMIT*
sb-c::*ELSEWHERE-LABEL*
sb-c::*EMIT-CFASL*
sb-c::*EMPTY-TYPE*
sb-c::*ENABLE-32-BIT-CODEGEN*
sb-c::*ENCLOSING-SOURCE-CUTOFF*
sb-c::*ENTRY-POINTS-ARGUMENT*
sb-c::*EOF-OBJECT*
sb-c::*EQUAL-SOURCE-PATHS*
sb-c::*ERROR-OUTPUT*
sb-c::*EVAL-CALLS*
sb-c::*EVALUATOR-MODE*
sb-c::*EVENT-NOTE-THRESHOLD*
sb-c::*EXIT-ERROR-HANDLER*
sb-c::*EXIT-HOOKS*
sb-c::*EXIT-IN-PROGRESS*
sb-c::*EXIT-TIMEOUT*
sb-c::*EXTENDED-SEQUENCE-TYPE*
sb-c::*EXTREME-NTHCDR-OPEN-CODE-LIMIT*
sb-c::*FAILURE-P*
sb-c::*FASL-FILE-TYPE*
sb-c::*FASL-HEADER-STRING-START-STRING*
sb-c::*FEATURES*
sb-c::*FINITE-SBS*
sb-c::*FORCE-SYSTEM-TLAB*
sb-c::*FORCIBLY-TERMINATE-THREADS-ON-EXIT*
sb-c::*FREE-INTERRUPT-CONTEXT-INDEX*
sb-c::*GC-INHIBIT*
sb-c::*GC-PENDING*
sb-c::*GC-PIN-CODE-PAGES*
sb-c::*GC-REAL-TIME*
sb-c::*GC-RUN-TIME*
sb-c::*GENSYM-COUNTER*
sb-c::*HANDLED-CONDITIONS*
sb-c::*HANDLER-CLUSTERS*
sb-c::*IN-COMPILATION-UNIT*
sb-c::*IN-WITHOUT-GCING*
sb-c::*INFO-ENVIRONMENT*
sb-c::*INIT-HOOKS*
sb-c::*INLINE-EXPANSION-LIMIT*
sb-c::*INLINE-EXPANSIONS*
sb-c::*INLINING*
sb-c::*INSPECTED*
sb-c::*INTERRUPT-PENDING*
sb-c::*INTERRUPTS-ENABLED*
sb-c::*INVOKE-DEBUGGER-HOOK*
sb-c::*IR1-NAMESPACE*
sb-c::*IR1-OPTIMIZE-MAXED-OUT-EVENT-INFO*
sb-c::*IR1-OPTIMIZE-UNTIL-DONE-EVENT-INFO*
sb-c::*IR1-TRANSFORMS-AFTER-CONSTRAINTS*
sb-c::*IR1-TRANSFORMS-AFTER-IR1-PHASES*
sb-c::*KEYWORD-PACKAGE*
sb-c::*LAMBDA-CONVERSIONS*
sb-c::*LAST-ERROR-CONTEXT*
sb-c::*LAST-MESSAGE-COUNT*
sb-c::*LEXENV*
sb-c::*LINKAGE-INFO*
sb-c::*LIST-OPEN-CODE-LIMIT*
sb-c::*LOAD-PATHNAME*
sb-c::*LOAD-PRINT*
sb-c::*LOAD-SOURCE-DEFAULT-TYPE*
sb-c::*LOAD-TRUENAME*
sb-c::*LOAD-VERBOSE*
sb-c::*LOCAL-CALL-CONTEXT*
sb-c::*LOCATION-CONTEXT*
sb-c::*LONG-SITE-NAME*
sb-c::*LOSSAGE-DETECTED*
sb-c::*LOSSAGE-FUN*
sb-c::*MACHINE-VERSION*
sb-c::*MACRO-POLICY*
sb-c::*MACROEXPAND-HOOK*
sb-c::*MAKE-VALUE-CELL-EVENT-EVENT-INFO*
sb-c::*MAX-FAST-PROPAGATE-LIVE-TN-PASSES*
sb-c::*MAX-OPTIMIZE-ITERATIONS*
sb-c::*MAXIMUM-ERROR-DEPTH*
sb-c::*MERGE-PATHNAMES*
sb-c::*MODULE-PROVIDER-FUNCTIONS*
sb-c::*MODULES*
sb-c::*MUFFLED-WARNINGS*
sb-c::*N-BYTES-FREED-OR-PURIFIED*
sb-c::*NAME-CONTEXT-FILE-PATH-SELECTOR*
sb-c::*ON-PACKAGE-VARIANCE*
sb-c::*OPTIMIZE-FORMAT-STRINGS*
sb-c::*PACKAGE*
sb-c::*PARSE-VOP-OPERAND-COUNT*
sb-c::*PERIODIC-POLLING-FUNCTION*
sb-c::*PERIODIC-POLLING-PERIOD*
sb-c::*PHASH-LAMBDA-CACHE*
sb-c::*POLICY*
sb-c::*POLICY-MAX*
sb-c::*POLICY-MIN*
sb-c::*POSIX-ARGV*
sb-c::*PREVIOUS-FORM-NUMBER*
sb-c::*PREVIOUS-LIVE*
sb-c::*PREVIOUS-LOCATION*
sb-c::*PRINT-ARRAY*
sb-c::*PRINT-BASE*
sb-c::*PRINT-CASE*
sb-c::*PRINT-CIRCLE*
sb-c::*PRINT-CIRCLE-NOT-SHARED*
sb-c::*PRINT-CONDITION-REFERENCES*
sb-c::*PRINT-ESCAPE*
sb-c::*PRINT-GENSYM*
sb-c::*PRINT-IR-NODES-PRETTY*
sb-c::*PRINT-LENGTH*
sb-c::*PRINT-LEVEL*
sb-c::*PRINT-LINES*
sb-c::*PRINT-MISER-WIDTH*
sb-c::*PRINT-PPRINT-DISPATCH*
sb-c::*PRINT-PRETTY*
sb-c::*PRINT-RADIX*
sb-c::*PRINT-READABLY*
sb-c::*PRINT-RIGHT-MARGIN*
sb-c::*PRINT-VECTOR-LENGTH*
sb-c::*QUERY-IO*
sb-c::*QUEUED-PROCLAIMS*
sb-c::*RANDOM-STATE*
sb-c::*READ-BASE*
sb-c::*READ-DEFAULT-FLOAT-FORMAT*
sb-c::*READ-EVAL*
sb-c::*READ-SUPPRESS*
sb-c::*READTABLE*
sb-c::*RECOGNIZED-DECLARATIONS*
sb-c::*REOPTIMIZE-LIMIT*
sb-c::*REOPTIMIZE-MAXED-OUT-EVENT-INFO*
sb-c::*REPL-PROMPT-FUN*
sb-c::*REPL-READ-FORM-FUN*
sb-c::*RESTART-CLUSTERS*
sb-c::*RUNTIME-DLHANDLE*
sb-c::*RUNTIME-PATHNAME*
sb-c::*SAVE-HOOKS*
sb-c::*SAVED-FP*
sb-c::*SEEN-BLOCKS*
sb-c::*SEEN-FUNS*
sb-c::*SETF-COMPILER-MACRO-FUNCTION-HOOK*
sb-c::*SETF-FDEFINITION-HOOK*
sb-c::*SETF-MACRO-FUNCTION-HOOK*
sb-c::*SHARED-OBJECTS*
sb-c::*SHORT-SITE-NAME*
sb-c::*SHOW-TRANSFORMS-P*
sb-c::*SOURCE-CONTEXT-METHODS*
sb-c::*SOURCE-FORM-CONTEXT-ALIST*
sb-c::*SOURCE-INFO*
sb-c::*SOURCE-NAMESTRING*
sb-c::*SOURCE-PATHS*
sb-c::*SOURCE-PLIST*
sb-c::*SPECIAL-CONSTANT-VARIABLES*
sb-c::*SPLIT-IR2-BLOCK-EVENT-INFO*
sb-c::*STACK-ALLOCATE-DYNAMIC-EXTENT*
sb-c::*STANDARD-INPUT*
sb-c::*STANDARD-OUTPUT*
sb-c::*STATIC-VOP-USAGE-COUNTS*
sb-c::*STDERR*
sb-c::*STDIN*
sb-c::*STDOUT*
sb-c::*STEPPER-HOOK*
sb-c::*STOP-FOR-GC-PENDING*
sb-c::*STRIP-LAMBA-LIST-RETAIN-AUX*
sb-c::*SUPPRESS-PRINT-ERRORS*
sb-c::*SUPPRESS-VALUES-DECLARATION*
sb-c::*SYSINIT-PATHNAME-FUNCTION*
sb-c::*TAGGED-MODULAR-CLASS*
sb-c::*TERMINAL-IO*
sb-c::*TOP-LEVEL-FORM-P*
sb-c::*TRACE-OUTPUT*
sb-c::*TRANSFORMING*
sb-c::*TTY*
sb-c::*TWO-ARG-FUNCTIONS*
sb-c::*TYPE-SYSTEM-INITIALIZED*
sb-c::*UNDEFINED-WARNING-LIMIT*
sb-c::*UNDEFINED-WARNINGS*
sb-c::*UNIVERSAL-FUN-TYPE*
sb-c::*UNIVERSAL-TYPE*
sb-c::*UNTAGGED-SIGNED-MODULAR-CLASS*
sb-c::*UNTAGGED-UNSIGNED-MODULAR-CLASS*
sb-c::*UNWINNAGE-DETECTED*
sb-c::*UNWINNAGE-FUN*
sb-c::*USERINIT-PATHNAME-FUNCTION*
sb-c::*VALUES-TYPE-OKAY*
sb-c::*VECTOR-WITHOUT-COMPLEX-TYPECODE-INFOS*
sb-c::*VOPS-ALLOWED-WITHIN-PSEUDO-ATOMIC*
sb-c::*WARNINGS-P*
sb-c::*WILD-TYPE*
