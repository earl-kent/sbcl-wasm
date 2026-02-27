

(in-package :sbcl-wasm)

(defun set-var! (var val env)
  "Set a variable to a value, in the given or global environment."
  (if (assoc var env)
      (setf (second (assoc var env)) val)
      (set-global-var! var val))
  val)

(defun get-var (var env)
  "Get the value of a variable, from the given or global environment."
    (if (assoc var env)
        (second (assoc var env))
        (get-global-var var)))


(defvar *global-vals* (gensym))


(defun set-global-var! (var val)
  (setf (get *global-vals* var) val))

(defun get-global-var (var)
  (let* ((default "unbound")
         (val (get *global-vals* var default)))
    (if (eq val default)
        (error "Unbound scheme variable: ~a" var)
        val)))

(defvar *machine*)


(defun machine (f)
  (funcall *machine* f))


(defun norvig-machine (f)
  "Run the abstract machine on the code for f."
  (let* ((code (fn-code f))
         (pc 0)
         (env nil)
         (stack nil)
         (n-args 0)
         (instr nil))
    (loop
       (setf instr (elt code pc))
      (incf pc)
      (format t "pc=~s env=~s stack=~s n-args=~s instr=~s~%"
	      pc env stack n-args instr)
       (case (opcode instr)

         ;; Variable/stack manipulation instructions:
         (:LVAR   (push (elt (elt env (arg1 instr)) (arg2 instr))
                       stack))
         (LSET   (setf (elt (elt env (arg1 instr)) (arg2 instr))
                       (top stack)))
         (GVAR   (push (get-global-var (arg1 instr)) stack))
         (GSET   (set-global-var! (arg1 instr) (top stack)))
         (POP    (pop stack))
         (CONST  (push (arg1 instr) stack))

         ;; Branching instructions:
         (JUMP   (setf pc (arg1 instr)))
         (FJUMP  (if (null (pop stack)) (setf pc (arg1 instr))))
         (TJUMP  (if (pop stack) (setf pc (arg1 instr))))

         ;; Function call/return instructions:
         (SAVE   (push (make-ret-addr :pc (arg1 instr)
                                      :fn f :env env)
                       stack))
         (RETURN ;; return value is top of stack; ret-addr is second
          (setf f (ret-addr-fn (second stack))
                code (fn-code f)
                env (ret-addr-env (second stack))
                pc (ret-addr-pc (second stack)))
          ;; Get rid of the ret-addr, but keep the value
          (setf stack (cons (first stack) (rest2 stack))))
         (CALLJ  (pop env)                 ; discard the top frame
                 (setf f  (pop stack)
                       code (fn-code f)
                       env (fn-env f)
                       pc 0
                       n-args (arg1 instr)))
         (ARGS   (assert (= n-args (arg1 instr)) ()
                         "Wrong number of arguments:~
                         ~d expected, ~d supplied"
                         (arg1 instr) n-args)
                 (push (make-array (arg1 instr)) env)
                 (loop for i from (- n-args 1) downto 0 do
                       (setf (elt (first env) i) (pop stack))))
         (ARGS.  (assert (>= n-args (arg1 instr)) ()
                         "Wrong number of arguments:~
                         ~d or more expected, ~d supplied"
                         (arg1 instr) n-args)
                 (push (make-array (+ 1 (arg1 instr))) env)
                 (loop repeat (- n-args (arg1 instr)) do
                       (push (pop stack) (elt (first env) (arg1 instr))))
                 (loop for i from (- (arg1 instr) 1) downto 0 do
                       (setf (elt (first env) i) (pop stack))))
         (FN     (push (make-fn :code (fn-code (arg1 instr))
                                :env env) stack))
         (PRIM   (push (apply (arg1 instr)
                              (loop with args = nil repeat n-args
                                    do (push (pop stack) args)
                                    finally (return args)))
                       stack))

         ;; Continuation instructions:
         (SET-CC (setf stack (top stack)))
         (CC     (push (make-fn
                         :env (list (vector stack))
                         :code '((ARGS 1) (:LVAR 1 0 ";" stack) (SET-CC)
                                 (:LVAR 0 0) (RETURN)))
                       stack))

         ;; Nullary operations:
         ((SCHEME-READ NEWLINE) ; *** fix, gat, 11/9/92
          (push (funcall (opcode instr)) stack))

         ;; Unary operations:
         ((CAR CDR CADR NOT LIST1 COMPILER DISPLAY WRITE RANDOM SCHEME-LOAD)
          (push (funcall (opcode instr) (pop stack)) stack))

         ;; Binary operations:
         ((+ - * / < > <= >= /= = CONS LIST2 NAME! EQ EQUAL EQL)
          (setf stack (cons (funcall (opcode instr) (second stack)
                                     (first stack))
                            (rest2 stack))))

         ;; Ternary operations:
         (LIST3
          (setf stack (cons (funcall (opcode instr) (third stack)
                                     (second stack) (first stack))
                            (rest3 stack))))

         ;; Constants:
         ((T NIL -1 0 1 2)
          (push (opcode instr) stack))

         ;; Other:
         ((HALT) (RETURN (top stack)))
         (otherwise (error "Unknown opcode: ~a" instr))))))



