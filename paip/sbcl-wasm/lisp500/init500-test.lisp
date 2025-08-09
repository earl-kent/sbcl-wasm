;; built in functions. We create sandbox cl analogs.

(eval-when (:compile-toplevel :load-toplevel :execute)
  (reset-cl-environmnt))

;; symbols with special  meaning

(def-builtsin-sym
  "NIL")

(def-builtsin-sym
  "T")

(def-builtsin-sym
  "&REST")

(def-builtsin-sym
  "&BODY")

(def-builtsin-sym
  "&OPTIONAL")

(def-builtsin-sym
  "&KEY")

(def-builtsin-sym
  "&WHOLE")

(def-builtsin-sym
  "&ENVIRONMENT")

(def-builtsin-sym
  "&AUX")

(def-builtsin-sym
  "&ALLOW-OTHER-KEYS")


;; special processes

(def-builtsin-sym
  "DECLARE" eval_declare -1)

(def-builtsin-sym
  "SPECIAL")



;; speciall forms

(def-builtsin-sym
  "QUOTE" eval_quote 1)

(def-builtsin-sym
  "LET" eval_let -2)

(def-builtsin-sym
  "LET*" eval_letm -2)

(def-builtsin-sym
  "FLET" eval_flet -2)

(def-builtsin-sym
  "LABELS" eval_labels -2)

(def-builtsin-sym
  "MACROLET" eval_macrolet -2)

(def-builtsin-sym
  "SYMBOL-MACROLET" eval_symbol_macrolet -2)

(def-builtsin-sym
  "SETQ" eval_setq 2)

(def-builtsin-sym
  "FUNCTION" eval_function 1)

(def-builtsin-sym
  "TAGBODY" eval_tagbody -1)

(def-builtsin-sym
  "GO" eval_go 1)

(def-builtsin-sym
  "BLOCK" eval_block -2)

(def-builtsin-sym
  "RETURN-FROM" eval_return_from 2)

(def-builtsin-sym
  "CATCH" eval_catch -2)

(def-builtsin-sym
  "THROW" eval_throw -2)

(def-builtsin-sym
  "UNWIND-PROTECT" eval_unwind_protect -2)

(def-builtsin-sym
  "IF" eval_if -3)

(def-builtsin-sym
  "MULTIPLE-VALUE-CALL" eval_multiple_value_call -2)

(def-builtsin-sym
  "MULTIPLE-VALUE-PROG1" eval_multiple_value_prog1 -2)

(def-builtsin-sym
  "PROGN" eval_body -1)

(def-builtsin-sym
  "PROGV" eval_progv -3)

(def-builtsin-sym
  "_SETF" eval_setf 2)

(def-builtsin-sym
  "FINISH-FILE-STREAM" lfinish_fs 1)

(def-builtsin-sym
  "MAKEI" lmakei -3)

(def-builtsin-sym
  "DPB" ldpb 3)

(def-builtsin-sym
  "LDB" lldb 2)

(def-builtsin-sym
  "BACKQUOTE")

(def-builtsin-sym
  "UNQUOTE")

(def-builtsin-sym
  "UNQUOTE-SPLICING")

(def-builtsin-sym
  "IBOUNDP" liboundp 2)

(def-builtsin-sym
  "LISTEN-FILE-STREAM" llisten_fs 1)

(def-builtsin-sym
  "LIST" llist -1)

(def-builtsin-sym
  "VALUES" lvalues -1)

(def-builtsin-sym
  "FUNCALL" lfuncall -2)

(def-builtsin-sym
  "APPLY" lapply -2)

(def-builtsin-sym
  "EQ" leq 2)

(def-builtsin-sym
  "CONS" lcons 2)

(def-builtsin-sym
  "CAR" lcar 1 setfcar 2)

(def-builtsin-sym
  "CDR" lcdr 1 setfcdr 2)

(def-builtsin-sym
  "=" lequ -2)

(def-builtsin-sym
  "<" lless -2)

(def-builtsin-sym
  "+" lplus -1)

(def-builtsin-sym
  "-" lminus -2)

(def-builtsin-sym
  "*" ltimes -1)

(def-builtsin-sym
  "/" ldivi -2)

(def-builtsin-sym
  "MAKE-FILE-STREAM" lmake_fs 2)

(def-builtsin-sym
  "HASH" lhash 1)

(def-builtsin-sym
  "IERROR")

(def-builtsin-sym
  "GENSYM" lgensym 0)

(def-builtsin-sym
  "STRING" lstring -1)

(def-builtsin-sym
  "FASL" lfasl 1)

(def-builtsin-sym
  "MAKEJ" lmakej 2)

(def-builtsin-sym
  "MAKEF" lmakef 0)

(def-builtsin-sym
  "FREF" lfref 1)

(def-builtsin-sym
  "PRINT" lprint 1)

(def-builtsin-sym
  "GC" gc 0)

(def-builtsin-sym
  "CLOSE-FILE-STREAM" lclose_fs 1)

(def-builtsin-sym
  "IVAL" lival 1)

(def-builtsin-sym
  "FLOOR" lfloor -2)

(def-builtsin-sym
  "READ-FILE-STREAM" lread_fs 3)

(def-builtsin-sym
  "WRITE-FILE-STREAM" lwrite_fs 4)

(def-builtsin-sym
  "LOAD" lload 1)

(def-builtsin-sym
  "IREF" liref 2 setfiref 3)

(def-builtsin-sym
  "LAMBDA")

(def-builtsin-sym
  "CODE-CHAR" lcode_char 1)

(def-builtsin-sym
  "CHAR-CODE" lchar_code 1)

(def-builtsin-sym
  "*STANDARD-INPUT*")

(def-builtsin-sym
  "*STANDARD-OUTPUT*")

(def-builtsin-sym
  "*ERROR-OUTPUT*")

(def-builtsin-sym
  "*PACKAGES*")

(def-builtsin-sym
  "STRING=" lstring_equal 2)

(def-builtsin-sym
  "IMAKUNBOUND" limakunbound 2)

(def-builtsin-sym
  "EVAL" leval -2)

(def-builtsin-sym
  "JREF" ljref 2 setfjref 3)

(def-builtsin-sym
  "RUN-PROGRAM" lrp -2)

(def-builtsin-sym
  "UNAME" luname 0)