(defun vm-machine (f)
  "Run the abstract machine on the code for f."
  (let* ((code (fn-code f))
         (pc 0)
         (env nil)
         (stack nil)
         (n-args 0)
         (instr nil))
    (loop
      (setf instr (elt code pc))
      (incf pc)
      (format t "pc=~s env=~s stack=~s n-args=~s instr=~s~%"
	      pc env stack n-args instr)
      (case (opcode instr)

        ;; Variable/stack manipulation instructions:
        (:LVAR   (push (elt (elt env (arg1 instr)) (arg2 instr))
                       stack))
        (LSET   (setf (elt (elt env (arg1 instr)) (arg2 instr))
                      (top stack)))
        (GVAR   (push (get-global-var (arg1 instr)) stack))
        (GSET   (set-global-var! (arg1 instr) (top stack)))
        (POP    (pop stack))
        (CONST  (push (arg1 instr) stack))

        ;; Branching instructions:
        (JUMP   (setf pc (arg1 instr)))
        (FJUMP  (if (null (pop stack)) (setf pc (arg1 instr))))
        (TJUMP  (if (pop stack) (setf pc (arg1 instr))))

        ;; Function call/return instructions:
        (SAVE   (push (make-ret-addr :pc (arg1 instr)
                                     :fn f :env env)
                      stack))
        (RETURN ;; return value is top of stack; ret-addr is second
          (setf f (ret-addr-fn (second stack))
                code (fn-code f)
                env (ret-addr-env (second stack))
                pc (ret-addr-pc (second stack)))
          ;; Get rid of the ret-addr, but keep the value
          (setf stack (cons (first stack) (rest2 stack))))
        (CALLJ  (pop env)                 ; discard the top frame
         (setf f  (pop stack)
               code (fn-code f)
               env (fn-env f)
               pc 0
               n-args (arg1 instr)))
        (ARGS   (assert (= n-args (arg1 instr)) ()
                        "Wrong number of arguments:~
                         ~d expected, ~d supplied"
                        (arg1 instr) n-args)
         (push (make-array (arg1 instr)) env)
         (loop for i from (- n-args 1) downto 0 do
           (setf (elt (first env) i) (pop stack))))
        (ARGS.  (assert (>= n-args (arg1 instr)) ()
                        "Wrong number of arguments:~
                         ~d or more expected, ~d supplied"
                        (arg1 instr) n-args)
         (push (make-array (+ 1 (arg1 instr))) env)
         (loop repeat (- n-args (arg1 instr)) do
           (push (pop stack) (elt (first env) (arg1 instr))))
         (loop for i from (- (arg1 instr) 1) downto 0 do
           (setf (elt (first env) i) (pop stack))))
        (FN     (push (make-fn :code (fn-code (arg1 instr))
                               :env env) stack))
        (PRIM   (push (apply (arg1 instr)
                             (loop with args = nil repeat n-args
                                   do (push (pop stack) args)
                                   finally (return args)))
                      stack))

        ;; Continuation instructions:
        (SET-CC (setf stack (top stack)))
        (CC     (push (make-fn
                       :env (list (vector stack))
                       :code '((ARGS 1) (:LVAR 1 0 ";" stack) (SET-CC)
                               (:LVAR 0 0) (RETURN)))
                      stack))

        ;; Nullary operations:
        ((SCHEME-READ NEWLINE) ; *** fix, gat, 11/9/92
         (push (funcall (opcode instr)) stack))

        ;; Unary operations:
        ((CAR CDR CADR NOT LIST1 COMPILER DISPLAY WRITE RANDOM SCHEME-LOAD)
         (push (funcall (opcode instr) (pop stack)) stack))

        ;; Binary operations:
        ((+ - * / < > <= >= /= = CONS LIST2 NAME! EQ EQUAL EQL)
         (setf stack (cons (funcall (opcode instr) (second stack)
                                    (first stack))
                           (rest2 stack))))

        ;; Ternary operations:
        (LIST3
         (setf stack (cons (funcall (opcode instr) (third stack)
                                    (second stack) (first stack))
                           (rest3 stack))))

        ;; Constants:
        ((T NIL -1 0 1 2)
         (push (opcode instr) stack))

        ;; Other:
        ((HALT) (RETURN (top stack)))
        (otherwise (error "Unknown opcode: ~a" instr))))))

(defun install-vm (vm)
  (setf *machine* (symbol-function vm)))

;; norvig by default
(install-vm 'norvig-machine)
